local fs = require("@lune/fs")
local task = require("@lune/task")
local proc = require("./proc")
local transport = require("./transport")
local tab = require("./tab")
local context = require("./context")
local polling = require("./util/polling")
local types = require("./types")
local Browser = require("./protocol/browser")
local Target = require("./protocol/target")

export type Browser = types.Browser

local DEFAULT_IDLE_TIMEOUT = 30

local function get_tabs(browser: Browser): { tab.Tab }
	return browser.tabs
end

local function call_method<Request, Response>(
	browser: Browser,
	method: string & { __Request: Request, __Response: Response },
	params: Request
): Response
	return browser.transport:call_method_on_browser(method, params)
end

local function add_event_listener<Parameters>(
	browser: Browser,
	event: string & { __Parameters: Parameters },
	callback: (params: Parameters) -> ()
): () -> ()
	return browser.transport:listen_to_browser_event(event, callback)
end

local function get_version(browser: Browser): {
	protocol_version: string,
	product: string,
	revision: string,
	user_agent: string,
	js_version: string,
}
	return browser:call_method(Browser.GetVersion)
end

local function create_tab(
	browser: Browser,
	options: {
		url: string,
		width: number?,
		height: number?,
		browser_context_id: Browser.BrowserContextID?,
		enable_begin_frame_control: boolean?,
		new_window: boolean?,
		background: boolean?,
		for_tab: boolean?,
	}?
): tab.Tab
	local opts = options or { url = "about:blank" }
	local target_id = browser:call_method(Target.CreateTarget, opts).target_id

	local t = polling.with_timeout(20):pause_until(function()
		for _, t in browser.tabs do
			if t:get_target_id() == target_id then
				return t
			end
		end
		return nil
	end)

	if not t then
		error("Failed to fetch new tab")
	end
	return t
end

local function create_context(browser: Browser): context.Context
	local context_id = browser:call_method(Target.CreateBrowserContext, {}).browser_context_id
	return context.create(browser, context_id)
end

local function register_missing_tabs(browser: Browser)
	local targets = browser:call_method(Target.GetTargets, nil :: any)

	local previous_target_id = ""

	for _, target in targets.target_infos do
		local target_id = target.target_id

		for _, t in browser.tabs do
			if t:get_target_id() == target_id or target.attached == false then
				previous_target_id = target_id
				break
			end
		end

		if previous_target_id == target_id then
			continue
		end

		local t_idx: number?
		for idx, t in browser.tabs do
			if t:get_target_id() == previous_target_id then
				t_idx = idx
				break
			end
		end

		local t = tab.create(target, browser.transport)
		if t_idx then
			table.insert(browser.tabs, t_idx, t)
		else
			table.insert(browser.tabs, t)
		end

		previous_target_id = target_id
	end
end

local function handle_browser_level_events(browser: Browser)
	browser:add_event_listener(Target.TargetCreated, function(target)
		local target_info = target.target_info
		if target_info.type ~= "page" then
			return
		end

		local t = tab.create(target_info, browser.transport)
		table.insert(browser.tabs, t)
	end)

	browser:add_event_listener(Target.TargetInfoChanged, function(target)
		local target_info = target.target_info
		if target_info.type ~= "page" or string.sub(target_info.url, 1, 11) == "devtools://" then
			return
		end

		for _, t in browser.tabs do
			if target_info.target_id == t:get_target_id() then
				t:update_target_info(target_info)
				break
			end
		end
	end)

	browser:add_event_listener(Target.TargetDestroyed, function(target)
		for idx, t in browser.tabs do
			if target.target_id == t:get_target_id() then
				table.remove(browser.tabs, idx)
				break
			end
		end
	end)
end

local function close(browser: Browser)
	browser.transport:call_method_on_browser(Browser.Close)
	browser.transport:shutdown()

	for _, on_close in browser.on_close_hooks do
		on_close()
	end
end

--- Allows you to drive an externally-launched Chrome process instead of launch one via `browser.create`.
--- If the browser is idle for `idle_browser_timeout` (or 30 seconds), the connection will be dropped.
--- @within Browser
local function connect(websocket_url: string, idle_browser_timeout: number?): Browser
	local bus = transport.create(websocket_url, idle_browser_timeout or DEFAULT_IDLE_TIMEOUT)

	local browser = {
		transport = bus,
		tabs = {},
		on_close_hooks = {},
		get_tabs = get_tabs,
		call_method = call_method,
		add_event_listener = add_event_listener,
		get_version = get_version,
		create_tab = create_tab,
		create_context = create_context,
		register_missing_tabs = register_missing_tabs,
		close = close,
	}

	handle_browser_level_events(browser)
	browser:call_method(Target.SetDiscoverTargets, { discover = true })

	return browser
end

--- Launch a new Chrome browser.
--- The browser will have its user data (aka "profile") directory stored in a temporary directory.
--- @within Browser
local function create(launch_options: proc.LaunchOptions?): Browser
	local chrome_proc = proc.launch(launch_options)
	local idle_browser_timeout = if launch_options and launch_options.idle_browser_timeout
		then launch_options.idle_browser_timeout
		else DEFAULT_IDLE_TIMEOUT

	local browser = connect(chrome_proc.websocket_url, idle_browser_timeout)

	local temp_user_data_dir = chrome_proc.temp_user_data_dir
	if temp_user_data_dir then
		local thread = task.spawn(function()
			chrome_proc.child.stderr:readToEnd()
			if fs.isDir(temp_user_data_dir) then
				fs.removeDir(temp_user_data_dir)
			end
		end)

		local ensure_cleanup = function()
			polling.forever():pause_until(function()
				return if coroutine.status(thread) == "dead" then true else nil
			end)
		end
		table.insert(browser.on_close_hooks, ensure_cleanup)
	end

	return browser
end

return {
	connect = connect,
	create = create,
}

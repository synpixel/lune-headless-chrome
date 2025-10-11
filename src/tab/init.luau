local serde = require("@lune/serde")
local Regex = require("@lune/regex")
local task = require("@lune/task")
local transport = require("./transport")
local element = require("@self/element")
local element_quad = require("@self/element-quad")
local box_model = require("@self/box-model")
local dialog = require("@self/dialog")
local keys = require("@self/keys")
local polling = require("./util/polling")
local base64 = require("./../luau_packages/base64")
local types = require("./types")
local Target = require("./protocol/target")
local Page = require("./protocol/page")
local Browser = require("./protocol/browser")
local Emulation = require("./protocol/emulation")
local Runtime = require("./protocol/runtime")
local Network = require("./protocol/network")
local DOM = require("./protocol/dom")
local Input = require("./protocol/input")
local Log = require("./protocol/log")
local Debugger = require("./protocol/debugger")
local Profiler = require("./protocol/profiler")
local Fetch = require("./protocol/fetch")

export type Tab = types.Tab

export type Element = element.Element
export type ElementQuad = element_quad.ElementQuad
export type BoxModel = box_model.BoxModel

local USER_AGENT_PATTERN = Regex.new([[\(([^)]+)\)]])

local function get_target_id(tab: Tab): string
	return tab.target_id
end

local function update_target_info(tab: Tab, target_info: Target.TargetInfo)
	tab.target_info = target_info
end

local function get_url(tab: Tab): string
	return tab.target_info.url
end

local function set_default_timeout(tab: Tab, timeout: number): Tab
	tab.default_timeout = timeout
	return tab
end

local function set_slow_motion_multiplier(tab: Tab, multiplier: number): Tab
	tab.slow_motion_multiplier = multiplier
	return tab
end

local function optional_slow_motion_sleep(tab: Tab, millis: number)
	if tab.slow_motion_multiplier == 0 then
		return
	end

	local seconds = millis / 1000
	task.wait(seconds * tab.slow_motion_multiplier)
end

local function call_method<Request, Response>(
	tab: Tab,
	method: string & { __Request: Request, __Response: Response },
	params: Request
): Response
	return tab.transport:call_method_on_target(method, params, tab.session_id)
end

local function add_event_listener<Parameters>(
	tab: Tab,
	event: string & { __Parameters: Parameters },
	callback: (params: Parameters) -> ()
): () -> ()
	return tab.transport:listen_to_target_event(event, tab.session_id, callback)
end

local function get_target_info(tab: Tab): Target.TargetInfo
	return tab.transport:call_method_on_browser(Target.GetTargetInfo, { target_id = tab.target_id }).target_info
end

local function get_browser_context_id(tab: Tab): string?
	local target_info = tab:get_target_info()
	return target_info.browser_context_id
end

local function set_user_agent(tab: Tab, user_agent: string, accept_language: string?, platform: string?)
	tab:call_method(
		Network.SetUserAgentOverride,
		{ user_agent = user_agent, accept_language = accept_language, platform = platform }
	)
end

local function set_extra_http_headers(tab: Tab, headers: { [string]: string })
	tab:call_method(Network.Enable, {})
	tab:call_method(Network.SetExtraHTTPHeaders, { headers = headers })
end

local function set_file_chooser_dialog_interception(tab: Tab, enabled: boolean)
	tab:call_method(Page.SetInterceptFileChooserDialog, { enabled = enabled })
end

local function handle_file_chooser(tab: Tab, files: { string }, node_id: DOM.NodeId)
	tab:call_method(DOM.SetFileInputFiles, { files = files, node_id = node_id })
end

local function bring_to_front(tab: Tab)
	tab:call_method(Page.BringToFront)
end

local function reload(tab: Tab, ignore_cache: boolean?, script_to_evaluate_on_load: string?): Tab
	optional_slow_motion_sleep(tab, 100)
	tab:call_method(
		Page.Reload,
		{ ignore_cache = ignore_cache, script_to_evaluate_on_load = script_to_evaluate_on_load }
	)
	return tab
end

local function stop_loading(tab: Tab)
	tab:call_method(Page.StopLoading)
end

local function navigate_to(tab: Tab, url: string): Tab
	tab:call_method(Page.Navigate, { url = url })
	return tab
end

local function wait_until_navigated(tab: Tab): Tab
	tab.navigating = true
	polling.with_timeout(tab.default_timeout):pause_until(function()
		return if tab.navigating then nil else true
	end)
	return tab
end

local function get_bounds(tab: Tab): Browser.Bounds
	return tab.transport:call_method_on_browser(Browser.GetWindowForTarget, { target_id = tab.target_id }).bounds
end

local function set_bounds(tab: Tab, bounds: Browser.Bounds): Tab
	local window_id =
		tab.transport:call_method_on_browser(Browser.GetWindowForTarget, { target_id = tab.target_id }).window_id

	tab.transport:call_method_on_browser(Browser.SetWindowBounds, { window_id = window_id, bounds = bounds })

	return tab
end

local function set_transparent_background_color(tab: Tab): Tab
	tab:call_method(Emulation.SetDefaultBackgroundColorOverride, {
		color = { r = 0, g = 0, b = 0, a = 0 },
	})
	return tab
end

local function set_background_color(tab: Tab, color: DOM.RGBA): Tab
	tab:call_method(Emulation.SetDefaultBackgroundColorOverride, { color = color })
	return tab
end

local function evaluate(tab: Tab, expression: string, await_promise: boolean?): Runtime.RemoteObject
	return tab:call_method(Runtime.Evaluate, {
		expression = expression,
		return_by_value = false,
		generate_preview = true,
		silent = false,
		await_promise = await_promise,
		include_command_line_api = false,
		user_gesture = false,
	}).result
end

local function get_title(tab: Tab): string
	local result = tab:evaluate("document.title")
	return result.value :: string
end

local function set_cookies(tab: Tab, cookies: { Network.CookieParam })
	local url = tab:get_url()
	local starts_with_http = string.sub(url, 1, 4) == "http"

	local patched_cookies = {}

	for index, cookie in cookies do
		if not cookie.url and starts_with_http then
			cookie = table.clone(cookie)
			cookie.url = url
		end

		patched_cookies[index] = cookie
	end

	tab:delete_cookies(patched_cookies :: any)
	tab:call_method(Network.SetCookies, { cookies = patched_cookies })
end

local function get_cookies(tab: Tab): { Network.Cookie }
	return tab:call_method(Network.GetCookies, {}).cookies
end

local function delete_cookies(
	tab: Tab,
	cookies: {
		{
			name: string,
			url: string?,
			domain: string?,
			path: string?,
			partition_key: Network.CookiePartitionKey?,
		}
	}
)
	local url = tab:get_url()
	local starts_with_http = string.sub(url, 1, 4) == "http"

	for _, cookie in cookies do
		if not cookie.url and starts_with_http then
			cookie = table.clone(cookie)
			cookie.url = url
		end

		tab:call_method(Network.DeleteCookies, cookie)
	end
end

local function set_storage(tab: Tab, name: string, item: any)
	local json = serde.encode("json", item)
	local value = if typeof(item) == "string" then json else `JSON.stringify({json})`
	tab:evaluate(`localStorage.setItem("{name}", {value})`)
end

local function get_storage(tab: Tab, name: string): any?
	local result = tab:evaluate(`localStorage.getItem("{name}")`)
	if result.type ~= "string" then
		return nil
	end

	local success, item = pcall(serde.decode, "json" :: any, result.value :: string)
	if success then
		return item
	end

	return result.value
end

local function remove_storage(tab: Tab, name: string)
	tab:evaluate(`localStorage.removeItem("{name}")`)
end

local function capture_screenshot(
	tab: Tab,
	options: {
		format: "jpeg" | "png" | "webp"?,
		quality: number?,
		clip: Page.Viewport?,
		from_surface: boolean?,
		capture_beyond_viewport: boolean?,
		optimize_for_speed: boolean?,
	}
): buffer
	local screenshot = tab:call_method(Page.CaptureScreenshot, options)
	local data = buffer.fromstring(screenshot.data)
	return base64.decode(data)
end

local function print_to_pdf(
	tab: Tab,
	options: {
		landscape: boolean?,
		display_header_footer: boolean?,
		print_background: boolean?,
		scale: number?,
		paper_width: number?,
		paper_height: number?,
		margin_top: number?,
		margin_bottom: number?,
		margin_left: number?,
		margin_right: number?,
		page_ranges: string?,
		header_template: string?,
		footer_template: string?,
		prefer_css_page_size: boolean?,
		generate_tagged_pdf: boolean?,
		generate_document_outline: boolean?,
	}?
): buffer
	local pdf = tab:call_method(Page.PrintToPDF, options :: any or {})
	local data = buffer.fromstring(pdf.data)
	return base64.decode(data)
end

local function start_screencast(
	tab: Tab,
	options: {
		format: "jpeg" | "png"?,
		quality: number?,
		max_width: number?,
		max_height: number?,
		every_nth_frame: number?,
	}
)
	tab:call_method(Page.StartScreencast, options)
end

local function stop_screencast(tab: Tab)
	tab:call_method(Page.StopScreencast)
end

local function ack_screencast(tab: Tab, session_id: number)
	tab:call_method(Page.ScreencastFrameAck, { session_id = session_id })
end

local function get_dialog(tab: Tab): dialog.Dialog
	return dialog.create(tab.session_id, tab.transport)
end

local function get_document(tab: Tab): DOM.Node
	return tab:call_method(DOM.GetDocument, { depth = 0, pierce = false }).root
end

local function get_content(tab: Tab): string
	local expression = [[
		let content = "";
        if (document.doctype)
            content += new XMLSerializer().serializeToString(document.doctype);
        if (document.documentElement)
            content += document.documentElement.outerHTML;
        return content;
	]]

	local html = tab:evaluate(expression).value
	return html :: string
end

local function describe_node(tab: Tab, node_id: DOM.NodeId): DOM.Node
	return tab:call_method(DOM.DescribeNode, { node_id = node_id, depth = 100 }).node
end

local function run_query_selector_on_node(tab: Tab, node_id: DOM.NodeId, selector: string): Element?
	local id = tab:call_method(DOM.QuerySelector, { node_id = node_id, selector = selector }).node_id
	return element.create(tab, id)
end

local function run_query_selector_all_on_node(tab: Tab, node_id: DOM.NodeId, selector: string): { Element }
	local node_ids = tab:call_method(DOM.QuerySelectorAll, { node_id = node_id, selector = selector }).node_ids

	local elements = {}

	for _, node_id in node_ids do
		local e = element.create(tab, node_id)
		if e then
			table.insert(elements, e)
		end
	end

	return elements
end

local function find_element(tab: Tab, selector: string): Element?
	local root_node_id = tab:get_document().node_id
	return tab:run_query_selector_on_node(root_node_id, selector)
end

local function find_element_by_xpath(tab: Tab, query: string): Element?
	tab:get_document()

	local search = tab:call_method(DOM.PerformSearch, { query = query })
	if search.result_count <= 0 then
		return nil
	end

	local results = tab:call_method(DOM.GetSearchResults, {
		search_id = search.search_id,
		from_index = 0,
		to_index = search.result_count,
	})

	local node_id = results.node_ids[1]
	return element.create(tab, node_id)
end

local function find_elements(tab: Tab, selector: string): { Element }
	local root_node_id = tab:get_document().node_id
	return tab:run_query_selector_all_on_node(root_node_id, selector)
end

local function find_elements_by_xpath(tab: Tab, query: string): { Element }
	tab:get_document()

	local search = tab:call_method(DOM.PerformSearch, { query = query })
	if search.result_count <= 0 then
		return {}
	end

	local results = tab:call_method(DOM.GetSearchResults, {
		search_id = search.search_id,
		from_index = 0,
		to_index = search.result_count,
	})

	local node_ids = results.node_ids
	local elements = {}

	for _, node_id in node_ids do
		local e = element.create(tab, node_id)
		if e then
			table.insert(elements, e)
		end
	end

	return elements
end

local function wait_for_element(tab: Tab, selector: string, timeout: number?): Element?
	local duration = timeout or tab.default_timeout
	return polling.with_timeout(duration):pause_until(function()
		return tab:find_element(selector)
	end)
end

local function wait_for_xpath(tab: Tab, selector: string, timeout: number?): Element?
	local duration = timeout or tab.default_timeout
	return polling.with_timeout(duration):pause_until(function()
		return tab:find_element_by_xpath(selector)
	end)
end

local function wait_for_elements(tab: Tab, selector: string, timeout: number?): { Element }
	local duration = timeout or tab.default_timeout
	return polling.with_timeout(duration):pause_until(function()
		local elements = tab:find_elements(selector)
		return #elements > 0 and elements
	end) or {}
end

local function wait_for_elements_by_xpath(tab: Tab, selector: string, timeout: number?): { Element }
	local duration = timeout or tab.default_timeout
	return polling.with_timeout(duration):pause_until(function()
		local elements = tab:find_elements_by_xpath(selector)
		return #elements > 0 and elements
	end) or {}
end

local function move_mouse_to_point(tab: Tab, point: vector): Tab
	optional_slow_motion_sleep(tab, 100)

	tab:call_method(Input.DispatchMouseEvent, {
		type = "mouseMoved",
		x = point.x,
		y = point.y,
	})

	return tab
end

local function click_point(tab: Tab, point: vector): Tab
	tab:move_mouse_to_point(point)

	optional_slow_motion_sleep(tab, 250)

	tab:call_method(Input.DispatchMouseEvent, {
		type = "mousePressed",
		x = point.x,
		y = point.y,
		button = "left",
		click_count = 1,
	})

	tab:call_method(Input.DispatchMouseEvent, {
		type = "mouseReleased",
		x = point.x,
		y = point.y,
		button = "left",
		click_count = 1,
	})

	return tab
end

local function insert_text(tab: Tab, text: string): Tab
	tab:call_method(Input.InsertText, { text = text })
	return tab
end

local function type_text(tab: Tab, text: string): Tab
	for char in string.gmatch(text, "[\0-\255]") do
		local definition = keys.get_key_definition(char :: keys.Key)
		if definition then
			tab:press_key(definition.key)
		else
			tab:insert_text(char)
		end
	end

	return tab
end

local function press_key_with_modifiers(tab: Tab, key: keys.Key, modifiers: { "Alt" | "Ctrl" | "Meta" | "Shift" }?): Tab
	local definition = keys.get_key_definition(key)
	if not definition then
		error("Invalid key")
	end

	local text = if definition.text then definition.text elseif #definition.key == 1 then definition.key else nil
	local key_down_event: "char" | "keyDown" | "keyUp" | "rawKeyDown" = if text then "keyDown" else "rawKeyDown"

	local mods = 0
	if modifiers then
		for _, modifier in modifiers do
			local index = if modifier == "Alt"
				then 1
				elseif modifier == "Ctrl" then 2
				elseif modifier == "Meta" then 4
				elseif modifier == "Shift" then 8
				else 0

			mods = bit32.bor(mods, index)
		end
	end

	optional_slow_motion_sleep(tab, 25)

	tab:call_method(Input.DispatchKeyEvent, {
		type = key_down_event,
		key = definition.key,
		text = text,
		code = definition.code,
		windows_virtual_key_code = definition.key_code,
		native_virtual_key_code = definition.key_code,
		modifiers = mods,
	})

	tab:call_method(Input.DispatchKeyEvent, {
		type = "keyUp",
		key = definition.key,
		text = text,
		code = definition.code,
		windows_virtual_key_code = definition.key_code,
		native_virtual_key_code = definition.key_code,
		modifiers = mods,
	})

	return tab
end

local function press_key(tab: Tab, key: keys.Key): Tab
	return tab:press_key_with_modifiers(key)
end

local function enable_log(tab: Tab): Tab
	tab:call_method(Log.Enable)
	return tab
end

local function disable_log(tab: Tab): Tab
	tab:call_method(Log.Disable)
	return tab
end

local function start_violations_report(tab: Tab, config: { Log.ViolationSetting }): Tab
	tab:call_method(Log.StartViolationsReport, { config = config })
	return tab
end

local function stop_violations_report(tab: Tab): Tab
	tab:call_method(Log.StopViolationsReport)
	return tab
end

local function enable_runtime(tab: Tab): Tab
	tab:call_method(Runtime.Enable)
	return tab
end

local function disable_runtime(tab: Tab): Tab
	tab:call_method(Runtime.Disable)
	return tab
end

local function enable_debugger(tab: Tab): Tab
	tab:call_method(Debugger.Enable, {})
	return tab
end

local function disable_debugger(tab: Tab): Tab
	tab:call_method(Debugger.Disable)
	return tab
end

local function get_script_source(tab: Tab, script_id: string): string
	return tab:call_method(Debugger.GetScriptSource, { script_id = script_id }).script_source
end

local function enable_profiler(tab: Tab): Tab
	tab:call_method(Profiler.Enable)
	return tab
end

local function disable_profiler(tab: Tab): Tab
	tab:call_method(Profiler.Disable)
	return tab
end

local function start_js_coverage(tab: Tab): Tab
	tab:call_method(Profiler.StartPreciseCoverage, { call_count = true, detailed = true })
	return tab
end

local function stop_js_coverage(tab: Tab): Tab
	tab:call_method(Profiler.StopPreciseCoverage)
	return tab
end

local function take_js_coverage(tab: Tab): { Profiler.ScriptCoverage }
	return tab:call_method(Profiler.TakePreciseCoverage).result
end

local function enable_fetch(tab: Tab, patterns: { Fetch.RequestPattern }?, handle_auth_requests: boolean?): Tab
	tab:call_method(Fetch.Enable, { patterns = patterns, handle_auth_requests = handle_auth_requests })
	return tab
end

local function disable_fetch(tab: Tab): Tab
	tab:call_method(Fetch.Disable)
	return tab
end

local function enable_request_interception(tab: Tab, interceptor: types.RequestInterceptor)
	tab.request_interceptor = interceptor
end

local function authenticate(tab: Tab, username: string?, password: string?): Tab
	tab.auth_handler = {
		response = "ProvideCredentials",
		username = username,
		password = password,
	}
	return tab
end

local function register_response_handling(tab: Tab, handler_name: string, handler: types.ResponseHandler)
	tab:call_method(Network.Enable, {})
	tab.response_handler[handler_name] = handler
end

local function register_loading_failed_handling(tab: Tab, handler_name: string, handler: types.LoadingFailedHandler)
	tab:call_method(Network.Enable, {})
	tab.loading_failed_handler[handler_name] = handler
end

local function deregister_response_handling(tab: Tab, handler_name: string)
	tab.response_handler[handler_name] = nil
end

local function deregister_response_handling_all(tab: Tab)
	table.clear(tab.response_handler)
end

local function expose_fn(tab: Tab, name: string, fn: (data: any) -> ())
	tab.page_bindings[name] = fn

	-- https://github.com/puppeteer/puppeteer/blob/97c9fe2520723d45a5a86da06b888ae888d400be/src/common/helper.ts#L183
	local expression = [[
		(function addPageBinding(bindingName) {
            const binding = window[bindingName];
            window[bindingName] = (...args) => {
              const me = window[bindingName];
              let callbacks = me.callbacks;
              if (!callbacks) {
                callbacks = new Map();
                me.callbacks = callbacks;
              }
              const seq = (me.lastSeq || 0) + 1;
              me.lastSeq = seq;
              const promise = new Promise((resolve, reject) => callbacks.set(seq, {resolve, reject}));
              binding(JSON.stringify({ name: bindingName, seq, args }));
              return promise;
            };
    	})()
	]]

	tab:call_method(Runtime.AddBinding, { name = name })
	tab:call_method(Page.AddScriptToEvaluateOnNewDocument, { source = expression })
end

local function remove_fn(tab: Tab, name: string)
	tab.page_bindings[name] = nil
end

local function bypass_user_agent(tab: Tab)
	local object = tab:evaluate("window.navigator.userAgent", true)
	local user_agent = object.value :: string?

	if not user_agent then
		return
	end

	user_agent = string.gsub(user_agent, "HeadlessChrome/", "Chrome/")
	user_agent = USER_AGENT_PATTERN:replace(user_agent, "(Windows NT 10.0; Win64; x64)")

	tab:set_user_agent(user_agent)
end

local function bypass_web_driver(tab: Tab)
	tab:call_method(Page.AddScriptToEvaluateOnNewDocument, {
		source = 'Object.defineProperty(navigator, "webdriver", { get: () => undefined });',
	})
end

local function bypass_chrome(tab: Tab)
	tab:call_method(Page.AddScriptToEvaluateOnNewDocument, {
		source = "window.chrome = { runtime: {} };",
	})
end

local function bypass_permissions(tab: Tab)
	local source = [[
		const originalQuery = window.navigator.permissions.query;
        window.navigator.permissions.__proto__.query = (parameters) =>
        parameters.name === "notifications"
            ? Promise.resolve({state: Notification.permission})
            : originalQuery(parameters);
	]]

	tab:call_method(Page.AddScriptToEvaluateOnNewDocument, {
		source = source,
	})
end

local function bypass_plugins(tab: Tab)
	local source = [[
		Object.defineProperty(navigator, "plugins", {
			get: () => [
            	{ filename: "internal-pdf-viewer" },
            	{ filename: "adsfkjlkjhalkh" },
            	{ filename: "internal-nacl-plugin" },
          	],
		});
	]]

	tab:call_method(Page.AddScriptToEvaluateOnNewDocument, {
		source = source,
	})
end

local function bypass_webgl_vendor(tab: Tab)
	local source = [[
		const getParameter = WebGLRenderingContext.getParameter;
        WebGLRenderingContext.prototype.getParameter = (parameter) => {
            // UNMASKED_VENDOR_WEBGL
            if (parameter === 37445) {
                return "Google Inc. (NVIDIA)";
            }
			
            // UNMASKED_RENDERER_WEBGL
            if (parameter === 37446) {
                return "ANGLE (NVIDIA, NVIDIA GeForce GTX 1050 Direct3D11 vs_5_0 ps_5_0, D3D11-27.21.14.5671)";
            }

            return getParameter(parameter);
        };
	]]

	tab:call_method(Page.AddScriptToEvaluateOnNewDocument, {
		source = source,
	})
end

local function enable_stealth_mode(tab: Tab)
	bypass_user_agent(tab)
	bypass_web_driver(tab)
	bypass_chrome(tab)
	bypass_permissions(tab)
	bypass_plugins(tab)
	bypass_webgl_vendor(tab)
end

local function close(tab: Tab)
	optional_slow_motion_sleep(tab, 50)
	tab:call_method(Target.CloseTarget, { target_id = tab.target_id })
end

local function handle_tab_level_events(tab: Tab)
	local received_event_params = {}

	tab:add_event_listener(Page.LifecycleEvent, function(event)
		if event.name == "networkAlmostIdle" then
			tab.navigating = false
		end
	end)

	tab:add_event_listener(Runtime.BindingCalled, function(binding)
		local name = binding.name
		local payload = binding.payload

		local fn = tab.page_bindings[name]
		fn(serde.decode("json", payload))
	end)

	tab:add_event_listener(Fetch.RequestPaused, function(params)
		local interceptor = tab.request_interceptor
		if not interceptor then
			tab:call_method(Fetch.ContinueRequest, { request_id = params.request_id })
			return
		end

		local decision = interceptor(tab.transport, tab.session_id, params)

		if decision.action == "Continue" then
			if (decision :: any).request_id then
				tab:call_method(Fetch.ContinueRequest, decision :: any)
			else
				tab:call_method(Fetch.ContinueRequest, { request_id = params.request_id })
			end
		elseif decision.action == "Fulfill" then
			tab:call_method(Fetch.FulfillRequest, decision)
		elseif decision.action == "Fail" then
			tab:call_method(Fetch.FailRequest, decision)
		end
	end)

	tab:add_event_listener(Fetch.AuthRequired, function(params)
		local response = tab.auth_handler
		if not response then
			return
		end

		local request_id = params.request_id
		tab:call_method(Fetch.ContinueWithAuth, {
			request_id = request_id,
			auth_challenge_response = response,
		})
	end)

	tab:add_event_listener(Network.ResponseReceived, function(response)
		local request_id = response.request_id
		received_event_params[request_id] = response
	end)

	tab:add_event_listener(Network.LoadingFinished, function(params)
		local request_id = params.request_id

		for _, handler in tab.response_handler do
			local function retrieve_body()
				return tab:call_method(Network.GetResponseBody, { request_id = request_id })
			end

			local response = received_event_params[request_id]
			if response then
				handler(response, retrieve_body)
			end
		end
	end)

	tab:add_event_listener(Network.LoadingFailed, function(params)
		local request_id = params.request_id

		for _, handler in tab.loading_failed_handler do
			local response = received_event_params[request_id]
			if response then
				handler(response, params)
			end
		end
	end)
end

local function create(target_info: Target.TargetInfo, tp: transport.Transport): Tab
	local target_id = target_info.target_id
	local session_id = tp:call_method_on_browser(Target.AttachToTarget, { target_id = target_id }).session_id

	local tab = {
		target_id = target_id,
		transport = tp,
		session_id = session_id,
		navigating = false,
		target_info = target_info,
		request_interceptor = nil,
		response_handler = {},
		loading_failed_handler = {},
		auth_handler = nil,
		default_timeout = 20,
		page_bindings = {},
		slow_motion_multiplier = 0,
		get_target_id = get_target_id,
		update_target_info = update_target_info,
		get_url = get_url,
		set_default_timeout = set_default_timeout,
		set_slow_motion_multiplier = set_slow_motion_multiplier,
		call_method = call_method,
		add_event_listener = add_event_listener,
		get_target_info = get_target_info,
		get_browser_context_id = get_browser_context_id,
		set_user_agent = set_user_agent,
		set_extra_http_headers = set_extra_http_headers,
		set_file_chooser_dialog_interception = set_file_chooser_dialog_interception,
		handle_file_chooser = handle_file_chooser,
		bring_to_front = bring_to_front,
		reload = reload,
		stop_loading = stop_loading,
		navigate_to = navigate_to,
		wait_until_navigated = wait_until_navigated,
		get_bounds = get_bounds,
		set_bounds = set_bounds,
		set_transparent_background_color = set_transparent_background_color,
		set_background_color = set_background_color,
		evaluate = evaluate,
		get_title = get_title,
		set_cookies = set_cookies,
		get_cookies = get_cookies,
		delete_cookies = delete_cookies,
		set_storage = set_storage,
		get_storage = get_storage,
		remove_storage = remove_storage,
		capture_screenshot = capture_screenshot,
		print_to_pdf = print_to_pdf,
		start_screencast = start_screencast,
		stop_screencast = stop_screencast,
		ack_screencast = ack_screencast,
		get_dialog = get_dialog,
		get_document = get_document,
		get_content = get_content,
		describe_node = describe_node,
		run_query_selector_on_node = run_query_selector_on_node,
		run_query_selector_all_on_node = run_query_selector_all_on_node,
		find_element = find_element,
		find_element_by_xpath = find_element_by_xpath,
		find_elements = find_elements,
		find_elements_by_xpath = find_elements_by_xpath,
		wait_for_element = wait_for_element :: any,
		wait_for_xpath = wait_for_xpath :: any,
		wait_for_elements = wait_for_elements,
		wait_for_elements_by_xpath = wait_for_elements_by_xpath,
		move_mouse_to_point = move_mouse_to_point,
		click_point = click_point,
		insert_text = insert_text,
		type_text = type_text,
		press_key_with_modifiers = press_key_with_modifiers,
		press_key = press_key,
		enable_log = enable_log,
		disable_log = disable_log,
		start_violations_report = start_violations_report,
		stop_violations_report = stop_violations_report,
		enable_runtime = enable_runtime,
		disable_runtime = disable_runtime,
		enable_debugger = enable_debugger,
		disable_debugger = disable_debugger,
		get_script_source = get_script_source,
		enable_profiler = enable_profiler,
		disable_profiler = disable_profiler,
		start_js_coverage = start_js_coverage,
		stop_js_coverage = stop_js_coverage,
		take_js_coverage = take_js_coverage,
		enable_fetch = enable_fetch,
		disable_fetch = disable_fetch,
		enable_request_interception = enable_request_interception,
		authenticate = authenticate,
		register_response_handling = register_response_handling,
		register_loading_failed_handling = register_loading_failed_handling,
		deregister_response_handling = deregister_response_handling,
		deregister_response_handling_all = deregister_response_handling_all,
		expose_fn = expose_fn,
		remove_fn = remove_fn,
		enable_stealth_mode = enable_stealth_mode,
		close = close,
	}

	tab:call_method(Page.Enable)
	tab:call_method(Page.SetLifecycleEventsEnabled, { enabled = true })

	handle_tab_level_events(tab)

	return tab
end

return { create = create }

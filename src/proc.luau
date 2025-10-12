local process = require("@lune/process")
local fs = require("@lune/fs")
local net = require("@lune/net")
local Regex = require("@lune/regex")
local tempfile = require("./util/tempfile")
local winreg = require("./util/winreg")

--[=[
	Represents the way in which Chrome is run. By default it will search for a Chrome
	binary on the system, use an available port for debugging, and start in headless mode.

	@interface LaunchOptions
	.headless boolean? -- Determines whether to run headless version of the browser. Defaults to true.
	.sandbox boolean? -- Determines whether to run the browser with a sandbox.
	.devtools boolean? -- Automatically open devtools for tabs. Forces headless to be false.
	.enable_gpu boolean? -- Determines whether to enable GPU or not. Default to false.
	.enable_logging boolean? -- Determines whether to run the browser with logging enabled (this can cause unwanted new shell window in Windows 10 and above).
	.window_size { width: number, height: number }? -- Launch the browser with a specific window width and height.
	.port number? -- Launch the browser with a specific debugging port.
	.ignore_certificate_errors boolean? -- Determines whether SSL certificates should be verified. This is unsafe and can lead to MiTM attacks. This is unsafe and can lead to MiTM attacks. Make sure you understand the risks.
	.path string? -- Path for Chrome or Chromium. If unspecified, the create will try to automatically detect a suitable binary.
	.user_data_dir string? -- User Data (Profile) to use. If unspecified, a new temp directory is created and used on every launch.
	.extensions { string }? -- A list of Chrome extensions to load. An extension should be a path to a folder containing the extension code. CRX files cannot be used directly and must be first extracted. Note that Chrome does not support loading extensions in headless-mode.
	.args { string }? -- Additional arguments to pass to the browser instance. The list of Chromium flags can be found: <http://peter.sh/experiments/chromium-command-line-switches/>.
	.ignore_default_args { string }? -- Ignore a default given flag.
	.disable_default_args boolean? -- Disable default arguments.
	.idle_browser_timeout number? -- How long to keep the WebSocket to the browser for after not receiving any events from it. Defaults to 30 seconds.
	.process_envs { [string]: string }? -- Environment variables to set for the Chromium process.
	.proxy_server string? -- Setup the proxy server for headless chrome instance
	@within Process
]=]
export type LaunchOptions = {
	headless: boolean?,
	sandbox: boolean?,
	devtools: boolean?,
	enable_gpu: boolean?,
	enable_logging: boolean?,
	window_size: { width: number, height: number }?,
	port: number?,
	ignore_certificate_errors: boolean?,
	path: string?,
	user_data_dir: string?,
	extensions: { string }?,
	args: { string }?,
	ignore_default_args: { string }?,
	disable_default_args: boolean?,
	-- fetcher_options
	idle_browser_timeout: number?,
	process_envs: { [string]: string }?,
	proxy_server: string?,
}

--- @class Process
export type Process = {
	child: process.ChildProcess,
	websocket_url: string,
	temp_user_data_dir: string?,
}

local DEFAULT_ARGS = table.freeze({
	"--disable-background-networking",
	"--enable-features=NetworkService,NetworkServiceInProcess",
	"--disable-background-timer-throttling",
	"--disable-backgrounding-occluded-windows",
	"--disable-breakpad",
	"--disable-client-side-phishing-detection",
	"--disable-component-extensions-with-background-pages",
	"--disable-default-apps",
	"--disable-dev-shm-usage",
	"--disable-extensions",
	-- BlinkGenPropertyTrees disabled due to crbug.com/937609
	"--disable-features=TranslateUI,BlinkGenPropertyTrees",
	"--disable-hang-monitor",
	"--disable-ipc-flooding-protection",
	"--disable-popup-blocking",
	"--disable-prompt-on-repost",
	"--disable-renderer-backgrounding",
	"--disable-sync",
	"--force-color-profile=srgb",
	"--metrics-recording-only",
	"--no-first-run",
	"--enable-automation",
	"--password-store=basic",
	"--use-mock-keychain",
})

local PORT_TAKEN_PATTERN = Regex.new("ERROR.*bind\\(\\)")
local WEBSOCKET_URL_PATTERN = Regex.new("listening on (.*/devtools/browser/.*)$")

local function which(binary_name: string): string?
	local path = process.env.PATH or process.env.Path
	if not path then
		return nil
	end

	for _, dir in string.split(path, ";") do
		if not fs.isDir(dir) then
			continue
		end

		for _, file in fs.readDir(dir) do
			local is_match = if process.os == "windows" then file == `{binary_name}.exe` else file == binary_name
			if is_match then
				return `{dir}/{file}`
			end
		end
	end

	return nil
end

local function get_chrome_path_from_registry(): string?
	local ok, path = pcall(function()
		return winreg
			.predef("HKEY_LOCAL_MACHINE")
			:open_subkey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\chrome.exe")
			:get_value()
	end)
	return if ok then path else nil
end

local function default_executable(): string
	local env_path = process.env.CHROME
	if env_path and fs.isFile(env_path) then
		return env_path
	end

	for _, app in
		{
			"google-chrome-stable",
			"google-chrome-beta",
			"google-chrome-dev",
			"google-chrome-unstable",
			"chromium",
			"chromium-browser",
			"microsoft-edge-stable",
			"microsoft-edge-beta",
			"microsoft-edge-dev",
			"chrome",
			"chrome-browser",
			"msedge",
			"microsoft-edge",
		}
	do
		local path = which(app)
		if path then
			return path
		end
	end

	if process.os == "macos" then
		for _, path in
			{
				"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
				"/Applications/Google Chrome Beta.app/Contents/MacOS/Google Chrome Beta",
				"/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev",
				"/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary",
				"/Applications/Chromium.app/Contents/MacOS/Chromium",
				"/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
				"/Applications/Microsoft Edge Beta.app/Contents/MacOS/Microsoft Edge Beta",
				"/Applications/Microsoft Edge Dev.app/Contents/MacOS/Microsoft Edge Dev",
				"/Applications/Microsoft Edge Canary.app/Contents/MacOS/Microsoft Edge Canary",
			}
		do
			if fs.isFile(path) then
				return path
			end
		end
	end

	if process.os == "windows" then
		local winreg_path = get_chrome_path_from_registry()
		if winreg_path and fs.isFile(winreg_path) then
			return winreg_path
		end

		local ms_edge_path = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
		if fs.isFile(ms_edge_path) then
			return ms_edge_path
		end
	end

	error("Could not auto detect a chrome executable")
end

local function is_port_available(port: number): boolean
	local available, handle = pcall(function()
		return net.serve(port, function()
			return { status = 200 }
		end)
	end)

	if available then
		handle.stop()
	end

	return available
end

local function get_available_port(): number
	for _ = 1, 1000 do
		local port = math.random(8000, 9000)
		if is_port_available(port) then
			return port
		end
	end

	error("Failed to find an available port")
end

local function get_websocket_url_from_output(child: process.ChildProcess): string
	local root_sandbox = "Running as root without --no-sandbox is not supported"

	local function extract(text: string): string?
		local captures = WEBSOCKET_URL_PATTERN:captures(text)
		if not captures then
			return nil
		end
		local capture = captures:get(1)
		return capture and capture.text
	end

	local stderr = child.stderr:read() :: string
	for line in stderr:gmatch("([^\n]+)") do
		if string.find(line, root_sandbox) then
			error("Running as root with no sandbox")
		end

		if PORT_TAKEN_PATTERN:isMatch(line) then
			error("Debug port in use")
		end

		local answer = extract(line)
		if answer then
			return answer
		end
	end

	error("Port open timeout")
end

local function start_process(launch_options: LaunchOptions): (process.ChildProcess, string?)
	if not launch_options.port then
		error("Port is required")
	end

	local args = {
		`--remote-debugging-port={launch_options.port}`,
		"--verbose",
		"--log-level=0",
		"--no-first-run",
	}

	local temp_user_data_dir: string?
	if launch_options.user_data_dir then
		table.insert(args, `--user-data-dir={launch_options.user_data_dir}`)
	else
		local user_data_dir = tempfile("chrome-luau-profile")
		table.insert(args, `--user-data-dir={user_data_dir}`)
		temp_user_data_dir = user_data_dir
	end

	if launch_options.disable_default_args ~= true then
		local defaults = table.clone(DEFAULT_ARGS)

		if launch_options.ignore_default_args then
			for _, arg in launch_options.ignore_default_args do
				local index = table.find(defaults, arg)
				table.remove(defaults, index)
			end
		end

		for _, arg in defaults do
			table.insert(args, arg)
		end
	end

	if launch_options.args then
		for _, arg in launch_options.args do
			table.insert(args, arg)
		end
	end

	if launch_options.window_size then
		table.insert(args, `--window-size={launch_options.window_size.width},{launch_options.window_size.height}`)
	end

	if launch_options.headless and not launch_options.devtools then
		table.insert(args, "--headless")
	elseif launch_options.devtools then
		table.insert(args, "--auto-open-devtools-for-tabs")
	end

	if launch_options.ignore_certificate_errors then
		table.insert(args, "--ignore-certificate-errors")
	end

	if launch_options.enable_logging then
		table.insert(args, "--enable-logging")
	end

	if launch_options.enable_gpu then
		table.insert(args, "--enable-gpu")
	end

	if launch_options.proxy_server then
		table.insert(args, `--proxy-server={launch_options.proxy_server}`)
	end

	if launch_options.sandbox == false then
		table.insert(args, "--no-sandbox")
		table.insert(args, "--disable-setuid-sandbox")
	end

	if launch_options.extensions then
		for _, extension in launch_options.extensions do
			table.insert(args, `--load-extension={extension}`)
		end
	end

	if not launch_options.path then
		error("Path is required")
	end

	return process.create(launch_options.path, args, {
		shell = true,
		env = launch_options.process_envs,
	}),
		temp_user_data_dir
end

local function launch(partial_launch_options: LaunchOptions?): Process
	local launch_options: LaunchOptions = {
		headless = true,
		sandbox = false,
		devtools = false,
	}

	if partial_launch_options then
		for key, value in partial_launch_options do
			launch_options[key] = value
		end
	end

	if not launch_options.path then
		-- TODO: Fetch Chrome installation
		launch_options.path = default_executable()
	end

	if not launch_options.port then
		launch_options.port = get_available_port()
	end

	local child, temp_user_data_dir = start_process(launch_options)
	local websocket_url = get_websocket_url_from_output(child)
	return {
		child = child,
		websocket_url = websocket_url,
		temp_user_data_dir = temp_user_data_dir,
	}
end

return { launch = launch }

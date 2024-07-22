local process = require("@lune/process")
local types = require("./types")

local DEFAULT_ARGUMENTS = {
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
}

local function launchBrowser(launchOptions: types.BrowserLaunchOptions): process.SpawnResult
	assert(launchOptions.port ~= nil, "port required")

	local arguments = {
		"--remote-debugging-port=" .. launchOptions.port,
		"--verbose",
		"--log-level=0",
		"--no-first-run",
	}

	if not launchOptions.disableDefaultArgs then
		for _, argument in DEFAULT_ARGUMENTS do
			table.insert(arguments, argument)
		end
	end

	if launchOptions.args ~= nil then
		for _, argument in launchOptions.args do
			table.insert(arguments, argument)
		end
	end

	if launchOptions.windowSize ~= nil then
		table.insert(arguments, `--window-size={launchOptions.windowSize.width},{launchOptions.windowSize.height}`)
	end

	if launchOptions.headless then
		table.insert(arguments, "--headless")
	end

	if launchOptions.ignoreCertificateErrors then
		table.insert(arguments, "--ignore-certificate-errors")
	end

	if launchOptions.enableLogging then
		table.insert(arguments, "--enable-logging")
	end

	if not launchOptions.enableGpu then
		table.insert(arguments, "--disable-gpu")
	end

	if launchOptions.proxyServer ~= nil then
		table.insert(arguments, "--proxy-server=" .. launchOptions.proxyServer)
	end

	if not launchOptions.sandbox then
		table.insert(arguments, "--no-sandbox")
		table.insert(arguments, "--disable-setuid-sandbox")
	end

	if launchOptions.extensions ~= nil then
		for _, extension in launchOptions.extensions do
			table.insert(arguments, "--load-extension=" .. extension)
		end
	end

	assert(launchOptions.path ~= nil, "chrome path required")

	local result = process.spawn(launchOptions.path, arguments, {
		shell = true,
		stdio = "none",
		env = launchOptions.processEnvs,
	})

	assert(result.ok, result.stderr)

	return result
end

return launchBrowser

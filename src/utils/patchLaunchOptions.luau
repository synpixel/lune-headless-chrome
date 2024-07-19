local types = require("../types")

local DEFAULT_OPTIONS: types.BrowserLaunchOptions = table.freeze({
	headless = true,
	sandbox = true,
	enableGpu = false,
	enableLogging = false,
	idleBrowserTimeout = 30,
	windowSize = nil,
	path = "chrome",
	userDataDirectory = nil,
	port = nil,
	ignoreCertificateErrors = true,
	extensions = nil,
	processEnvs = nil,
	args = nil,
	disableDefaultArgs = false,
	proxyServer = nil,
})

local function patchLaunchOptions(partialOptions: types.PartialBrowserLaunchOptions): types.BrowserLaunchOptions
	local options = table.clone(partialOptions)

	for key, default in DEFAULT_OPTIONS do
		if options[key] == nil then
			options[key] = default
		end
	end

	return options
end

return patchLaunchOptions

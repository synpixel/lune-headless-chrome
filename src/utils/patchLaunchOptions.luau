local net = require("@lune/net")
local types = require("../types")

local DEFAULT_PORT_RANGE = { min = 8000, max = 9000 }

local DEFAULT_OPTIONS: types.BrowserLaunchOptions = table.freeze({
	headless = true,
	sandbox = true,
	enableGpu = false,
	enableLogging = false,
	idleBrowserTimeout = 30,
	windowSize = nil,
	path = "chrome",
	userDataDirectory = nil,
	port = nil, -- default in patchLaunchOptions
	ignoreCertificateErrors = true,
	extensions = nil,
	processEnvs = nil,
	args = nil,
	disableDefaultArgs = false,
	proxyServer = nil,
})

local DO_NOTHING = function() end

local function isPortAvailable(port: number)
	local success, handle = pcall(net.serve, port, DO_NOTHING)
	if success then
		handle.stop()
	end

	return success
end

local function findAvailablePort(): number?
	for _ = DEFAULT_PORT_RANGE.min, DEFAULT_PORT_RANGE.max do
		local port = math.random(DEFAULT_PORT_RANGE.min, DEFAULT_PORT_RANGE.max)
		if not isPortAvailable(port) then
			continue
		end

		return port
	end

	return nil
end

local function patchLaunchOptions(partialOptions: types.PartialBrowserLaunchOptions?): types.BrowserLaunchOptions
	local options = if partialOptions ~= nil then table.clone(partialOptions) else table.clone(DEFAULT_OPTIONS)

	for key, default in DEFAULT_OPTIONS do
		if options[key] == nil then
			options[key] = default
		end
	end

	if options.port == nil then
		local defaultPort = findAvailablePort()
		assert(defaultPort ~= nil, "failed to find available port")
		options.port = defaultPort
	end

	return options
end

return patchLaunchOptions

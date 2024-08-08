local net = require("@lune/net")
local createBridge = require("./createBridge")
local launchBrowser = require("./launchBrowser")
local patchLaunchOptions = require("./utils/patchLaunchOptions")
local createTab = require("./createTab")
local Future = require("./packages/future")
local Browser = require("./protocol/Browser")
local types = require("./types")

local function fetchBrowserProtocolInfo(port: number): types.ProtocolInfo
	local response = net.request(`http://localhost:{port}/json/version`)
	local version = net.jsonDecode(response.body)
	return version
end

local function createBrowser(partialLaunchOptions: types.PartialBrowserLaunchOptions?): types.Browser
	local launchOptions = patchLaunchOptions(partialLaunchOptions)
	local launchResult = launchBrowser(launchOptions)
	assert(launchResult.ok, launchResult.stderr)

	local protocolInfo = fetchBrowserProtocolInfo(launchOptions.port)
	local bridge = createBridge(protocolInfo.webSocketDebuggerUrl)

	local browser = {}

	function browser:sendOverProtocol(method, parameters)
		return bridge:sendOverProtocol(method, parameters)
	end

	function browser:subscribeToEvent(event, callback)
		return bridge:subscribeToEvent(event, callback)
	end

	function browser:getVersion()
		return bridge:sendOverProtocol(Browser.getVersion)
	end

	function browser:newTab()
		return Future.spawn(function()
			local response = net.request({
				method = "PUT",
				url = `http://localhost:{launchOptions.port}/json/new`,
			})

			local protocolInfo: types.ProtocolInfo<{ id: string }> = net.jsonDecode(response.body)
			return createTab(browser, protocolInfo)
		end)
	end

	function browser:close()
		return Future.spawn(function()
			bridge:sendOverProtocol(Browser.close):await()
			bridge:close()
		end)
	end

	return browser
end

return createBrowser

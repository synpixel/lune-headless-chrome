local net = require("@lune/net")
local createBridge = require("./createBridge")
local mapList = require("./utils/mapList")
local mapFuture = require("./utils/mapFuture")
local Future = require("./packages/future")
local base64 = require("./packages/base64")
local types = require("./types")

local function createTab(protocolInfo: types.ProtocolInfo<{ id: string }>): types.Tab
	local socket = net.socket(protocolInfo.webSocketDebuggerUrl)
	local bridge = createBridge(socket)

	local tab = {}

	function tab:getTargetId()
		return protocolInfo.id
	end

	function tab:getTargetInfo()
		local targetId = tab:getTargetId()
		return mapFuture(bridge:sendOverProtocol("Target.getTargetInfo", { targetId = targetId }), function(result)
			return result.targetInfo
		end)
	end

	function tab:getUrl()
		return mapFuture(tab:getTargetInfo(), function(targetInfo)
			return targetInfo.url
		end)
	end

	function tab:navigateTo(url)
		return bridge:sendOverProtocol("Page.navigate", { url = url })
	end

	function tab:reload(ignoreCache, scriptToEvaluateOnLoad)
		return bridge:sendOverProtocol(
			"Page.reload",
			{ ignoreCache = ignoreCache, scriptToEvaluateOnLoad = scriptToEvaluateOnLoad }
		)
	end

	function tab:getCookies()
		return Future.spawn(function()
			local url = tab:getUrl():await()
			local result = bridge:sendOverProtocol("Network.getCookies", { urls = { url } }):await()
			return result.cookies
		end)
	end

	function tab:setCookies(cookies)
		return Future.spawn(function()
			local url = tab:getUrl():await()

			local patchedCookies = mapList(cookies, function(cookie)
				if cookie.url ~= nil then
					return cookie
				end

				local copy = table.clone(cookie)
				copy.url = url
				return copy
			end)

			return bridge:sendOverProtocol("Network.setCookies", { cookies = patchedCookies }):await()
		end)
	end

	function tab:captureScreenshot(options)
		return mapFuture(bridge:sendOverProtocol("Page.captureScreenshot"), function(result)
			local data = buffer.fromstring(result.data)
			return base64.decode(data)
		end)
	end

	function tab:close()
		return bridge:sendOverProtocol("Page.close")
	end

	return tab
end

return createTab

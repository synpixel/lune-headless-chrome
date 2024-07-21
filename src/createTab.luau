local net = require("@lune/net")
local createBridge = require("./createBridge")
local createElement = require("./createElement")
local mapList = require("./utils/mapList")
local filterList = require("./utils/filterList")
local mapFuture = require("./utils/mapFuture")
local waitFor = require("./utils/waitFor")
local qwerty = require("./utils/qwerty")
local Future = require("./packages/future")
local base64 = require("./packages/base64")
local Page = require("./protocol/Page")
local Target = require("./protocol/Target")
local Network = require("./protocol/Network")
local Input = require("./protocol/Input")
local DOM = require("./protocol/DOM")
local Runtime = require("./protocol/Runtime")
local Debugger = require("./protocol/Debugger")
local types = require("./types")

local function createTab(protocolInfo: types.ProtocolInfo<{ id: string }>): types.Tab
	local socket = net.socket(protocolInfo.webSocketDebuggerUrl)
	local bridge = createBridge(socket)

	local tab = {}

	function tab:sendOverProtocol(method, parameters)
		return bridge:sendOverProtocol(method, parameters)
	end

	function tab:getTargetId()
		return protocolInfo.id
	end

	function tab:getTargetInfo()
		local targetId = tab:getTargetId()
		return mapFuture(bridge:sendOverProtocol(Target.getTargetInfo, { targetId = targetId }), function(result)
			return result.targetInfo
		end)
	end

	function tab:getUrl()
		return mapFuture(tab:getTargetInfo(), function(targetInfo)
			return targetInfo.url
		end)
	end

	function tab:getTitle()
		return mapFuture(tab:getTargetInfo(), function(targetInfo)
			return targetInfo.title
		end)
	end

	function tab:navigateTo(url)
		return bridge:sendOverProtocol(Page.navigate, { url = url })
	end

	function tab:reload(ignoreCache, scriptToEvaluateOnLoad)
		return bridge:sendOverProtocol(
			Page.reload,
			{ ignoreCache = ignoreCache, scriptToEvaluateOnLoad = scriptToEvaluateOnLoad }
		)
	end

	function tab:getCookies()
		return Future.spawn(function()
			local url = tab:getUrl():await()
			local result = bridge:sendOverProtocol(Network.getCookies, { urls = { url } }):await()
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

			return bridge:sendOverProtocol(Network.setCookies, { cookies = patchedCookies }):await()
		end)
	end

	function tab:sendCharacters(characters)
		return Future.spawn(function()
			bridge:sendOverProtocol(Input.insertText, { text = characters }):await()
			return tab
		end)
	end

	function tab:pressKey(key)
		return Future.spawn(function()
			local definition = qwerty.findKeyDefinition(key)
			if definition == nil then
				return
			end

			local text = definition.text
			if text == nil and #definition.key == 1 then
				text = definition.key
			end

			local keyDownEvent = if text ~= nil then "keyDown" else "rawKeyDown"

			bridge
				:sendOverProtocol(Input.dispatchKeyEvent, {
					type = keyDownEvent,
					key = definition.key,
					text = text,
					code = definition.code,
					windowsVirtualKeyCode = definition.keyCode,
					nativeVirtualKeyCode = definition.keyCode,
				})
				:await()

			bridge
				:sendOverProtocol(Input.dispatchKeyEvent, {
					type = "keyUp",
					key = definition.key,
					text = text,
					code = definition.code,
					windowsVirtualKeyCode = definition.keyCode,
					nativeVirtualKeyCode = definition.keyCode,
				})
				:await()

			return tab
		end)
	end

	function tab:moveMouseToPoint(point)
		return Future.spawn(function()
			bridge
				:sendOverProtocol(Input.dispatchMouseEvent, {
					type = "mouseMoved",
					x = point.x,
					y = point.y,
				})
				:await()

			return tab
		end)
	end

	function tab:clickAtPoint(point)
		return Future.spawn(function()
			tab:moveMouseToPoint(point):await()

			bridge
				:sendOverProtocol(Input.dispatchMouseEvent, {
					type = "mousePressed",
					x = point.x,
					y = point.y,
					button = "left",
					clickCount = 1,
				})
				:await()

			bridge
				:sendOverProtocol(Input.dispatchMouseEvent, {
					type = "mouseReleased",
					x = point.x,
					y = point.y,
					button = "left",
					clickCount = 1,
				})
				:await()

			return tab
		end)
	end

	function tab:captureScreenshot(options)
		return mapFuture(bridge:sendOverProtocol(Page.captureScreenshot), function(result)
			local data = buffer.fromstring(result.data)
			return base64.decode(data)
		end)
	end

	function tab:evaluate(expression, awaitPromise)
		return mapFuture(
			bridge:sendOverProtocol(Runtime.evaluate, {
				expression = expression,
				returnByValue = false,
				generatePreview = true,
				silent = false,
				awaitPromise = awaitPromise,
				includeCommandLineAPI = false,
				userGesture = false,
			}),
			function(result)
				return result.result
			end
		)
	end

	function tab:getContent()
		local expression = [[
			let content = "";

			if (document.doctype) content += new XMLSerializer().serializeToString(document.doctype);
			if (document.documentElement) content += document.documentElement.outerHTML;

			content
		]]

		return mapFuture(tab:evaluate(expression), function(result)
			return result.value
		end)
	end

	function tab:describeNode(nodeId)
		return mapFuture(bridge:sendOverProtocol(DOM.describeNode, { nodeId = nodeId, depth = 100 }), function(result)
			return result.node
		end)
	end

	function tab:getDocument()
		return mapFuture(bridge:sendOverProtocol(DOM.getDocument, { depth = 0, pierce = false }), function(result)
			return result.root
		end)
	end

	function tab:runQuerySelectorOnNode(nodeId, selector)
		return mapFuture(
			bridge:sendOverProtocol(DOM.querySelector, { nodeId = nodeId, selector = selector }),
			function(result)
				if result.nodeId == 0 then
					return
				end

				return createElement(tab, result.nodeId)
			end
		)
	end

	function tab:runQuerySelectorAllOnNode(nodeId, selector)
		return mapFuture(
			bridge:sendOverProtocol(DOM.querySelectorAll, { nodeId = nodeId, selector = selector }),
			function(result)
				local nodeIds = filterList(result.nodeIds, function(nodeId)
					return nodeId ~= 0
				end)

				return mapList(nodeIds, function(nodeId)
					return createElement(tab, nodeId)
				end)
			end
		)
	end

	function tab:findElement(selector)
		return Future.spawn(function()
			local document = tab:getDocument():await()
			return tab:runQuerySelectorOnNode(document.nodeId, selector):await()
		end)
	end

	function tab:findElementByXPath(query)
		return Future.spawn(function()
			tab:getDocument():await()

			local result = tab:sendOverProtocol(DOM.performSearch, { query = query, includeUserAgentShadowDOM = true })
				:await()

			local searchResults = tab:sendOverProtocol(
				DOM.getSearchResults,
				{ searchId = result.searchId, fromIndex = 0, toIndex = result.resultCount }
			):await()

			local id = searchResults.nodeIds[1]
			return createElement(tab, id)
		end)
	end

	function tab:findElements(selector)
		return Future.spawn(function()
			local document = tab:getDocument():await()
			return tab:runQuerySelectorAllOnNode(document.nodeId, selector):await()
		end)
	end

	function tab:findElementsByXPath(query)
		return Future.spawn(function()
			tab:getDocument():await()

			local result = tab:sendOverProtocol(DOM.performSearch, { query = query, includeUserAgentShadowDOM = true })
				:await()

			local searchResults = tab:sendOverProtocol(
				DOM.getSearchResults,
				{ searchId = result.searchId, fromIndex = 0, toIndex = result.resultCount }
			):await()

			return mapList(searchResults.nodeIds, function(id)
				return createElement(tab, id)
			end)
		end)
	end

	function tab:waitForElement(selector, timeout)
		return waitFor(function()
			return tab:findElement(selector):await()
		end, timeout)
	end

	function tab:waitForElementByXPath(query, timeout)
		return waitFor(function()
			return tab:findElementByXPath(query):await()
		end, timeout)
	end

	function tab:waitForElements(selector, timeout)
		return waitFor(function()
			return tab:findElements(selector):await()
		end, timeout)
	end

	function tab:waitForElementsByXPath(query, timeout)
		return waitFor(function()
			return tab:findElementsByXPath(query):await()
		end, timeout)
	end

	function tab:enableDebugger()
		return bridge:sendOverProtocol(Debugger.enable)
	end

	function tab:disableDebugger()
		return bridge:sendOverProtocol(Debugger.disable)
	end

	function tab:close()
		return bridge:sendOverProtocol(Page.close)
	end

	return tab
end

return createTab

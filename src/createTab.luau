local serde = require("@lune/serde")
local Regex = require("@lune/regex")
local createBridge = require("./createBridge")
local createElement = require("./createElement")
local mapList = require("./utils/mapList")
local filterList = require("./utils/filterList")
local waitUntil = require("./utils/waitUntil")
local qwerty = require("./utils/qwerty")
local Future = require("./packages/future")
local base64 = require("./packages/base64")
local Page = require("./protocol/Page")
local Target = require("./protocol/Target")
local Network = require("./protocol/Network")
local Input = require("./protocol/Input")
local DOM = require("./protocol/DOM")
local Runtime = require("./protocol/Runtime")
local Browser = require("./protocol/Browser")
local Profiler = require("./protocol/Profiler")
local Debugger = require("./protocol/Debugger")
local types = require("./types")

local function createTab(browser: types.Browser, protocolInfo: types.ProtocolInfo<{ id: string }>): types.Tab
	local bridge = createBridge(protocolInfo.webSocketDebuggerUrl)

	--[[
	local isNavigating = false

	bridge:subscribeToEvent(Page.lifecycleEvent, function(parameters)
		if parameters.name == "networkAlmostIdle" then
			isNavigating = false
		elseif parameters.name == "init" then
			isNavigating = true
		end
	end)

	bridge:sendOverProtocol(Page.setLifecycleEventsEnabled, { enabled = true }):await()
	]]

	local tab = {}

	function tab:sendOverProtocol(method, parameters)
		return bridge:sendOverProtocol(method, parameters)
	end

	function tab:subscribeToEvent(event, callback)
		return bridge:subscribeToEvent(event, callback)
	end

	function tab:getTargetId()
		return Future.new(protocolInfo.id)
	end

	function tab:getTargetInfo()
		return Future.spawn(function()
			local targetId = tab:getTargetId():await()
			local result = bridge:sendOverProtocol(Target.getTargetInfo, { targetId = targetId }):await()
			return result.targetInfo
		end)
	end

	function tab:getUrl()
		return Future.spawn(function()
			local targetInfo = tab:getTargetInfo():await()
			return targetInfo.url
		end)
	end

	function tab:getTitle()
		return Future.spawn(function()
			local targetInfo = tab:getTargetInfo():await()
			return targetInfo.title
		end)
	end

	function tab:setUserAgent(userAgent, acceptLanguage, platform)
		return tab:sendOverProtocol(Network.setUserAgentOverride, {
			userAgent = userAgent,
			acceptLanguage = acceptLanguage,
			platform = platform,
		})
	end

	function tab:getStorage(itemName)
		return Future.spawn(function()
			local object = tab:evaluate(`localStorage.getItem("{itemName}")`):await()
			return serde.decode("json", object.value)
		end)
	end

	function tab:setStorage(itemName, item)
		local value = serde.encode("json", item)
		return tab:evaluate(`localStorage.setItem("{itemName}", JSON.stringify({value}))`)
	end

	function tab:removeStorage(itemName)
		return tab:evaluate(`localStorage.removeItem("{itemName}")`)
	end

	function tab:navigateTo(url)
		return Future.spawn(function()
			bridge:sendOverProtocol(Page.navigate, { url = url }):await()
			-- isNavigating = true
			return tab
		end)
	end

	--[[
	function tab:waitUntilNavigated()
		return waitUntil(function()
			return not isNavigating, tab
		end)
	end
	]]

	function tab:reload(ignoreCache, scriptToEvaluateOnLoad)
		return bridge:sendOverProtocol(
			Page.reload,
			{ ignoreCache = ignoreCache, scriptToEvaluateOnLoad = scriptToEvaluateOnLoad }
		)
	end

	function tab:getCookies()
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(Network.getCookies):await()
			return result.cookies
		end)
	end

	function tab:setCookies(cookies)
		return Future.spawn(function()
			local url = tab:getUrl():await()
			local startsWithHttp = url:find("^http") ~= nil

			local patchedCookies = mapList(cookies, function(cookie)
				if cookie.url ~= nil and not startsWithHttp then
					return cookie
				end

				local copy = table.clone(cookie)
				copy.url = url
				return copy
			end)

			tab:deleteCookies(patchedCookies):await()
			bridge:sendOverProtocol(Network.setCookies, { cookies = patchedCookies }):await()
		end)
	end

	function tab:deleteCookies(cookies)
		return Future.spawn(function()
			local url = tab:getUrl():await()
			local startsWithHttp = url:find("^http") ~= nil

			local patchedCookies = mapList(cookies, function(cookie)
				if cookie.url ~= nil and not startsWithHttp then
					return cookie
				end

				local copy = table.clone(cookie)
				copy.url = url
				return copy
			end)

			local futures = mapList(patchedCookies, function(cookie)
				return bridge:sendOverProtocol(Network.deleteCookies, cookie)
			end)

			return Future.all(futures):await()
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
				return tab
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
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(Page.captureScreenshot, options):await()
			local data = buffer.fromstring(result.data)
			return base64.decode(data)
		end)
	end

	function tab:startScreencast(options)
		return bridge:sendOverProtocol(Page.startScreencast, options)
	end

	function tab:stopScreencast()
		return bridge:sendOverProtocol(Page.stopScreencast)
	end

	function tab:onScreencastFrame(callback)
		return bridge:subscribeToEvent(Page.screencastFrame, function(result)
			local data = buffer.fromstring(result.data)

			callback({
				data = base64.decode(data),
				metadata = result.metadata,
				sessionId = result.sessionId,
			})
		end)
	end

	function tab:acknowledgeScreencastFrame(sessionId)
		return bridge:sendOverProtocol(Page.screencastFrameAck, { sessionId = sessionId })
	end

	function tab:printToPDF(options)
		assert(
			options == nil or options.transferMode == "ReturnAsBase64" or options.transferMode == nil,
			"transferMode should be ReturnAsBase64"
		)

		return Future.spawn(function()
			local result = bridge:sendOverProtocol(Page.printToPDF, options):await()
			local data = buffer.fromstring(result.data)
			return base64.decode(data)
		end)
	end

	function tab:evaluate(expression, awaitPromise)
		return Future.spawn(function()
			local result = bridge
				:sendOverProtocol(Runtime.evaluate, {
					expression = expression,
					returnByValue = false,
					generatePreview = true,
					silent = false,
					awaitPromise = awaitPromise,
					includeCommandLineAPI = false,
					userGesture = false,
				})
				:await()

			return result.result
		end)
	end

	function tab:getContent()
		local expression = [[
			let content = "";

			if (document.doctype) content += new XMLSerializer().serializeToString(document.doctype);
			if (document.documentElement) content += document.documentElement.outerHTML;

			content
		]]

		return Future.spawn(function()
			local result = tab:evaluate(expression):await()
			return result.value
		end)
	end

	function tab:describeNode(nodeId)
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(DOM.describeNode, { nodeId = nodeId, depth = 100 }):await()
			return result.node
		end)
	end

	function tab:getDocument()
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(DOM.getDocument, { depth = 0, pierce = false }):await()
			return result.root
		end)
	end

	function tab:runQuerySelectorOnNode(nodeId, selector)
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(DOM.querySelector, { nodeId = nodeId, selector = selector }):await()

			if result == nil or result.nodeId == 0 then
				return
			end

			return createElement(tab, result.nodeId)
		end)
	end

	function tab:runQuerySelectorAllOnNode(nodeId, selector)
		return Future.spawn(function()
			local result = bridge
				:sendOverProtocol(DOM.querySelectorAll, {
					nodeId = nodeId,
					selector = selector,
				})
				:await()

			if result == nil then
				return {}
			end

			local nodeIds = filterList(result.nodeIds, function(nodeId)
				return nodeId ~= 0
			end)

			return mapList(nodeIds, function(nodeId)
				return createElement(tab, nodeId)
			end)
		end)
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

			local result = tab:sendOverProtocol(DOM.performSearch, {
				query = query,
				includeUserAgentShadowDOM = true,
			}):await()

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

			local result = tab:sendOverProtocol(DOM.performSearch, {
				query = query,
				includeUserAgentShadowDOM = true,
			}):await()

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
		return waitUntil(function()
			local element = tab:findElement(selector):await()
			return element ~= nil, element
		end, timeout)
	end

	function tab:waitForElementByXPath(query, timeout)
		return waitUntil(function()
			local element = tab:findElementByXPath(query):await()
			return element ~= nil, element
		end, timeout)
	end

	function tab:waitForElements(selector, timeout)
		return Future.spawn(function()
			local elements = waitUntil(function()
				local result = tab:findElements(selector):await()
				return #result > 0, result
			end, timeout):await()

			return elements or {}
		end)
	end

	function tab:waitForElementsByXPath(query, timeout)
		return Future.spawn(function()
			local elements = waitUntil(function()
				local result = tab:findElementsByXPath(query):await()
				return #result > 0, result
			end, timeout):await()

			return elements or {}
		end)
	end

	function tab:getBounds()
		return Future.spawn(function()
			local targetId = tab:getTargetId():await()
			local result = browser:sendOverProtocol(Browser.getWindowForTarget, { targetId = targetId }):await()
			return result.bounds
		end)
	end

	function tab:setBounds(bounds)
		return Future.spawn(function()
			local targetId = tab:getTargetId():await()
			local result = browser:sendOverProtocol(Browser.getWindowForTarget, { targetId = targetId }):await()

			browser
				:sendOverProtocol(Browser.setWindowBounds, {
					windowId = result.windowId,
					bounds = bounds,
				})
				:await()

			return tab
		end)
	end

	function tab:bypassUserAgent()
		return Future.spawn(function()
			local object = tab:evaluate("window.navigator.userAgent", true):await()
			local userAgent = object.value:gsub("HeadlessChrome/", "Chrome/")

			local regex = Regex.new("(([^)]+))")
			userAgent = regex:replace(userAgent, "(Windows NT 10.0; Win64; x64)")

			tab:setUserAgent(userAgent):await()
		end)
	end

	function tab:bypassWebDriver()
		return bridge:sendOverProtocol(Page.addScriptToEvaluateOnNewDocument, {
			source = 'Object.defineProperty(navigator, "webdriver", { get: () => undefined });',
		})
	end

	function tab:bypassChrome()
		return bridge:sendOverProtocol(Page.addScriptToEvaluateOnNewDocument, {
			source = "window.chrome = { runtime: {} };",
		})
	end

	function tab:bypassPermissions()
		local source = [[
			const originalQuery = window.navigator.permissions.query;

			function stealthQuery(parameters) {
				return parameters.name === "notifications"
					? Promise.resolve({ state: Notification.permission })
					: originalQuery(parameters);
			}

			window.navigator.permissions.__proto__.query = stealthQuery;
		]]

		return bridge:sendOverProtocol(Page.addScriptToEvaluateOnNewDocument, { source = source })
	end

	function tab:bypassPlugins()
		local source = [[
			Object.defineProperty(navigator, "plugins", {
				get: () => [
					{ filename: "internal-pdf-viewer" },
					{ filename: "adsfkjlkjhalkh" },
					{ filename: "internal-nacl-plugin" },
				],
			});
		]]

		return bridge:sendOverProtocol(Page.addScriptToEvaluateOnNewDocument, { source = source })
	end

	function tab:bypassWebGLVendor()
		local source = [[
			const getParameter = WebGLRenderingContext.getParameter;
			WebGLRenderingContext.prototype.getParameter = (parameter) => {
				// UNMASKED_VENDOR_WEBGL
				if (parameter === 37445) return "Google Inc. (NVIDIA)";

				// UNMASKED_RENDERER_WEBGL
				if (parameter === 37446) return "ANGLE (NVIDIA, NVIDIA GeForce GTX 1050 Direct3D11 vs_5_0 ps_5_0, D3D11-27.21.14.5671)";

				return getParameter(parameter);
			};
		]]

		return bridge:sendOverProtocol(Page.addScriptToEvaluateOnNewDocument, { source = source })
	end

	function tab:enableStealthMode()
		return Future.spawn(function()
			tab:bypassUserAgent():await()
			tab:bypassWebDriver():await()
			tab:bypassChrome():await()
			tab:bypassPermissions():await()
			tab:bypassPlugins():await()
			tab:bypassWebGLVendor():await()
		end)
	end

	function tab:enableProfiler()
		return Future.spawn(function()
			bridge:sendOverProtocol(Profiler.enable):await()
			return tab
		end)
	end

	function tab:disableProfiler()
		return Future.spawn(function()
			bridge:sendOverProtocol(Profiler.disable):await()
			return tab
		end)
	end

	function tab:startPreciseJsCoverage()
		return Future.spawn(function()
			bridge:sendOverProtocol(Profiler.startPreciseCoverage, { callCount = true, detailed = true }):await()
			return tab
		end)
	end

	function tab:stopPreciseJsCoverage()
		return Future.spawn(function()
			bridge:sendOverProtocol(Profiler.stopPreciseCoverage):await()
			return tab
		end)
	end

	function tab:takePreciseJsCoverage()
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(Profiler.takePreciseCoverage):await()
			return result.result
		end)
	end

	function tab:enableDebugger()
		return bridge:sendOverProtocol(Debugger.enable)
	end

	function tab:disableDebugger()
		return bridge:sendOverProtocol(Debugger.disable)
	end

	function tab:getScriptSource(scriptId)
		return Future.spawn(function()
			local result = bridge:sendOverProtocol(Debugger.getScriptSource, { scriptId = scriptId }):await()
			return result.scriptSource
		end)
	end

	function tab:close()
		return Future.spawn(function()
			bridge:sendOverProtocol(Page.close):await()
			bridge:close()
		end)
	end

	return tab
end

return createTab

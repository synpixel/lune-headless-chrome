local mapList = require("./utils/mapList")
local mapFuture = require("./utils/mapFuture")
local waitFor = require("./utils/waitFor")
local pointUtils = require("./utils/pointUtils")
local Future = require("./packages/future")
local DOM = require("./protocol/DOM")
local Runtime = require("./protocol/Runtime")
local types = require("./types")

local function useElementQuad(quad: { number }): {
	topLeft: types.Point,
	topRight: types.Point,
	bottomRight: types.Point,
	bottomLeft: types.Point,
}
	return {
		topLeft = { x = quad[1], y = quad[2] },
		topRight = { x = quad[3], y = quad[4] },
		bottomRight = { x = quad[5], y = quad[6] },
		bottomLeft = { x = quad[7], y = quad[8] },
	}
end

local function createElement(tab: types.Tab, nodeId: number): types.Element
	local node = tab:describeNode(nodeId):await()
	local object =
		tab:sendOverProtocol(DOM.resolveNode, { backendNodeId = node.backendNodeId }):await().object :: Runtime.RemoteObject

	local element = {}

	function element:getDescription()
		return mapFuture(
			tab:sendOverProtocol(DOM.describeNode, { backendNodeId = node.backendNodeId, depth = 100 }),
			function(result)
				return result.node
			end
		)
	end

	function element:getAttributes()
		return Future.spawn(function()
			local attributes = {}

			local description = element:getDescription():await()
			for index = 1, #description.attributes, 2 do
				attributes[description.attributes[index]] = description.attributes[index + 1]
			end

			return attributes
		end)
	end

	function element:findElement(selector)
		return tab:runQuerySelectorOnNode(nodeId, selector):await()
	end

	element.findElementByXPath = tab.findElementByXPath :: any

	function element:findElements(selector)
		return tab:runQuerySelectorAllOnNode(nodeId, selector):await()
	end

	element.findElementsByXPath = tab.findElementsByXPath :: any

	function element:waitForElement(selector, timeout)
		return waitFor(function()
			return element:findElement(selector)
		end, timeout)
	end

	function element:waitForElementByXPath(query, timeout)
		return waitFor(function()
			return element:findElementByXPath(query)
		end, timeout)
	end

	function element:waitForElements(selector, timeout)
		return waitFor(function()
			return element:findElements(selector):await()
		end, timeout)
	end

	function element:waitForElementsByXPath(query, timeout)
		return waitFor(function()
			return element:findElementsByXPath(query):await()
		end, timeout)
	end

	function element:callFunction(declaration, arguments, awaitPromise)
		local mappedArguments: { { value: string } }? = nil
		if arguments ~= nil then
			mappedArguments = mapList(arguments, function(argument)
				return { value = tostring(argument) }
			end)
		end

		return mapFuture(
			tab:sendOverProtocol(Runtime.callFunctionOn, {
				objectId = object.objectId,
				functionDeclaration = declaration,
				arguments = mappedArguments,
				returnByValue = false,
				generatePreview = true,
				silent = false,
				awaitPromise = awaitPromise,
			}),
			function(result)
				return result.result
			end
		)
	end

	function element:getPosition()
		return mapFuture(
			tab:sendOverProtocol(DOM.getContentQuads, { backendNodeId = node.backendNodeId }),
			function(result)
				local quad = result.quads[1]
				local elementQuad = useElementQuad(quad)
				local point = pointUtils.addPoints(elementQuad.bottomRight, elementQuad.topLeft)

				return { x = point.x / 2, y = point.y / 2 }
			end
		)
	end

	function element:scrollIntoView()
		return Future.spawn(function()
			local declaration = [[
				async function() {
					if (!this.isConnected) return "node is detached from document";
					if (this.nodeType !== Node.ELEMENT_NODE) return "node is not of type HTMLElement";

					const visibleRatio = await new Promise((resolve) => {
						const observer = new IntersectionObserver((entries) => {
							resolve(entries[0].intersectionRatio);
							observer.disconnect();
						});
						observer.observe(this);
					});

					if (visibleRatio !== 1.0) {
						this.scrollIntoView({
							block: "center",
							inline: "center",
							behavior: "instant",
						});
					}
				}
			]]

			local result = element:callFunction(declaration, {}, true):await()
			if result.type == "string" then
				error(result.value)
			end

			return element
		end)
	end

	function element:moveMouseOver()
		return Future.spawn(function()
			element:scrollIntoView():await()
			local position = element:getPosition():await()
			tab:moveMouseToPoint(position):await()
			return element
		end)
	end

	function element:click()
		return Future.spawn(function()
			element:scrollIntoView():await()
			local position = element:getPosition():await()
			tab:clickAtPoint(position):await()
			return element
		end)
	end

	function element:sendCharactersInto(characters)
		return Future.spawn(function()
			element:click():await()
			tab:sendCharacters(characters):await()
			return element
		end)
	end

	function element:focus()
		return Future.spawn(function()
			element:scrollIntoView()
			tab:sendOverProtocol(DOM.focus, {
				backendNodeId = node.backendNodeId,
			}):await()
			return element
		end)
	end

	return element
end

return createElement

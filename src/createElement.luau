local mapList = require("./utils/mapList")
local waitUntil = require("./utils/waitUntil")
local pointUtils = require("./utils/pointUtils")
local Future = require("./packages/future")
local DOM = require("./protocol/DOM")
local Runtime = require("./protocol/Runtime")
local types = require("./types")

local function useElementQuad(quad: { number }): types.ElementQuad
	return {
		topLeft = { x = quad[1], y = quad[2] },
		topRight = { x = quad[3], y = quad[4] },
		bottomRight = { x = quad[5], y = quad[6] },
		bottomLeft = { x = quad[7], y = quad[8] },
	}
end

local function extractElementPosition(remoteObject: Runtime.RemoteObject): types.Point
	if remoteObject.preview == nil then
		return { x = 0, y = 0 }
	end

	local properties = {}

	for _, property in remoteObject.preview.properties do
		properties[property.name] = tonumber(property.value)
	end

	return {
		x = properties.x + properties.width / 2,
		y = properties.y + properties.height / 2,
	}
end

local function createElement(tab: types.Tab, nodeId: number): types.Element
	local node = tab:describeNode(nodeId):await()
	local object: Runtime.RemoteObject = nil

	do
		local result = tab:sendOverProtocol(DOM.resolveNode, { backendNodeId = node.backendNodeId }):await()
		object = result.object
	end

	local element = {}

	function element:getDescription()
		return Future.spawn(function()
			local result = tab:sendOverProtocol(DOM.describeNode, {
				backendNodeId = node.backendNodeId,
				depth = 100,
			}):await()

			return result.node
		end)
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
		return tab:runQuerySelectorOnNode(nodeId, selector)
	end

	element.findElementByXPath = tab.findElementByXPath :: any

	function element:findElements(selector)
		return tab:runQuerySelectorAllOnNode(nodeId, selector)
	end

	element.findElementsByXPath = tab.findElementsByXPath :: any

	function element:waitForElement(selector, timeout)
		return waitUntil(function()
			local otherElement = element:findElement(selector):await()
			return otherElement ~= nil, otherElement
		end, timeout)
	end

	function element:waitForElementByXPath(query, timeout)
		return waitUntil(function()
			local otherElement = element:findElementByXPath(query):await()
			return otherElement ~= nil, otherElement
		end, timeout)
	end

	function element:waitForElements(selector, timeout)
		return Future.spawn(function()
			local result = waitUntil(function()
				local elements = element:findElements(selector):await()
				return #elements > 0, elements
			end, timeout):await()

			if result == nil then
				return {}
			end

			return result
		end)
	end

	function element:waitForElementsByXPath(query, timeout)
		return Future.spawn(function()
			local result = waitUntil(function()
				local elements = element:findElementsByXPath(query):await()
				return #elements > 0, elements
			end, timeout):await()

			if result == nil then
				return {}
			end

			return result
		end)
	end

	function element:callFunction(declaration, arguments, awaitPromise)
		local mappedArguments: { { value: string } }? = nil
		if arguments ~= nil then
			mappedArguments = mapList(arguments, function(argument)
				return { value = tostring(argument) }
			end)
		end

		return Future.spawn(function()
			local result = tab:sendOverProtocol(Runtime.callFunctionOn, {
				objectId = object.objectId,
				functionDeclaration = declaration,
				arguments = mappedArguments,
				returnByValue = false,
				generatePreview = true,
				silent = false,
				awaitPromise = awaitPromise,
			}):await()

			return result.result
		end)
	end

	function element:getPosition()
		return Future.spawn(function()
			local result = tab:sendOverProtocol(DOM.getContentQuads, { backendNodeId = node.backendNodeId }):await()
			if result.quads ~= nil and #result.quads > 0 then
				local quad = result.quads[1]
				local elementQuad = useElementQuad(quad)
				local point = pointUtils.addPoints(elementQuad.bottomRight, elementQuad.topLeft)

				return { x = point.x / 2, y = point.y / 2 }
			end

			local position = waitUntil(function()
				local declaration = [[
					function() {
						let rect = this.getBoundingClientRect();
						if (rect.x !== 0) this.scrollIntoView();
						return this.getBoundingClientRect();
					}
				]]

				local result = element:callFunction(declaration):await()
				local point = extractElementPosition(result)

				if point.x == 0 then
					return false, nil
				end

				return true, point
			end)

			return position:await()
		end)
	end

	function element:getBoxModel()
		return Future.spawn(function()
			local result = tab:sendOverProtocol(DOM.getBoxModel, { backendNodeId = node.backendNodeId }):await()
			local model = result.model

			return {
				content = useElementQuad(model.content),
				padding = useElementQuad(model.padding),
				border = useElementQuad(model.border),
				margin = useElementQuad(model.margin),
				width = model.width,
				height = model.height,
				shapeOutside = model.shapeOutside,
			}
		end)
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
			element:scrollIntoView():await()
			tab:sendOverProtocol(DOM.focus, {
				backendNodeId = node.backendNodeId,
			}):await()
			return element
		end)
	end

	function element:captureScreenshot(options: types.ElementScreenshotOptions)
		return Future.spawn(function()
			element:scrollIntoView():await()

			local model = element:getBoxModel():await()
			local viewport = {
				x = model.content.topLeft.x,
				y = model.content.topLeft.y,
				width = model.content.topRight.x - model.content.topLeft.x,
				height = model.content.bottomLeft.y - model.content.topLeft.y,
				scale = 1,
			}

			return tab:captureScreenshot({
				format = options.format,
				quality = options.quality,
				clip = viewport,
				fromSurface = options.fromSurface,
				captureBeyondViewport = false,
				optimizeForSpeed = options.optimizeForSpeed,
			}):await()
		end)
	end

	return element
end

return createElement

local net = require("@lune/net")
local task = require("@lune/task")
local Future = require("./packages/future")
local types = require("./types")

local function generateProtocolId()
	return math.random(1, 999)
end

local function createBridge(socket: net.WebSocket): types.Bridge
	local protocolListeners: { [number]: (result: any) -> () } = {}
	local bridge = {}

	local function flushListeners(response: types.BridgeProtocolResponse)
		for id, listener in protocolListeners do
			if response.id == id then
				protocolListeners[id] = nil
				listener(response.result)
			end
		end
	end

	local responseStreamThread = task.spawn(function()
		while true do
			local response = net.jsonDecode(socket.next() :: string)
			flushListeners(response)
		end
	end)

	function bridge:sendOverProtocol(method, parameters)
		local id = generateProtocolId()
		local protocol: types.BridgeProtocolRequest = {
			id = id,
			method = method,
			params = parameters,
		}

		socket.send(net.jsonEncode(protocol))

		local future, listener = Future.pending()
		protocolListeners[id] = listener

		return future
	end

	function bridge:destroy()
		if responseStreamThread == nil then
			return
		end

		task.cancel(responseStreamThread)
		responseStreamThread = nil
	end

	return bridge
end

return createBridge

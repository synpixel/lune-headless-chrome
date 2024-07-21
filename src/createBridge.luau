local net = require("@lune/net")
local task = require("@lune/task")
local Future = require("./packages/future")
local types = require("./types")

local MAX_REQUEST_ID = 999

-- fixes incorrect serialization of empty tables
local function jsonEncode(value: any, pretty: boolean?)
	local result = net.jsonEncode(value):gsub("{}", "[]")
	return result
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
		local id = math.random(1, MAX_REQUEST_ID)
		local request: types.BridgeProtocolRequest = {
			id = id,
			method = method,
			params = parameters,
		}

		socket.send(jsonEncode(request))

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

		socket.close(0)
	end

	return bridge
end

return createBridge

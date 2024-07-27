local net = require("@lune/net")
local task = require("@lune/task")
local Future = require("./packages/future")
local types = require("./types")

local MAX_REQUEST_ID = 999

-- fixes incorrect serialization of empty tables
local function jsonEncode(value: any, pretty: boolean?)
	local result = net.jsonEncode(value, pretty):gsub("{}", "[]")
	return result
end

local function createBridge(url: string): types.Bridge
	local socket = net.socket(url)
	local protocolListeners: { [number]: (result: any) -> () } = {}
	local protocolEventConnections: { [string]: { (result: any) -> () } } = {}

	local bridge = {}

	local function flushListeners(response: types.BridgeProtocolResponse)
		for id, listener in protocolListeners do
			if response.id == id then
				protocolListeners[id] = nil
				listener(response.result)
			end
		end
	end

	local function flushEventConnections(response: types.BridgeProtocolEvent)
		local function flushEventListeners(listeners: { (result: any) -> () })
			for _, listener in listeners do
				task.spawn(listener, response.params)
			end
		end

		for event, listeners in protocolEventConnections do
			if response.method == event then
				flushEventListeners(listeners)
			end
		end
	end

	local responseStreamThread = task.spawn(function()
		while true do
			local response = net.jsonDecode(socket.next() :: string)

			-- hacky way to know if it's a response
			if response.id ~= nil then
				flushListeners(response)
				continue
			end

			-- or an event
			if response.method ~= nil then
				flushEventConnections(response)
				continue
			end
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

	function bridge:subscribeToEvent(event, callback)
		if protocolEventConnections[event] == nil then
			protocolEventConnections[event] = {}
		end

		table.insert(protocolEventConnections[event], callback)

		return function()
			if #protocolEventConnections[event] <= 1 then
				protocolEventConnections[event] = nil
				return
			end

			local index = table.find(protocolEventConnections[event], callback)
			table.remove(protocolEventConnections[event], index)
		end
	end

	function bridge:close()
		task.cancel(responseStreamThread)
		responseStreamThread = nil

		socket.close(0)
		socket = nil
	end

	return bridge
end

return createBridge

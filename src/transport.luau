local task = require("@lune/task")
local net = require("@lune/net")
local serde = require("@lune/serde")
local casing = require("./util/casing")
local Target = require("./protocol/target")

export type Transport = {
	connection: net.WebSocket,
	waiting_calls: { [number]: thread },
	listeners: { { event: string, session_id: string?, callback: (params: any) -> () } },
	open: boolean,
	call_id_counter: number,
	-- loop_shutdown_tx
	idle_browser_timeout: number,
	unique_call_id: (self: Transport) -> number,
	call_method_on_browser: <Request, Response>(
		self: Transport,
		method: string & { __Request: Request, __Response: Response },
		params: Request
	) -> Response,
	call_method_on_target: <Request, Response>(
		self: Transport,
		method: string & { __Request: Request, __Response: Response },
		params: Request,
		session_id: string
	) -> Response,
	listen_to_browser_event: <Parameters>(
		self: Transport,
		event: string & { __Parameters: Parameters },
		callback: (params: Parameters) -> ()
	) -> () -> (),
	listen_to_target_event: <Parameters>(
		self: Transport,
		event: string & { __Parameters: Parameters },
		session_id: string,
		callback: (params: Parameters) -> ()
	) -> () -> (),
	shutdown: (self: Transport) -> (),
}

local function unique_call_id(transport: Transport): number
	transport.call_id_counter += 1
	return transport.call_id_counter
end

local function call_method_on_browser<Request, Response>(
	transport: Transport,
	method: string & { __Request: Request, __Response: Response },
	params: Request
): Response
	if not transport.open then
		error("Connection was closed")
	end

	local id = transport:unique_call_id()
	local call = {
		id = id,
		method = method,
		params = casing.snake_to_camel(params),
	}

	local message = serde.encode("json", call)

	local thread = coroutine.running()
	transport.waiting_calls[id] = thread

	transport.connection:send(message)

	local response = coroutine.yield()
	if response.error then
		error(response.error.message)
	end

	return response.result
end

local function call_method_on_target<Request, Response>(
	transport: Transport,
	method: string & { __Request: Request, __Response: Response },
	params: Request,
	session_id: string
): Response
	if not transport.open then
		error("Connection was closed")
	end

	local id = transport:unique_call_id()
	local call = {
		id = id,
		method = method,
		params = casing.snake_to_camel(params),
	}

	local message = serde.encode("json", call)

	local thread = coroutine.running()
	transport.waiting_calls[id] = thread

	transport:call_method_on_browser(Target.SendMessageToTarget, {
		session_id = session_id,
		message = message,
	})

	local response = coroutine.yield()
	if response.error then
		error(response.error.message)
	end

	return response.result
end

local function listen_to_browser_event<Parameters>(
	transport: Transport,
	event: string & { __Parameters: Parameters },
	callback: (params: Parameters) -> ()
): () -> ()
	local listener = { event = event, callback = callback }
	table.insert(transport.listeners, listener)

	return function()
		local index = table.find(transport.listeners, listener)
		table.remove(transport.listeners, index)
	end
end

local function listen_to_target_event<Parameters>(
	transport: Transport,
	event: string & { __Parameters: Parameters },
	session_id: string,
	callback: (params: Parameters) -> ()
): () -> ()
	local listener = { event = event, session_id = session_id, callback = callback }
	table.insert(transport.listeners, listener)

	return function()
		local index = table.find(transport.listeners, listener)
		table.remove(transport.listeners, index)
	end
end

local function handle_incoming_messages(transport: Transport)
	local last_message_at = os.clock()

	task.spawn(function()
		while true do
			if not transport.open then
				break
			end

			local success, message = pcall(function()
				return transport.connection:next()
			end)
			if not success then
				transport.open = false
				break
			end

			local now = os.clock()

			if not message then
				if now - last_message_at > transport.idle_browser_timeout then
					transport.open = false
					break
				end

				continue
			end

			last_message_at = now

			local response = serde.decode("json", message)
			local session_id = if response.params then response.params.sessionId else nil

			if response.method == Target.ReceivedMessageFromTarget then
				response = serde.decode("json", response.params.message)
			end

			response = casing.camel_to_snake(response)

			for id, call in transport.waiting_calls do
				if response.id == id then
					transport.waiting_calls[id] = nil
					task.spawn(call, response)
					break
				end
			end

			for index, listener in transport.listeners do
				if session_id ~= listener.session_id then
					continue
				end

				if response.method == listener.event then
					task.spawn(listener.callback, response.params)
				end
			end
		end
	end)
end

local function shutdown(transport: Transport)
	transport.open = false
	transport.connection:close(1000)
end

local function create(websocket_url: string, idle_browser_timeout: number): Transport
	local connection = net.socket(websocket_url)

	local transport = {
		connection = connection,
		waiting_calls = {},
		listeners = {},
		open = true,
		call_id_counter = 0,
		idle_browser_timeout = idle_browser_timeout,
		unique_call_id = unique_call_id,
		call_method_on_browser = call_method_on_browser,
		call_method_on_target = call_method_on_target,
		listen_to_browser_event = listen_to_browser_event,
		listen_to_target_event = listen_to_target_event,
		shutdown = shutdown,
	}

	handle_incoming_messages(transport)

	return transport
end

return { create = create }

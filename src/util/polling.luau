local task = require("@lune/task")

export type Polling = {
	timeout: number,
	sleep: number,
	pause_until: <T>(self: Polling, try: () -> T?) -> T?,
}

local TIMEOUT_DEFAULT = 10
local SLEEP_DEFAULT = 1 / 10

local function pause_until<T>(polling: Polling, try: () -> T?): T?
	local start = os.clock()

	while true do
		local value = try()
		if value ~= nil then
			return value
		end

		if os.clock() - start > polling.timeout then
			return nil
		end

		task.wait(polling.sleep)
	end
end

local function create(timeout: number, sleep: number): Polling
	return {
		timeout = timeout,
		sleep = sleep,
		pause_until = pause_until,
	}
end

local function with_timeout(timeout: number): Polling
	return create(timeout, SLEEP_DEFAULT)
end

local function with_sleep(sleep: number): Polling
	return create(TIMEOUT_DEFAULT, sleep)
end

local function forever(): Polling
	return create(math.huge, SLEEP_DEFAULT)
end

return {
	create = create,
	with_timeout = with_timeout,
	with_sleep = with_sleep,
	forever = forever,
}

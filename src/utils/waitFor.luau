local Future = require("../packages/future")

local function waitFor<T>(tryFetch: () -> T?, timeout: number?): Future.Future<T?>
	return Future.spawn(function()
		local start = os.clock()

		while true do
			if timeout ~= nil and os.clock() >= start + timeout then
				return nil
			end

			local value = tryFetch()
			if value == nil then
				continue
			end

			return value
		end

		return nil
	end)
end

return waitFor

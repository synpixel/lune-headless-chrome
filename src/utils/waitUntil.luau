local Future = require("../packages/future")

local function waitUntil<T>(try: () -> (boolean, T?), timeout: number?): Future.Future<T?>
	return Future.spawn(function()
		local start = os.clock()

		while true do
			if timeout ~= nil and os.clock() > start + timeout then
				return nil
			end

			local success, value = try()
			if success then
				return value
			end
		end

		return nil
	end)
end

return waitUntil

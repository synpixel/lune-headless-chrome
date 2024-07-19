local Future = require("../packages/future")

local function mapFuture<T, K>(future: Future.Future<T>, transform: (value: T) -> K): Future.Future<K>
	return Future.spawn(function()
		local value = future:await()
		return transform(value)
	end)
end

return mapFuture

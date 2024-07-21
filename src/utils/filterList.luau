local function filterList<T>(list: { T }, predicate: (value: T) -> boolean): { T }
	local copy = {}

	for _, value in list do
		if predicate(value) then
			table.insert(copy, value)
		end
	end

	return copy
end

return filterList

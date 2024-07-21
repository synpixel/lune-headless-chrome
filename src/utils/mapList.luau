local function mapList<T, K>(list: { T }, transform: (value: T) -> K): { K }
	local copy = {}

	for _, value in list do
		table.insert(copy, transform(value))
	end

	return copy
end

return mapList

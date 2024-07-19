local function mapList<T, K>(array: { T }, transform: (value: T) -> K): { K }
	local copy = {}

	for _, value in array do
		table.insert(copy, transform(value))
	end

	return copy
end

return mapList

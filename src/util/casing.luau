local function transform(x: any, processor: (string) -> string): any
	if typeof(x) == "string" then
		return processor(x)
	elseif typeof(x) == "table" then
		local clone = {}

		for key, value in x do
			if typeof(value) == "table" then
				value = transform(value, processor)
			end
			clone[transform(key, processor)] = value
		end

		return clone
	else
		return x
	end
end

local function snake_to_camel<T>(value: T): T
	return transform(value, function(str)
		return string.gsub(str, "_(%l)", string.upper)
	end)
end

local function camel_to_snake<T>(value: T): T
	return transform(value, function(str)
		local result = str
		result = string.gsub(result, "(%u+)(%u%l)", "%1_%2")
		result = string.gsub(result, "([a-z%d])(%u)", "%1_%2")
		result = string.lower(result)
		return result
	end)
end

return {
	snake_to_camel = snake_to_camel,
	camel_to_snake = camel_to_snake,
}

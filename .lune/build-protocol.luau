local fs = require("@lune/fs")
local serde = require("@lune/serde")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local PROTOCOL_OUTPUT = "src/protocol"

type ProtocolDomainTypeDefinition = {
	name: string,
	description: string,
	optional: boolean?,
	type: string?,
	enum: { string }?,
	items: ProtocolDomainTypeDefinition?,
	properties: { ProtocolDomainTypeDefinition }?,
	["$ref"]: string?,
}

type ProtocolDomainCommandDefinition = {
	name: string,
}

type ProtocolDomainEventDefinition = {
	name: string,
}

type ProtocolDomainDefinition = {
	domain: string,
	dependencies: { string }?,
	types: { ProtocolDomainTypeDefinition & { id: string } }?,
	commands: { ProtocolDomainCommandDefinition }?,
	events: { ProtocolDomainEventDefinition }?,
}

type ProtocolDefinitions = {
	version: { major: string, minor: string },
	domains: { ProtocolDomainDefinition },
}

type File = {
	writeContents: (File, newContents: string) -> (),
	readContents: (File) -> string,
	append: (File, text: string) -> (),
	appendLine: (File, line: string) -> (),
}

local function mapList<T, K>(list: { T }, transform: (T) -> K): { K }
	local copy = {}

	for _, value in list do
		table.insert(copy, transform(value))
	end

	return copy
end

local function createFile(initialContents: string?): File
	local contents = initialContents or ""
	local file = {}

	function file:readContents()
		return contents
	end

	function file:writeContents(newContents)
		contents = newContents
	end

	function file:append(text)
		contents ..= text
	end

	function file:appendLine(line)
		contents ..= line
		contents ..= "\n"
	end

	return file
end

local function formatLuauWithStyLua(luau: string)
	local result = process.spawn("stylua", { "-" }, { stdin = luau, shell = true })

	if not result.ok then
		error(result.stderr)
	end

	return result.stdout
end

local function fixFieldNameForLuau(fieldName: string)
	if fieldName == "function" or fieldName == "end" then
		return `["{fieldName}"]`
	end

	return fieldName
end

local function parseToLuauType(domainType: ProtocolDomainTypeDefinition)
	local optionalTypeSuffix = ""
	if domainType.optional then
		optionalTypeSuffix = "?"
	end

	if domainType["$ref"] ~= nil then
		return domainType["$ref"] .. optionalTypeSuffix
	end

	if domainType.enum ~= nil then
		local parsedEnum = table.concat(
			mapList(domainType.enum, function(enumType)
				return `"{enumType}"`
			end),
			"|"
		)
		return `({parsedEnum})` .. optionalTypeSuffix
	end

	if domainType.type == "array" then
		return `\{ {parseToLuauType(domainType.items :: any)} \}` .. optionalTypeSuffix
	end

	if domainType.type == "object" then
		if domainType.properties == nil then
			return "{}"
		end

		local parsedFields = table.concat(
			mapList(domainType.properties, function(fieldType)
				return `{fixFieldNameForLuau(fieldType.name)}: {parseToLuauType(fieldType)}`
			end),
			","
		)

		return `\{ {parsedFields} \}` .. optionalTypeSuffix
	end

	if domainType.type == "integer" then
		return "number" .. optionalTypeSuffix
	end

	return domainType.type .. optionalTypeSuffix
end

local function writeDomainDefinitionFile(domain: ProtocolDomainDefinition)
	local file = createFile()

	if domain.dependencies ~= nil then
		for _, dependency in domain.dependencies do
			file:appendLine(`local {dependency} = require("./{dependency}")`)
		end
	end

	if domain.types ~= nil then
		for _, type in domain.types do
			file:appendLine(`export type {type.id} = {parseToLuauType(type)}`)
		end
	end

	file:appendLine("return {")

	if domain.commands ~= nil then
		for _, command in domain.commands do
			file:appendLine(`{fixFieldNameForLuau(command.name)} = "{domain.domain}.{command.name}",`)
		end
	end

	if domain.events ~= nil then
		for _, event in domain.events do
			file:appendLine(`{fixFieldNameForLuau(event.name)} = "{domain.domain}.{event.name}",`)
		end
	end

	file:appendLine("}")

	local formattedContents = formatLuauWithStyLua(file:readContents())
	file:writeContents(formattedContents)

	return file
end

local browserProtocolDefinitions =
	serde.decode("json", fs.readFile("json/browser_protocol.json")) :: ProtocolDefinitions
local jsProtocolDefinitions = serde.decode("json", fs.readFile("json/js_protocol.json")) :: ProtocolDefinitions

for _, domain in browserProtocolDefinitions.domains do
	local filePath = `{PROTOCOL_OUTPUT}/{domain.domain}.luau`
	local file = writeDomainDefinitionFile(domain)

	fs.writeFile(filePath, file:readContents())

	print(`{stdio.color("cyan")}BrowserProtocol/{domain.domain} >{stdio.color("reset")} {filePath}`)
end

for _, domain in jsProtocolDefinitions.domains do
	local filePath = `{PROTOCOL_OUTPUT}/{domain.domain}.luau`
	local file = writeDomainDefinitionFile(domain)

	fs.writeFile(filePath, file:readContents())

	print(`{stdio.color("cyan")}JSProtocol/{domain.domain} >{stdio.color("reset")} {filePath}`)
end

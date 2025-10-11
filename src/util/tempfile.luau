local process = require("@lune/process")
local fs = require("@lune/fs")

local NUM_RANDOM_CHARS = 6
local NUM_RETRIES = 2 ^ 31

local ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

local function assert_temp(): string
	if not process.env.TEMP then
		error("Missing TEMP variable")
	end
	if not fs.isDir(process.env.TEMP) then
		error("TEMP variable is not a directory")
	end
	return process.env.TEMP
end

local function tempname(prefix: string, length: number): string
	local name = ""

	for _ = 1, length do
		local idx = math.random(1, #ALPHABET)
		local char = string.sub(ALPHABET, idx, idx)
		name ..= char
	end

	return prefix .. name
end

local function tempfile(prefix: string): string
	local temp = assert_temp()

	for _ = 0, NUM_RETRIES do
		local name = tempname(prefix, NUM_RANDOM_CHARS)
		local path = `{temp}/{name}`

		if not fs.isFile(path) and not fs.isDir(path) then
			return path
		end
	end

	error("Too many temporary files exist")
end

return tempfile

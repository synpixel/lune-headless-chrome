--[[
	MIT License

	Copyright (c) 2024-present jiwonz

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local process = require("@lune/process")
local fs = require("@lune/fs")
local Regex = require("@lune/regex")

export type RegKey = {
	path: string,
	join_subkey: (self: RegKey, subpath: string) -> string,
	open_subkey: (self: RegKey, subpath: string) -> RegKey,
	get_value: (self: RegKey) -> string,
}

export type HkeyPath =
	| "HKEY_CLASSES_ROOT"
	| "HKEY_CURRENT_USER"
	| "HKEY_LOCAL_MACHINE"
	| "HKEY_USERS"
	| "HKEY_PERFORMANCE_DATA"
	| "HKEY_PERFORMANCE_TEXT"
	| "HKEY_PERFORMANCE_NLSTEXT"
	| "HKEY_CURRENT_CONFIG"
	| "HKEY_DYN_DATA"
	| "HKEY_CURRENT_USER_LOCAL_SETTINGS"

local ITEM_PATTERN =
	Regex.new("^(.*)\\s(REG_SZ|REG_MULTI_SZ|REG_EXPAND_SZ|REG_DWORD|REG_QWORD|REG_BINARY|REG_NONE)\\s+([^\\s].*)$")

local create_regkey: (path: string) -> RegKey

local function winreg_program(): string
	if process.os == "windows" then
		local windir = process.env.windir
		local path = `{windir}/system32/reg.exe`
		if fs.isFile(path) then
			return path
		end
	end
	return "REG"
end

local function winreg_exists(path: string): boolean
	local result = process.exec(winreg_program(), { "QUERY", `"{path}"`, "/ve" }, { shell = true })
	return result.ok
end

local function winreg_predef(hkey: HkeyPath): RegKey
	if winreg_exists(hkey) then
		return create_regkey(hkey)
	else
		error(`"{hkey}" is not a valid HKEY`)
	end
end

local function regkey_join_subkey(key: RegKey, subpath: string): string
	return `{key.path}\\{subpath}`
end

local function regkey_open_subkey(key: RegKey, subpath: string): RegKey
	local path = key:join_subkey(subpath)
	if winreg_exists(path) then
		return create_regkey(path)
	else
		error(`Key "{path}" does not exist`)
	end
end

local function regkey_get_raw_value(key: RegKey): { vtype: string, value: string }
	local result = process.exec(winreg_program(), { "QUERY", `"{key.path}"`, "/ve" }, { shell = true })
	if not result.ok then
		error(`Failed to read from key "{key.path}" ({result.stderr})`)
	end

	local items = {}
	local lines = string.split(result.stdout, "\r\n")

	for i = 2, #lines do
		local line = lines[i]
		if #line ~= 0 then
			table.insert(items, line)
		end
	end

	local item = items[#items] or ""
	local match = ITEM_PATTERN:captures(item)

	if match then
		local vtype = match:get(2)
		local value = match:get(3)
		if not vtype or not value then
			error("Failed to read from key")
		end

		return {
			vtype = vtype.text,
			value = value.text,
		}
	else
		error("Failed to capture item")
	end
end

local function regkey_get_value(key: RegKey): string
	local raw = regkey_get_raw_value(key)
	if raw.vtype == "REG_SZ" then
		return raw.value
	else
		error(`Unimplemented vtype "{raw.vtype}"`)
	end
end

function create_regkey(path: string): RegKey
	return {
		path = path,
		join_subkey = regkey_join_subkey,
		open_subkey = regkey_open_subkey,
		get_value = regkey_get_value,
	}
end

return {
	program = winreg_program,
	exists = winreg_exists,
	predef = winreg_predef,
}

-- Copyright (c) 2024-present LukaDev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local libs = require("./libs")
local runtime = require("./runtime")

export type Runtime = runtime.Runtime
export type RuntimeDefinition = runtime.RuntimeDefinition

export type TaskLib = libs.TaskLib

local std = {}

local function detectRuntime(): Runtime?
	if _G.UTIL_TARGET == "roblox" or typeof(script) == "Instance" then
		return require("./default-runtimes/roblox")
	end

	if string.sub(_VERSION, 1, 5):lower() == "lune " then
		return require("./default-runtimes/lune")
	end

	return nil
end

local detectedRuntime = detectRuntime()
std.runtime = detectedRuntime

if detectedRuntime ~= nil then
	std.task = table.clone(detectedRuntime.libs.task)
else
	std.task = libs.defaultImplementation("task", libs.task)
end

function std.setRuntime(runtime: Runtime)
	std.runtime = runtime

	for libName, lib in runtime.libs do
		for k, v in lib :: any do
			std[libName][k] = v
		end
	end
end

std.defineRuntime = runtime.defineRuntime

return std

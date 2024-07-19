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

local std = require("../std")
local task = std.task

local threadpool = {}

local freeThreads: { thread } = {}

local function run<T...>(f: (T...) -> (), thread: thread, ...)
	f(...)
	table.insert(freeThreads, thread)
end

local function yielder()
	while true do
		run(coroutine.yield())
	end
end

--[=[
  Executes the given function in a separate thread, threads are pooled and reused.
]=]
function threadpool.spawn<T...>(f: (T...) -> (), ...: T...)
	local thread
	if #freeThreads > 0 then
		thread = freeThreads[#freeThreads]
		freeThreads[#freeThreads] = nil
	else
		thread = coroutine.create(yielder)
		coroutine.resume(thread)
	end

	task.spawn(thread, f, thread, ...)
end

return threadpool

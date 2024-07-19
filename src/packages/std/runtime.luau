local libs = require("./libs")

export type Runtime = {
	name: string,
	libs: {
		task: libs.TaskLib,
	},
}

export type RuntimeDefinition = {
	name: string,
	libs: {
		task: {
			cancel: ((thread) -> ())?,
			defer: (<T...>(functionOrThread: thread | (T...) -> (), T...) -> thread)?,
			delay: (<T...>(duration: number, functionOrThread: thread | (T...) -> (), T...) -> thread)?,
			spawn: (<T...>(functionOrThread: thread | (T...) -> (), T...) -> thread)?,
			wait: ((duration: number) -> number)?,
		}?,
	},
}

local runtime = {}

local function notImplemented(runtimeName: string, functionName: string)
	return function()
		error(`'{functionName}' is not implemented by runtime '{runtimeName}'`, 2)
	end
end

local function fillMissing(runtimeName: string, lib: { [any]: any }?, libName: string, keys: { string }): { [any]: any }
	local out = {}

	for _, key in keys do
		if lib == nil or lib[key] == nil then
			out[key] = notImplemented(runtimeName, `{libName}.{key}`)
		else
			out[key] = lib[key]
		end
	end

	return out
end

function runtime.defineRuntime(definition: RuntimeDefinition): Runtime
	local runtime = {
		name = definition.name,
		libs = {
			task = fillMissing(definition.name, definition.libs.task, "task", libs.task),
		},
	}

	return runtime
end

return runtime

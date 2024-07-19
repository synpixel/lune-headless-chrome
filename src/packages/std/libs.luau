local libs = {}

export type TaskLib = {
	cancel: (thread) -> (),
	defer: <T...>(functionOrThread: thread | (T...) -> (), T...) -> thread,
	delay: <T...>(duration: number, functionOrThread: thread | (T...) -> (), T...) -> thread,
	spawn: <T...>(functionOrThread: thread | (T...) -> (), T...) -> thread,
	wait: (duration: number) -> number,
}

libs.task = {
	"cancel",
	"defer",
	"delay",
	"spawn",
	"wait",
}

function libs.defaultImplementation(libName: string, keys: { string }): { [any]: any }
	local lib = {}
	for _, key in keys do
		lib[key] = function()
			error(`Called '{libName}.${key}' on an unsupported runtime.`)
		end
	end
	return lib
end

return libs

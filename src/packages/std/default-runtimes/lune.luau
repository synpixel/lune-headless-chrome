local runtime = require("../runtime")
local task = require("@lune/task")

return runtime.defineRuntime({
	name = "lune",
	libs = {
		task = {
			cancel = task.cancel,
			defer = task.defer,
			delay = task.delay,
			spawn = task.spawn,
			wait = task.wait,
		},
	},
})

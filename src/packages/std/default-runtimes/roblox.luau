local runtime = require("../runtime")

return runtime.defineRuntime({
	name = "roblox",
	libs = {
		task = {
			cancel = task.cancel,
			defer = task.defer,
			delay = task.delay,
			spawn = task.spawn,
			wait = task.wait,
		} :: any,
	},
})

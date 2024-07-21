local Runtime = require("./Runtime")
export type ConsoleMessage = {
	source: (
		"xml"
		| "javascript"
		| "network"
		| "console-api"
		| "storage"
		| "appcache"
		| "rendering"
		| "security"
		| "other"
		| "deprecation"
		| "worker"
	),
	level: "log" | "warning" | "error" | "debug" | "info",
	text: string,
	url: string?,
	line: number?,
	column: number?,
}
return {
	clearMessages = "Console.clearMessages",
	disable = "Console.disable",
	enable = "Console.enable",
}

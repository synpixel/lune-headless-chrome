local Runtime = require("./Runtime")
local Network = require("./Network")
export type LogEntry = {
	source: "xml"
		| "javascript"
		| "network"
		| "storage"
		| "appcache"
		| "rendering"
		| "security"
		| "deprecation"
		| "worker"
		| "violation"
		| "intervention"
		| "recommendation"
		| "other",
	level: "verbose" | "info" | "warning" | "error",
	text: string,
	category: "cors",
	timestamp: Runtime.Timestamp,
	url: string,
	lineNumber: number,
	stackTrace: Runtime.StackTrace,
	networkRequestId: Network.RequestId,
	workerId: string,
	args: { Runtime.RemoteObject },
}
export type ViolationSetting = {
	name: "longTask"
		| "longLayout"
		| "blockedEvent"
		| "blockedParser"
		| "discouragedAPIUse"
		| "handler"
		| "recurringHandler",
	threshold: number,
}
return {
	clear = "Log.clear",
	disable = "Log.disable",
	enable = "Log.enable",
	startViolationsReport = "Log.startViolationsReport",
	stopViolationsReport = "Log.stopViolationsReport",
}

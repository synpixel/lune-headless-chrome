export type ScriptId = string
export type SerializationOptions =
	{ serialization: "deep" | "json" | "idOnly", maxDepth: number?, additionalParameters: {} }
export type DeepSerializedValue = {
	type: (
		"undefined"
		| "null"
		| "string"
		| "number"
		| "boolean"
		| "bigint"
		| "regexp"
		| "date"
		| "symbol"
		| "array"
		| "object"
		| "function"
		| "map"
		| "set"
		| "weakmap"
		| "weakset"
		| "error"
		| "proxy"
		| "promise"
		| "typedarray"
		| "arraybuffer"
		| "node"
		| "window"
		| "generator"
	),
	value: any?,
	objectId: string?,
	weakLocalObjectReference: number?,
}
export type RemoteObjectId = string
export type UnserializableValue = string
export type RemoteObject = {
	type: "object" | "function" | "undefined" | "string" | "number" | "boolean" | "symbol" | "bigint",
	subtype: (
		"array"
		| "null"
		| "node"
		| "regexp"
		| "date"
		| "map"
		| "set"
		| "weakmap"
		| "weakset"
		| "iterator"
		| "generator"
		| "error"
		| "proxy"
		| "promise"
		| "typedarray"
		| "arraybuffer"
		| "dataview"
		| "webassemblymemory"
		| "wasmvalue"
	)?,
	className: string?,
	value: any?,
	unserializableValue: UnserializableValue?,
	description: string?,
	deepSerializedValue: DeepSerializedValue?,
	objectId: RemoteObjectId?,
	preview: ObjectPreview?,
	customPreview: CustomPreview?,
}
export type CustomPreview = { header: string, bodyGetterId: RemoteObjectId? }
export type ObjectPreview = {
	type: "object" | "function" | "undefined" | "string" | "number" | "boolean" | "symbol" | "bigint",
	subtype: (
		"array"
		| "null"
		| "node"
		| "regexp"
		| "date"
		| "map"
		| "set"
		| "weakmap"
		| "weakset"
		| "iterator"
		| "generator"
		| "error"
		| "proxy"
		| "promise"
		| "typedarray"
		| "arraybuffer"
		| "dataview"
		| "webassemblymemory"
		| "wasmvalue"
	)?,
	description: string?,
	overflow: boolean,
	properties: { PropertyPreview },
	entries: { EntryPreview }?,
}
export type PropertyPreview = {
	name: string,
	type: "object" | "function" | "undefined" | "string" | "number" | "boolean" | "symbol" | "accessor" | "bigint",
	value: string?,
	valuePreview: ObjectPreview?,
	subtype: (
		"array"
		| "null"
		| "node"
		| "regexp"
		| "date"
		| "map"
		| "set"
		| "weakmap"
		| "weakset"
		| "iterator"
		| "generator"
		| "error"
		| "proxy"
		| "promise"
		| "typedarray"
		| "arraybuffer"
		| "dataview"
		| "webassemblymemory"
		| "wasmvalue"
	)?,
}
export type EntryPreview = { key: ObjectPreview?, value: ObjectPreview }
export type PropertyDescriptor = {
	name: string,
	value: RemoteObject?,
	writable: boolean?,
	get: RemoteObject?,
	set: RemoteObject?,
	configurable: boolean,
	enumerable: boolean,
	wasThrown: boolean?,
	isOwn: boolean?,
	symbol: RemoteObject?,
}
export type InternalPropertyDescriptor = { name: string, value: RemoteObject? }
export type PrivatePropertyDescriptor = { name: string, value: RemoteObject?, get: RemoteObject?, set: RemoteObject? }
export type CallArgument = { value: any?, unserializableValue: UnserializableValue?, objectId: RemoteObjectId? }
export type ExecutionContextId = number
export type ExecutionContextDescription = {
	id: ExecutionContextId,
	origin: string,
	name: string,
	uniqueId: string,
	auxData: {},
}
export type ExceptionDetails = {
	exceptionId: number,
	text: string,
	lineNumber: number,
	columnNumber: number,
	scriptId: ScriptId?,
	url: string?,
	stackTrace: StackTrace?,
	exception: RemoteObject?,
	executionContextId: ExecutionContextId?,
	exceptionMetaData: {},
}
export type Timestamp = number
export type TimeDelta = number
export type CallFrame = { functionName: string, scriptId: ScriptId, url: string, lineNumber: number, columnNumber: number }
export type StackTrace = { description: string?, callFrames: { CallFrame }, parent: StackTrace?, parentId: StackTraceId? }
export type UniqueDebuggerId = string
export type StackTraceId = { id: string, debuggerId: UniqueDebuggerId? }
return {
	awaitPromise = "Runtime.awaitPromise",
	callFunctionOn = "Runtime.callFunctionOn",
	compileScript = "Runtime.compileScript",
	disable = "Runtime.disable",
	discardConsoleEntries = "Runtime.discardConsoleEntries",
	enable = "Runtime.enable",
	evaluate = "Runtime.evaluate",
	getIsolateId = "Runtime.getIsolateId",
	getHeapUsage = "Runtime.getHeapUsage",
	getProperties = "Runtime.getProperties",
	globalLexicalScopeNames = "Runtime.globalLexicalScopeNames",
	queryObjects = "Runtime.queryObjects",
	releaseObject = "Runtime.releaseObject",
	releaseObjectGroup = "Runtime.releaseObjectGroup",
	runIfWaitingForDebugger = "Runtime.runIfWaitingForDebugger",
	runScript = "Runtime.runScript",
	setAsyncCallStackDepth = "Runtime.setAsyncCallStackDepth",
	setCustomObjectFormatterEnabled = "Runtime.setCustomObjectFormatterEnabled",
	setMaxCallStackSizeToCapture = "Runtime.setMaxCallStackSizeToCapture",
	terminateExecution = "Runtime.terminateExecution",
	addBinding = "Runtime.addBinding",
	removeBinding = "Runtime.removeBinding",
	getExceptionDetails = "Runtime.getExceptionDetails",
	bindingCalled = "Runtime.bindingCalled",
	consoleAPICalled = "Runtime.consoleAPICalled",
	exceptionRevoked = "Runtime.exceptionRevoked",
	exceptionThrown = "Runtime.exceptionThrown",
	executionContextCreated = "Runtime.executionContextCreated",
	executionContextDestroyed = "Runtime.executionContextDestroyed",
	executionContextsCleared = "Runtime.executionContextsCleared",
	inspectRequested = "Runtime.inspectRequested",
}

-- this file was automatically generated and not intended for manual editing
local Runtime = require("./Runtime")
export type BreakpointId = string
export type CallFrameId = string
export type Location = { scriptId: Runtime.ScriptId, lineNumber: number, columnNumber: number? }
export type ScriptPosition = { lineNumber: number, columnNumber: number }
export type LocationRange = { scriptId: Runtime.ScriptId, start: ScriptPosition, ["end"]: ScriptPosition }
export type CallFrame = {
	callFrameId: CallFrameId,
	functionName: string,
	functionLocation: Location?,
	location: Location,
	url: string,
	scopeChain: { Scope },
	this: Runtime.RemoteObject,
	returnValue: Runtime.RemoteObject?,
	canBeRestarted: boolean?,
}
export type Scope = {
	type: (
		"global"
		| "local"
		| "with"
		| "closure"
		| "catch"
		| "block"
		| "script"
		| "eval"
		| "module"
		| "wasm-expression-stack"
	),
	object: Runtime.RemoteObject,
	name: string?,
	startLocation: Location?,
	endLocation: Location?,
}
export type SearchMatch = { lineNumber: number, lineContent: string }
export type BreakLocation = {
	scriptId: Runtime.ScriptId,
	lineNumber: number,
	columnNumber: number?,
	type: ("debuggerStatement" | "call" | "return")?,
}
export type WasmDisassemblyChunk = { lines: { string }, bytecodeOffsets: { number } }
export type ScriptLanguage = "JavaScript" | "WebAssembly"
export type DebugSymbols = { type: "None" | "SourceMap" | "EmbeddedDWARF" | "ExternalDWARF", externalURL: string? }
return {
	continueToLocation = "Debugger.continueToLocation",
	disable = "Debugger.disable",
	enable = "Debugger.enable",
	evaluateOnCallFrame = "Debugger.evaluateOnCallFrame",
	getPossibleBreakpoints = "Debugger.getPossibleBreakpoints",
	getScriptSource = "Debugger.getScriptSource",
	disassembleWasmModule = "Debugger.disassembleWasmModule",
	nextWasmDisassemblyChunk = "Debugger.nextWasmDisassemblyChunk",
	getWasmBytecode = "Debugger.getWasmBytecode",
	getStackTrace = "Debugger.getStackTrace",
	pause = "Debugger.pause",
	pauseOnAsyncCall = "Debugger.pauseOnAsyncCall",
	removeBreakpoint = "Debugger.removeBreakpoint",
	restartFrame = "Debugger.restartFrame",
	resume = "Debugger.resume",
	searchInContent = "Debugger.searchInContent",
	setAsyncCallStackDepth = "Debugger.setAsyncCallStackDepth",
	setBlackboxPatterns = "Debugger.setBlackboxPatterns",
	setBlackboxedRanges = "Debugger.setBlackboxedRanges",
	setBreakpoint = "Debugger.setBreakpoint",
	setInstrumentationBreakpoint = "Debugger.setInstrumentationBreakpoint",
	setBreakpointByUrl = "Debugger.setBreakpointByUrl",
	setBreakpointOnFunctionCall = "Debugger.setBreakpointOnFunctionCall",
	setBreakpointsActive = "Debugger.setBreakpointsActive",
	setPauseOnExceptions = "Debugger.setPauseOnExceptions",
	setReturnValue = "Debugger.setReturnValue",
	setScriptSource = "Debugger.setScriptSource",
	setSkipAllPauses = "Debugger.setSkipAllPauses",
	setVariableValue = "Debugger.setVariableValue",
	stepInto = "Debugger.stepInto",
	stepOut = "Debugger.stepOut",
	stepOver = "Debugger.stepOver",
	breakpointResolved = "Debugger.breakpointResolved",
	paused = "Debugger.paused",
	resumed = "Debugger.resumed",
	scriptFailedToParse = "Debugger.scriptFailedToParse",
	scriptParsed = "Debugger.scriptParsed",
}

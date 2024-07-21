local DOM = require("./DOM")
local Runtime = require("./Runtime")
export type DOMBreakpointType = "subtree-modified" | "attribute-modified" | "node-removed"
export type CSPViolationType = "trustedtype-sink-violation" | "trustedtype-policy-violation"
export type EventListener = {
	type: string,
	useCapture: boolean,
	passive: boolean,
	once: boolean,
	scriptId: Runtime.ScriptId,
	lineNumber: number,
	columnNumber: number,
	handler: Runtime.RemoteObject,
	originalHandler: Runtime.RemoteObject,
	backendNodeId: DOM.BackendNodeId,
}
return {
	getEventListeners = "DOMDebugger.getEventListeners",
	removeDOMBreakpoint = "DOMDebugger.removeDOMBreakpoint",
	removeEventListenerBreakpoint = "DOMDebugger.removeEventListenerBreakpoint",
	removeInstrumentationBreakpoint = "DOMDebugger.removeInstrumentationBreakpoint",
	removeXHRBreakpoint = "DOMDebugger.removeXHRBreakpoint",
	setBreakOnCSPViolation = "DOMDebugger.setBreakOnCSPViolation",
	setDOMBreakpoint = "DOMDebugger.setDOMBreakpoint",
	setEventListenerBreakpoint = "DOMDebugger.setEventListenerBreakpoint",
	setInstrumentationBreakpoint = "DOMDebugger.setInstrumentationBreakpoint",
	setXHRBreakpoint = "DOMDebugger.setXHRBreakpoint",
}

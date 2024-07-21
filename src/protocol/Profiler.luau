local Runtime = require("./Runtime")
local Debugger = require("./Debugger")
export type ProfileNode = {
	id: number,
	callFrame: Runtime.CallFrame,
	hitCount: number,
	children: { number },
	deoptReason: string,
	positionTicks: { PositionTickInfo },
}
export type Profile = {
	nodes: { ProfileNode },
	startTime: number,
	endTime: number,
	samples: { number },
	timeDeltas: { number },
}
export type PositionTickInfo = { line: number, ticks: number }
export type CoverageRange = { startOffset: number, endOffset: number, count: number }
export type FunctionCoverage = { functionName: string, ranges: { CoverageRange }, isBlockCoverage: boolean }
export type ScriptCoverage = { scriptId: Runtime.ScriptId, url: string, functions: { FunctionCoverage } }
return {
	disable = "Profiler.disable",
	enable = "Profiler.enable",
	getBestEffortCoverage = "Profiler.getBestEffortCoverage",
	setSamplingInterval = "Profiler.setSamplingInterval",
	start = "Profiler.start",
	startPreciseCoverage = "Profiler.startPreciseCoverage",
	stop = "Profiler.stop",
	stopPreciseCoverage = "Profiler.stopPreciseCoverage",
	takePreciseCoverage = "Profiler.takePreciseCoverage",
}

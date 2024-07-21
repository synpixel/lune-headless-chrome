local IO = require("./IO")
export type MemoryDumpConfig = {}
export type TraceConfig = {
	recordMode: ("recordUntilFull" | "recordContinuously" | "recordAsMuchAsPossible" | "echoToConsole")?,
	traceBufferSizeInKb: number?,
	enableSampling: boolean?,
	enableSystrace: boolean?,
	enableArgumentFilter: boolean?,
	includedCategories: { string }?,
	excludedCategories: { string }?,
	syntheticDelays: { string }?,
	memoryDumpConfig: MemoryDumpConfig?,
}
export type StreamFormat = "json" | "proto"
export type StreamCompression = "none" | "gzip"
export type MemoryDumpLevelOfDetail = "background" | "light" | "detailed"
export type TracingBackend = "auto" | "chrome" | "system"
return {
	["end"] = "Tracing.end",
	getCategories = "Tracing.getCategories",
	recordClockSyncMarker = "Tracing.recordClockSyncMarker",
	requestMemoryDump = "Tracing.requestMemoryDump",
	start = "Tracing.start",
}

local Runtime = require("./Runtime")
export type HeapSnapshotObjectId = string
export type SamplingHeapProfileNode = {
	callFrame: Runtime.CallFrame,
	selfSize: number,
	id: number,
	children: { SamplingHeapProfileNode },
}
export type SamplingHeapProfileSample = { size: number, nodeId: number, ordinal: number }
export type SamplingHeapProfile = { head: SamplingHeapProfileNode, samples: { SamplingHeapProfileSample } }
return {
	addInspectedHeapObject = "HeapProfiler.addInspectedHeapObject",
	collectGarbage = "HeapProfiler.collectGarbage",
	disable = "HeapProfiler.disable",
	enable = "HeapProfiler.enable",
	getHeapObjectId = "HeapProfiler.getHeapObjectId",
	getObjectByHeapObjectId = "HeapProfiler.getObjectByHeapObjectId",
	getSamplingProfile = "HeapProfiler.getSamplingProfile",
	startSampling = "HeapProfiler.startSampling",
	startTrackingHeapObjects = "HeapProfiler.startTrackingHeapObjects",
	stopSampling = "HeapProfiler.stopSampling",
	stopTrackingHeapObjects = "HeapProfiler.stopTrackingHeapObjects",
	takeHeapSnapshot = "HeapProfiler.takeHeapSnapshot",
}

export type PressureLevel = "moderate" | "critical"
export type SamplingProfileNode = { size: number, total: number, stack: { string } }
export type SamplingProfile = { samples: { SamplingProfileNode }, modules: { Module } }
export type Module = { name: string, uuid: string, baseAddress: string, size: number }
return {
	getDOMCounters = "Memory.getDOMCounters",
	prepareForLeakDetection = "Memory.prepareForLeakDetection",
	forciblyPurgeJavaScriptMemory = "Memory.forciblyPurgeJavaScriptMemory",
	setPressureNotificationsSuppressed = "Memory.setPressureNotificationsSuppressed",
	simulatePressureNotification = "Memory.simulatePressureNotification",
	startSampling = "Memory.startSampling",
	stopSampling = "Memory.stopSampling",
	getAllTimeSamplingProfile = "Memory.getAllTimeSamplingProfile",
	getBrowserSamplingProfile = "Memory.getBrowserSamplingProfile",
	getSamplingProfile = "Memory.getSamplingProfile",
}

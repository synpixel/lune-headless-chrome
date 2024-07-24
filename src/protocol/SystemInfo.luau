-- this file was automatically generated and not intended for manual editing
export type GPUDevice = {
	vendorId: number,
	deviceId: number,
	subSysId: number?,
	revision: number?,
	vendorString: string,
	deviceString: string,
	driverVendor: string,
	driverVersion: string,
}
export type Size = { width: number, height: number }
export type VideoDecodeAcceleratorCapability = { profile: string, maxResolution: Size, minResolution: Size }
export type VideoEncodeAcceleratorCapability = {
	profile: string,
	maxResolution: Size,
	maxFramerateNumerator: number,
	maxFramerateDenominator: number,
}
export type SubsamplingFormat = "yuv420" | "yuv422" | "yuv444"
export type ImageType = "jpeg" | "webp" | "unknown"
export type ImageDecodeAcceleratorCapability = {
	imageType: ImageType,
	maxDimensions: Size,
	minDimensions: Size,
	subsamplings: { SubsamplingFormat },
}
export type GPUInfo = {
	devices: { GPUDevice },
	auxAttributes: {},
	featureStatus: {},
	driverBugWorkarounds: { string },
	videoDecoding: { VideoDecodeAcceleratorCapability },
	videoEncoding: { VideoEncodeAcceleratorCapability },
	imageDecoding: { ImageDecodeAcceleratorCapability },
}
export type ProcessInfo = { type: string, id: number, cpuTime: number }
return {
	getInfo = "SystemInfo.getInfo",
	getFeatureState = "SystemInfo.getFeatureState",
	getProcessInfo = "SystemInfo.getProcessInfo",
}

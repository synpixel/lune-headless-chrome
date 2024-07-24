-- this file was automatically generated and not intended for manual editing
local DOM = require("./DOM")
local Page = require("./Page")
local Runtime = require("./Runtime")
export type ScreenOrientation = {
	type: "portraitPrimary" | "portraitSecondary" | "landscapePrimary" | "landscapeSecondary",
	angle: number,
}
export type DisplayFeature = { orientation: "vertical" | "horizontal", offset: number, maskLength: number }
export type DevicePosture = { type: "continuous" | "folded" }
export type MediaFeature = { name: string, value: string }
export type VirtualTimePolicy = "advance" | "pause" | "pauseIfNetworkFetchesPending"
export type UserAgentBrandVersion = { brand: string, version: string }
export type UserAgentMetadata = {
	brands: { UserAgentBrandVersion }?,
	fullVersionList: { UserAgentBrandVersion }?,
	fullVersion: string?,
	platform: string,
	platformVersion: string,
	architecture: string,
	model: string,
	mobile: boolean,
	bitness: string?,
	wow64: boolean?,
}
export type SensorType = (
	"absolute-orientation"
	| "accelerometer"
	| "ambient-light"
	| "gravity"
	| "gyroscope"
	| "linear-acceleration"
	| "magnetometer"
	| "proximity"
	| "relative-orientation"
)
export type SensorMetadata = { available: boolean?, minimumFrequency: number?, maximumFrequency: number? }
export type SensorReadingSingle = { value: number }
export type SensorReadingXYZ = { x: number, y: number, z: number }
export type SensorReadingQuaternion = { x: number, y: number, z: number, w: number }
export type SensorReading = { single: SensorReadingSingle?, xyz: SensorReadingXYZ?, quaternion: SensorReadingQuaternion? }
export type PressureSource = "cpu"
export type PressureState = "nominal" | "fair" | "serious" | "critical"
export type PressureMetadata = { available: boolean? }
export type DisabledImageType = "avif" | "webp"
return {
	canEmulate = "Emulation.canEmulate",
	clearDeviceMetricsOverride = "Emulation.clearDeviceMetricsOverride",
	clearGeolocationOverride = "Emulation.clearGeolocationOverride",
	resetPageScaleFactor = "Emulation.resetPageScaleFactor",
	setFocusEmulationEnabled = "Emulation.setFocusEmulationEnabled",
	setAutoDarkModeOverride = "Emulation.setAutoDarkModeOverride",
	setCPUThrottlingRate = "Emulation.setCPUThrottlingRate",
	setDefaultBackgroundColorOverride = "Emulation.setDefaultBackgroundColorOverride",
	setDeviceMetricsOverride = "Emulation.setDeviceMetricsOverride",
	setDevicePostureOverride = "Emulation.setDevicePostureOverride",
	clearDevicePostureOverride = "Emulation.clearDevicePostureOverride",
	setScrollbarsHidden = "Emulation.setScrollbarsHidden",
	setDocumentCookieDisabled = "Emulation.setDocumentCookieDisabled",
	setEmitTouchEventsForMouse = "Emulation.setEmitTouchEventsForMouse",
	setEmulatedMedia = "Emulation.setEmulatedMedia",
	setEmulatedVisionDeficiency = "Emulation.setEmulatedVisionDeficiency",
	setGeolocationOverride = "Emulation.setGeolocationOverride",
	getOverriddenSensorInformation = "Emulation.getOverriddenSensorInformation",
	setSensorOverrideEnabled = "Emulation.setSensorOverrideEnabled",
	setSensorOverrideReadings = "Emulation.setSensorOverrideReadings",
	setPressureSourceOverrideEnabled = "Emulation.setPressureSourceOverrideEnabled",
	setPressureStateOverride = "Emulation.setPressureStateOverride",
	setIdleOverride = "Emulation.setIdleOverride",
	clearIdleOverride = "Emulation.clearIdleOverride",
	setNavigatorOverrides = "Emulation.setNavigatorOverrides",
	setPageScaleFactor = "Emulation.setPageScaleFactor",
	setScriptExecutionDisabled = "Emulation.setScriptExecutionDisabled",
	setTouchEmulationEnabled = "Emulation.setTouchEmulationEnabled",
	setVirtualTimePolicy = "Emulation.setVirtualTimePolicy",
	setLocaleOverride = "Emulation.setLocaleOverride",
	setTimezoneOverride = "Emulation.setTimezoneOverride",
	setVisibleSize = "Emulation.setVisibleSize",
	setDisabledImageTypes = "Emulation.setDisabledImageTypes",
	setHardwareConcurrencyOverride = "Emulation.setHardwareConcurrencyOverride",
	setUserAgentOverride = "Emulation.setUserAgentOverride",
	setAutomationOverride = "Emulation.setAutomationOverride",
	virtualTimeBudgetExpired = "Emulation.virtualTimeBudgetExpired",
}

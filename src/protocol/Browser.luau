export type BrowserContextID = string
export type WindowID = number
export type WindowState = "normal" | "minimized" | "maximized" | "fullscreen"
export type Bounds = { left: number?, top: number?, width: number?, height: number?, windowState: WindowState? }
export type PermissionType = (
	"accessibilityEvents"
	| "audioCapture"
	| "backgroundSync"
	| "backgroundFetch"
	| "capturedSurfaceControl"
	| "clipboardReadWrite"
	| "clipboardSanitizedWrite"
	| "displayCapture"
	| "durableStorage"
	| "flash"
	| "geolocation"
	| "idleDetection"
	| "localFonts"
	| "midi"
	| "midiSysex"
	| "nfc"
	| "notifications"
	| "paymentHandler"
	| "periodicBackgroundSync"
	| "protectedMediaIdentifier"
	| "sensors"
	| "storageAccess"
	| "speakerSelection"
	| "topLevelStorageAccess"
	| "videoCapture"
	| "videoCapturePanTiltZoom"
	| "wakeLockScreen"
	| "wakeLockSystem"
	| "windowManagement"
)
export type PermissionSetting = "granted" | "denied" | "prompt"
export type PermissionDescriptor = {
	name: string,
	sysex: boolean?,
	userVisibleOnly: boolean?,
	allowWithoutSanitization: boolean?,
	allowWithoutGesture: boolean?,
	panTiltZoom: boolean?,
}
export type BrowserCommandId = "openTabSearch" | "closeTabSearch"
export type Bucket = { low: number, high: number, count: number }
export type Histogram = { name: string, sum: number, count: number, buckets: { Bucket } }
return {
	setPermission = "Browser.setPermission",
	grantPermissions = "Browser.grantPermissions",
	resetPermissions = "Browser.resetPermissions",
	setDownloadBehavior = "Browser.setDownloadBehavior",
	cancelDownload = "Browser.cancelDownload",
	close = "Browser.close",
	crash = "Browser.crash",
	crashGpuProcess = "Browser.crashGpuProcess",
	getVersion = "Browser.getVersion",
	getBrowserCommandLine = "Browser.getBrowserCommandLine",
	getHistograms = "Browser.getHistograms",
	getHistogram = "Browser.getHistogram",
	getWindowBounds = "Browser.getWindowBounds",
	getWindowForTarget = "Browser.getWindowForTarget",
	setWindowBounds = "Browser.setWindowBounds",
	setDockTile = "Browser.setDockTile",
	executeBrowserCommand = "Browser.executeBrowserCommand",
	addPrivacySandboxEnrollmentOverride = "Browser.addPrivacySandboxEnrollmentOverride",
	downloadWillBegin = "Browser.downloadWillBegin",
	downloadProgress = "Browser.downloadProgress",
}

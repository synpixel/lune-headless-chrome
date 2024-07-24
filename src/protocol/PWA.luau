-- this file was automatically generated and not intended for manual editing
export type FileHandlerAccept = { mediaType: string, fileExtensions: { string } }
export type FileHandler = { action: string, accepts: { FileHandlerAccept }, displayName: string }
export type DisplayMode = "standalone" | "browser"
return {
	getOsAppState = "PWA.getOsAppState",
	install = "PWA.install",
	uninstall = "PWA.uninstall",
	launch = "PWA.launch",
	launchFilesInApp = "PWA.launchFilesInApp",
	openCurrentPageInApp = "PWA.openCurrentPageInApp",
	changeAppUserSettings = "PWA.changeAppUserSettings",
}

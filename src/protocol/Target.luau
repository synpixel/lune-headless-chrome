export type TargetID = string
export type SessionID = string
export type TargetInfo = {
	targetId: TargetID,
	type: string,
	title: string,
	url: string,
	attached: boolean,
	openerId: TargetID?,
	canAccessOpener: boolean,
	openerFrameId: Page.FrameId?,
	browserContextId: Browser.BrowserContextID?,
	subtype: string?,
}
export type FilterEntry = { exclude: boolean?, type: string? }
export type TargetFilter = { FilterEntry }
export type RemoteLocation = { host: string, port: number }
return {
	activateTarget = "Target.activateTarget",
	attachToTarget = "Target.attachToTarget",
	attachToBrowserTarget = "Target.attachToBrowserTarget",
	closeTarget = "Target.closeTarget",
	exposeDevToolsProtocol = "Target.exposeDevToolsProtocol",
	createBrowserContext = "Target.createBrowserContext",
	getBrowserContexts = "Target.getBrowserContexts",
	createTarget = "Target.createTarget",
	detachFromTarget = "Target.detachFromTarget",
	disposeBrowserContext = "Target.disposeBrowserContext",
	getTargetInfo = "Target.getTargetInfo",
	getTargets = "Target.getTargets",
	sendMessageToTarget = "Target.sendMessageToTarget",
	setAutoAttach = "Target.setAutoAttach",
	autoAttachRelated = "Target.autoAttachRelated",
	setDiscoverTargets = "Target.setDiscoverTargets",
	setRemoteLocations = "Target.setRemoteLocations",
}

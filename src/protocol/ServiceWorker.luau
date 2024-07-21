local Target = require("./Target")
export type RegistrationID = string
export type ServiceWorkerRegistration = { registrationId: RegistrationID, scopeURL: string, isDeleted: boolean }
export type ServiceWorkerVersionRunningStatus = "stopped" | "starting" | "running" | "stopping"
export type ServiceWorkerVersionStatus = "new" | "installing" | "installed" | "activating" | "activated" | "redundant"
export type ServiceWorkerVersion = {
	versionId: string,
	registrationId: RegistrationID,
	scriptURL: string,
	runningStatus: ServiceWorkerVersionRunningStatus,
	status: ServiceWorkerVersionStatus,
	scriptLastModified: number?,
	scriptResponseTime: number?,
	controlledClients: { Target.TargetID }?,
	targetId: Target.TargetID?,
	routerRules: string?,
}
export type ServiceWorkerErrorMessage = {
	errorMessage: string,
	registrationId: RegistrationID,
	versionId: string,
	sourceURL: string,
	lineNumber: number,
	columnNumber: number,
}
return {
	deliverPushMessage = "ServiceWorker.deliverPushMessage",
	disable = "ServiceWorker.disable",
	dispatchSyncEvent = "ServiceWorker.dispatchSyncEvent",
	dispatchPeriodicSyncEvent = "ServiceWorker.dispatchPeriodicSyncEvent",
	enable = "ServiceWorker.enable",
	inspectWorker = "ServiceWorker.inspectWorker",
	setForceUpdateOnPageLoad = "ServiceWorker.setForceUpdateOnPageLoad",
	skipWaiting = "ServiceWorker.skipWaiting",
	startWorker = "ServiceWorker.startWorker",
	stopAllWorkers = "ServiceWorker.stopAllWorkers",
	stopWorker = "ServiceWorker.stopWorker",
	unregister = "ServiceWorker.unregister",
	updateRegistration = "ServiceWorker.updateRegistration",
	workerErrorReported = "ServiceWorker.workerErrorReported",
	workerRegistrationUpdated = "ServiceWorker.workerRegistrationUpdated",
	workerVersionUpdated = "ServiceWorker.workerVersionUpdated",
}

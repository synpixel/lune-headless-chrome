-- this file was automatically generated and not intended for manual editing
export type ServiceName = (
	"backgroundFetch"
	| "backgroundSync"
	| "pushMessaging"
	| "notifications"
	| "paymentHandler"
	| "periodicBackgroundSync"
)
export type EventMetadata = { key: string, value: string }
export type BackgroundServiceEvent = {
	timestamp: Network.TimeSinceEpoch,
	origin: string,
	serviceWorkerRegistrationId: ServiceWorker.RegistrationID,
	service: ServiceName,
	eventName: string,
	instanceId: string,
	eventMetadata: { EventMetadata },
	storageKey: string,
}
return {
	startObserving = "BackgroundService.startObserving",
	stopObserving = "BackgroundService.stopObserving",
	setRecording = "BackgroundService.setRecording",
	clearEvents = "BackgroundService.clearEvents",
	recordingStateChanged = "BackgroundService.recordingStateChanged",
	backgroundServiceEventReceived = "BackgroundService.backgroundServiceEventReceived",
}

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
}

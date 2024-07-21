local Browser = require("./Browser")
local Network = require("./Network")
export type SerializedStorageKey = string
export type StorageType =
	"appcache"
	| "cookies"
	| "file_systems"
	| "indexeddb"
	| "local_storage"
	| "shader_cache"
	| "websql"
	| "service_workers"
	| "cache_storage"
	| "interest_groups"
	| "shared_storage"
	| "storage_buckets"
	| "all"
	| "other"
export type UsageForType = { storageType: StorageType, usage: number }
export type TrustTokens = { issuerOrigin: string, count: number }
export type InterestGroupAuctionId = string
export type InterestGroupAccessType =
	"join"
	| "leave"
	| "update"
	| "loaded"
	| "bid"
	| "win"
	| "additionalBid"
	| "additionalBidWin"
	| "topLevelBid"
	| "topLevelAdditionalBid"
	| "clear"
export type InterestGroupAuctionEventType = "started" | "configResolved"
export type InterestGroupAuctionFetchType =
	"bidderJs"
	| "bidderWasm"
	| "sellerJs"
	| "bidderTrustedSignals"
	| "sellerTrustedSignals"
export type SharedStorageAccessType =
	"documentAddModule"
	| "documentSelectURL"
	| "documentRun"
	| "documentSet"
	| "documentAppend"
	| "documentDelete"
	| "documentClear"
	| "documentGet"
	| "workletSet"
	| "workletAppend"
	| "workletDelete"
	| "workletClear"
	| "workletGet"
	| "workletKeys"
	| "workletEntries"
	| "workletLength"
	| "workletRemainingBudget"
	| "headerSet"
	| "headerAppend"
	| "headerDelete"
	| "headerClear"
export type SharedStorageEntry = { key: string, value: string }
export type SharedStorageMetadata = {
	creationTime: Network.TimeSinceEpoch,
	length: number,
	remainingBudget: number,
	bytesUsed: number,
}
export type SharedStorageReportingMetadata = { eventType: string, reportingUrl: string }
export type SharedStorageUrlWithMetadata = { url: string, reportingMetadata: { SharedStorageReportingMetadata } }
export type SharedStorageAccessParams = {
	scriptSourceUrl: string,
	operationName: string,
	serializedData: string,
	urlsWithMetadata: { SharedStorageUrlWithMetadata },
	key: string,
	value: string,
	ignoreIfPresent: boolean,
}
export type StorageBucketsDurability = "relaxed" | "strict"
export type StorageBucket = { storageKey: SerializedStorageKey, name: string }
export type StorageBucketInfo = {
	bucket: StorageBucket,
	id: string,
	expiration: Network.TimeSinceEpoch,
	quota: number,
	persistent: boolean,
	durability: StorageBucketsDurability,
}
export type AttributionReportingSourceType = "navigation" | "event"
export type UnsignedInt64AsBase10 = string
export type UnsignedInt128AsBase16 = string
export type SignedInt64AsBase10 = string
export type AttributionReportingFilterDataEntry = { key: string, values: { string } }
export type AttributionReportingFilterConfig = {
	filterValues: { AttributionReportingFilterDataEntry },
	lookbackWindow: number,
}
export type AttributionReportingFilterPair = {
	filters: { AttributionReportingFilterConfig },
	notFilters: { AttributionReportingFilterConfig },
}
export type AttributionReportingAggregationKeysEntry = { key: string, value: UnsignedInt128AsBase16 }
export type AttributionReportingEventReportWindows = { start: number, ends: { number } }
export type AttributionReportingTriggerSpec = {
	triggerData: { number },
	eventReportWindows: AttributionReportingEventReportWindows,
}
export type AttributionReportingTriggerDataMatching = "exact" | "modulus"
export type AttributionReportingAggregatableDebugReportingData = {
	keyPiece: UnsignedInt128AsBase16,
	value: number,
	types: { string },
}
export type AttributionReportingAggregatableDebugReportingConfig = {
	budget: number,
	keyPiece: UnsignedInt128AsBase16,
	debugData: { AttributionReportingAggregatableDebugReportingData },
	aggregationCoordinatorOrigin: string,
}
export type AttributionReportingSourceRegistration = {
	time: Network.TimeSinceEpoch,
	expiry: number,
	triggerSpecs: { AttributionReportingTriggerSpec },
	aggregatableReportWindow: number,
	type: AttributionReportingSourceType,
	sourceOrigin: string,
	reportingOrigin: string,
	destinationSites: { string },
	eventId: UnsignedInt64AsBase10,
	priority: SignedInt64AsBase10,
	filterData: { AttributionReportingFilterDataEntry },
	aggregationKeys: { AttributionReportingAggregationKeysEntry },
	debugKey: UnsignedInt64AsBase10,
	triggerDataMatching: AttributionReportingTriggerDataMatching,
	destinationLimitPriority: SignedInt64AsBase10,
	aggregatableDebugReportingConfig: AttributionReportingAggregatableDebugReportingConfig,
}
export type AttributionReportingSourceRegistrationResult =
	"success"
	| "internalError"
	| "insufficientSourceCapacity"
	| "insufficientUniqueDestinationCapacity"
	| "excessiveReportingOrigins"
	| "prohibitedByBrowserPolicy"
	| "successNoised"
	| "destinationReportingLimitReached"
	| "destinationGlobalLimitReached"
	| "destinationBothLimitsReached"
	| "reportingOriginsPerSiteLimitReached"
	| "exceedsMaxChannelCapacity"
	| "exceedsMaxTriggerStateCardinality"
	| "destinationPerDayReportingLimitReached"
export type AttributionReportingSourceRegistrationTimeConfig = "include" | "exclude"
export type AttributionReportingAggregatableValueDictEntry = {
	key: string,
	value: number,
	filteringId: UnsignedInt64AsBase10,
}
export type AttributionReportingAggregatableValueEntry = {
	values: { AttributionReportingAggregatableValueDictEntry },
	filters: AttributionReportingFilterPair,
}
export type AttributionReportingEventTriggerData = {
	data: UnsignedInt64AsBase10,
	priority: SignedInt64AsBase10,
	dedupKey: UnsignedInt64AsBase10,
	filters: AttributionReportingFilterPair,
}
export type AttributionReportingAggregatableTriggerData = {
	keyPiece: UnsignedInt128AsBase16,
	sourceKeys: { string },
	filters: AttributionReportingFilterPair,
}
export type AttributionReportingAggregatableDedupKey = {
	dedupKey: UnsignedInt64AsBase10,
	filters: AttributionReportingFilterPair,
}
export type AttributionReportingTriggerRegistration = {
	filters: AttributionReportingFilterPair,
	debugKey: UnsignedInt64AsBase10,
	aggregatableDedupKeys: { AttributionReportingAggregatableDedupKey },
	eventTriggerData: { AttributionReportingEventTriggerData },
	aggregatableTriggerData: { AttributionReportingAggregatableTriggerData },
	aggregatableValues: { AttributionReportingAggregatableValueEntry },
	aggregatableFilteringIdMaxBytes: number,
	debugReporting: boolean,
	aggregationCoordinatorOrigin: string,
	sourceRegistrationTimeConfig: AttributionReportingSourceRegistrationTimeConfig,
	triggerContextId: string,
	aggregatableDebugReportingConfig: AttributionReportingAggregatableDebugReportingConfig,
}
export type AttributionReportingEventLevelResult =
	"success"
	| "successDroppedLowerPriority"
	| "internalError"
	| "noCapacityForAttributionDestination"
	| "noMatchingSources"
	| "deduplicated"
	| "excessiveAttributions"
	| "priorityTooLow"
	| "neverAttributedSource"
	| "excessiveReportingOrigins"
	| "noMatchingSourceFilterData"
	| "prohibitedByBrowserPolicy"
	| "noMatchingConfigurations"
	| "excessiveReports"
	| "falselyAttributedSource"
	| "reportWindowPassed"
	| "notRegistered"
	| "reportWindowNotStarted"
	| "noMatchingTriggerData"
export type AttributionReportingAggregatableResult =
	"success"
	| "internalError"
	| "noCapacityForAttributionDestination"
	| "noMatchingSources"
	| "excessiveAttributions"
	| "excessiveReportingOrigins"
	| "noHistograms"
	| "insufficientBudget"
	| "noMatchingSourceFilterData"
	| "notRegistered"
	| "prohibitedByBrowserPolicy"
	| "deduplicated"
	| "reportWindowPassed"
	| "excessiveReports"
export type RelatedWebsiteSet = { primarySites: { string }, associatedSites: { string }, serviceSites: { string } }
return {
	getStorageKeyForFrame = "Storage.getStorageKeyForFrame",
	clearDataForOrigin = "Storage.clearDataForOrigin",
	clearDataForStorageKey = "Storage.clearDataForStorageKey",
	getCookies = "Storage.getCookies",
	setCookies = "Storage.setCookies",
	clearCookies = "Storage.clearCookies",
	getUsageAndQuota = "Storage.getUsageAndQuota",
	overrideQuotaForOrigin = "Storage.overrideQuotaForOrigin",
	trackCacheStorageForOrigin = "Storage.trackCacheStorageForOrigin",
	trackCacheStorageForStorageKey = "Storage.trackCacheStorageForStorageKey",
	trackIndexedDBForOrigin = "Storage.trackIndexedDBForOrigin",
	trackIndexedDBForStorageKey = "Storage.trackIndexedDBForStorageKey",
	untrackCacheStorageForOrigin = "Storage.untrackCacheStorageForOrigin",
	untrackCacheStorageForStorageKey = "Storage.untrackCacheStorageForStorageKey",
	untrackIndexedDBForOrigin = "Storage.untrackIndexedDBForOrigin",
	untrackIndexedDBForStorageKey = "Storage.untrackIndexedDBForStorageKey",
	getTrustTokens = "Storage.getTrustTokens",
	clearTrustTokens = "Storage.clearTrustTokens",
	getInterestGroupDetails = "Storage.getInterestGroupDetails",
	setInterestGroupTracking = "Storage.setInterestGroupTracking",
	setInterestGroupAuctionTracking = "Storage.setInterestGroupAuctionTracking",
	getSharedStorageMetadata = "Storage.getSharedStorageMetadata",
	getSharedStorageEntries = "Storage.getSharedStorageEntries",
	setSharedStorageEntry = "Storage.setSharedStorageEntry",
	deleteSharedStorageEntry = "Storage.deleteSharedStorageEntry",
	clearSharedStorageEntries = "Storage.clearSharedStorageEntries",
	resetSharedStorageBudget = "Storage.resetSharedStorageBudget",
	setSharedStorageTracking = "Storage.setSharedStorageTracking",
	setStorageBucketTracking = "Storage.setStorageBucketTracking",
	deleteStorageBucket = "Storage.deleteStorageBucket",
	runBounceTrackingMitigations = "Storage.runBounceTrackingMitigations",
	setAttributionReportingLocalTestingMode = "Storage.setAttributionReportingLocalTestingMode",
	setAttributionReportingTracking = "Storage.setAttributionReportingTracking",
	sendPendingAttributionReports = "Storage.sendPendingAttributionReports",
	getRelatedWebsiteSets = "Storage.getRelatedWebsiteSets",
}

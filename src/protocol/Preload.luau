export type RuleSetId = string
export type RuleSet = {
	id: RuleSetId,
	loaderId: Network.LoaderId,
	sourceText: string,
	backendNodeId: DOM.BackendNodeId?,
	url: string?,
	requestId: Network.RequestId?,
	errorType: RuleSetErrorType?,
	errorMessage: string?,
}
export type RuleSetErrorType = "SourceIsNotJsonObject" | "InvalidRulesSkipped"
export type SpeculationAction = "Prefetch" | "Prerender"
export type SpeculationTargetHint = "Blank" | "Self"
export type PreloadingAttemptKey = {
	loaderId: Network.LoaderId,
	action: SpeculationAction,
	url: string,
	targetHint: SpeculationTargetHint?,
}
export type PreloadingAttemptSource = {
	key: PreloadingAttemptKey,
	ruleSetIds: { RuleSetId },
	nodeIds: { DOM.BackendNodeId },
}
export type PrerenderFinalStatus =
	"Activated"
	| "Destroyed"
	| "LowEndDevice"
	| "InvalidSchemeRedirect"
	| "InvalidSchemeNavigation"
	| "NavigationRequestBlockedByCsp"
	| "MainFrameNavigation"
	| "MojoBinderPolicy"
	| "RendererProcessCrashed"
	| "RendererProcessKilled"
	| "Download"
	| "TriggerDestroyed"
	| "NavigationNotCommitted"
	| "NavigationBadHttpStatus"
	| "ClientCertRequested"
	| "NavigationRequestNetworkError"
	| "CancelAllHostsForTesting"
	| "DidFailLoad"
	| "Stop"
	| "SslCertificateError"
	| "LoginAuthRequested"
	| "UaChangeRequiresReload"
	| "BlockedByClient"
	| "AudioOutputDeviceRequested"
	| "MixedContent"
	| "TriggerBackgrounded"
	| "MemoryLimitExceeded"
	| "DataSaverEnabled"
	| "TriggerUrlHasEffectiveUrl"
	| "ActivatedBeforeStarted"
	| "InactivePageRestriction"
	| "StartFailed"
	| "TimeoutBackgrounded"
	| "CrossSiteRedirectInInitialNavigation"
	| "CrossSiteNavigationInInitialNavigation"
	| "SameSiteCrossOriginRedirectNotOptInInInitialNavigation"
	| "SameSiteCrossOriginNavigationNotOptInInInitialNavigation"
	| "ActivationNavigationParameterMismatch"
	| "ActivatedInBackground"
	| "EmbedderHostDisallowed"
	| "ActivationNavigationDestroyedBeforeSuccess"
	| "TabClosedByUserGesture"
	| "TabClosedWithoutUserGesture"
	| "PrimaryMainFrameRendererProcessCrashed"
	| "PrimaryMainFrameRendererProcessKilled"
	| "ActivationFramePolicyNotCompatible"
	| "PreloadingDisabled"
	| "BatterySaverEnabled"
	| "ActivatedDuringMainFrameNavigation"
	| "PreloadingUnsupportedByWebContents"
	| "CrossSiteRedirectInMainFrameNavigation"
	| "CrossSiteNavigationInMainFrameNavigation"
	| "SameSiteCrossOriginRedirectNotOptInInMainFrameNavigation"
	| "SameSiteCrossOriginNavigationNotOptInInMainFrameNavigation"
	| "MemoryPressureOnTrigger"
	| "MemoryPressureAfterTriggered"
	| "PrerenderingDisabledByDevTools"
	| "SpeculationRuleRemoved"
	| "ActivatedWithAuxiliaryBrowsingContexts"
	| "MaxNumOfRunningEagerPrerendersExceeded"
	| "MaxNumOfRunningNonEagerPrerendersExceeded"
	| "MaxNumOfRunningEmbedderPrerendersExceeded"
	| "PrerenderingUrlHasEffectiveUrl"
	| "RedirectedPrerenderingUrlHasEffectiveUrl"
	| "ActivationUrlHasEffectiveUrl"
	| "JavaScriptInterfaceAdded"
	| "JavaScriptInterfaceRemoved"
	| "AllPrerenderingCanceled"
	| "WindowClosed"
export type PreloadingStatus = "Pending" | "Running" | "Ready" | "Success" | "Failure" | "NotSupported"
export type PrefetchStatus =
	"PrefetchAllowed"
	| "PrefetchFailedIneligibleRedirect"
	| "PrefetchFailedInvalidRedirect"
	| "PrefetchFailedMIMENotSupported"
	| "PrefetchFailedNetError"
	| "PrefetchFailedNon2XX"
	| "PrefetchFailedPerPageLimitExceeded"
	| "PrefetchEvictedAfterCandidateRemoved"
	| "PrefetchEvictedForNewerPrefetch"
	| "PrefetchHeldback"
	| "PrefetchIneligibleRetryAfter"
	| "PrefetchIsPrivacyDecoy"
	| "PrefetchIsStale"
	| "PrefetchNotEligibleBrowserContextOffTheRecord"
	| "PrefetchNotEligibleDataSaverEnabled"
	| "PrefetchNotEligibleExistingProxy"
	| "PrefetchNotEligibleHostIsNonUnique"
	| "PrefetchNotEligibleNonDefaultStoragePartition"
	| "PrefetchNotEligibleSameSiteCrossOriginPrefetchRequiredProxy"
	| "PrefetchNotEligibleSchemeIsNotHttps"
	| "PrefetchNotEligibleUserHasCookies"
	| "PrefetchNotEligibleUserHasServiceWorker"
	| "PrefetchNotEligibleBatterySaverEnabled"
	| "PrefetchNotEligiblePreloadingDisabled"
	| "PrefetchNotFinishedInTime"
	| "PrefetchNotStarted"
	| "PrefetchNotUsedCookiesChanged"
	| "PrefetchProxyNotAvailable"
	| "PrefetchResponseUsed"
	| "PrefetchSuccessfulButNotUsed"
	| "PrefetchNotUsedProbeFailed"
export type PrerenderMismatchedHeaders = { headerName: string, initialValue: string?, activationValue: string? }
return { enable = "Preload.enable", disable = "Preload.disable" }

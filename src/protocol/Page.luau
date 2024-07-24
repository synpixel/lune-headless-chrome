-- this file was automatically generated and not intended for manual editing
local Debugger = require("./Debugger")
local DOM = require("./DOM")
local IO = require("./IO")
local Network = require("./Network")
local Runtime = require("./Runtime")
export type FrameId = string
export type AdFrameType = "none" | "child" | "root"
export type AdFrameExplanation = "ParentIsAd" | "CreatedByAdScript" | "MatchedBlockingRule"
export type AdFrameStatus = { adFrameType: AdFrameType, explanations: { AdFrameExplanation }? }
export type AdScriptId = { scriptId: Runtime.ScriptId, debuggerId: Runtime.UniqueDebuggerId }
export type SecureContextType = "Secure" | "SecureLocalhost" | "InsecureScheme" | "InsecureAncestor"
export type CrossOriginIsolatedContextType = "Isolated" | "NotIsolated" | "NotIsolatedFeatureDisabled"
export type GatedAPIFeatures = (
	"SharedArrayBuffers" | "SharedArrayBuffersTransferAllowed" | "PerformanceMeasureMemory" | "PerformanceProfile"
)
export type PermissionsPolicyFeature = (
	"accelerometer"
	| "ambient-light-sensor"
	| "attribution-reporting"
	| "autoplay"
	| "bluetooth"
	| "browsing-topics"
	| "camera"
	| "captured-surface-control"
	| "ch-dpr"
	| "ch-device-memory"
	| "ch-downlink"
	| "ch-ect"
	| "ch-prefers-color-scheme"
	| "ch-prefers-reduced-motion"
	| "ch-prefers-reduced-transparency"
	| "ch-rtt"
	| "ch-save-data"
	| "ch-ua"
	| "ch-ua-arch"
	| "ch-ua-bitness"
	| "ch-ua-platform"
	| "ch-ua-model"
	| "ch-ua-mobile"
	| "ch-ua-form-factors"
	| "ch-ua-full-version"
	| "ch-ua-full-version-list"
	| "ch-ua-platform-version"
	| "ch-ua-wow64"
	| "ch-viewport-height"
	| "ch-viewport-width"
	| "ch-width"
	| "clipboard-read"
	| "clipboard-write"
	| "compute-pressure"
	| "cross-origin-isolated"
	| "deferred-fetch"
	| "digital-credentials-get"
	| "direct-sockets"
	| "display-capture"
	| "document-domain"
	| "encrypted-media"
	| "execution-while-out-of-viewport"
	| "execution-while-not-rendered"
	| "focus-without-user-activation"
	| "fullscreen"
	| "frobulate"
	| "gamepad"
	| "geolocation"
	| "gyroscope"
	| "hid"
	| "identity-credentials-get"
	| "idle-detection"
	| "interest-cohort"
	| "join-ad-interest-group"
	| "keyboard-map"
	| "local-fonts"
	| "magnetometer"
	| "microphone"
	| "midi"
	| "otp-credentials"
	| "payment"
	| "picture-in-picture"
	| "private-aggregation"
	| "private-state-token-issuance"
	| "private-state-token-redemption"
	| "publickey-credentials-create"
	| "publickey-credentials-get"
	| "run-ad-auction"
	| "screen-wake-lock"
	| "serial"
	| "shared-autofill"
	| "shared-storage"
	| "shared-storage-select-url"
	| "smart-card"
	| "speaker-selection"
	| "storage-access"
	| "sub-apps"
	| "sync-xhr"
	| "unload"
	| "usb"
	| "usb-unrestricted"
	| "vertical-scroll"
	| "web-printing"
	| "web-share"
	| "window-management"
	| "xr-spatial-tracking"
)
export type PermissionsPolicyBlockReason = "Header" | "IframeAttribute" | "InFencedFrameTree" | "InIsolatedApp"
export type PermissionsPolicyBlockLocator = { frameId: FrameId, blockReason: PermissionsPolicyBlockReason }
export type PermissionsPolicyFeatureState = {
	feature: PermissionsPolicyFeature,
	allowed: boolean,
	locator: PermissionsPolicyBlockLocator?,
}
export type OriginTrialTokenStatus = (
	"Success"
	| "NotSupported"
	| "Insecure"
	| "Expired"
	| "WrongOrigin"
	| "InvalidSignature"
	| "Malformed"
	| "WrongVersion"
	| "FeatureDisabled"
	| "TokenDisabled"
	| "FeatureDisabledForUser"
	| "UnknownTrial"
)
export type OriginTrialStatus = "Enabled" | "ValidTokenNotProvided" | "OSNotSupported" | "TrialNotAllowed"
export type OriginTrialUsageRestriction = "None" | "Subset"
export type OriginTrialToken = {
	origin: string,
	matchSubDomains: boolean,
	trialName: string,
	expiryTime: Network.TimeSinceEpoch,
	isThirdParty: boolean,
	usageRestriction: OriginTrialUsageRestriction,
}
export type OriginTrialTokenWithStatus = {
	rawTokenText: string,
	parsedToken: OriginTrialToken?,
	status: OriginTrialTokenStatus,
}
export type OriginTrial =
	{ trialName: string, status: OriginTrialStatus, tokensWithStatus: { OriginTrialTokenWithStatus } }
export type Frame = {
	id: FrameId,
	parentId: FrameId?,
	loaderId: Network.LoaderId,
	name: string?,
	url: string,
	urlFragment: string?,
	domainAndRegistry: string,
	securityOrigin: string,
	mimeType: string,
	unreachableUrl: string?,
	adFrameStatus: AdFrameStatus?,
	secureContextType: SecureContextType,
	crossOriginIsolatedContextType: CrossOriginIsolatedContextType,
	gatedAPIFeatures: { GatedAPIFeatures },
}
export type FrameResource = {
	url: string,
	type: Network.ResourceType,
	mimeType: string,
	lastModified: Network.TimeSinceEpoch?,
	contentSize: number?,
	failed: boolean?,
	canceled: boolean?,
}
export type FrameResourceTree = { frame: Frame, childFrames: { FrameResourceTree }?, resources: { FrameResource } }
export type FrameTree = { frame: Frame, childFrames: { FrameTree }? }
export type ScriptIdentifier = string
export type TransitionType = (
	"link"
	| "typed"
	| "address_bar"
	| "auto_bookmark"
	| "auto_subframe"
	| "manual_subframe"
	| "generated"
	| "auto_toplevel"
	| "form_submit"
	| "reload"
	| "keyword"
	| "keyword_generated"
	| "other"
)
export type NavigationEntry =
	{ id: number, url: string, userTypedURL: string, title: string, transitionType: TransitionType }
export type ScreencastFrameMetadata = {
	offsetTop: number,
	pageScaleFactor: number,
	deviceWidth: number,
	deviceHeight: number,
	scrollOffsetX: number,
	scrollOffsetY: number,
	timestamp: Network.TimeSinceEpoch?,
}
export type DialogType = "alert" | "confirm" | "prompt" | "beforeunload"
export type AppManifestError = { message: string, critical: number, line: number, column: number }
export type AppManifestParsedProperties = { scope: string }
export type LayoutViewport = { pageX: number, pageY: number, clientWidth: number, clientHeight: number }
export type VisualViewport = {
	offsetX: number,
	offsetY: number,
	pageX: number,
	pageY: number,
	clientWidth: number,
	clientHeight: number,
	scale: number,
	zoom: number?,
}
export type Viewport = { x: number, y: number, width: number, height: number, scale: number }
export type FontFamilies = {
	standard: string?,
	fixed: string?,
	serif: string?,
	sansSerif: string?,
	cursive: string?,
	fantasy: string?,
	math: string?,
}
export type ScriptFontFamilies = { script: string, fontFamilies: FontFamilies }
export type FontSizes = { standard: number?, fixed: number? }
export type ClientNavigationReason = (
	"formSubmissionGet"
	| "formSubmissionPost"
	| "httpHeaderRefresh"
	| "scriptInitiated"
	| "metaTagRefresh"
	| "pageBlockInterstitial"
	| "reload"
	| "anchorClick"
)
export type ClientNavigationDisposition = "currentTab" | "newTab" | "newWindow" | "download"
export type InstallabilityErrorArgument = { name: string, value: string }
export type InstallabilityError = { errorId: string, errorArguments: { InstallabilityErrorArgument } }
export type ReferrerPolicy = (
	"noReferrer"
	| "noReferrerWhenDowngrade"
	| "origin"
	| "originWhenCrossOrigin"
	| "sameOrigin"
	| "strictOrigin"
	| "strictOriginWhenCrossOrigin"
	| "unsafeUrl"
)
export type CompilationCacheParams = { url: string, eager: boolean? }
export type FileFilter = { name: string?, accepts: { string }? }
export type FileHandler = {
	action: string,
	name: string,
	icons: { ImageResource }?,
	accepts: { FileFilter }?,
	launchType: string,
}
export type ImageResource = { url: string, sizes: string?, type: string? }
export type LaunchHandler = { clientMode: string }
export type ProtocolHandler = { protocol: string, url: string }
export type RelatedApplication = { id: string?, url: string }
export type ScopeExtension = { origin: string, hasOriginWildcard: boolean }
export type Screenshot = { image: ImageResource, formFactor: string, label: string? }
export type ShareTarget = {
	action: string,
	method: string,
	enctype: string,
	title: string?,
	text: string?,
	url: string?,
	files: { FileFilter }?,
}
export type Shortcut = { name: string, url: string }
export type WebAppManifest = {
	backgroundColor: string?,
	description: string?,
	dir: string?,
	display: string?,
	displayOverrides: { string }?,
	fileHandlers: { FileHandler }?,
	icons: { ImageResource }?,
	id: string?,
	lang: string?,
	launchHandler: LaunchHandler?,
	name: string?,
	orientation: string?,
	preferRelatedApplications: boolean?,
	protocolHandlers: { ProtocolHandler }?,
	relatedApplications: { RelatedApplication }?,
	scope: string?,
	scopeExtensions: { ScopeExtension }?,
	screenshots: { Screenshot }?,
	shareTarget: ShareTarget?,
	shortName: string?,
	shortcuts: { Shortcut }?,
	startUrl: string?,
	themeColor: string?,
}
export type AutoResponseMode = "none" | "autoAccept" | "autoReject" | "autoOptOut"
export type NavigationType = "Navigation" | "BackForwardCacheRestore"
export type BackForwardCacheNotRestoredReason = (
	"NotPrimaryMainFrame"
	| "BackForwardCacheDisabled"
	| "RelatedActiveContentsExist"
	| "HTTPStatusNotOK"
	| "SchemeNotHTTPOrHTTPS"
	| "Loading"
	| "WasGrantedMediaAccess"
	| "DisableForRenderFrameHostCalled"
	| "DomainNotAllowed"
	| "HTTPMethodNotGET"
	| "SubframeIsNavigating"
	| "Timeout"
	| "CacheLimit"
	| "JavaScriptExecution"
	| "RendererProcessKilled"
	| "RendererProcessCrashed"
	| "SchedulerTrackedFeatureUsed"
	| "ConflictingBrowsingInstance"
	| "CacheFlushed"
	| "ServiceWorkerVersionActivation"
	| "SessionRestored"
	| "ServiceWorkerPostMessage"
	| "EnteredBackForwardCacheBeforeServiceWorkerHostAdded"
	| "RenderFrameHostReused_SameSite"
	| "RenderFrameHostReused_CrossSite"
	| "ServiceWorkerClaim"
	| "IgnoreEventAndEvict"
	| "HaveInnerContents"
	| "TimeoutPuttingInCache"
	| "BackForwardCacheDisabledByLowMemory"
	| "BackForwardCacheDisabledByCommandLine"
	| "NetworkRequestDatapipeDrainedAsBytesConsumer"
	| "NetworkRequestRedirected"
	| "NetworkRequestTimeout"
	| "NetworkExceedsBufferLimit"
	| "NavigationCancelledWhileRestoring"
	| "NotMostRecentNavigationEntry"
	| "BackForwardCacheDisabledForPrerender"
	| "UserAgentOverrideDiffers"
	| "ForegroundCacheLimit"
	| "BrowsingInstanceNotSwapped"
	| "BackForwardCacheDisabledForDelegate"
	| "UnloadHandlerExistsInMainFrame"
	| "UnloadHandlerExistsInSubFrame"
	| "ServiceWorkerUnregistration"
	| "CacheControlNoStore"
	| "CacheControlNoStoreCookieModified"
	| "CacheControlNoStoreHTTPOnlyCookieModified"
	| "NoResponseHead"
	| "Unknown"
	| "ActivationNavigationsDisallowedForBug1234857"
	| "ErrorDocument"
	| "FencedFramesEmbedder"
	| "CookieDisabled"
	| "HTTPAuthRequired"
	| "CookieFlushed"
	| "BroadcastChannelOnMessage"
	| "WebViewSettingsChanged"
	| "WebViewJavaScriptObjectChanged"
	| "WebViewMessageListenerInjected"
	| "WebViewSafeBrowsingAllowlistChanged"
	| "WebViewDocumentStartJavascriptChanged"
	| "WebSocket"
	| "WebTransport"
	| "WebRTC"
	| "MainResourceHasCacheControlNoStore"
	| "MainResourceHasCacheControlNoCache"
	| "SubresourceHasCacheControlNoStore"
	| "SubresourceHasCacheControlNoCache"
	| "ContainsPlugins"
	| "DocumentLoaded"
	| "OutstandingNetworkRequestOthers"
	| "RequestedMIDIPermission"
	| "RequestedAudioCapturePermission"
	| "RequestedVideoCapturePermission"
	| "RequestedBackForwardCacheBlockedSensors"
	| "RequestedBackgroundWorkPermission"
	| "BroadcastChannel"
	| "WebXR"
	| "SharedWorker"
	| "WebLocks"
	| "WebHID"
	| "WebShare"
	| "RequestedStorageAccessGrant"
	| "WebNfc"
	| "OutstandingNetworkRequestFetch"
	| "OutstandingNetworkRequestXHR"
	| "AppBanner"
	| "Printing"
	| "WebDatabase"
	| "PictureInPicture"
	| "SpeechRecognizer"
	| "IdleManager"
	| "PaymentManager"
	| "SpeechSynthesis"
	| "KeyboardLock"
	| "WebOTPService"
	| "OutstandingNetworkRequestDirectSocket"
	| "InjectedJavascript"
	| "InjectedStyleSheet"
	| "KeepaliveRequest"
	| "IndexedDBEvent"
	| "Dummy"
	| "JsNetworkRequestReceivedCacheControlNoStoreResource"
	| "WebRTCSticky"
	| "WebTransportSticky"
	| "WebSocketSticky"
	| "SmartCard"
	| "LiveMediaStreamTrack"
	| "UnloadHandler"
	| "ParserAborted"
	| "ContentSecurityHandler"
	| "ContentWebAuthenticationAPI"
	| "ContentFileChooser"
	| "ContentSerial"
	| "ContentFileSystemAccess"
	| "ContentMediaDevicesDispatcherHost"
	| "ContentWebBluetooth"
	| "ContentWebUSB"
	| "ContentMediaSessionService"
	| "ContentScreenReader"
	| "EmbedderPopupBlockerTabHelper"
	| "EmbedderSafeBrowsingTriggeredPopupBlocker"
	| "EmbedderSafeBrowsingThreatDetails"
	| "EmbedderAppBannerManager"
	| "EmbedderDomDistillerViewerSource"
	| "EmbedderDomDistillerSelfDeletingRequestDelegate"
	| "EmbedderOomInterventionTabHelper"
	| "EmbedderOfflinePage"
	| "EmbedderChromePasswordManagerClientBindCredentialManager"
	| "EmbedderPermissionRequestManager"
	| "EmbedderModalDialog"
	| "EmbedderExtensions"
	| "EmbedderExtensionMessaging"
	| "EmbedderExtensionMessagingForOpenPort"
	| "EmbedderExtensionSentMessageToCachedFrame"
	| "RequestedByWebViewClient"
)
export type BackForwardCacheNotRestoredReasonType = "SupportPending" | "PageSupportNeeded" | "Circumstantial"
export type BackForwardCacheBlockingDetails = {
	url: string?,
	["function"]: string?,
	lineNumber: number,
	columnNumber: number,
}
export type BackForwardCacheNotRestoredExplanation = {
	type: BackForwardCacheNotRestoredReasonType,
	reason: BackForwardCacheNotRestoredReason,
	context: string?,
	details: { BackForwardCacheBlockingDetails }?,
}
export type BackForwardCacheNotRestoredExplanationTree = {
	url: string,
	explanations: { BackForwardCacheNotRestoredExplanation },
	children: { BackForwardCacheNotRestoredExplanationTree },
}
return {
	addScriptToEvaluateOnLoad = "Page.addScriptToEvaluateOnLoad",
	addScriptToEvaluateOnNewDocument = "Page.addScriptToEvaluateOnNewDocument",
	bringToFront = "Page.bringToFront",
	captureScreenshot = "Page.captureScreenshot",
	captureSnapshot = "Page.captureSnapshot",
	clearDeviceMetricsOverride = "Page.clearDeviceMetricsOverride",
	clearDeviceOrientationOverride = "Page.clearDeviceOrientationOverride",
	clearGeolocationOverride = "Page.clearGeolocationOverride",
	createIsolatedWorld = "Page.createIsolatedWorld",
	deleteCookie = "Page.deleteCookie",
	disable = "Page.disable",
	enable = "Page.enable",
	getAppManifest = "Page.getAppManifest",
	getInstallabilityErrors = "Page.getInstallabilityErrors",
	getManifestIcons = "Page.getManifestIcons",
	getAppId = "Page.getAppId",
	getAdScriptId = "Page.getAdScriptId",
	getFrameTree = "Page.getFrameTree",
	getLayoutMetrics = "Page.getLayoutMetrics",
	getNavigationHistory = "Page.getNavigationHistory",
	resetNavigationHistory = "Page.resetNavigationHistory",
	getResourceContent = "Page.getResourceContent",
	getResourceTree = "Page.getResourceTree",
	handleJavaScriptDialog = "Page.handleJavaScriptDialog",
	navigate = "Page.navigate",
	navigateToHistoryEntry = "Page.navigateToHistoryEntry",
	printToPDF = "Page.printToPDF",
	reload = "Page.reload",
	removeScriptToEvaluateOnLoad = "Page.removeScriptToEvaluateOnLoad",
	removeScriptToEvaluateOnNewDocument = "Page.removeScriptToEvaluateOnNewDocument",
	screencastFrameAck = "Page.screencastFrameAck",
	searchInResource = "Page.searchInResource",
	setAdBlockingEnabled = "Page.setAdBlockingEnabled",
	setBypassCSP = "Page.setBypassCSP",
	getPermissionsPolicyState = "Page.getPermissionsPolicyState",
	getOriginTrials = "Page.getOriginTrials",
	setDeviceMetricsOverride = "Page.setDeviceMetricsOverride",
	setDeviceOrientationOverride = "Page.setDeviceOrientationOverride",
	setFontFamilies = "Page.setFontFamilies",
	setFontSizes = "Page.setFontSizes",
	setDocumentContent = "Page.setDocumentContent",
	setDownloadBehavior = "Page.setDownloadBehavior",
	setGeolocationOverride = "Page.setGeolocationOverride",
	setLifecycleEventsEnabled = "Page.setLifecycleEventsEnabled",
	setTouchEmulationEnabled = "Page.setTouchEmulationEnabled",
	startScreencast = "Page.startScreencast",
	stopLoading = "Page.stopLoading",
	crash = "Page.crash",
	close = "Page.close",
	setWebLifecycleState = "Page.setWebLifecycleState",
	stopScreencast = "Page.stopScreencast",
	produceCompilationCache = "Page.produceCompilationCache",
	addCompilationCache = "Page.addCompilationCache",
	clearCompilationCache = "Page.clearCompilationCache",
	setSPCTransactionMode = "Page.setSPCTransactionMode",
	setRPHRegistrationMode = "Page.setRPHRegistrationMode",
	generateTestReport = "Page.generateTestReport",
	waitForDebugger = "Page.waitForDebugger",
	setInterceptFileChooserDialog = "Page.setInterceptFileChooserDialog",
	setPrerenderingAllowed = "Page.setPrerenderingAllowed",
	domContentEventFired = "Page.domContentEventFired",
	fileChooserOpened = "Page.fileChooserOpened",
	frameAttached = "Page.frameAttached",
	frameClearedScheduledNavigation = "Page.frameClearedScheduledNavigation",
	frameDetached = "Page.frameDetached",
	frameNavigated = "Page.frameNavigated",
	documentOpened = "Page.documentOpened",
	frameResized = "Page.frameResized",
	frameRequestedNavigation = "Page.frameRequestedNavigation",
	frameScheduledNavigation = "Page.frameScheduledNavigation",
	frameStartedLoading = "Page.frameStartedLoading",
	frameStoppedLoading = "Page.frameStoppedLoading",
	downloadWillBegin = "Page.downloadWillBegin",
	downloadProgress = "Page.downloadProgress",
	interstitialHidden = "Page.interstitialHidden",
	interstitialShown = "Page.interstitialShown",
	javascriptDialogClosed = "Page.javascriptDialogClosed",
	javascriptDialogOpening = "Page.javascriptDialogOpening",
	lifecycleEvent = "Page.lifecycleEvent",
	backForwardCacheNotUsed = "Page.backForwardCacheNotUsed",
	loadEventFired = "Page.loadEventFired",
	navigatedWithinDocument = "Page.navigatedWithinDocument",
	screencastFrame = "Page.screencastFrame",
	screencastVisibilityChanged = "Page.screencastVisibilityChanged",
	windowOpen = "Page.windowOpen",
	compilationCacheProduced = "Page.compilationCacheProduced",
}

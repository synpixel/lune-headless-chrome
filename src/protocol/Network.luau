local Debugger = require("./Debugger")
local Runtime = require("./Runtime")
local Security = require("./Security")
export type ResourceType = (
	"Document"
	| "Stylesheet"
	| "Image"
	| "Media"
	| "Font"
	| "Script"
	| "TextTrack"
	| "XHR"
	| "Fetch"
	| "Prefetch"
	| "EventSource"
	| "WebSocket"
	| "Manifest"
	| "SignedExchange"
	| "Ping"
	| "CSPViolationReport"
	| "Preflight"
	| "Other"
)
export type LoaderId = string
export type RequestId = string
export type InterceptionId = string
export type ErrorReason = (
	"Failed"
	| "Aborted"
	| "TimedOut"
	| "AccessDenied"
	| "ConnectionClosed"
	| "ConnectionReset"
	| "ConnectionRefused"
	| "ConnectionAborted"
	| "ConnectionFailed"
	| "NameNotResolved"
	| "InternetDisconnected"
	| "AddressUnreachable"
	| "BlockedByClient"
	| "BlockedByResponse"
)
export type TimeSinceEpoch = number
export type MonotonicTime = number
export type Headers = {}
export type ConnectionType = (
	"none" | "cellular2g" | "cellular3g" | "cellular4g" | "bluetooth" | "ethernet" | "wifi" | "wimax" | "other"
)
export type CookieSameSite = "Strict" | "Lax" | "None"
export type CookiePriority = "Low" | "Medium" | "High"
export type CookieSourceScheme = "Unset" | "NonSecure" | "Secure"
export type ResourceTiming = {
	requestTime: number,
	proxyStart: number,
	proxyEnd: number,
	dnsStart: number,
	dnsEnd: number,
	connectStart: number,
	connectEnd: number,
	sslStart: number,
	sslEnd: number,
	workerStart: number,
	workerReady: number,
	workerFetchStart: number,
	workerRespondWithSettled: number,
	workerRouterEvaluationStart: number?,
	workerCacheLookupStart: number?,
	sendStart: number,
	sendEnd: number,
	pushStart: number,
	pushEnd: number,
	receiveHeadersStart: number,
	receiveHeadersEnd: number,
}
export type ResourcePriority = "VeryLow" | "Low" | "Medium" | "High" | "VeryHigh"
export type PostDataEntry = { bytes: string? }
export type Request = {
	url: string,
	urlFragment: string?,
	method: string,
	headers: Headers,
	postData: string?,
	hasPostData: boolean?,
	postDataEntries: { PostDataEntry }?,
	mixedContentType: Security.MixedContentType?,
	initialPriority: ResourcePriority,
	referrerPolicy: (
		"unsafe-url"
		| "no-referrer-when-downgrade"
		| "no-referrer"
		| "origin"
		| "origin-when-cross-origin"
		| "same-origin"
		| "strict-origin"
		| "strict-origin-when-cross-origin"
	),
	isLinkPreload: boolean?,
	trustTokenParams: TrustTokenParams?,
	isSameSite: boolean?,
}
export type SignedCertificateTimestamp = {
	status: string,
	origin: string,
	logDescription: string,
	logId: string,
	timestamp: number,
	hashAlgorithm: string,
	signatureAlgorithm: string,
	signatureData: string,
}
export type SecurityDetails = {
	protocol: string,
	keyExchange: string,
	keyExchangeGroup: string?,
	cipher: string,
	mac: string?,
	certificateId: Security.CertificateId,
	subjectName: string,
	sanList: { string },
	issuer: string,
	validFrom: TimeSinceEpoch,
	validTo: TimeSinceEpoch,
	signedCertificateTimestampList: { SignedCertificateTimestamp },
	certificateTransparencyCompliance: CertificateTransparencyCompliance,
	serverSignatureAlgorithm: number?,
	encryptedClientHello: boolean,
}
export type CertificateTransparencyCompliance = "unknown" | "not-compliant" | "compliant"
export type BlockedReason = (
	"other"
	| "csp"
	| "mixed-content"
	| "origin"
	| "inspector"
	| "subresource-filter"
	| "content-type"
	| "coep-frame-resource-needs-coep-header"
	| "coop-sandboxed-iframe-cannot-navigate-to-coop-page"
	| "corp-not-same-origin"
	| "corp-not-same-origin-after-defaulted-to-same-origin-by-coep"
	| "corp-not-same-origin-after-defaulted-to-same-origin-by-dip"
	| "corp-not-same-origin-after-defaulted-to-same-origin-by-coep-and-dip"
	| "corp-not-same-site"
)
export type CorsError = (
	"DisallowedByMode"
	| "InvalidResponse"
	| "WildcardOriginNotAllowed"
	| "MissingAllowOriginHeader"
	| "MultipleAllowOriginValues"
	| "InvalidAllowOriginValue"
	| "AllowOriginMismatch"
	| "InvalidAllowCredentials"
	| "CorsDisabledScheme"
	| "PreflightInvalidStatus"
	| "PreflightDisallowedRedirect"
	| "PreflightWildcardOriginNotAllowed"
	| "PreflightMissingAllowOriginHeader"
	| "PreflightMultipleAllowOriginValues"
	| "PreflightInvalidAllowOriginValue"
	| "PreflightAllowOriginMismatch"
	| "PreflightInvalidAllowCredentials"
	| "PreflightMissingAllowExternal"
	| "PreflightInvalidAllowExternal"
	| "PreflightMissingAllowPrivateNetwork"
	| "PreflightInvalidAllowPrivateNetwork"
	| "InvalidAllowMethodsPreflightResponse"
	| "InvalidAllowHeadersPreflightResponse"
	| "MethodDisallowedByPreflightResponse"
	| "HeaderDisallowedByPreflightResponse"
	| "RedirectContainsCredentials"
	| "InsecurePrivateNetwork"
	| "InvalidPrivateNetworkAccess"
	| "UnexpectedPrivateNetworkAccess"
	| "NoCorsRedirectModeNotFollow"
	| "PreflightMissingPrivateNetworkAccessId"
	| "PreflightMissingPrivateNetworkAccessName"
	| "PrivateNetworkAccessPermissionUnavailable"
	| "PrivateNetworkAccessPermissionDenied"
)
export type CorsErrorStatus = { corsError: CorsError, failedParameter: string }
export type ServiceWorkerResponseSource = "cache-storage" | "http-cache" | "fallback-code" | "network"
export type TrustTokenParams = {
	operation: TrustTokenOperationType,
	refreshPolicy: "UseCached" | "Refresh",
	issuers: { string }?,
}
export type TrustTokenOperationType = "Issuance" | "Redemption" | "Signing"
export type AlternateProtocolUsage = (
	"alternativeJobWonWithoutRace"
	| "alternativeJobWonRace"
	| "mainJobWonRace"
	| "mappingMissing"
	| "broken"
	| "dnsAlpnH3JobWonWithoutRace"
	| "dnsAlpnH3JobWonRace"
	| "unspecifiedReason"
)
export type ServiceWorkerRouterSource = "network" | "cache" | "fetch-event" | "race-network-and-fetch-handler"
export type ServiceWorkerRouterInfo = {
	ruleIdMatched: number?,
	matchedSourceType: ServiceWorkerRouterSource?,
	actualSourceType: ServiceWorkerRouterSource?,
}
export type Response = {
	url: string,
	status: number,
	statusText: string,
	headers: Headers,
	headersText: string?,
	mimeType: string,
	charset: string,
	requestHeaders: Headers?,
	requestHeadersText: string?,
	connectionReused: boolean,
	connectionId: number,
	remoteIPAddress: string?,
	remotePort: number?,
	fromDiskCache: boolean?,
	fromServiceWorker: boolean?,
	fromPrefetchCache: boolean?,
	fromEarlyHints: boolean?,
	serviceWorkerRouterInfo: ServiceWorkerRouterInfo?,
	encodedDataLength: number,
	timing: ResourceTiming?,
	serviceWorkerResponseSource: ServiceWorkerResponseSource?,
	responseTime: TimeSinceEpoch?,
	cacheStorageCacheName: string?,
	protocol: string?,
	alternateProtocolUsage: AlternateProtocolUsage?,
	securityState: Security.SecurityState,
	securityDetails: SecurityDetails?,
}
export type WebSocketRequest = { headers: Headers }
export type WebSocketResponse = {
	status: number,
	statusText: string,
	headers: Headers,
	headersText: string?,
	requestHeaders: Headers?,
	requestHeadersText: string?,
}
export type WebSocketFrame = { opcode: number, mask: boolean, payloadData: string }
export type CachedResource = { url: string, type: ResourceType, response: Response?, bodySize: number }
export type Initiator = {
	type: "parser" | "script" | "preload" | "SignedExchange" | "preflight" | "other",
	stack: Runtime.StackTrace?,
	url: string?,
	lineNumber: number?,
	columnNumber: number?,
	requestId: RequestId?,
}
export type CookiePartitionKey = { topLevelSite: string, hasCrossSiteAncestor: boolean }
export type Cookie = {
	name: string,
	value: string,
	domain: string,
	path: string,
	expires: number,
	size: number,
	httpOnly: boolean,
	secure: boolean,
	session: boolean,
	sameSite: CookieSameSite?,
	priority: CookiePriority,
	sameParty: boolean,
	sourceScheme: CookieSourceScheme,
	sourcePort: number,
	partitionKey: CookiePartitionKey?,
	partitionKeyOpaque: boolean?,
}
export type SetCookieBlockedReason = (
	"SecureOnly"
	| "SameSiteStrict"
	| "SameSiteLax"
	| "SameSiteUnspecifiedTreatedAsLax"
	| "SameSiteNoneInsecure"
	| "UserPreferences"
	| "ThirdPartyPhaseout"
	| "ThirdPartyBlockedInFirstPartySet"
	| "SyntaxError"
	| "SchemeNotSupported"
	| "OverwriteSecure"
	| "InvalidDomain"
	| "InvalidPrefix"
	| "UnknownError"
	| "SchemefulSameSiteStrict"
	| "SchemefulSameSiteLax"
	| "SchemefulSameSiteUnspecifiedTreatedAsLax"
	| "SamePartyFromCrossPartyContext"
	| "SamePartyConflictsWithOtherAttributes"
	| "NameValuePairExceedsMaxSize"
	| "DisallowedCharacter"
	| "NoCookieContent"
)
export type CookieBlockedReason = (
	"SecureOnly"
	| "NotOnPath"
	| "DomainMismatch"
	| "SameSiteStrict"
	| "SameSiteLax"
	| "SameSiteUnspecifiedTreatedAsLax"
	| "SameSiteNoneInsecure"
	| "UserPreferences"
	| "ThirdPartyPhaseout"
	| "ThirdPartyBlockedInFirstPartySet"
	| "UnknownError"
	| "SchemefulSameSiteStrict"
	| "SchemefulSameSiteLax"
	| "SchemefulSameSiteUnspecifiedTreatedAsLax"
	| "SamePartyFromCrossPartyContext"
	| "NameValuePairExceedsMaxSize"
)
export type CookieExemptionReason = (
	"None"
	| "UserSetting"
	| "TPCDMetadata"
	| "TPCDDeprecationTrial"
	| "TPCDHeuristics"
	| "EnterprisePolicy"
	| "StorageAccess"
	| "TopLevelStorageAccess"
	| "CorsOptIn"
	| "Scheme"
)
export type BlockedSetCookieWithReason =
	{ blockedReasons: { SetCookieBlockedReason }, cookieLine: string, cookie: Cookie? }
export type ExemptedSetCookieWithReason = { exemptionReason: CookieExemptionReason, cookieLine: string, cookie: Cookie }
export type AssociatedCookie = {
	cookie: Cookie,
	blockedReasons: { CookieBlockedReason },
	exemptionReason: CookieExemptionReason?,
}
export type CookieParam = {
	name: string,
	value: string,
	url: string?,
	domain: string?,
	path: string?,
	secure: boolean?,
	httpOnly: boolean?,
	sameSite: CookieSameSite?,
	expires: TimeSinceEpoch?,
	priority: CookiePriority?,
	sameParty: boolean?,
	sourceScheme: CookieSourceScheme?,
	sourcePort: number?,
	partitionKey: CookiePartitionKey?,
}
export type AuthChallenge = { source: ("Server" | "Proxy")?, origin: string, scheme: string, realm: string }
export type AuthChallengeResponse = {
	response: "Default" | "CancelAuth" | "ProvideCredentials",
	username: string?,
	password: string?,
}
export type InterceptionStage = "Request" | "HeadersReceived"
export type RequestPattern = { urlPattern: string?, resourceType: ResourceType?, interceptionStage: InterceptionStage? }
export type SignedExchangeSignature = {
	label: string,
	signature: string,
	integrity: string,
	certUrl: string?,
	certSha256: string?,
	validityUrl: string,
	date: number,
	expires: number,
	certificates: { string }?,
}
export type SignedExchangeHeader = {
	requestUrl: string,
	responseCode: number,
	responseHeaders: Headers,
	signatures: { SignedExchangeSignature },
	headerIntegrity: string,
}
export type SignedExchangeErrorField = (
	"signatureSig"
	| "signatureIntegrity"
	| "signatureCertUrl"
	| "signatureCertSha256"
	| "signatureValidityUrl"
	| "signatureTimestamps"
)
export type SignedExchangeError = { message: string, signatureIndex: number?, errorField: SignedExchangeErrorField? }
export type SignedExchangeInfo = {
	outerResponse: Response,
	header: SignedExchangeHeader?,
	securityDetails: SecurityDetails?,
	errors: { SignedExchangeError }?,
}
export type ContentEncoding = "deflate" | "gzip" | "br" | "zstd"
export type PrivateNetworkRequestPolicy = (
	"Allow" | "BlockFromInsecureToMorePrivate" | "WarnFromInsecureToMorePrivate" | "PreflightBlock" | "PreflightWarn"
)
export type IPAddressSpace = "Local" | "Private" | "Public" | "Unknown"
export type ConnectTiming = { requestTime: number }
export type ClientSecurityState = {
	initiatorIsSecureContext: boolean,
	initiatorIPAddressSpace: IPAddressSpace,
	privateNetworkRequestPolicy: PrivateNetworkRequestPolicy,
}
export type CrossOriginOpenerPolicyValue = (
	"SameOrigin"
	| "SameOriginAllowPopups"
	| "RestrictProperties"
	| "UnsafeNone"
	| "SameOriginPlusCoep"
	| "RestrictPropertiesPlusCoep"
	| "NoopenerAllowPopups"
)
export type CrossOriginOpenerPolicyStatus = {
	value: CrossOriginOpenerPolicyValue,
	reportOnlyValue: CrossOriginOpenerPolicyValue,
	reportingEndpoint: string?,
	reportOnlyReportingEndpoint: string?,
}
export type CrossOriginEmbedderPolicyValue = "None" | "Credentialless" | "RequireCorp"
export type CrossOriginEmbedderPolicyStatus = {
	value: CrossOriginEmbedderPolicyValue,
	reportOnlyValue: CrossOriginEmbedderPolicyValue,
	reportingEndpoint: string?,
	reportOnlyReportingEndpoint: string?,
}
export type ContentSecurityPolicySource = "HTTP" | "Meta"
export type ContentSecurityPolicyStatus = {
	effectiveDirectives: string,
	isEnforced: boolean,
	source: ContentSecurityPolicySource,
}
export type SecurityIsolationStatus = {
	coop: CrossOriginOpenerPolicyStatus?,
	coep: CrossOriginEmbedderPolicyStatus?,
	csp: { ContentSecurityPolicyStatus }?,
}
export type ReportStatus = "Queued" | "Pending" | "MarkedForRemoval" | "Success"
export type ReportId = string
export type ReportingApiReport = {
	id: ReportId,
	initiatorUrl: string,
	destination: string,
	type: string,
	timestamp: Network.TimeSinceEpoch,
	depth: number,
	completedAttempts: number,
	body: {},
	status: ReportStatus,
}
export type ReportingApiEndpoint = { url: string, groupName: string }
export type LoadNetworkResourcePageResult = {
	success: boolean,
	netError: number?,
	netErrorName: string?,
	httpStatusCode: number?,
	stream: IO.StreamHandle?,
	headers: Network.Headers?,
}
export type LoadNetworkResourceOptions = { disableCache: boolean, includeCredentials: boolean }
return {
	setAcceptedEncodings = "Network.setAcceptedEncodings",
	clearAcceptedEncodingsOverride = "Network.clearAcceptedEncodingsOverride",
	canClearBrowserCache = "Network.canClearBrowserCache",
	canClearBrowserCookies = "Network.canClearBrowserCookies",
	canEmulateNetworkConditions = "Network.canEmulateNetworkConditions",
	clearBrowserCache = "Network.clearBrowserCache",
	clearBrowserCookies = "Network.clearBrowserCookies",
	continueInterceptedRequest = "Network.continueInterceptedRequest",
	deleteCookies = "Network.deleteCookies",
	disable = "Network.disable",
	emulateNetworkConditions = "Network.emulateNetworkConditions",
	enable = "Network.enable",
	getAllCookies = "Network.getAllCookies",
	getCertificate = "Network.getCertificate",
	getCookies = "Network.getCookies",
	getResponseBody = "Network.getResponseBody",
	getRequestPostData = "Network.getRequestPostData",
	getResponseBodyForInterception = "Network.getResponseBodyForInterception",
	takeResponseBodyForInterceptionAsStream = "Network.takeResponseBodyForInterceptionAsStream",
	replayXHR = "Network.replayXHR",
	searchInResponseBody = "Network.searchInResponseBody",
	setBlockedURLs = "Network.setBlockedURLs",
	setBypassServiceWorker = "Network.setBypassServiceWorker",
	setCacheDisabled = "Network.setCacheDisabled",
	setCookie = "Network.setCookie",
	setCookies = "Network.setCookies",
	setExtraHTTPHeaders = "Network.setExtraHTTPHeaders",
	setAttachDebugStack = "Network.setAttachDebugStack",
	setRequestInterception = "Network.setRequestInterception",
	setUserAgentOverride = "Network.setUserAgentOverride",
	streamResourceContent = "Network.streamResourceContent",
	getSecurityIsolationStatus = "Network.getSecurityIsolationStatus",
	enableReportingApi = "Network.enableReportingApi",
	loadNetworkResource = "Network.loadNetworkResource",
}

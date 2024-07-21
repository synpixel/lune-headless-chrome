local Network = require("./Network")
export type AffectedCookie = { name: string, path: string, domain: string }
export type AffectedRequest = { requestId: Network.RequestId, url: string? }
export type AffectedFrame = { frameId: Page.FrameId }
export type CookieExclusionReason = (
	"ExcludeSameSiteUnspecifiedTreatedAsLax"
	| "ExcludeSameSiteNoneInsecure"
	| "ExcludeSameSiteLax"
	| "ExcludeSameSiteStrict"
	| "ExcludeInvalidSameParty"
	| "ExcludeSamePartyCrossPartyContext"
	| "ExcludeDomainNonASCII"
	| "ExcludeThirdPartyCookieBlockedInFirstPartySet"
	| "ExcludeThirdPartyPhaseout"
)
export type CookieWarningReason = (
	"WarnSameSiteUnspecifiedCrossSiteContext"
	| "WarnSameSiteNoneInsecure"
	| "WarnSameSiteUnspecifiedLaxAllowUnsafe"
	| "WarnSameSiteStrictLaxDowngradeStrict"
	| "WarnSameSiteStrictCrossDowngradeStrict"
	| "WarnSameSiteStrictCrossDowngradeLax"
	| "WarnSameSiteLaxCrossDowngradeStrict"
	| "WarnSameSiteLaxCrossDowngradeLax"
	| "WarnAttributeValueExceedsMaxSize"
	| "WarnDomainNonASCII"
	| "WarnThirdPartyPhaseout"
	| "WarnCrossSiteRedirectDowngradeChangesInclusion"
)
export type CookieOperation = "SetCookie" | "ReadCookie"
export type CookieIssueDetails = {
	cookie: AffectedCookie?,
	rawCookieLine: string?,
	cookieWarningReasons: { CookieWarningReason },
	cookieExclusionReasons: { CookieExclusionReason },
	operation: CookieOperation,
	siteForCookies: string?,
	cookieUrl: string?,
	request: AffectedRequest?,
}
export type MixedContentResolutionStatus = (
	"MixedContentBlocked" | "MixedContentAutomaticallyUpgraded" | "MixedContentWarning"
)
export type MixedContentResourceType = (
	"AttributionSrc"
	| "Audio"
	| "Beacon"
	| "CSPReport"
	| "Download"
	| "EventSource"
	| "Favicon"
	| "Font"
	| "Form"
	| "Frame"
	| "Image"
	| "Import"
	| "JSON"
	| "Manifest"
	| "Ping"
	| "PluginData"
	| "PluginResource"
	| "Prefetch"
	| "Resource"
	| "Script"
	| "ServiceWorker"
	| "SharedWorker"
	| "SpeculationRules"
	| "Stylesheet"
	| "Track"
	| "Video"
	| "Worker"
	| "XMLHttpRequest"
	| "XSLT"
)
export type MixedContentIssueDetails = {
	resourceType: MixedContentResourceType?,
	resolutionStatus: MixedContentResolutionStatus,
	insecureURL: string,
	mainResourceURL: string,
	request: AffectedRequest?,
	frame: AffectedFrame?,
}
export type BlockedByResponseReason = (
	"CoepFrameResourceNeedsCoepHeader"
	| "CoopSandboxedIFrameCannotNavigateToCoopPage"
	| "CorpNotSameOrigin"
	| "CorpNotSameOriginAfterDefaultedToSameOriginByCoep"
	| "CorpNotSameOriginAfterDefaultedToSameOriginByDip"
	| "CorpNotSameOriginAfterDefaultedToSameOriginByCoepAndDip"
	| "CorpNotSameSite"
)
export type BlockedByResponseIssueDetails = {
	request: AffectedRequest,
	parentFrame: AffectedFrame?,
	blockedFrame: AffectedFrame?,
	reason: BlockedByResponseReason,
}
export type HeavyAdResolutionStatus = "HeavyAdBlocked" | "HeavyAdWarning"
export type HeavyAdReason = "NetworkTotalLimit" | "CpuTotalLimit" | "CpuPeakLimit"
export type HeavyAdIssueDetails = { resolution: HeavyAdResolutionStatus, reason: HeavyAdReason, frame: AffectedFrame }
export type ContentSecurityPolicyViolationType = (
	"kInlineViolation"
	| "kEvalViolation"
	| "kURLViolation"
	| "kTrustedTypesSinkViolation"
	| "kTrustedTypesPolicyViolation"
	| "kWasmEvalViolation"
)
export type SourceCodeLocation = { scriptId: Runtime.ScriptId?, url: string, lineNumber: number, columnNumber: number }
export type ContentSecurityPolicyIssueDetails = {
	blockedURL: string?,
	violatedDirective: string,
	isReportOnly: boolean,
	contentSecurityPolicyViolationType: ContentSecurityPolicyViolationType,
	frameAncestor: AffectedFrame?,
	sourceCodeLocation: SourceCodeLocation?,
	violatingNodeId: DOM.BackendNodeId?,
}
export type SharedArrayBufferIssueType = "TransferIssue" | "CreationIssue"
export type SharedArrayBufferIssueDetails = {
	sourceCodeLocation: SourceCodeLocation,
	isWarning: boolean,
	type: SharedArrayBufferIssueType,
}
export type LowTextContrastIssueDetails = {
	violatingNodeId: DOM.BackendNodeId,
	violatingNodeSelector: string,
	contrastRatio: number,
	thresholdAA: number,
	thresholdAAA: number,
	fontSize: string,
	fontWeight: string,
}
export type CorsIssueDetails = {
	corsErrorStatus: Network.CorsErrorStatus,
	isWarning: boolean,
	request: AffectedRequest,
	location: SourceCodeLocation?,
	initiatorOrigin: string?,
	resourceIPAddressSpace: Network.IPAddressSpace?,
	clientSecurityState: Network.ClientSecurityState?,
}
export type AttributionReportingIssueType = (
	"PermissionPolicyDisabled"
	| "UntrustworthyReportingOrigin"
	| "InsecureContext"
	| "InvalidHeader"
	| "InvalidRegisterTriggerHeader"
	| "SourceAndTriggerHeaders"
	| "SourceIgnored"
	| "TriggerIgnored"
	| "OsSourceIgnored"
	| "OsTriggerIgnored"
	| "InvalidRegisterOsSourceHeader"
	| "InvalidRegisterOsTriggerHeader"
	| "WebAndOsHeaders"
	| "NoWebOrOsSupport"
	| "NavigationRegistrationWithoutTransientUserActivation"
	| "InvalidInfoHeader"
	| "NoRegisterSourceHeader"
	| "NoRegisterTriggerHeader"
	| "NoRegisterOsSourceHeader"
	| "NoRegisterOsTriggerHeader"
)
export type SharedDictionaryError = (
	"UseErrorCrossOriginNoCorsRequest"
	| "UseErrorDictionaryLoadFailure"
	| "UseErrorMatchingDictionaryNotUsed"
	| "UseErrorUnexpectedContentDictionaryHeader"
	| "WriteErrorCossOriginNoCorsRequest"
	| "WriteErrorDisallowedBySettings"
	| "WriteErrorExpiredResponse"
	| "WriteErrorFeatureDisabled"
	| "WriteErrorInsufficientResources"
	| "WriteErrorInvalidMatchField"
	| "WriteErrorInvalidStructuredHeader"
	| "WriteErrorNavigationRequest"
	| "WriteErrorNoMatchField"
	| "WriteErrorNonListMatchDestField"
	| "WriteErrorNonSecureContext"
	| "WriteErrorNonStringIdField"
	| "WriteErrorNonStringInMatchDestList"
	| "WriteErrorNonStringMatchField"
	| "WriteErrorNonTokenTypeField"
	| "WriteErrorRequestAborted"
	| "WriteErrorShuttingDown"
	| "WriteErrorTooLongIdField"
	| "WriteErrorUnsupportedType"
)
export type AttributionReportingIssueDetails = {
	violationType: AttributionReportingIssueType,
	request: AffectedRequest?,
	violatingNodeId: DOM.BackendNodeId?,
	invalidParameter: string?,
}
export type QuirksModeIssueDetails = {
	isLimitedQuirksMode: boolean,
	documentNodeId: DOM.BackendNodeId,
	url: string,
	frameId: Page.FrameId,
	loaderId: Network.LoaderId,
}
export type NavigatorUserAgentIssueDetails = { url: string, location: SourceCodeLocation? }
export type SharedDictionaryIssueDetails = { sharedDictionaryError: SharedDictionaryError, request: AffectedRequest }
export type GenericIssueErrorType = (
	"FormLabelForNameError"
	| "FormDuplicateIdForInputError"
	| "FormInputWithNoLabelError"
	| "FormAutocompleteAttributeEmptyError"
	| "FormEmptyIdAndNameAttributesForInputError"
	| "FormAriaLabelledByToNonExistingId"
	| "FormInputAssignedAutocompleteValueToIdOrNameAttributeError"
	| "FormLabelHasNeitherForNorNestedInput"
	| "FormLabelForMatchesNonExistingIdError"
	| "FormInputHasWrongButWellIntendedAutocompleteValueError"
	| "ResponseWasBlockedByORB"
)
export type GenericIssueDetails = {
	errorType: GenericIssueErrorType,
	frameId: Page.FrameId?,
	violatingNodeId: DOM.BackendNodeId?,
	violatingNodeAttribute: string?,
	request: AffectedRequest?,
}
export type DeprecationIssueDetails = {
	affectedFrame: AffectedFrame?,
	sourceCodeLocation: SourceCodeLocation,
	type: string,
}
export type BounceTrackingIssueDetails = { trackingSites: { string } }
export type CookieDeprecationMetadataIssueDetails = {
	allowedSites: { string },
	optOutPercentage: number,
	isOptOutTopLevel: boolean,
	operation: CookieOperation,
}
export type ClientHintIssueReason = "MetaTagAllowListInvalidOrigin" | "MetaTagModifiedHTML"
export type FederatedAuthRequestIssueDetails = { federatedAuthRequestIssueReason: FederatedAuthRequestIssueReason }
export type FederatedAuthRequestIssueReason = (
	"ShouldEmbargo"
	| "TooManyRequests"
	| "WellKnownHttpNotFound"
	| "WellKnownNoResponse"
	| "WellKnownInvalidResponse"
	| "WellKnownListEmpty"
	| "WellKnownInvalidContentType"
	| "ConfigNotInWellKnown"
	| "WellKnownTooBig"
	| "ConfigHttpNotFound"
	| "ConfigNoResponse"
	| "ConfigInvalidResponse"
	| "ConfigInvalidContentType"
	| "ClientMetadataHttpNotFound"
	| "ClientMetadataNoResponse"
	| "ClientMetadataInvalidResponse"
	| "ClientMetadataInvalidContentType"
	| "IdpNotPotentiallyTrustworthy"
	| "DisabledInSettings"
	| "DisabledInFlags"
	| "ErrorFetchingSignin"
	| "InvalidSigninResponse"
	| "AccountsHttpNotFound"
	| "AccountsNoResponse"
	| "AccountsInvalidResponse"
	| "AccountsListEmpty"
	| "AccountsInvalidContentType"
	| "IdTokenHttpNotFound"
	| "IdTokenNoResponse"
	| "IdTokenInvalidResponse"
	| "IdTokenIdpErrorResponse"
	| "IdTokenCrossSiteIdpErrorResponse"
	| "IdTokenInvalidRequest"
	| "IdTokenInvalidContentType"
	| "ErrorIdToken"
	| "Canceled"
	| "RpPageNotVisible"
	| "SilentMediationFailure"
	| "ThirdPartyCookiesBlocked"
	| "NotSignedInWithIdp"
	| "MissingTransientUserActivation"
	| "ReplacedByButtonMode"
	| "InvalidFieldsSpecified"
	| "RelyingPartyOriginIsOpaque"
	| "TypeNotMatching"
)
export type FederatedAuthUserInfoRequestIssueDetails = {
	federatedAuthUserInfoRequestIssueReason: FederatedAuthUserInfoRequestIssueReason,
}
export type FederatedAuthUserInfoRequestIssueReason = (
	"NotSameOrigin"
	| "NotIframe"
	| "NotPotentiallyTrustworthy"
	| "NoApiPermission"
	| "NotSignedInWithIdp"
	| "NoAccountSharingPermission"
	| "InvalidConfigOrWellKnown"
	| "InvalidAccountsResponse"
	| "NoReturningUserFromFetchedAccounts"
)
export type ClientHintIssueDetails = {
	sourceCodeLocation: SourceCodeLocation,
	clientHintIssueReason: ClientHintIssueReason,
}
export type FailedRequestInfo = { url: string, failureMessage: string, requestId: Network.RequestId? }
export type StyleSheetLoadingIssueReason = "LateImportRule" | "RequestFailed"
export type StylesheetLoadingIssueDetails = {
	sourceCodeLocation: SourceCodeLocation,
	styleSheetLoadingIssueReason: StyleSheetLoadingIssueReason,
	failedRequestInfo: FailedRequestInfo?,
}
export type PropertyRuleIssueReason = "InvalidSyntax" | "InvalidInitialValue" | "InvalidInherits" | "InvalidName"
export type PropertyRuleIssueDetails = {
	sourceCodeLocation: SourceCodeLocation,
	propertyRuleIssueReason: PropertyRuleIssueReason,
	propertyValue: string?,
}
export type InspectorIssueCode = (
	"CookieIssue"
	| "MixedContentIssue"
	| "BlockedByResponseIssue"
	| "HeavyAdIssue"
	| "ContentSecurityPolicyIssue"
	| "SharedArrayBufferIssue"
	| "LowTextContrastIssue"
	| "CorsIssue"
	| "AttributionReportingIssue"
	| "QuirksModeIssue"
	| "NavigatorUserAgentIssue"
	| "GenericIssue"
	| "DeprecationIssue"
	| "ClientHintIssue"
	| "FederatedAuthRequestIssue"
	| "BounceTrackingIssue"
	| "CookieDeprecationMetadataIssue"
	| "StylesheetLoadingIssue"
	| "FederatedAuthUserInfoRequestIssue"
	| "PropertyRuleIssue"
	| "SharedDictionaryIssue"
)
export type InspectorIssueDetails = {
	cookieIssueDetails: CookieIssueDetails?,
	mixedContentIssueDetails: MixedContentIssueDetails?,
	blockedByResponseIssueDetails: BlockedByResponseIssueDetails?,
	heavyAdIssueDetails: HeavyAdIssueDetails?,
	contentSecurityPolicyIssueDetails: ContentSecurityPolicyIssueDetails?,
	sharedArrayBufferIssueDetails: SharedArrayBufferIssueDetails?,
	lowTextContrastIssueDetails: LowTextContrastIssueDetails?,
	corsIssueDetails: CorsIssueDetails?,
	attributionReportingIssueDetails: AttributionReportingIssueDetails?,
	quirksModeIssueDetails: QuirksModeIssueDetails?,
	navigatorUserAgentIssueDetails: NavigatorUserAgentIssueDetails?,
	genericIssueDetails: GenericIssueDetails?,
	deprecationIssueDetails: DeprecationIssueDetails?,
	clientHintIssueDetails: ClientHintIssueDetails?,
	federatedAuthRequestIssueDetails: FederatedAuthRequestIssueDetails?,
	bounceTrackingIssueDetails: BounceTrackingIssueDetails?,
	cookieDeprecationMetadataIssueDetails: CookieDeprecationMetadataIssueDetails?,
	stylesheetLoadingIssueDetails: StylesheetLoadingIssueDetails?,
	propertyRuleIssueDetails: PropertyRuleIssueDetails?,
	federatedAuthUserInfoRequestIssueDetails: FederatedAuthUserInfoRequestIssueDetails?,
	sharedDictionaryIssueDetails: SharedDictionaryIssueDetails?,
}
export type IssueId = string
export type InspectorIssue = { code: InspectorIssueCode, details: InspectorIssueDetails, issueId: IssueId? }
return {
	getEncodedResponse = "Audits.getEncodedResponse",
	disable = "Audits.disable",
	enable = "Audits.enable",
	checkContrast = "Audits.checkContrast",
	checkFormsIssues = "Audits.checkFormsIssues",
}

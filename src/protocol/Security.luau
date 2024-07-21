export type CertificateId = number
export type MixedContentType = "blockable" | "optionally-blockable" | "none"
export type SecurityState = "unknown" | "neutral" | "insecure" | "secure" | "info" | "insecure-broken"
export type CertificateSecurityState = {
	protocol: string,
	keyExchange: string,
	keyExchangeGroup: string,
	cipher: string,
	mac: string,
	certificate: { string },
	subjectName: string,
	issuer: string,
	validFrom: Network.TimeSinceEpoch,
	validTo: Network.TimeSinceEpoch,
	certificateNetworkError: string,
	certificateHasWeakSignature: boolean,
	certificateHasSha1Signature: boolean,
	modernSSL: boolean,
	obsoleteSslProtocol: boolean,
	obsoleteSslKeyExchange: boolean,
	obsoleteSslCipher: boolean,
	obsoleteSslSignature: boolean,
}
export type SafetyTipStatus = "badReputation" | "lookalike"
export type SafetyTipInfo = { safetyTipStatus: SafetyTipStatus, safeUrl: string }
export type VisibleSecurityState = {
	securityState: SecurityState,
	certificateSecurityState: CertificateSecurityState,
	safetyTipInfo: SafetyTipInfo,
	securityStateIssueIds: { string },
}
export type SecurityStateExplanation = {
	securityState: SecurityState,
	title: string,
	summary: string,
	description: string,
	mixedContentType: MixedContentType,
	certificate: { string },
	recommendations: { string },
}
export type InsecureContentStatus = {
	ranMixedContent: boolean,
	displayedMixedContent: boolean,
	containedMixedForm: boolean,
	ranContentWithCertErrors: boolean,
	displayedContentWithCertErrors: boolean,
	ranInsecureContentStyle: SecurityState,
	displayedInsecureContentStyle: SecurityState,
}
export type CertificateErrorAction = "continue" | "cancel"
return {
	disable = "Security.disable",
	enable = "Security.enable",
	setIgnoreCertificateErrors = "Security.setIgnoreCertificateErrors",
	handleCertificateError = "Security.handleCertificateError",
	setOverrideCertificateErrors = "Security.setOverrideCertificateErrors",
}

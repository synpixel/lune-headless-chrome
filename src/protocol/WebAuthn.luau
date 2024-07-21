export type AuthenticatorId = string
export type AuthenticatorProtocol = "u2f" | "ctap2"
export type Ctap2Version = "ctap2_0" | "ctap2_1"
export type AuthenticatorTransport = "usb" | "nfc" | "ble" | "cable" | "internal"
export type VirtualAuthenticatorOptions = {
	protocol: AuthenticatorProtocol,
	ctap2Version: Ctap2Version,
	transport: AuthenticatorTransport,
	hasResidentKey: boolean,
	hasUserVerification: boolean,
	hasLargeBlob: boolean,
	hasCredBlob: boolean,
	hasMinPinLength: boolean,
	hasPrf: boolean,
	automaticPresenceSimulation: boolean,
	isUserVerified: boolean,
	defaultBackupEligibility: boolean,
	defaultBackupState: boolean,
}
export type Credential = {
	credentialId: string,
	isResidentCredential: boolean,
	rpId: string,
	privateKey: string,
	userHandle: string,
	signCount: number,
	largeBlob: string,
	backupEligibility: boolean,
	backupState: boolean,
}
return {
	enable = "WebAuthn.enable",
	disable = "WebAuthn.disable",
	addVirtualAuthenticator = "WebAuthn.addVirtualAuthenticator",
	setResponseOverrideBits = "WebAuthn.setResponseOverrideBits",
	removeVirtualAuthenticator = "WebAuthn.removeVirtualAuthenticator",
	addCredential = "WebAuthn.addCredential",
	getCredential = "WebAuthn.getCredential",
	getCredentials = "WebAuthn.getCredentials",
	removeCredential = "WebAuthn.removeCredential",
	clearCredentials = "WebAuthn.clearCredentials",
	setUserVerified = "WebAuthn.setUserVerified",
	setAutomaticPresenceSimulation = "WebAuthn.setAutomaticPresenceSimulation",
	setCredentialProperties = "WebAuthn.setCredentialProperties",
}

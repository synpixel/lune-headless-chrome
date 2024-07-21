export type LoginState = "SignIn" | "SignUp"
export type DialogType = "AccountChooser" | "AutoReauthn" | "ConfirmIdpLogin" | "Error"
export type DialogButton = "ConfirmIdpLoginContinue" | "ErrorGotIt" | "ErrorMoreDetails"
export type AccountUrlType = "TermsOfService" | "PrivacyPolicy"
export type Account = {
	accountId: string,
	email: string,
	name: string,
	givenName: string,
	pictureUrl: string,
	idpConfigUrl: string,
	idpLoginUrl: string,
	loginState: LoginState,
	termsOfServiceUrl: string?,
	privacyPolicyUrl: string?,
}
return {
	enable = "FedCm.enable",
	disable = "FedCm.disable",
	selectAccount = "FedCm.selectAccount",
	clickDialogButton = "FedCm.clickDialogButton",
	openUrl = "FedCm.openUrl",
	dismissDialog = "FedCm.dismissDialog",
	resetCooldown = "FedCm.resetCooldown",
}

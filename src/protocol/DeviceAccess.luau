export type RequestId = string
export type DeviceId = string
export type PromptDevice = { id: DeviceId, name: string }
return {
	enable = "DeviceAccess.enable",
	disable = "DeviceAccess.disable",
	selectPrompt = "DeviceAccess.selectPrompt",
	cancelPrompt = "DeviceAccess.cancelPrompt",
	deviceRequestPrompted = "DeviceAccess.deviceRequestPrompted",
}

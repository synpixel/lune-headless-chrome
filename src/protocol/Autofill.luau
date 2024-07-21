export type CreditCard = { number: string, name: string, expiryMonth: string, expiryYear: string, cvc: string }
export type AddressField = { name: string, value: string }
export type AddressFields = { fields: { AddressField } }
export type Address = { fields: { AddressField } }
export type AddressUI = { addressFields: { AddressFields } }
export type FillingStrategy = "autocompleteAttribute" | "autofillInferred"
export type FilledField = {
	htmlType: string,
	id: string,
	name: string,
	value: string,
	autofillType: string,
	fillingStrategy: FillingStrategy,
	frameId: Page.FrameId,
	fieldId: DOM.BackendNodeId,
}
return {
	trigger = "Autofill.trigger",
	setAddresses = "Autofill.setAddresses",
	disable = "Autofill.disable",
	enable = "Autofill.enable",
}

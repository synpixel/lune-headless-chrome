export type SerializedStorageKey = string
export type StorageId = { securityOrigin: string, storageKey: SerializedStorageKey, isLocalStorage: boolean }
export type Item = { string }
return {
	clear = "DOMStorage.clear",
	disable = "DOMStorage.disable",
	enable = "DOMStorage.enable",
	getDOMStorageItems = "DOMStorage.getDOMStorageItems",
	removeDOMStorageItem = "DOMStorage.removeDOMStorageItem",
	setDOMStorageItem = "DOMStorage.setDOMStorageItem",
}

-- this file was automatically generated and not intended for manual editing
local Runtime = require("./Runtime")
local Storage = require("./Storage")
export type DatabaseWithObjectStores = { name: string, version: number, objectStores: { ObjectStore } }
export type ObjectStore = { name: string, keyPath: KeyPath, autoIncrement: boolean, indexes: { ObjectStoreIndex } }
export type ObjectStoreIndex = { name: string, keyPath: KeyPath, unique: boolean, multiEntry: boolean }
export type Key = {
	type: "number" | "string" | "date" | "array",
	number: number?,
	string: string?,
	date: number?,
	array: { Key }?,
}
export type KeyRange = { lower: Key?, upper: Key?, lowerOpen: boolean, upperOpen: boolean }
export type DataEntry = { key: Runtime.RemoteObject, primaryKey: Runtime.RemoteObject, value: Runtime.RemoteObject }
export type KeyPath = { type: "null" | "string" | "array", string: string?, array: { string }? }
return {
	clearObjectStore = "IndexedDB.clearObjectStore",
	deleteDatabase = "IndexedDB.deleteDatabase",
	deleteObjectStoreEntries = "IndexedDB.deleteObjectStoreEntries",
	disable = "IndexedDB.disable",
	enable = "IndexedDB.enable",
	requestData = "IndexedDB.requestData",
	getMetadata = "IndexedDB.getMetadata",
	requestDatabase = "IndexedDB.requestDatabase",
	requestDatabaseNames = "IndexedDB.requestDatabaseNames",
}

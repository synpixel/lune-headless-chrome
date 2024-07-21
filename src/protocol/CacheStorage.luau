local Storage = require("./Storage")
export type CacheId = string
export type CachedResponseType = "basic" | "cors" | "default" | "error" | "opaqueResponse" | "opaqueRedirect"
export type DataEntry = {
	requestURL: string,
	requestMethod: string,
	requestHeaders: { Header },
	responseTime: number,
	responseStatus: number,
	responseStatusText: string,
	responseType: CachedResponseType,
	responseHeaders: { Header },
}
export type Cache = {
	cacheId: CacheId,
	securityOrigin: string,
	storageKey: string,
	storageBucket: Storage.StorageBucket?,
	cacheName: string,
}
export type Header = { name: string, value: string }
export type CachedResponse = { body: string }
return {
	deleteCache = "CacheStorage.deleteCache",
	deleteEntry = "CacheStorage.deleteEntry",
	requestCacheNames = "CacheStorage.requestCacheNames",
	requestCachedResponse = "CacheStorage.requestCachedResponse",
	requestEntries = "CacheStorage.requestEntries",
}

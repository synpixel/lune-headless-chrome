local Network = require("./Network")
local Storage = require("./Storage")
export type File = { name: string, lastModified: Network.TimeSinceEpoch, size: number, type: string }
export type Directory = { name: string, nestedDirectories: { string }, nestedFiles: { File } }
export type BucketFileSystemLocator = {
	storageKey: Storage.SerializedStorageKey,
	bucketName: string?,
	pathComponents: { string },
}
return {
	getDirectory = "FileSystem.getDirectory",
}

-- this file was automatically generated and not intended for manual editing
local Page = require("./Page")
local Runtime = require("./Runtime")
export type ScreenshotParams = { format: ("jpeg" | "png" | "webp")?, quality: number?, optimizeForSpeed: boolean? }
return {
	beginFrame = "HeadlessExperimental.beginFrame",
	disable = "HeadlessExperimental.disable",
	enable = "HeadlessExperimental.enable",
}

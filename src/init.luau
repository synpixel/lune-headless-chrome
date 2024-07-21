local createBrowser = require("./createBrowser")
local types = require("./types")

export type Future<T> = types.Future<T>

export type BrowserLaunchOptions = types.BrowserLaunchOptions
export type PartialBrowserLaunchOptions = types.PartialBrowserLaunchOptions
export type BrowserVersion = types.BrowserVersion
export type Browser = types.Browser

export type Tab = types.Tab
export type Point = types.Point
export type ScreenshotOptions = types.ScreenshotOptions
export type ScreencastOptions = types.ScreencastOptions
export type ScreencastFrame = types.ScreencastFrame

return {
	createBrowser = createBrowser,
}

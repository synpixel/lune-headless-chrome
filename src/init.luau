local createBrowser = require("./createBrowser")
local types = require("./types")

export type Future<T> = types.Future<T>

export type BrowserLaunchOptions = types.BrowserLaunchOptions
export type PartialBrowserLaunchOptions = types.PartialBrowserLaunchOptions
export type BrowserVersion = types.BrowserVersion
export type Browser = types.Browser

export type Tab = types.Tab
export type Point = types.Point
export type ElementQuad = types.ElementQuad
export type ScreenshotOptions = types.ScreenshotOptions
export type ElementScreenshotOptions = types.ElementScreenshotOptions
export type ScreencastOptions = types.ScreencastOptions
export type ScreencastFrame = types.ScreencastFrame
export type PrintToPDFOptions = types.PrintToPDFOptions

return {
	createBrowser = createBrowser,
}

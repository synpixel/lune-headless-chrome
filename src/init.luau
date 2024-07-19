local createBrowser = require("./createBrowser")
local types = require("./types")

export type TargetInfo = types.TargetInfo
export type BrowserVersion = types.BrowserVersion
export type BrowserLaunchOptions = types.BrowserLaunchOptions
export type PartialBrowserLaunchOptions = types.PartialBrowserLaunchOptions
export type Cookie = types.Cookie
export type ScreenshotOptions = types.ScreenshotOptions

export type Browser = types.Browser
export type Tab = types.Tab

return {
	createBrowser = createBrowser,
}

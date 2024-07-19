local createBrowser = require("./createBrowser")
local Future = require("./packages/future")
local types = require("./types")

export type Future<T> = Future.Future<T>

export type TargetInfo = types.TargetInfo

export type BrowserLaunchOptions = types.BrowserLaunchOptions
export type PartialBrowserLaunchOptions = types.PartialBrowserLaunchOptions
export type BrowserVersion = types.BrowserVersion
export type Browser = types.Browser

export type Tab = types.Tab

export type CookieParameters = types.CookieParameters
export type Cookie = types.Cookie

export type Viewport = types.Viewport
export type ScreenshotOptions = types.ScreenshotOptions

export type RemoteObject = types.RemoteObject

return {
	createBrowser = createBrowser,
}

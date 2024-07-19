local createBrowser = require("./createBrowser")
local types = require("./types")

export type TargetInfo = types.TargetInfo

export type BrowserLaunchOptions = types.BrowserLaunchOptions
export type PartialBrowserLaunchOptions = types.PartialBrowserLaunchOptions
export type BrowserVersion = types.BrowserVersion
export type Browser = types.Browser

export type Tab = types.Tab

export type CookieParameters = types.CookieParameters
export type CookieSameSite = types.CookieSameSite
export type CookiePriority = types.CookiePriority
export type CookieSourceScheme = types.CookieSourceScheme
export type CookiePartitionKey = types.CookiePartitionKey
export type Cookie = types.Cookie

export type Viewport = types.Viewport
export type ScreenshotOptions = types.ScreenshotOptions

export type RemoteObject = types.RemoteObject

return {
	createBrowser = createBrowser,
}

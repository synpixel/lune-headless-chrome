local proc = require("@self/proc")
local browser = require("@self/browser")
local context = require("@self/context")
local tab = require("@self/tab")
local polling = require("@self/util/polling")
local Method = require("@self/protocol/method")
local Event = require("@self/protocol/event")

export type LaunchOptions = proc.LaunchOptions
export type Browser = browser.Browser
export type Context = context.Context

export type Tab = tab.Tab
export type Element = tab.Element
export type ElementQuad = tab.ElementQuad
export type BoxModel = tab.BoxModel

return {
	polling = polling,
	browser = browser,
	Method = Method,
	Event = Event,
}

# lune-headless-chrome

A headless chrome implementation for [Lune](https://github.com/lune-org/lune) based off of the [headless_chrome](https://github.com/rust-headless-chrome/rust-headless-chrome) crate.

## Quick Start

> https://github.com/rust-headless-chrome/rust-headless-chrome/blob/main/README.md#quick-start

```luau
local fs = require("@lune/fs")
local chrome = require(...)

local browser = chrome.createBrowser()
local tab = browser:newTab():await()

-- navigate to wikipedia
tab:navigateTo("https://www.wikipedia.org/"):await()

-- wait for network/javascript/dom to make the search-box available
-- and click it.
tab:waitForElement("input#searchInput"):await():click():await()

-- type in a query and press `Enter`
tab:sendCharacters("WebKit"):await():pressKey("Enter"):await()

-- we should end up on the WebKit-page once navigated
local element = tab:waitForElement("#firstHeading"):await()
assert(tab:getUrl():await():find("WebKit") ~= nil)

-- take a screenshot of the entire browser window
local screenshot = tab:captureScreenshot({
	format = "jpeg",
}):await()

-- save the screenshot to disc
fs.writeFile("screenshot.jpeg", screenshot)

-- run JavaScript in the page
local functionDeclaration = [[
	function getIdTwice() {
		// `this` is always the element that you called `callFunction` on
		const id = this.id;
		return id + id;
	}
]]

local remoteObject = element:callFunction(functionDeclaration):await()
assert(remoteObject.value == "firstHeadingfirstHeading")
```

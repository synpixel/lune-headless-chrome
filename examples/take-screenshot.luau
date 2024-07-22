-- https://github.com/rust-headless-chrome/rust-headless-chrome/blob/main/examples/take_screenshot.rs

local fs = require("@lune/fs")
local chrome = require("../src")

local browser = chrome.createBrowser()
local tab = browser:newTab():await()

local jpegScreenshot = tab:navigateTo("https://www.wikipedia.org/")
	:await()
	:captureScreenshot({ format = "jpeg", quality = 75, fromSurface = true })
	:await()

fs.writeFile("screenshot.jpeg", jpegScreenshot)

local pngScreenshot = tab:navigateTo("https://en.wikipedia.org/wiki/WebKit")
	:await()
	:waitForElement("#mw-content-text > div > table.infobox.vevent")
	:await()
	:captureScreenshot({ format = "png" })
	:await()

fs.writeFile("screenshot.png", pngScreenshot)

print("screenshots successfully created.")

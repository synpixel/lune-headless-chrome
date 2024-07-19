local fs = require("@lune/fs")
local chrome = require("../src")

local browser = chrome.createBrowser({
	headless = false,
	port = 3466,
})

local browserVersion = browser:getVersion():await()
print("browser version:", browserVersion)

local tab = browser:newTab():await()
print("opened tab")

tab:navigateTo("https://www.wikipedia.org/"):await()
print("navigated to Wikipedia")

local targetInfo = tab:getTargetInfo():await()
print("tab target info:", targetInfo)

local screenshot = tab:captureScreenshot({
	format = "jpeg",
	optimizeForSpeed = true,
}):await()

fs.writeFile("screenshot.jpeg", screenshot)
print("wrote screenshot to screenshot.jpeg")

local fs = require("@lune/fs")
local chrome = require("../src")

local browser = chrome.browser.create()
local tab = browser:create_tab()

local jpeg = tab:navigate_to("https://www.wikipedia.org")
	:wait_until_navigated()
	:capture_screenshot({ format = "jpeg", quality = 75, from_surface = true })
fs.writeFile("screenshot.jpg", jpeg)

local png = tab:navigate_to("https://en.wikipedia.org/wiki/WebKit")
	:wait_until_navigated()
	:wait_for_element("#mw-content-text > div > table.infobox.vevent")
	:capture_screenshot({ format = "png", from_surface = true })
fs.writeFile("screenshot.png", png)

print("Screenshots successfully created.")

browser:close()

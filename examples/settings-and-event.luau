local chrome = require("../src")

local browser = chrome.browser.create({ headless = false })
local tab = browser:create_tab()

tab:navigate_to("https://www.google.com"):wait_until_navigated()

tab:add_event_listener(chrome.Event.PageLifecycleEvent, function(lifecycle)
	if lifecycle.name == "DOMContentLoaded" then
		print(tab:get_url())
	end
end)

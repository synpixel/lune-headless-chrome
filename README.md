# chrome.luau

This is an implementation of the Chrome DevTools Protocol written in Luau for Lune, based on [rust-headless-chrome](https://github.com/rust-headless-chrome/rust-headless-chrome).

It allows you to control a Chromium browser with Luau code thanks to Lune's networking features, which is useful for web-crawling, automating tasks, authentication and basically everything else you can do with a browser.

Below you will find a quick snippet showcasing its usage. You can also take a peek inside the `examples` folder.

## Quick Start

```luau
local fs = require("@lune/fs")
local chrome = require("./lune_packages/chrome")

local browser = chrome.browser.create()
local tab = browser:create_tab()

-- Navigate to wikipedia
tab:navigate_to("https://www.wikipedia.org"):wait_until_navigated()

-- Wait for network/javascript/dom to make the search-box available
-- and click it.
tab:wait_for_element("input#searchInput"):click()

-- Type in a query and press `Enter`
tab:type_text("WebKit"):press_key("Enter"):wait_until_navigated()

-- We should end up on the WebKit-page once navigated
local element = tab:wait_for_element("#firstHeading")
assert(string.sub(tab:get_url(), -6) == "WebKit")

-- Take a screenshot of the entire browser window
local jpeg = tab:capture_screenshot({ format = "jpeg", from_surface = true })
-- Save the screenshot to disc
fs.writeFile("screenshot.jpeg", jpeg)

-- Take a screenshot of just the WebKit-Infobox
local png = tab:wait_for_element("#mw-content-text > div > table.infobox.vevent"):capture_screenshot({ format = "png" })
-- Save the screenshot to disc
fs.writeFile("screenshot.png", png)

-- Run JavaScript in the page
local result = element:call_js_fn([[
    function getIdTwice() {
        // `this` is always the element that you called `call_js_fn` on
        const id = this.id;
        return id + id;
    }
]])

assert(result.value == "firstHeadingfirstHeading")
```

## Installation

As of now, chrome.luau only supports pesde as a package manager.  
To install the package, just execute the following command.

```sh
pesde add synpixel/chrome
```

## Features

- [x] Type safety
- [x] Launch a browser instance
- [x] Connect to an existing browser instance
- [x] Headless browsing (default)
- [x] DOM manipulation
- [x] Dispatch user input
- [x] Access and modify storage
- [x] Intercept and network traffic
- [ ] (To-Do) Auto-install a browser

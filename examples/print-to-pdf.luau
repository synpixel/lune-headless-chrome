local process = require("@lune/process")
local fs = require("@lune/fs")
local chrome = require("../src")

local WEBSOCKET_URL = assert(process.args[1], "Must provide websocket url")
local FILE_PATH = assert(process.args[2], "Must provide path/to/file/index.html")

local browser = chrome.browser.connect(WEBSOCKET_URL)
local tab = browser:create_tab()

local wikidata = tab:navigate_to("https://www.wikipedia.org"):wait_until_navigated():print_to_pdf()
fs.writeFile("wiki.pdf", wikidata)
print("PDF successfully created from internet web page.")

local local_pdf = tab:navigate_to(FILE_PATH):wait_until_navigated():print_to_pdf()
fs.writeFile("rust.pdf", local_pdf)
print("PDF successfully created from local web page.")

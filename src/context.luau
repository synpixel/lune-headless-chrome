local types = require("./types")

export type Context = types.Context

local function get_id(context: Context): string
	return context.id
end

local function get_tabs(context: Context): { types.Tab }
	local tabs = {}

	for _, t in context.browser:get_tabs() do
		if t:get_browser_context_id() == context.id then
			table.insert(tabs, t)
		end
	end

	return tabs
end

local function create_tab(context: Context): types.Tab
	return context.browser:create_tab({
		url = "about:blank",
		browser_context_id = context.id,
	})
end

local function create(browser: types.Browser, context_id: string): Context
	return {
		id = context_id,
		browser = browser,
		get_id = get_id,
		get_tabs = get_tabs,
		create_tab = create_tab,
	}
end

return { create = create }

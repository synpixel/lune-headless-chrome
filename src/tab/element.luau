local element_quad = require("./element-quad")
local box_model = require("./box-model")
local polling = require("../util/polling")
local types = require("../types")
local DOM = require("../protocol/dom")
local Runtime = require("../protocol/runtime")

export type Element = types.Element

local DEFAULT_TIMEOUT = 3

local create: (parent: types.Tab, node_id: DOM.NodeId) -> Element?

local function extract_midpoint(remote_object: Runtime.RemoteObject): vector
	if not remote_object.preview then
		return vector.zero
	end

	local props = {}

	for _, property in remote_object.preview.properties do
		props[property.name] = tonumber(property.value) :: number
	end

	return vector.create(props.x + props.width / 2, props.y + props.height / 2)
end

local function get_description(element: Element): DOM.Node
	return element.parent:call_method(DOM.DescribeNode, { node_id = element.node_id, depth = 100 }).node
end

local function get_attributes(element: Element): { string }?
	local description = element:get_description()
	return description.attributes
end

local function get_attribute_value(element: Element, name: string): string?
	local expression = `function() \{ return this.getAttribute("{name}"); \}`

	local value = element:call_js_fn(expression, nil, true).value
	return value
end

local function get_inner_text(element: Element): string
	local text = element:call_js_fn("function() { return this.innerText }").value
	return text :: string
end

local function get_content(element: Element): string
	local html = element:call_js_fn("function() { return this.outerHTML }").value
	return html :: string
end

local function find_element(element: Element, selector: string): Element?
	return element.parent:run_query_selector_on_node(element.node_id, selector)
end

local function find_element_by_xpath(element: Element, query: string): Element?
	element.parent:get_document()

	local search =
		element.parent:call_method(DOM.PerformSearch, { query = query, include_user_agent_shadow_dom = true })
	if search.result_count <= 0 then
		return nil
	end

	local results = element.parent:call_method(DOM.GetSearchResults, {
		search_id = search.search_id,
		from_index = 0,
		to_index = search.result_count,
	})

	local node_id = results.node_ids[1]
	return create(element.parent, node_id)
end

local function find_elements(element: Element, selector: string): { Element }
	return element.parent:run_query_selector_all_on_node(element.node_id, selector)
end

local function find_elements_by_xpath(element: Element, query: string): { Element }
	element.parent:get_document()

	local search =
		element.parent:call_method(DOM.PerformSearch, { query = query, include_user_agent_shadow_dom = true })
	if search.result_count <= 0 then
		return {}
	end

	local results = element.parent:call_method(DOM.GetSearchResults, {
		search_id = search.search_id,
		from_index = 0,
		to_index = search.result_count,
	})

	local node_ids = results.node_ids
	local elements = {}

	for _, node_id in node_ids do
		local e = create(element.parent, node_id)
		if e then
			table.insert(elements, element)
		end
	end

	return elements
end

local function wait_for_element(element: Element, selector: string, timeout: number?): Element?
	local duration = timeout or DEFAULT_TIMEOUT
	return polling.with_timeout(duration):pause_until(function()
		return element:find_element(selector)
	end)
end

local function wait_for_xpath(element: Element, selector: string, timeout: number?): Element?
	local duration = timeout or DEFAULT_TIMEOUT
	return polling.with_timeout(duration):pause_until(function()
		return element:find_element_by_xpath(selector)
	end)
end

local function wait_for_elements(element: Element, selector: string, timeout: number?): { Element }
	local duration = timeout or DEFAULT_TIMEOUT
	return polling.with_timeout(duration):pause_until(function()
		local elements = element:find_elements(selector)
		return #elements > 0 and elements
	end) or {}
end

local function wait_for_elements_by_xpath(element: Element, selector: string, timeout: number?): { Element }
	local duration = timeout or DEFAULT_TIMEOUT
	return polling.with_timeout(duration):pause_until(function()
		local elements = element:find_elements_by_xpath(selector)
		return #elements > 0 and elements
	end) or {}
end

local function call_js_fn(
	element: Element,
	fn_declaration: string,
	args: { string }?,
	await_promise: boolean?
): Runtime.RemoteObject
	local call_args: { Runtime.CallArgument }

	if args then
		call_args = {}
		for index, arg in args do
			call_args[index] = { value = arg }
		end
	end

	return element.parent:call_method(Runtime.CallFunctionOn, {
		object_id = element.remote_object_id,
		function_declaration = fn_declaration,
		arguments = call_args,
		return_by_value = false,
		generate_preview = true,
		silent = false,
		await_promise = await_promise,
	}).result
end

local function get_midpoint(element: Element): vector
	local quads = element.parent:call_method(DOM.GetContentQuads, { backend_node_id = element.backend_node_id }).quads

	local raw_quad = quads[1]
	if raw_quad then
		local input_quad = element_quad.from_raw_points(raw_quad)
		return vector.create(
			(input_quad.bottom_right.x + input_quad.top_left.x) / 2,
			(input_quad.bottom_right.y + input_quad.top_left.y) / 2
		)
	end

	local midpoint = polling.with_timeout(20):pause_until(function()
		local result = element:call_js_fn([[
			function() {
                let rect = this.getBoundingClientRect();

                if(rect.x != 0) {
                    this.scrollIntoView();
                }

                return this.getBoundingClientRect();
            }
		]])

		local midpoint = extract_midpoint(result)
		if midpoint.x == 0 then
			return nil
		end

		return midpoint
	end)

	if not midpoint then
		error("Failed to get element midpoint")
	end
	return midpoint
end

local function get_box_model(element: Element): box_model.BoxModel
	local model = element.parent:call_method(DOM.GetBoxModel, { backend_node_id = element.backend_node_id }).model
	return box_model.create({
		content = element_quad.from_raw_points(model.content),
		padding = element_quad.from_raw_points(model.padding),
		border = element_quad.from_raw_points(model.border),
		margin = element_quad.from_raw_points(model.margin),
		width = model.width,
		height = model.height,
	})
end

local function scroll_into_view(element: Element): Element
	local result = element:call_js_fn(
		[[
			async function() {
            	if (!this.isConnected) return "Node is detached from document";
            	if (this.nodeType !== Node.ELEMENT_NODE) return "Node is not of type HTMLElement";

            	const visibleRatio = await new Promise(resolve => {
                	const observer = new IntersectionObserver(entries => {
                    	resolve(entries[0].intersectionRatio);
                    	observer.disconnect();
                	});
                	observer.observe(this);
            	});

            	if (visibleRatio !== 1.0)
                	this.scrollIntoView({
                    	block: "center",
                    	inline: "center",
                    	behavior: "instant",
                	});
			
            	return false;
        	}
	]],
		nil,
		true
	)

	if result.type == "string" then
		error(result.value)
	end

	return element
end

local function move_mouse_over(element: Element): Element
	element:scroll_into_view()
	local midpoint = element:get_midpoint()
	element.parent:move_mouse_to_point(midpoint)
	return element
end

local function click(element: Element): Element
	element:scroll_into_view()
	local midpoint = element:get_midpoint()
	element.parent:click_point(midpoint)
	return element
end

local function type_into(element: Element, text: string): Element
	element:click()
	element.parent:type_text(text)
	return element
end

local function focus(element: Element): Element
	element:scroll_into_view()
	element.parent:call_method(DOM.Focus, { backend_node_id = element.backend_node_id })
	return element
end

local function capture_screenshot(
	element: Element,
	options: {
		format: "jpeg" | "png" | "webp"?,
		quality: number?,
		from_surface: boolean?,
		optimize_for_speed: boolean?,
	}
): buffer
	element:scroll_into_view()
	return element.parent:capture_screenshot({
		format = options.format,
		quality = options.quality,
		clip = element:get_box_model():content_viewport(),
		from_surface = options.from_surface,
		optimize_for_speed = options.optimize_for_speed,
	})
end

--- Using a "node_id", of the type returned by QuerySelector and QuerySelectorAll, this finds
--- the "backend_node_id" and "remote_object_id" which are stable identifiers, unlike node_id.
--- We use these two when making various calls to the API because of that.
--- @within Element
function create(parent: types.Tab, node_id: DOM.NodeId): Element?
	if node_id == 0 then
		return nil
	end

	local node = parent:call_method(DOM.DescribeNode, { node_id = node_id, depth = 100 }).node

	local attributes = node.attributes
	local tag = node.node_name

	local backend_node_id = node.backend_node_id

	local object = parent:call_method(DOM.ResolveNode, { backend_node_id = backend_node_id }).object

	local value = tostring(object.value)
	local remote_object_id = object.object_id

	if not remote_object_id then
		error("Could not find object ID")
	end

	return {
		remote_object_id = remote_object_id,
		backend_node_id = backend_node_id,
		node_id = node_id,
		parent = parent,
		attributes = attributes,
		tag = tag,
		value = value,
		get_description = get_description,
		get_attributes = get_attributes,
		get_attribute_value = get_attribute_value,
		get_inner_text = get_inner_text,
		get_content = get_content,
		find_element = find_element,
		find_element_by_xpath = find_element_by_xpath,
		find_elements = find_elements,
		find_elements_by_xpath = find_elements_by_xpath,
		wait_for_element = wait_for_element :: any,
		wait_for_xpath = wait_for_xpath :: any,
		wait_for_elements = wait_for_elements,
		wait_for_elements_by_xpath = wait_for_elements_by_xpath,
		call_js_fn = call_js_fn,
		get_midpoint = get_midpoint,
		get_box_model = get_box_model,
		scroll_into_view = scroll_into_view,
		move_mouse_over = move_mouse_over,
		click = click,
		type_into = type_into,
		focus = focus,
		capture_screenshot = capture_screenshot,
	}
end

return { create = create }

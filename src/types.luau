local transport = require("./transport")
local dialog = require("./tab/dialog")
local keys = require("./tab/keys")
local Target = require("./protocol/target")
local Page = require("./protocol/page")
local Browser = require("./protocol/browser")
local Runtime = require("./protocol/runtime")
local Network = require("./protocol/network")
local DOM = require("./protocol/dom")
local Log = require("./protocol/log")
local Profiler = require("./protocol/profiler")
local Fetch = require("./protocol/fetch")

--[=[
	A handle to an instance of Chrome / Chromium, which wraps a WebSocket connection to its debugging port.

	Most of your actual "driving" (e.g. clicking, typing, navigating) will be via instances of [Tab](../api/Tab), which are accessible via methods such as `get_tabs`.

	A Browser can either manage its own Chrome process or connect to a remote one.

	`browser.create` will return a headless instance of whatever browser can be found using
	`default_executable`, which will search on your PATH for relevant binaries or use the path
	specified in the `CHROME` env var.

	@class Browser
]=]
export type Browser = {
	transport: transport.Transport,
	tabs: { Tab },
	on_close_hooks: { () -> () },

	--- @within Browser
	get_tabs: (self: Browser) -> { Tab },

	--- Call a browser method.
	--- @within Browser
	call_method: <Request, Response>(
		self: Browser,
		method: string & { __Request: Request, __Response: Response },
		params: Request
	) -> Response,

	--- Adds event listener to `event`
	--- @within Browser
	add_event_listener: <Parameters>(
		self: Browser,
		event: string & { __Parameters: Parameters },
		callback: (params: Parameters) -> ()
	) -> () -> (),

	--- Get version information
	--- @within Browser
	get_version: (
		self: Browser
	) -> {
		protocol_version: string,
		product: string,
		revision: string,
		user_agent: string,
		js_version: string,
	},

	--- Create a new tab and return a handle to it.
	--- @within Browser
	create_tab: (
		self: Browser,
		options: {
			url: string,
			width: number?,
			height: number?,
			browser_context_id: Browser.BrowserContextID?,
			enable_begin_frame_control: boolean?,
			new_window: boolean?,
			background: boolean?,
			for_tab: boolean?,
		}?
	) -> Tab,

	--- Creates the equivalent of a new incognito window, AKA a browser context
	--- @within Browser
	create_context: (self: Browser) -> Context,

	--- Adds tabs that have not been opened with `new_tab` to the list of tabs
	--- @within Browser
	register_missing_tabs: (self: Browser) -> (),

	--- Closes the browser.
	--- @within Browser
	close: (self: Browser) -> (),
}

--- Equivalent to a new incognito window
--- @class Context
export type Context = {
	id: string,
	browser: Browser,

	--- The BrowserContextId associated with this context
	--- @within Context
	get_id: (self: Context) -> string,

	--- Any tabs created in this context
	--- @within Context
	get_tabs: (self: Context) -> { Tab },

	--- Opens a new tab in this context. It will not share cookies or a cache with the default
	--- browsing context or any other contexts created
	--- @within Context
	create_tab: (self: Context) -> Tab,
}

--- A handle to a single page. Exposes methods for simulating user actions (clicking,
--- typing), and also for getting information about the DOM and other parts of the page.
--- @class Tab
export type Tab = {
	target_id: string,
	transport: transport.Transport,
	session_id: string,
	navigating: boolean,
	target_info: Target.TargetInfo,
	request_interceptor: RequestInterceptor?,
	response_handler: { [string]: ResponseHandler },
	loading_failed_handler: { [string]: LoadingFailedHandler },
	auth_handler: Fetch.AuthChallengeResponse?,
	default_timeout: number,
	page_bindings: { [string]: (data: any) -> () },
	slow_motion_multiplier: number,

	--- @within Tab
	get_target_id: (self: Tab) -> string,

	--- @within Tab
	update_target_info: (self: Tab, target_info: Target.TargetInfo) -> (),

	--- @within Tab
	get_url: (self: Tab) -> string,

	--- Set default timeout for the tab
	--- This will be applied to all `wait_for_element` and `wait_for_elements` calls without a timeout for this tab
	--- @within Tab
	set_default_timeout: (self: Tab, timeout: number) -> Tab,

	--[=[
		Analogous to Puppeteer's ['slowMo' option](https://github.com/GoogleChrome/puppeteer/blob/v1.20.0/docs/api.md#puppeteerconnectoptions),
		but with some differences:

		* It doesn't add a delay after literally every message sent via the protocol, but instead
		just for:
			* clicking a specific point on the page (default: 100ms before moving the mouse, 250ms
			before pressing and releasting mouse button)
			* pressing a key (default: 25 ms)
			* reloading the page (default: 100ms)
			* closing a tab (default: 100ms)
		* Instead of an absolute number of milliseconds, it's a multiplier, so that we can delay
		longer on certain actions like clicking or moving the mouse, and shorter on others like
		on pressing a key (or the individual 'mouseDown' and 'mouseUp' actions that go across the
		wire. If the delay was always the same, filling out a form (e.g.) would take ages).

		By default the multiplier is set to zero, which effectively disables the slow motion.

		The defaults for the various actions (i.e. how long we sleep for when
		multiplier is 1.0) are supposed to be just slow enough to help a human see what's going on
		as a test runs.

		@within Tab
	]=]
	set_slow_motion_multiplier: (self: Tab, multiplier: number) -> Tab,

	--- Call a target method.
	--- @within Tab
	call_method: <Request, Response>(
		self: Tab,
		method: string & { __Request: Request, __Response: Response },
		params: Request
	) -> Response,

	--- Adds event listener to `event`
	--- @within Tab
	add_event_listener: <Parameters>(
		self: Tab,
		event: string & { __Parameters: Parameters },
		callback: (params: Parameters) -> ()
	) -> () -> (),

	--- Fetches the most recent info about this target
	--- @within Tab
	get_target_info: (self: Tab) -> Target.TargetInfo,

	--- @within Tab
	get_browser_context_id: (self: Tab) -> string?,

	--- Allows overriding user agent with the given string.
	--- @within Tab
	set_user_agent: (self: Tab, userAgent: string, acceptLanguage: string?, platform: string?) -> (),

	--- @within Tab
	set_extra_http_headers: (self: Tab, headers: { [string]: string }) -> (),

	--- If enabled, instead of using the GUI to select files, the browser will
	--- wait for the `handle_file_chooser` method to be called.
	--- \**WARNING**: Only works on Chromium / Chrome 77 and above.
	--- @within Tab
	set_file_chooser_dialog_interception: (self: Tab, enabled: boolean) -> (),

	--[=[
		Will have the same effect as choosing these files from the file chooser dialog that would've
		popped up had `set_file_chooser_dialog_interception` not been called. Calls to this method
		must be preceded by calls to that method.

		Supports selecting files or closing the file chooser dialog.

		NOTE: the filepaths listed in `files` must be absolute.

		@within Tab
	]=]
	handle_file_chooser: (self: Tab, files: { string }, node_id: DOM.NodeId) -> (),

	--- Pulls focus to this tab
	--- @within Tab
	bring_to_front: (self: Tab) -> (),

	--[=[
		Reloads given page optionally ignoring the cache

		If `ignore_cache` is true, the browser cache is ignored (as if the user pressed Shift+F5).  
		If `script_to_evaluate` is given, the script will be injected into all frames of the
		inspected page after reload. Argument will be ignored if reloading dataURL origin.

		@within Tab
	]=]
	reload: (self: Tab, ignore_cache: boolean?, script_to_evaluate_on_load: string?) -> Tab,

	--- @within Tab
	stop_loading: (self: Tab) -> (),

	--- @within Tab
	navigate_to: (self: Tab, url: string) -> Tab,

	--- @within Tab
	wait_until_navigated: (self: Tab) -> Tab,

	--[=[
		Get position and size of the browser window associated with this `Tab`.

		Note that the returned bounds are always specified for normal (windowed)
		state; they do not change when minimizing, maximizing or setting to
		fullscreen.

		@within Tab
	]=]
	get_bounds: (self: Tab) -> Browser.Bounds,

	--[=[
		Set position and/or size of the browser window associated with this `Tab`.

		When setting the window to normal (windowed) state, unspecified fields
		are left unchanged.

		@within Tab
	]=]
	set_bounds: (self: Tab, bounds: Browser.Bounds) -> Tab,

	--- Set the background color of the dom to transparent.
	--- Useful when you want capture a .png
	--- @within Tab
	set_transparent_background_color: (self: Tab) -> Tab,

	--- Set the default background color of the dom.
	--- Pass a RGBA to override the backrgound color of the dom.
	--- @within Tab
	set_background_color: (self: Tab, color: DOM.RGBA) -> Tab,

	--- Evaluates expression on global object.
	--- @within Tab
	evaluate: (self: Tab, expression: string, await_promise: boolean?) -> Runtime.RemoteObject,

	--- Returns the title of the document.
	--- @within Tab
	get_title: (self: Tab) -> string,

	--- Set cookies with tab's current URL
	--- @within Tab
	set_cookies: (self: Tab, cookies: { Network.CookieParam }) -> (),

	--- Returns all cookies that match the tab's current URL.
	--- @within Tab
	get_cookies: (self: Tab) -> { Network.Cookie },

	--- Delete cookies with tab's current URL
	--- @within Tab
	delete_cookies: (
		self: Tab,
		cookies: {
			{
				name: string,
				url: string?,
				domain: string?,
				path: string?,
				partition_key: Network.CookiePartitionKey?,
			}
		}
	) -> (),

	--- @within Tab
	set_storage: (self: Tab, name: string, item: any) -> (),

	--- @within Tab
	get_storage: (self: Tab, name: string) -> any?,

	--- @within Tab
	remove_storage: (self: Tab, name: string) -> (),

	--[=[
		Capture a screenshot of the current page.

		If `clip` is given, the screenshot is taken of the specified region only.
		`Element.get_box_model` can be used to get regions of certains elements on the page; there is
		also `Element.capture_screenshot` as a shorthand.

		If `from_surface` is true, the screenshot is taken from the surface rather than the view.

		@within Tab
	]=]
	capture_screenshot: (
		self: Tab,
		options: {
			format: "jpeg" | "png" | "webp"?,
			quality: number?,
			clip: Page.Viewport?,
			from_surface: boolean?,
			capture_beyond_viewport: boolean?,
			optimize_for_speed: boolean?,
		}
	) -> buffer,

	--- @within Tab
	print_to_pdf: (
		self: Tab,
		options: {
			landscape: boolean?,
			display_header_footer: boolean?,
			print_background: boolean?,
			scale: number?,
			paper_width: number?,
			paper_height: number?,
			margin_top: number?,
			margin_bottom: number?,
			margin_left: number?,
			margin_right: number?,
			page_ranges: string?,
			header_template: string?,
			footer_template: string?,
			prefer_css_page_size: boolean?,
			generate_tagged_pdf: boolean?,
			generate_document_outline: boolean?,
		}?
	) -> buffer,

	--- @within Tab
	start_screencast: (
		self: Tab,
		options: {
			format: "jpeg" | "png"?,
			quality: number?,
			max_width: number?,
			max_height: number?,
			every_nth_frame: number?,
		}
	) -> (),

	--- @within Tab
	stop_screencast: (self: Tab) -> (),

	--- @within Tab
	ack_screencast: (self: Tab, session_id: number) -> (),

	--- Get the handle of the dialog opened in this tab.
	--- @within Tab
	get_dialog: (self: Tab) -> dialog.Dialog,

	--- @within Tab
	get_document: (self: Tab) -> DOM.Node,

	--- Get the full HTML contents of the page.
	--- @within Tab
	get_content: (self: Tab) -> string,

	--- @within Tab
	describe_node: (self: Tab, node_id: DOM.NodeId) -> DOM.Node,

	--- @within Tab
	run_query_selector_on_node: (self: Tab, node_id: DOM.NodeId, selector: string) -> Element?,

	--- @within Tab
	run_query_selector_all_on_node: (self: Tab, node_id: DOM.NodeId, selector: string) -> { Element },

	--- Returns the first element in the document which matches the given selector.
	--- Equivalent to the following JS:
	--- ```js
	--- document.querySelector(selector)
	--- ```
	--- @within Tab
	find_element: (self: Tab, selector: string) -> Element?,

	--- @within Tab
	find_element_by_xpath: (self: Tab, selector: string) -> Element?,

	--- @within Tab
	find_elements: (self: Tab, selector: string) -> { Element },

	--- @within Tab
	find_elements_by_xpath: (self: Tab, selector: string) -> { Element },

	--- @within Tab
	wait_for_element: ((self: Tab, selector: string) -> Element)
		& ((self: Tab, selector: string, timeout: number) -> Element?),

	--- @within Tab
	wait_for_xpath: ((self: Tab, selector: string) -> Element)
		& ((self: Tab, selector: string, timeout: number) -> Element?),

	--- @within Tab
	wait_for_elements: (self: Tab, selector: string, timeout: number?) -> { Element },

	--- @within Tab
	wait_for_elements_by_xpath: (self: Tab, selector: string, timeout: number?) -> { Element },

	--- Moves the mouse to this point (dispatches a mouseMoved event)
	--- @within Tab
	move_mouse_to_point: (self: Tab, point: vector) -> Tab,

	--- @within Tab
	click_point: (self: Tab, point: vector) -> Tab,

	--- Does the same as `type_text` but it only dispatches a `keypress` and `input` event.
	--- It does not send a `keydown` or `keyup` event. What this means is that it is much faster.
	--- It is especially useful when you have a lot of text as input.
	--- @within Tab
	insert_text: (self: Tab, text: string) -> Tab,

	--- @within Tab
	type_text: (self: Tab, text: string) -> Tab,

	--- Press a key on the keyboard, optionally with some modifier keys.
	--- See [this file](https://github.com/puppeteer/puppeteer/blob/62da2366c65b335751896afbb0206f23c61436f1/lib/USKeyboardLayout.js)
	--- for a full definition of which strings correspond with which keys.
	--- @within Tab
	press_key_with_modifiers: (self: Tab, key: keys.Key, modifiers: { "Alt" | "Ctrl" | "Meta" | "Shift" }?) -> Tab,

	--- Press a key on the keyboard. See [this file](https://github.com/puppeteer/puppeteer/blob/62da2366c65b335751896afbb0206f23c61436f1/lib/USKeyboardLayout.js)
	--- for a full definition of which strings correspond with which keys.
	--- @within Tab
	press_key: (self: Tab, key: keys.Key) -> Tab,

	--- Enables log domain.
	--- Sends the entries collected so far to the client by means of the entryAdded notification.
	--- See <https://chromedevtools.github.io/devtools-protocol/tot/Log#method-enable>.
	--- @within Tab
	enable_log: (self: Tab) -> Tab,

	--- Disables log domain.
	--- Prevents further log entries from being reported to the client.
	--- See <https://chromedevtools.github.io/devtools-protocol/tot/Log#method-disable>.
	--- @within Tab
	disable_log: (self: Tab) -> Tab,

	--- Starts violation reporting.
	--- See <https://chromedevtools.github.io/devtools-protocol/tot/Log#method-startViolationsReport>.
	--- @within Tab
	start_violations_report: (self: Tab, config: { Log.ViolationSetting }) -> Tab,

	--- Stops violation reporting.
	--- See <https://chromedevtools.github.io/devtools-protocol/tot/Log#method-stopViolationsReport>.
	--- @within Tab
	stop_violations_report: (self: Tab) -> Tab,

	--- Enables runtime domain.
	--- @within Tab
	enable_runtime: (self: Tab) -> Tab,

	--- Disables runtime domain.
	--- @within Tab
	disable_runtime: (self: Tab) -> Tab,

	--- Enables debugger domain.
	--- @within Tab
	enable_debugger: (self: Tab) -> Tab,

	--- Disables debugger domain.
	--- @within Tab
	disable_debugger: (self: Tab) -> Tab,

	--- Returns source for the script with given id.
	--- Debugger domain must be enabled.
	--- @within Tab
	get_script_source: (self: Tab, script_id: string) -> string,

	--- Enables the profiler domain.
	--- @within Tab
	enable_profiler: (self: Tab) -> Tab,

	--- Disables the profiler domain.
	--- @within Tab
	disable_profiler: (self: Tab) -> Tab,

	--[=[
		Starts tracking which lines of JS have been executed

		Will error unless `enable_profiler` has been called.

		Equivalent to hitting the record button in the "coverage" tab in Chrome DevTools.

		By default we enable the 'detailed' flag on StartPreciseCoverage, which enables block-level
		granularity, and also enable 'call_count' (which when disabled always sets count to 1 or 0).

		@within Tab
	]=]
	start_js_coverage: (self: Tab) -> Tab,

	--- Stops tracking which lines of JS have been executed.
	--- If you're finished with the profiler, don't forget to call `disable_profiler`.
	--- @within Tab
	stop_js_coverage: (self: Tab) -> Tab,

	--[=[
		Collect coverage data for the current isolate, and resets execution counters.

		Precise code coverage needs to have started (see `start_js_coverage`).

		Will only send information about code that's been executed since this method was last
		called, or (if this is the first time) since calling `start_js_coverage`.
		Another way of thinking about it is: every time you call this, the call counts for
		FunctionRanges are reset after returning.

		The format of the data is a little unintuitive, see here for details:
		<https://chromedevtools.github.io/devtools-protocol/tot/Profiler#type-ScriptCoverage>

		@within Tab
	]=]
	take_js_coverage: (self: Tab) -> { Profiler.ScriptCoverage },

	--- Enables fetch domain.
	--- @within Tab
	enable_fetch: (self: Tab, patterns: { Fetch.RequestPattern }?, handle_auth_requests: boolean?) -> Tab,

	--- Disables fetch domain.
	--- @within Tab
	disable_fetch: (self: Tab) -> Tab,

	--[=[
		Allows you to inspect outgoing network requests from the tab, and optionally return
		your own responses to them

		The `interceptor` argument is a closure which takes this tab's `Transport` and its SessionID
		so that you can call methods from within the closure using `transport.call_method_on_target`.

		The closure needs to return { action: "Fulfill" | "Fail" | "Continue", ... }.

		@within Tab
	]=]
	enable_request_interception: (self: Tab, interceptor: RequestInterceptor) -> (),

	--- @within Tab
	authenticate: (self: Tab, username: string, password: string?) -> Tab,

	--[=[
		Lets you register a listener for responses, and gives you a way to get the response body too.

    	Please note that the 'response' does not include the *body* of the response -- Chrome tells
    	us about them separately (because you might quickly get the status code and headers from a
    	server well before you receive the entire response body which could, after all, be gigabytes
    	long).

    	Currently we leave it up to the caller to decide when to call `fetch_body` (the second
    	argument to the response handler), although ideally it wouldn't be possible until Chrome has
    	sent the `Network.loadingFinished` event.

    	a option for ResponseHandler for existing handler with same name if existed.

		@within Tab
	]=]
	register_response_handling: (self: Tab, handler_name: string, handler: ResponseHandler) -> (),

	--- @within Tab
	register_loading_failed_handling: (self: Tab, handler_name: string, handler: LoadingFailedHandler) -> (),

	--[=[
		Deregister a response handler based on its name.

		Return a option for ResponseHandler for removed handler if existed.

		@within Tab
	]=]
	deregister_response_handling: (self: Tab, handler_name: string) -> (),

	--- Deregister all registered handlers.
	--- @within Tab
	deregister_response_handling_all: (self: Tab) -> (),

	--- @within Tab
	expose_fn: (self: Tab, name: string, fn: (data: any) -> ()) -> (),

	--- @within Tab
	remove_fn: (self: Tab, name: string) -> (),

	--- @within Tab
	enable_stealth_mode: (self: Tab) -> (),

	--- Closes the target Page
	--- @within Tab
	close: (self: Tab) -> (),
}

export type ResponseHandler = (
	response: {
		request_id: Network.RequestId,
		loader_id: Network.LoaderId,
		timestamp: Network.MonotonicTime,
		type: Network.ResourceType,
		response: Network.Response,
		has_extra_info: boolean,
		frame_id: Page.FrameId?,
	},
	fetch_body: () -> { body: string, base64_encoded: boolean }
) -> ()

export type LoadingFailedHandler = (
	response: {
		request_id: Network.RequestId,
		loader_id: Network.LoaderId,
		timestamp: Network.MonotonicTime,
		type: Network.ResourceType,
		response: Network.Response,
		has_extra_info: boolean,
		frame_id: Page.FrameId?,
	},
	params: {
		request_id: Network.RequestId,
		timestamp: Network.MonotonicTime,
		type: Network.ResourceType,
		error_text: string,
		canceled: boolean?,
		blocked_reason: Network.BlockedReason?,
		cors_error_status: Network.CorsErrorStatus?,
	}
) -> ()

export type RequestInterceptor = (
	transport: transport.Transport,
	session_id: string,
	params: {
		request_id: Fetch.RequestId,
		request: Network.Request,
		frame_id: Page.FrameId,
		resource_type: Network.ResourceType,
		response_error_reason: Network.ErrorReason?,
		response_status_code: number?,
		response_status_text: string?,
		response_headers: { Fetch.HeaderEntry }?,
		network_id: Network.RequestId?,
		redirected_request_id: Fetch.RequestId?,
	}
) -> {
	action: "Fulfill",
	request_id: Fetch.RequestId,
	response_code: number,
	response_headers: { Fetch.HeaderEntry }?,
	binary_response_headers: string?,
	body: string?,
	response_phrase: string?,
} | {
	action: "Fail",
	request_id: Fetch.RequestId,
	error_reason: Network.ErrorReason,
} | {
	action: "Continue",
} | {
	action: "Continue",
	request_id: Fetch.RequestId,
	url: string?,
	method: string?,
	post_data: string?,
	headers: { Fetch.HeaderEntry }?,
	intercept_reason: boolean?,
}

--[=[
	A handle to a [DOM Element](https://developer.mozilla.org/en-US/docs/Web/API/Element).

	Typically you get access to these by passing `Tab.wait_for_element` a CSS selector. Once
	you have a handle to an element, you can click it, type into it, inspect its
	attributes, and more. You can even run a JavaScript function inside the tab which can reference
	the element via `this`.

	@class Element
]=]
export type Element = {
	--- @prop remote_object_id string
	--- @within Element
	remote_object_id: string,

	--- @prop backend_node_id DOM.NodeId
	--- @within Element
	backend_node_id: DOM.BackendNodeId,

	--- @prop node_id DOM.NodeId
	--- @within Element
	node_id: DOM.NodeId,

	--- @prop parent Tab
	--- @within Element
	parent: Tab,

	--- @prop attributes { string }?
	--- @within Element
	attributes: { string }?,

	--- @prop tag string
	--- @within Element
	tag: string,

	--- @prop value string
	--- @within Element
	value: string,

	--- @within Element
	get_description: (self: Element) -> DOM.Node,

	--- @within Element
	get_attributes: (self: Element) -> { string }?,

	--- @within Element
	get_attribute_value: (self: Element, name: string) -> string?,

	--[=[
		Returns the inner text of an HTML Element. Returns an empty string on elements with no text.

		Note: .innerText and .textContent are not the same thing. See:
		<https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/innerText>

		Note: if you somehow call this on a node that's not an HTML Element (e.g. `document`), this
		will fail.

		@within Element
	]=]
	get_inner_text: (self: Element) -> string,

	--- Get the full HTML contents of the element.
	--- Equivalent to the following JS: ```element.outerHTML```.
	--- @within Element
	get_content: (self: Element) -> string,

	--- @within Element
	find_element: (self: Element, selector: string) -> Element?,

	--- @within Element
	find_element_by_xpath: (self: Element, selector: string) -> Element?,

	--- @within Element
	find_elements: (self: Element, selector: string) -> { Element },

	--- @within Element
	find_elements_by_xpath: (self: Element, selector: string) -> { Element },

	--- @within Element
	wait_for_element: ((self: Element, selector: string) -> Element)
		& ((self: Element, selector: string, timeout: number) -> Element?),

	--- @within Element
	wait_for_xpath: ((self: Element, selector: string) -> Element)
		& ((self: Element, selector: string, timeout: number) -> Element?),

	--- @within Element
	wait_for_elements: (self: Element, selector: string, timeout: number?) -> { Element },

	--- @within Element
	wait_for_elements_by_xpath: (self: Element, selector: string, timeout: number?) -> { Element },

	--- @within Element
	call_js_fn: (
		self: Element,
		fn_declaration: string,
		args: { string }?,
		await_promise: boolean?
	) -> Runtime.RemoteObject,

	--- @within Element
	get_midpoint: (self: Element) -> vector,

	--- Get boxes for this element
	--- @within Element
	get_box_model: (self: Element) -> BoxModel,

	--- Scrolls the current element into view
	--- Used prior to any action applied to the current element to ensure action is duable.
	--- @within Element
	scroll_into_view: (self: Element) -> Element,

	--- Moves the mouse to the middle of this element
	--- @within Element
	move_mouse_over: (self: Element) -> Element,

	--- @within Element
	click: (self: Element) -> Element,

	--- @within Element
	type_into: (self: Element, text: string) -> Element,

	--- @within Element
	focus: (self: Element) -> Element,

	--- Capture a screenshot of this element.
	--- The screenshot is taken from the surface using this element's content-box.
	--- @within Element
	capture_screenshot: (
		self: Element,
		options: {
			format: "jpeg" | "png" | "webp"?,
			quality: number?,
			from_surface: boolean?,
			optimize_for_speed: boolean?,
		}
	) -> buffer,
}

--- @class ElementQuad
export type ElementQuad = {
	top_left: vector,
	top_right: vector,
	bottom_right: vector,
	bottom_left: vector,

	--- @within ElementQuad
	height: (self: ElementQuad) -> number,

	--- @within ElementQuad
	width: (self: ElementQuad) -> number,

	--- The width divided by the height
	--- @within ElementQuad
	aspect_ratio: (self: ElementQuad) -> number,

	--- The most left (smallest) x-coordinate
	--- @within ElementQuad
	most_left: (self: ElementQuad) -> number,

	--- The most right (largest) x-coordinate
	--- @within ElementQuad
	most_right: (self: ElementQuad) -> number,

	--- The most top (smallest) y-coordinate
	--- @within ElementQuad
	most_top: (self: ElementQuad) -> number,

	--- The most bottom (largest) y-coordinate
	--- @within ElementQuad
	most_bottom: (self: ElementQuad) -> number,

	--- If the most bottom point of `self` is above the most top point of `other`
	--- @within ElementQuad
	strictly_above: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most bottom point of `self` is above or on the same line as the
	--- most top point of `other`
	--- @within ElementQuad
	above: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most top point of `self` is below the most bottom point of `other`
	--- @within ElementQuad
	strictly_below: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most top point of `self` is below or on the same line as the
	--- most bottom point of `other`
	--- @within ElementQuad
	below: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most right point of `self` is left of the most left point of `other`
	--- @within ElementQuad
	strictly_left_of: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most right point of `self` is left or on the same line as the
	--- most left point of `other`
	--- @within ElementQuad
	left_of: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most left point of `self` is right of the most right point of `other`
	--- @within ElementQuad
	strictly_right_of: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If the most left point of `self` is right or on the same line as the
	--- most right point of `other`
	--- @within ElementQuad
	right_of: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If `self` is within the left/right boundaries defined by `other`.
	--- @within ElementQuad
	within_horizontal_bounds_of: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If `self` is within the top/bottom boundaries defined by `other`.
	--- @within ElementQuad
	within_vertical_bounds_of: (self: ElementQuad, other: ElementQuad) -> boolean,

	--- If `self` is within the boundaries defined by `other`.
	--- @within ElementQuad
	within_bounds_of: (self: ElementQuad, other: ElementQuad) -> boolean,
}

--- @class BoxModel
export type BoxModel = {
	content: ElementQuad,
	padding: ElementQuad,
	border: ElementQuad,
	margin: ElementQuad,
	width: number,
	height: number,

	--- Create a `Page.Viewport` equal to the content-box, using a scale of 1.0
	--- @within BoxModel
	content_viewport: (self: BoxModel) -> Page.Viewport,

	--- Create a `Page.Viewport` equal to the padding-box, using a scale of 1.0
	--- @within BoxModel
	padding_viewport: (self: BoxModel) -> Page.Viewport,

	--- Create a `Page.Viewport` equal to the border-box, using a scale of 1.0
	--- @within BoxModel
	border_viewport: (self: BoxModel) -> Page.Viewport,

	--- Create a `Page.Viewport` equal to the margin-box, using a scale of 1.0
	--- @within BoxModel
	margin_viewport: (self: BoxModel) -> Page.Viewport,
}

return nil

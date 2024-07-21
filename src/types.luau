local Future = require("./packages/future")
local Browser = require("./protocol/Browser")
local Target = require("./protocol/Target")
local Network = require("./protocol/Network")
local DOM = require("./protocol/DOM")
local Runtime = require("./protocol/Runtime")
local Page = require("./protocol/Page")

export type Future<T> = Future.Future<T>

export type ProtocolInfo<ExtraInfo = {}> = ExtraInfo & {
	webSocketDebuggerUrl: string,
}

export type BridgeProtocolRequest = {
	id: number,
	method: string,
	params: { [string]: any }?,
}

export type BridgeProtocolResponse = {
	id: number,
	result: { [string]: any }?,
}

export type BridgeProtocolEvent = {
	method: string,
	params: { [string]: any }?,
}

export type Bridge = {
	sendOverProtocol: (Bridge, method: string, parameters: { [string]: any }?) -> Future<{ [string]: any }?>,
	subscribeToEvent: (Browser, event: string, callback: (result: { [string]: any }?) -> ()) -> () -> (),
	destroy: (Bridge) -> (),
}

export type BrowserVersion = {
	jsVersion: string,
	product: string,
	protocolVersion: string,
	revision: string,
	userAgent: string,
}

export type Browser = {
	sendOverProtocol: (Browser, method: string, parameters: { [string]: any }?) -> Future<{ [string]: any }?>,
	getVersion: (Browser) -> Future<BrowserVersion>,
	newTab: (Browser) -> Future<Tab>,
	close: (Browser) -> Future<nil>,
}

export type BrowserLaunchOptions = {
	headless: boolean,
	sandbox: boolean,
	enableGpu: boolean,
	enableLogging: boolean,
	windowSize: { width: number, height: number },
	port: number,
	ignoreCertificateErrors: boolean,
	path: string,
	userDataDirectory: string,
	extensions: { string },
	args: { string },
	disableDefaultArgs: boolean,
	idleBrowserTimeout: number,
	processEnvs: { [string]: string },
	proxyServer: string,
}

-- type functions when?
export type PartialBrowserLaunchOptions = {
	headless: boolean?,
	sandbox: boolean?,
	enableGpu: boolean?,
	enableLogging: boolean?,
	windowSize: { width: number, height: number }?,
	port: number?,
	ignoreCertificateErrors: boolean?,
	path: string?,
	userDataDirectory: string?,
	extensions: { string }?,
	args: { string }?,
	disableDefaultArgs: boolean?,
	idleBrowserTimeout: number?,
	processEnvs: { [string]: string }?,
	proxyServer: string?,
}

export type Tab = {
	sendOverProtocol: (Tab, method: string, parameters: { [string]: any }?) -> Future<{ [string]: any }?>,
	getTargetId: (Tab) -> Future<string>,
	getTargetInfo: (Tab) -> Future<Target.TargetInfo>,
	getUrl: (Tab) -> Future<string>,
	getTitle: (Tab) -> Future<string>,
	navigateTo: (Tab, url: string) -> Future<Tab>,
	reload: (Tab, ignoreCache: boolean?, scriptToEvaluateOnLoad: string?) -> Future<nil>,
	getCookies: (Tab) -> Future<{ Network.Cookie }>,
	setCookies: (Tab, cookies: { Network.CookieParam }) -> Future<nil>,
	sendCharacters: (Tab, characters: string) -> Future<Tab>,
	pressKey: (Tab, key: string) -> Future<Tab>,
	moveMouseToPoint: (Tab, point: Point) -> Future<Tab>,
	clickAtPoint: (Tab, point: Point) -> Future<Tab>,
	captureScreenshot: (Tab, options: ScreenshotOptions) -> Future<buffer>,
	startScreencast: (Tab, options: ScreencastOptions) -> Future<nil>,
	stopScreencast: (Tab) -> Future<nil>,
	onScreencastFrame: (Tab, callback: (frame: ScreencastFrame) -> ()) -> () -> (),
	acknowledgeScreencastFrame: (Tab, sessionId: number) -> Future<nil>,
	evaluate: (Tab, expression: string, awaitPromise: boolean?) -> Future<Runtime.RemoteObject>,
	getContent: (Tab) -> Future<string>,
	describeNode: (Tab, nodeId: DOM.NodeId) -> Future<DOM.Node>,
	getDocument: (Tab) -> Future<DOM.Node>,
	runQuerySelectorOnNode: (Tab, nodeId: DOM.NodeId, selector: string) -> Future<Element?>,
	runQuerySelectorAllOnNode: (Tab, nodeId: DOM.NodeId, selector: string) -> Future<{ Element }>,
	findElement: (Tab, selector: string) -> Future<Element?>,
	findElementByXPath: (Tab, query: string) -> Future<Element?>,
	findElements: (Tab, selector: string) -> Future<{ Element }>,
	findElementsByXPath: (Tab, query: string) -> Future<{ Element }>,
	waitForElement: (Tab, selector: string, timeout: number?) -> Future<Element?>,
	waitForElementByXPath: (Tab, query: string, timeout: number?) -> Future<Element?>,
	waitForElements: (Tab, selector: string, timeout: number?) -> Future<{ Element }>,
	waitForElementsByXPath: (Tab, query: string, timeout: number?) -> Future<{ Element }>,
	getBounds: (Tab) -> Future<Browser.Bounds>,
	setBounds: (Tab, bounds: Browser.Bounds) -> Future<Tab>,
	enableDebugger: (Tab) -> Future<nil>,
	disableDebugger: (Tab) -> Future<nil>,
	close: (Tab) -> Future<nil>,
}

export type Point = { x: number, y: number }

export type ScreenshotOptions = {
	format: "jpeg" | "png" | "webp",
	quality: number?,
	clip: Page.Viewport?,
	fromSurface: boolean?,
	captureBeyondViewport: boolean?,
	optimizeForSpeed: boolean?,
}

export type ScreencastOptions = {
	format: "jpeg" | "png",
	quality: number?,
	maxWidth: number?,
	maxHeight: number?,
	everyNthFrame: number?,
}

export type ScreencastFrame = {
	data: buffer,
	metadata: Page.ScreencastFrameMetadata,
	sessionId: number,
}

export type Element = {
	getDescription: (Element) -> Future<DOM.Node>,
	getAttributes: (Element) -> Future<{ [string]: string }>,
	findElement: (Element, selector: string) -> Future<Element?>,
	findElementByXPath: (Element, query: string) -> Future<Element?>,
	findElements: (Element, selector: string) -> Future<{ Element }>,
	findElementsByXPath: (Element, query: string) -> Future<{ Element }>,
	waitForElement: (Element, selector: string, timeout: number?) -> Future<Element?>,
	waitForElementByXPath: (Element, query: string, timeout: number?) -> Future<Element?>,
	waitForElements: (Element, selector: string, timeout: number?) -> Future<{ Element }>,
	waitForElementsByXPath: (Element, query: string, timeout: number?) -> Future<{ Element }>,
	callFunction: (
		Element,
		declaration: string,
		arguments: { any }?,
		awaitPromise: boolean?
	) -> Future<Runtime.RemoteObject>,
	getPosition: (Element) -> Future<Point>,
	scrollIntoView: (Element) -> Future<Element>,
	moveMouseOver: (Element) -> Future<Element>,
	click: (Element) -> Future<Element>,
	sendCharactersInto: (Element, characters: string) -> Future<Element>,
	focus: (Element) -> Future<Element>,
}

return nil

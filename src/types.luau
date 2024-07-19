local Future = require("./packages/future")

export type ProtocolInfo<ExtraInfo = {}> = ExtraInfo & {
	webSocketDebuggerUrl: string,
}

export type TargetInfo = {
	targetId: string,
	-- https://source.chromium.org/chromium/chromium/src/+/main:content/browser/devtools/devtools_agent_host_impl.cc?ss=chromium&q=f:devtools%20-f:out%20%22::kTypeTab%5B%5D%22
	type: "tab"
		| "page"
		| "iframe"
		| "worker"
		| "shared_worker"
		| "service_worker"
		| "worklet"
		| "shared_storage_worklet"
		| "browser"
		| "webview"
		| "other"
		| "auction_worklet"
		| "assistive_technology",
	title: string,
	url: string,
	attached: boolean,
	openerId: string?,
	canAccessOpener: boolean,
	openerFrameId: string?,
	browserContextId: string?,
	subtype: string?,
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

export type Bridge = {
	sendOverProtocol: (Bridge, method: string, parameters: { [string]: any }?) -> Future.Future<{ [string]: any }>,
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
	getVersion: (Browser) -> Future.Future<BrowserVersion>,
	newTab: (Browser) -> Future.Future<Tab>,
	close: (Browser) -> Future.Future<nil>,
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
	getTargetId: (Tab) -> Future.Future<string>,
	getTargetInfo: (Tab) -> Future.Future<TargetInfo>,
	getUrl: (Tab) -> Future.Future<string>,
	getTitle: (Tab) -> Future.Future<string>,
	navigateTo: (Tab, url: string) -> Future.Future<nil>,
	reload: (Tab, ignoreCache: boolean?, scriptToEvaluateOnLoad: string?) -> Future.Future<nil>,
	getCookies: (Tab) -> Future.Future<{ Cookie }>,
	setCookies: (Tab, cookies: { CookieParameters }) -> Future.Future<nil>,
	sendCharacter: (Tab, character: string) -> Future.Future<nil>,
	captureScreenshot: (Tab, options: ScreenshotOptions) -> Future.Future<buffer>,
	evaluate: (Tab, expression: string, awaitPromise: boolean) -> Future.Future<RemoteObject>,
	enableDebugger: (Tab) -> Future.Future<nil>,
	disableDebugger: (Tab) -> Future.Future<nil>,
	close: (Tab) -> Future.Future<nil>,
}

export type CookieSameSite = "Strict" | "Lax" | "None"

export type CookiePriority = "Low" | "Medium" | "High"

export type CookieSourceScheme = "Unset" | "NonSecure" | "Secure"

export type CookiePartitionKey = { topLevelSite: string, hasCrossSiteAncestor: boolean }

export type CookieParameters = {
	name: string,
	value: string,
	url: string?,
	domain: string?,
	path: string?,
	secure: boolean?,
	httpOnly: boolean?,
	sameSite: CookieSameSite?,
	expires: number?,
	priority: CookiePriority?,
	sameParty: boolean?,
	sourceScheme: CookieSourceScheme?,
	sourcePort: number?,
	partitionKey: CookiePartitionKey?,
}

export type Cookie = {
	name: string,
	value: string,
	domain: string,
	path: string,
	expires: number,
	size: number,
	httpOnly: boolean,
	secure: boolean,
	session: boolean,
	sameSite: CookieSameSite?,
	priority: CookiePriority,
	sameParty: boolean,
	sourceScheme: CookieSourceScheme,
	sourcePort: number,
	partitionKey: CookiePartitionKey?,
	partitionKeyOpaque: boolean?,
}

export type ObjectType = "object" | "function" | "undefined" | "string" | "number" | "boolean" | "symbol" | "bigint"

export type ObjectSubtype =
	"array"
	| "null"
	| "node"
	| "regexp"
	| "date"
	| "map"
	| "set"
	| "weakmap"
	| "weakset"
	| "iterator"
	| "generator"
	| "error"
	| "proxy"
	| "promise"
	| "typedarray"
	| "arraybuffer"
	| "dataview"
	| "webassemblymemory"
	| "wasmvalue"

export type DeepSerializedValue = {
	type: "undefined"
		| "null"
		| "string"
		| "number"
		| "boolean"
		| "bigint"
		| "regexp"
		| "date"
		| "symbol"
		| "array"
		| "object"
		| "function"
		| "map"
		| "set"
		| "weakmap"
		| "weakset"
		| "error"
		| "proxy"
		| "promise"
		| "typedarray"
		| "arraybuffer"
		| "node"
		| "window"
		| "generator",
	value: any?,
	objectId: string?,
	weakLocalObjectReference: number?,
}

export type ObjectPreview = {
	type: ObjectType,
	subtype: ObjectSubtype?,
	description: string?,
	overflow: boolean,
	properties: { PropertyPreview },
	entries: { EntryPreview }?,
}

export type PropertyPreview = {
	name: string,
	type: ObjectType,
	value: string?,
	valuePreview: ObjectPreview?,
	subtype: ObjectSubtype?,
}

export type EntryPreview = { key: ObjectPreview?, value: ObjectPreview }

export type CustomPreview = { header: string, bodyGetterId: string? }

export type RemoteObject = {
	type: ObjectType,
	subtype: ObjectSubtype?,
	className: string?,
	value: any?,
	unserializableValue: string?,
	description: string?,
	deepSerializedValue: DeepSerializedValue?,
	objectId: string?,
	preview: ObjectPreview?,
	customPreview: CustomPreview?,
}

export type Viewport = {
	x: number,
	y: number,
	width: number,
	height: number,
	scale: number,
}

export type ScreenshotOptions = {
	format: "jpeg" | "png" | "webp",
	quality: number?,
	clip: Viewport?,
	fromSurface: boolean?,
	captureBeyondViewport: boolean?,
	optimizeForSpeed: boolean?,
}

return nil

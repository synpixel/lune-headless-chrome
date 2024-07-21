local CSS = require("./CSS")
local DOM = require("./DOM")
local DOMDebugger = require("./DOMDebugger")
local Page = require("./Page")
export type DOMNode = {
	nodeType: number,
	nodeName: string,
	nodeValue: string,
	textValue: string,
	inputValue: string,
	inputChecked: boolean,
	optionSelected: boolean,
	backendNodeId: DOM.BackendNodeId,
	childNodeIndexes: { number },
	attributes: { NameValue },
	pseudoElementIndexes: { number },
	layoutNodeIndex: number,
	documentURL: string,
	baseURL: string,
	contentLanguage: string,
	documentEncoding: string,
	publicId: string,
	systemId: string,
	frameId: Page.FrameId,
	contentDocumentIndex: number,
	pseudoType: DOM.PseudoType,
	shadowRootType: DOM.ShadowRootType,
	isClickable: boolean,
	eventListeners: { DOMDebugger.EventListener },
	currentSourceURL: string,
	originURL: string,
	scrollOffsetX: number,
	scrollOffsetY: number,
}
export type InlineTextBox = { boundingBox: DOM.Rect, startCharacterIndex: number, numCharacters: number }
export type LayoutTreeNode = {
	domNodeIndex: number,
	boundingBox: DOM.Rect,
	layoutText: string,
	inlineTextNodes: { InlineTextBox },
	styleIndex: number,
	paintOrder: number,
	isStackingContext: boolean,
}
export type ComputedStyle = { properties: { NameValue } }
export type NameValue = { name: string, value: string }
export type StringIndex = number
export type ArrayOfStrings = { StringIndex }
export type RareStringData = { index: { number }, value: { StringIndex } }
export type RareBooleanData = { index: { number } }
export type RareIntegerData = { index: { number }, value: { number } }
export type Rectangle = { number }
export type DocumentSnapshot = {
	documentURL: StringIndex,
	title: StringIndex,
	baseURL: StringIndex,
	contentLanguage: StringIndex,
	encodingName: StringIndex,
	publicId: StringIndex,
	systemId: StringIndex,
	frameId: StringIndex,
	nodes: NodeTreeSnapshot,
	layout: LayoutTreeSnapshot,
	textBoxes: TextBoxSnapshot,
	scrollOffsetX: number,
	scrollOffsetY: number,
	contentWidth: number,
	contentHeight: number,
}
export type NodeTreeSnapshot = {
	parentIndex: { number },
	nodeType: { number },
	shadowRootType: RareStringData,
	nodeName: { StringIndex },
	nodeValue: { StringIndex },
	backendNodeId: { DOM.BackendNodeId },
	attributes: { ArrayOfStrings },
	textValue: RareStringData,
	inputValue: RareStringData,
	inputChecked: RareBooleanData,
	optionSelected: RareBooleanData,
	contentDocumentIndex: RareIntegerData,
	pseudoType: RareStringData,
	pseudoIdentifier: RareStringData,
	isClickable: RareBooleanData,
	currentSourceURL: RareStringData,
	originURL: RareStringData,
}
export type LayoutTreeSnapshot = {
	nodeIndex: { number },
	styles: { ArrayOfStrings },
	bounds: { Rectangle },
	text: { StringIndex },
	stackingContexts: RareBooleanData,
	paintOrders: { number },
	offsetRects: { Rectangle },
	scrollRects: { Rectangle },
	clientRects: { Rectangle },
	blendedBackgroundColors: { StringIndex },
	textColorOpacities: { number },
}
export type TextBoxSnapshot = { layoutIndex: { number }, bounds: { Rectangle }, start: { number }, length: { number } }
return {
	disable = "DOMSnapshot.disable",
	enable = "DOMSnapshot.enable",
	getSnapshot = "DOMSnapshot.getSnapshot",
	captureSnapshot = "DOMSnapshot.captureSnapshot",
}

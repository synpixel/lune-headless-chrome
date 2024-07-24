-- this file was automatically generated and not intended for manual editing
local Runtime = require("./Runtime")
export type NodeId = number
export type BackendNodeId = number
export type BackendNode = { nodeType: number, nodeName: string, backendNodeId: BackendNodeId }
export type PseudoType = (
	"first-line"
	| "first-letter"
	| "before"
	| "after"
	| "marker"
	| "backdrop"
	| "selection"
	| "search-text"
	| "target-text"
	| "spelling-error"
	| "grammar-error"
	| "highlight"
	| "first-line-inherited"
	| "scroll-marker"
	| "scroll-marker-group"
	| "scrollbar"
	| "scrollbar-thumb"
	| "scrollbar-button"
	| "scrollbar-track"
	| "scrollbar-track-piece"
	| "scrollbar-corner"
	| "resizer"
	| "input-list-button"
	| "view-transition"
	| "view-transition-group"
	| "view-transition-image-pair"
	| "view-transition-old"
	| "view-transition-new"
)
export type ShadowRootType = "user-agent" | "open" | "closed"
export type CompatibilityMode = "QuirksMode" | "LimitedQuirksMode" | "NoQuirksMode"
export type PhysicalAxes = "Horizontal" | "Vertical" | "Both"
export type LogicalAxes = "Inline" | "Block" | "Both"
export type ScrollOrientation = "horizontal" | "vertical"
export type Node = {
	nodeId: NodeId,
	parentId: NodeId?,
	backendNodeId: BackendNodeId,
	nodeType: number,
	nodeName: string,
	localName: string,
	nodeValue: string,
	childNodeCount: number?,
	children: { Node }?,
	attributes: { string }?,
	documentURL: string?,
	baseURL: string?,
	publicId: string?,
	systemId: string?,
	internalSubset: string?,
	xmlVersion: string?,
	name: string?,
	value: string?,
	pseudoType: PseudoType?,
	pseudoIdentifier: string?,
	shadowRootType: ShadowRootType?,
	frameId: Page.FrameId?,
	contentDocument: Node?,
	shadowRoots: { Node }?,
	templateContent: Node?,
	pseudoElements: { Node }?,
	importedDocument: Node?,
	distributedNodes: { BackendNode }?,
	isSVG: boolean?,
	compatibilityMode: CompatibilityMode?,
	assignedSlot: BackendNode?,
}
export type RGBA = { r: number, g: number, b: number, a: number? }
export type Quad = { number }
export type BoxModel = {
	content: Quad,
	padding: Quad,
	border: Quad,
	margin: Quad,
	width: number,
	height: number,
	shapeOutside: ShapeOutsideInfo?,
}
export type ShapeOutsideInfo = { bounds: Quad, shape: { any }, marginShape: { any } }
export type Rect = { x: number, y: number, width: number, height: number }
export type CSSComputedStyleProperty = { name: string, value: string }
return {
	collectClassNamesFromSubtree = "DOM.collectClassNamesFromSubtree",
	copyTo = "DOM.copyTo",
	describeNode = "DOM.describeNode",
	scrollIntoViewIfNeeded = "DOM.scrollIntoViewIfNeeded",
	disable = "DOM.disable",
	discardSearchResults = "DOM.discardSearchResults",
	enable = "DOM.enable",
	focus = "DOM.focus",
	getAttributes = "DOM.getAttributes",
	getBoxModel = "DOM.getBoxModel",
	getContentQuads = "DOM.getContentQuads",
	getDocument = "DOM.getDocument",
	getFlattenedDocument = "DOM.getFlattenedDocument",
	getNodesForSubtreeByStyle = "DOM.getNodesForSubtreeByStyle",
	getNodeForLocation = "DOM.getNodeForLocation",
	getOuterHTML = "DOM.getOuterHTML",
	getRelayoutBoundary = "DOM.getRelayoutBoundary",
	getSearchResults = "DOM.getSearchResults",
	hideHighlight = "DOM.hideHighlight",
	highlightNode = "DOM.highlightNode",
	highlightRect = "DOM.highlightRect",
	markUndoableState = "DOM.markUndoableState",
	moveTo = "DOM.moveTo",
	performSearch = "DOM.performSearch",
	pushNodeByPathToFrontend = "DOM.pushNodeByPathToFrontend",
	pushNodesByBackendIdsToFrontend = "DOM.pushNodesByBackendIdsToFrontend",
	querySelector = "DOM.querySelector",
	querySelectorAll = "DOM.querySelectorAll",
	getTopLayerElements = "DOM.getTopLayerElements",
	getElementByRelation = "DOM.getElementByRelation",
	redo = "DOM.redo",
	removeAttribute = "DOM.removeAttribute",
	removeNode = "DOM.removeNode",
	requestChildNodes = "DOM.requestChildNodes",
	requestNode = "DOM.requestNode",
	resolveNode = "DOM.resolveNode",
	setAttributeValue = "DOM.setAttributeValue",
	setAttributesAsText = "DOM.setAttributesAsText",
	setFileInputFiles = "DOM.setFileInputFiles",
	setNodeStackTracesEnabled = "DOM.setNodeStackTracesEnabled",
	getNodeStackTraces = "DOM.getNodeStackTraces",
	getFileInfo = "DOM.getFileInfo",
	setInspectedNode = "DOM.setInspectedNode",
	setNodeName = "DOM.setNodeName",
	setNodeValue = "DOM.setNodeValue",
	setOuterHTML = "DOM.setOuterHTML",
	undo = "DOM.undo",
	getFrameOwner = "DOM.getFrameOwner",
	getContainerForNode = "DOM.getContainerForNode",
	getQueryingDescendantsForContainer = "DOM.getQueryingDescendantsForContainer",
	getAnchorElement = "DOM.getAnchorElement",
	attributeModified = "DOM.attributeModified",
	attributeRemoved = "DOM.attributeRemoved",
	characterDataModified = "DOM.characterDataModified",
	childNodeCountUpdated = "DOM.childNodeCountUpdated",
	childNodeInserted = "DOM.childNodeInserted",
	childNodeRemoved = "DOM.childNodeRemoved",
	distributedNodesUpdated = "DOM.distributedNodesUpdated",
	documentUpdated = "DOM.documentUpdated",
	inlineStyleInvalidated = "DOM.inlineStyleInvalidated",
	pseudoElementAdded = "DOM.pseudoElementAdded",
	topLayerElementsUpdated = "DOM.topLayerElementsUpdated",
	pseudoElementRemoved = "DOM.pseudoElementRemoved",
	setChildNodes = "DOM.setChildNodes",
	shadowRootPopped = "DOM.shadowRootPopped",
	shadowRootPushed = "DOM.shadowRootPushed",
}

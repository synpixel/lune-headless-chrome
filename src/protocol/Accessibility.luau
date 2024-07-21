local DOM = require("./DOM")
export type AXNodeId = string
export type AXValueType =
	"boolean"
	| "tristate"
	| "booleanOrUndefined"
	| "idref"
	| "idrefList"
	| "integer"
	| "node"
	| "nodeList"
	| "number"
	| "string"
	| "computedString"
	| "token"
	| "tokenList"
	| "domRelation"
	| "role"
	| "internalRole"
	| "valueUndefined"
export type AXValueSourceType = "attribute" | "implicit" | "style" | "contents" | "placeholder" | "relatedElement"
export type AXValueNativeSourceType =
	"description"
	| "figcaption"
	| "label"
	| "labelfor"
	| "labelwrapped"
	| "legend"
	| "rubyannotation"
	| "tablecaption"
	| "title"
	| "other"
export type AXValueSource = {
	type: AXValueSourceType,
	value: AXValue?,
	attribute: string?,
	attributeValue: AXValue?,
	superseded: boolean?,
	nativeSource: AXValueNativeSourceType?,
	nativeSourceValue: AXValue?,
	invalid: boolean?,
	invalidReason: string?,
}
export type AXRelatedNode = { backendDOMNodeId: DOM.BackendNodeId, idref: string?, text: string? }
export type AXProperty = { name: AXPropertyName, value: AXValue }
export type AXValue = { type: AXValueType, value: any?, relatedNodes: { AXRelatedNode }?, sources: { AXValueSource }? }
export type AXPropertyName =
	"busy"
	| "disabled"
	| "editable"
	| "focusable"
	| "focused"
	| "hidden"
	| "hiddenRoot"
	| "invalid"
	| "keyshortcuts"
	| "settable"
	| "roledescription"
	| "live"
	| "atomic"
	| "relevant"
	| "root"
	| "autocomplete"
	| "hasPopup"
	| "level"
	| "multiselectable"
	| "orientation"
	| "multiline"
	| "readonly"
	| "required"
	| "valuemin"
	| "valuemax"
	| "valuetext"
	| "checked"
	| "expanded"
	| "modal"
	| "pressed"
	| "selected"
	| "activedescendant"
	| "controls"
	| "describedby"
	| "details"
	| "errormessage"
	| "flowto"
	| "labelledby"
	| "owns"
	| "url"
export type AXNode = {
	nodeId: AXNodeId,
	ignored: boolean,
	ignoredReasons: { AXProperty }?,
	role: AXValue?,
	chromeRole: AXValue?,
	name: AXValue?,
	description: AXValue?,
	value: AXValue?,
	properties: { AXProperty }?,
	parentId: AXNodeId?,
	childIds: { AXNodeId }?,
	backendDOMNodeId: DOM.BackendNodeId?,
	frameId: Page.FrameId?,
}
return {
	disable = "Accessibility.disable",
	enable = "Accessibility.enable",
	getPartialAXTree = "Accessibility.getPartialAXTree",
	getFullAXTree = "Accessibility.getFullAXTree",
	getRootAXNode = "Accessibility.getRootAXNode",
	getAXNodeAndAncestors = "Accessibility.getAXNodeAndAncestors",
	getChildAXNodes = "Accessibility.getChildAXNodes",
	queryAXTree = "Accessibility.queryAXTree",
}

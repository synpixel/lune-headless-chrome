local DOM = require("./DOM")
local Page = require("./Page")
export type StyleSheetId = string
export type StyleSheetOrigin = "injected" | "user-agent" | "inspector" | "regular"
export type PseudoElementMatches = { pseudoType: DOM.PseudoType, pseudoIdentifier: string?, matches: { RuleMatch } }
export type InheritedStyleEntry = { inlineStyle: CSSStyle?, matchedCSSRules: { RuleMatch } }
export type InheritedPseudoElementMatches = { pseudoElements: { PseudoElementMatches } }
export type RuleMatch = { rule: CSSRule, matchingSelectors: { number } }
export type Value = { text: string, range: SourceRange?, specificity: Specificity? }
export type Specificity = { a: number, b: number, c: number }
export type SelectorList = { selectors: { Value }, text: string }
export type CSSStyleSheetHeader = {
	styleSheetId: StyleSheetId,
	frameId: Page.FrameId,
	sourceURL: string,
	sourceMapURL: string?,
	origin: StyleSheetOrigin,
	title: string,
	ownerNode: DOM.BackendNodeId?,
	disabled: boolean,
	hasSourceURL: boolean?,
	isInline: boolean,
	isMutable: boolean,
	isConstructed: boolean,
	startLine: number,
	startColumn: number,
	length: number,
	endLine: number,
	endColumn: number,
	loadingFailed: boolean?,
}
export type CSSRule = {
	styleSheetId: StyleSheetId?,
	selectorList: SelectorList,
	nestingSelectors: { string }?,
	origin: StyleSheetOrigin,
	style: CSSStyle,
	media: { CSSMedia }?,
	containerQueries: { CSSContainerQuery }?,
	supports: { CSSSupports }?,
	layers: { CSSLayer }?,
	scopes: { CSSScope }?,
	ruleTypes: { CSSRuleType }?,
}
export type CSSRuleType = "MediaRule" | "SupportsRule" | "ContainerRule" | "LayerRule" | "ScopeRule" | "StyleRule"
export type RuleUsage = { styleSheetId: StyleSheetId, startOffset: number, endOffset: number, used: boolean }
export type SourceRange = { startLine: number, startColumn: number, endLine: number, endColumn: number }
export type ShorthandEntry = { name: string, value: string, important: boolean? }
export type CSSComputedStyleProperty = { name: string, value: string }
export type CSSStyle = {
	styleSheetId: StyleSheetId?,
	cssProperties: { CSSProperty },
	shorthandEntries: { ShorthandEntry },
	cssText: string?,
	range: SourceRange?,
}
export type CSSProperty = {
	name: string,
	value: string,
	important: boolean?,
	implicit: boolean?,
	text: string?,
	parsedOk: boolean?,
	disabled: boolean?,
	range: SourceRange?,
	longhandProperties: { CSSProperty }?,
}
export type CSSMedia = {
	text: string,
	source: "mediaRule" | "importRule" | "linkedSheet" | "inlineSheet",
	sourceURL: string?,
	range: SourceRange?,
	styleSheetId: StyleSheetId?,
	mediaList: { MediaQuery }?,
}
export type MediaQuery = { expressions: { MediaQueryExpression }, active: boolean }
export type MediaQueryExpression = {
	value: number,
	unit: string,
	feature: string,
	valueRange: SourceRange?,
	computedLength: number?,
}
export type CSSContainerQuery = {
	text: string,
	range: SourceRange?,
	styleSheetId: StyleSheetId?,
	name: string?,
	physicalAxes: DOM.PhysicalAxes?,
	logicalAxes: DOM.LogicalAxes?,
}
export type CSSSupports = { text: string, active: boolean, range: SourceRange?, styleSheetId: StyleSheetId? }
export type CSSScope = { text: string, range: SourceRange?, styleSheetId: StyleSheetId? }
export type CSSLayer = { text: string, range: SourceRange?, styleSheetId: StyleSheetId? }
export type CSSLayerData = { name: string, subLayers: { CSSLayerData }?, order: number }
export type PlatformFontUsage = { familyName: string, postScriptName: string, isCustomFont: boolean, glyphCount: number }
export type FontVariationAxis = { tag: string, name: string, minValue: number, maxValue: number, defaultValue: number }
export type FontFace = {
	fontFamily: string,
	fontStyle: string,
	fontVariant: string,
	fontWeight: string,
	fontStretch: string,
	fontDisplay: string,
	unicodeRange: string,
	src: string,
	platformFontFamily: string,
	fontVariationAxes: { FontVariationAxis }?,
}
export type CSSTryRule = { styleSheetId: StyleSheetId?, origin: StyleSheetOrigin, style: CSSStyle }
export type CSSPositionFallbackRule = { name: Value, tryRules: { CSSTryRule } }
export type CSSPositionTryRule = {
	name: Value,
	styleSheetId: StyleSheetId?,
	origin: StyleSheetOrigin,
	style: CSSStyle,
	active: boolean,
}
export type CSSKeyframesRule = { animationName: Value, keyframes: { CSSKeyframeRule } }
export type CSSPropertyRegistration = { propertyName: string, initialValue: Value?, inherits: boolean, syntax: string }
export type CSSFontPaletteValuesRule = {
	styleSheetId: StyleSheetId?,
	origin: StyleSheetOrigin,
	fontPaletteName: Value,
	style: CSSStyle,
}
export type CSSPropertyRule =
	{ styleSheetId: StyleSheetId?, origin: StyleSheetOrigin, propertyName: Value, style: CSSStyle }
export type CSSKeyframeRule = { styleSheetId: StyleSheetId?, origin: StyleSheetOrigin, keyText: Value, style: CSSStyle }
export type StyleDeclarationEdit = { styleSheetId: StyleSheetId, range: SourceRange, text: string }
return {
	addRule = "CSS.addRule",
	collectClassNames = "CSS.collectClassNames",
	createStyleSheet = "CSS.createStyleSheet",
	disable = "CSS.disable",
	enable = "CSS.enable",
	forcePseudoState = "CSS.forcePseudoState",
	getBackgroundColors = "CSS.getBackgroundColors",
	getComputedStyleForNode = "CSS.getComputedStyleForNode",
	getInlineStylesForNode = "CSS.getInlineStylesForNode",
	getMatchedStylesForNode = "CSS.getMatchedStylesForNode",
	getMediaQueries = "CSS.getMediaQueries",
	getPlatformFontsForNode = "CSS.getPlatformFontsForNode",
	getStyleSheetText = "CSS.getStyleSheetText",
	getLayersForNode = "CSS.getLayersForNode",
	getLocationForSelector = "CSS.getLocationForSelector",
	trackComputedStyleUpdates = "CSS.trackComputedStyleUpdates",
	takeComputedStyleUpdates = "CSS.takeComputedStyleUpdates",
	setEffectivePropertyValueForNode = "CSS.setEffectivePropertyValueForNode",
	setPropertyRulePropertyName = "CSS.setPropertyRulePropertyName",
	setKeyframeKey = "CSS.setKeyframeKey",
	setMediaText = "CSS.setMediaText",
	setContainerQueryText = "CSS.setContainerQueryText",
	setSupportsText = "CSS.setSupportsText",
	setScopeText = "CSS.setScopeText",
	setRuleSelector = "CSS.setRuleSelector",
	setStyleSheetText = "CSS.setStyleSheetText",
	setStyleTexts = "CSS.setStyleTexts",
	startRuleUsageTracking = "CSS.startRuleUsageTracking",
	stopRuleUsageTracking = "CSS.stopRuleUsageTracking",
	takeCoverageDelta = "CSS.takeCoverageDelta",
	setLocalFontsEnabled = "CSS.setLocalFontsEnabled",
	fontsUpdated = "CSS.fontsUpdated",
	mediaQueryResultChanged = "CSS.mediaQueryResultChanged",
	styleSheetAdded = "CSS.styleSheetAdded",
	styleSheetChanged = "CSS.styleSheetChanged",
	styleSheetRemoved = "CSS.styleSheetRemoved",
}

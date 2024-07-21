local DOM = require("./DOM")
local Page = require("./Page")
local Runtime = require("./Runtime")
export type SourceOrderConfig = { parentOutlineColor: DOM.RGBA, childOutlineColor: DOM.RGBA }
export type GridHighlightConfig = {
	showGridExtensionLines: boolean?,
	showPositiveLineNumbers: boolean?,
	showNegativeLineNumbers: boolean?,
	showAreaNames: boolean?,
	showLineNames: boolean?,
	showTrackSizes: boolean?,
	gridBorderColor: DOM.RGBA?,
	cellBorderColor: DOM.RGBA?,
	rowLineColor: DOM.RGBA?,
	columnLineColor: DOM.RGBA?,
	gridBorderDash: boolean?,
	cellBorderDash: boolean?,
	rowLineDash: boolean?,
	columnLineDash: boolean?,
	rowGapColor: DOM.RGBA?,
	rowHatchColor: DOM.RGBA?,
	columnGapColor: DOM.RGBA?,
	columnHatchColor: DOM.RGBA?,
	areaBorderColor: DOM.RGBA?,
	gridBackgroundColor: DOM.RGBA?,
}
export type FlexContainerHighlightConfig = {
	containerBorder: LineStyle?,
	lineSeparator: LineStyle?,
	itemSeparator: LineStyle?,
	mainDistributedSpace: BoxStyle?,
	crossDistributedSpace: BoxStyle?,
	rowGapSpace: BoxStyle?,
	columnGapSpace: BoxStyle?,
	crossAlignment: LineStyle?,
}
export type FlexItemHighlightConfig = { baseSizeBox: BoxStyle?, baseSizeBorder: LineStyle?, flexibilityArrow: LineStyle? }
export type LineStyle = { color: DOM.RGBA?, pattern: ("dashed" | "dotted")? }
export type BoxStyle = { fillColor: DOM.RGBA?, hatchColor: DOM.RGBA? }
export type ContrastAlgorithm = "aa" | "aaa" | "apca"
export type HighlightConfig = {
	showInfo: boolean?,
	showStyles: boolean?,
	showRulers: boolean?,
	showAccessibilityInfo: boolean?,
	showExtensionLines: boolean?,
	contentColor: DOM.RGBA?,
	paddingColor: DOM.RGBA?,
	borderColor: DOM.RGBA?,
	marginColor: DOM.RGBA?,
	eventTargetColor: DOM.RGBA?,
	shapeColor: DOM.RGBA?,
	shapeMarginColor: DOM.RGBA?,
	cssGridColor: DOM.RGBA?,
	colorFormat: ColorFormat?,
	gridHighlightConfig: GridHighlightConfig?,
	flexContainerHighlightConfig: FlexContainerHighlightConfig?,
	flexItemHighlightConfig: FlexItemHighlightConfig?,
	contrastAlgorithm: ContrastAlgorithm?,
	containerQueryContainerHighlightConfig: ContainerQueryContainerHighlightConfig?,
}
export type ColorFormat = "rgb" | "hsl" | "hwb" | "hex"
export type GridNodeHighlightConfig = { gridHighlightConfig: GridHighlightConfig, nodeId: DOM.NodeId }
export type FlexNodeHighlightConfig = { flexContainerHighlightConfig: FlexContainerHighlightConfig, nodeId: DOM.NodeId }
export type ScrollSnapContainerHighlightConfig = {
	snapportBorder: LineStyle?,
	snapAreaBorder: LineStyle?,
	scrollMarginColor: DOM.RGBA?,
	scrollPaddingColor: DOM.RGBA?,
}
export type ScrollSnapHighlightConfig = {
	scrollSnapContainerHighlightConfig: ScrollSnapContainerHighlightConfig,
	nodeId: DOM.NodeId,
}
export type HingeConfig = { rect: DOM.Rect, contentColor: DOM.RGBA?, outlineColor: DOM.RGBA? }
export type WindowControlsOverlayConfig = { showCSS: boolean, selectedPlatform: string, themeColor: string }
export type ContainerQueryHighlightConfig = {
	containerQueryContainerHighlightConfig: ContainerQueryContainerHighlightConfig,
	nodeId: DOM.NodeId,
}
export type ContainerQueryContainerHighlightConfig = { containerBorder: LineStyle?, descendantBorder: LineStyle? }
export type IsolatedElementHighlightConfig = {
	isolationModeHighlightConfig: IsolationModeHighlightConfig,
	nodeId: DOM.NodeId,
}
export type IsolationModeHighlightConfig = { resizerColor: DOM.RGBA?, resizerHandleColor: DOM.RGBA?, maskColor: DOM.RGBA? }
export type InspectMode = (
	"searchForNode" | "searchForUAShadowDOM" | "captureAreaScreenshot" | "showDistances" | "none"
)
return {
	disable = "Overlay.disable",
	enable = "Overlay.enable",
	getHighlightObjectForTest = "Overlay.getHighlightObjectForTest",
	getGridHighlightObjectsForTest = "Overlay.getGridHighlightObjectsForTest",
	getSourceOrderHighlightObjectForTest = "Overlay.getSourceOrderHighlightObjectForTest",
	hideHighlight = "Overlay.hideHighlight",
	highlightFrame = "Overlay.highlightFrame",
	highlightNode = "Overlay.highlightNode",
	highlightQuad = "Overlay.highlightQuad",
	highlightRect = "Overlay.highlightRect",
	highlightSourceOrder = "Overlay.highlightSourceOrder",
	setInspectMode = "Overlay.setInspectMode",
	setShowAdHighlights = "Overlay.setShowAdHighlights",
	setPausedInDebuggerMessage = "Overlay.setPausedInDebuggerMessage",
	setShowDebugBorders = "Overlay.setShowDebugBorders",
	setShowFPSCounter = "Overlay.setShowFPSCounter",
	setShowGridOverlays = "Overlay.setShowGridOverlays",
	setShowFlexOverlays = "Overlay.setShowFlexOverlays",
	setShowScrollSnapOverlays = "Overlay.setShowScrollSnapOverlays",
	setShowContainerQueryOverlays = "Overlay.setShowContainerQueryOverlays",
	setShowPaintRects = "Overlay.setShowPaintRects",
	setShowLayoutShiftRegions = "Overlay.setShowLayoutShiftRegions",
	setShowScrollBottleneckRects = "Overlay.setShowScrollBottleneckRects",
	setShowHitTestBorders = "Overlay.setShowHitTestBorders",
	setShowWebVitals = "Overlay.setShowWebVitals",
	setShowViewportSizeOnResize = "Overlay.setShowViewportSizeOnResize",
	setShowHinge = "Overlay.setShowHinge",
	setShowIsolatedElements = "Overlay.setShowIsolatedElements",
	setShowWindowControlsOverlay = "Overlay.setShowWindowControlsOverlay",
}

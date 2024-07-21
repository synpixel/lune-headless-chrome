local DOM = require("./DOM")
export type LayerId = string
export type SnapshotId = string
export type ScrollRect = { rect: DOM.Rect, type: "RepaintsOnScroll" | "TouchEventHandler" | "WheelEventHandler" }
export type StickyPositionConstraint = {
	stickyBoxRect: DOM.Rect,
	containingBlockRect: DOM.Rect,
	nearestLayerShiftingStickyBox: LayerId?,
	nearestLayerShiftingContainingBlock: LayerId?,
}
export type PictureTile = { x: number, y: number, picture: string }
export type Layer = {
	layerId: LayerId,
	parentLayerId: LayerId?,
	backendNodeId: DOM.BackendNodeId?,
	offsetX: number,
	offsetY: number,
	width: number,
	height: number,
	transform: { number }?,
	anchorX: number?,
	anchorY: number?,
	anchorZ: number?,
	paintCount: number,
	drawsContent: boolean,
	invisible: boolean?,
	scrollRects: { ScrollRect }?,
	stickyPositionConstraint: StickyPositionConstraint?,
}
export type PaintProfile = { number }
return {
	compositingReasons = "LayerTree.compositingReasons",
	disable = "LayerTree.disable",
	enable = "LayerTree.enable",
	loadSnapshot = "LayerTree.loadSnapshot",
	makeSnapshot = "LayerTree.makeSnapshot",
	profileSnapshot = "LayerTree.profileSnapshot",
	releaseSnapshot = "LayerTree.releaseSnapshot",
	replaySnapshot = "LayerTree.replaySnapshot",
	snapshotCommandLog = "LayerTree.snapshotCommandLog",
	layerPainted = "LayerTree.layerPainted",
	layerTreeDidChange = "LayerTree.layerTreeDidChange",
}

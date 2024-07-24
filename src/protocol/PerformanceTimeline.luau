-- this file was automatically generated and not intended for manual editing
local DOM = require("./DOM")
local Network = require("./Network")
export type LargestContentfulPaint = {
	renderTime: Network.TimeSinceEpoch,
	loadTime: Network.TimeSinceEpoch,
	size: number,
	elementId: string?,
	url: string?,
	nodeId: DOM.BackendNodeId?,
}
export type LayoutShiftAttribution = { previousRect: DOM.Rect, currentRect: DOM.Rect, nodeId: DOM.BackendNodeId? }
export type LayoutShift = {
	value: number,
	hadRecentInput: boolean,
	lastInputTime: Network.TimeSinceEpoch,
	sources: { LayoutShiftAttribution },
}
export type TimelineEvent = {
	frameId: Page.FrameId,
	type: string,
	name: string,
	time: Network.TimeSinceEpoch,
	duration: number?,
	lcpDetails: LargestContentfulPaint?,
	layoutShiftDetails: LayoutShift?,
}
return {
	enable = "PerformanceTimeline.enable",
	timelineEventAdded = "PerformanceTimeline.timelineEventAdded",
}

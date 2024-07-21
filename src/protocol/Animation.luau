local Runtime = require("./Runtime")
local DOM = require("./DOM")
export type Animation = {
	id: string,
	name: string,
	pausedState: boolean,
	playState: string,
	playbackRate: number,
	startTime: number,
	currentTime: number,
	type: "CSSTransition" | "CSSAnimation" | "WebAnimation",
	source: AnimationEffect,
	cssId: string,
	viewOrScrollTimeline: ViewOrScrollTimeline,
}
export type ViewOrScrollTimeline = {
	sourceNodeId: DOM.BackendNodeId,
	startOffset: number,
	endOffset: number,
	subjectNodeId: DOM.BackendNodeId,
	axis: DOM.ScrollOrientation,
}
export type AnimationEffect = {
	delay: number,
	endDelay: number,
	iterationStart: number,
	iterations: number,
	duration: number,
	direction: string,
	fill: string,
	backendNodeId: DOM.BackendNodeId,
	keyframesRule: KeyframesRule,
	easing: string,
}
export type KeyframesRule = { name: string, keyframes: { KeyframeStyle } }
export type KeyframeStyle = { offset: string, easing: string }
return {
	disable = "Animation.disable",
	enable = "Animation.enable",
	getCurrentTime = "Animation.getCurrentTime",
	getPlaybackRate = "Animation.getPlaybackRate",
	releaseAnimations = "Animation.releaseAnimations",
	resolveAnimation = "Animation.resolveAnimation",
	seekAnimations = "Animation.seekAnimations",
	setPaused = "Animation.setPaused",
	setPlaybackRate = "Animation.setPlaybackRate",
	setTiming = "Animation.setTiming",
}

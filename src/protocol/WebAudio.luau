-- this file was automatically generated and not intended for manual editing
export type GraphObjectId = string
export type ContextType = "realtime" | "offline"
export type ContextState = "suspended" | "running" | "closed"
export type NodeType = string
export type ChannelCountMode = "clamped-max" | "explicit" | "max"
export type ChannelInterpretation = "discrete" | "speakers"
export type ParamType = string
export type AutomationRate = "a-rate" | "k-rate"
export type ContextRealtimeData = {
	currentTime: number,
	renderCapacity: number,
	callbackIntervalMean: number,
	callbackIntervalVariance: number,
}
export type BaseAudioContext = {
	contextId: GraphObjectId,
	contextType: ContextType,
	contextState: ContextState,
	realtimeData: ContextRealtimeData?,
	callbackBufferSize: number,
	maxOutputChannelCount: number,
	sampleRate: number,
}
export type AudioListener = { listenerId: GraphObjectId, contextId: GraphObjectId }
export type AudioNode = {
	nodeId: GraphObjectId,
	contextId: GraphObjectId,
	nodeType: NodeType,
	numberOfInputs: number,
	numberOfOutputs: number,
	channelCount: number,
	channelCountMode: ChannelCountMode,
	channelInterpretation: ChannelInterpretation,
}
export type AudioParam = {
	paramId: GraphObjectId,
	nodeId: GraphObjectId,
	contextId: GraphObjectId,
	paramType: ParamType,
	rate: AutomationRate,
	defaultValue: number,
	minValue: number,
	maxValue: number,
}
return {
	enable = "WebAudio.enable",
	disable = "WebAudio.disable",
	getRealtimeData = "WebAudio.getRealtimeData",
	contextCreated = "WebAudio.contextCreated",
	contextWillBeDestroyed = "WebAudio.contextWillBeDestroyed",
	contextChanged = "WebAudio.contextChanged",
	audioListenerCreated = "WebAudio.audioListenerCreated",
	audioListenerWillBeDestroyed = "WebAudio.audioListenerWillBeDestroyed",
	audioNodeCreated = "WebAudio.audioNodeCreated",
	audioNodeWillBeDestroyed = "WebAudio.audioNodeWillBeDestroyed",
	audioParamCreated = "WebAudio.audioParamCreated",
	audioParamWillBeDestroyed = "WebAudio.audioParamWillBeDestroyed",
	nodesConnected = "WebAudio.nodesConnected",
	nodesDisconnected = "WebAudio.nodesDisconnected",
	nodeParamConnected = "WebAudio.nodeParamConnected",
	nodeParamDisconnected = "WebAudio.nodeParamDisconnected",
}

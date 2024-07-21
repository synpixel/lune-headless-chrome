export type PlayerId = string
export type Timestamp = number
export type PlayerMessage = { level: "error" | "warning" | "info" | "debug", message: string }
export type PlayerProperty = { name: string, value: string }
export type PlayerEvent = { timestamp: Timestamp, value: string }
export type PlayerErrorSourceLocation = { file: string, line: number }
export type PlayerError = {
	errorType: string,
	code: number,
	stack: { PlayerErrorSourceLocation },
	cause: { PlayerError },
	data: {},
}
return {
	enable = "Media.enable",
	disable = "Media.disable",
	playerPropertiesChanged = "Media.playerPropertiesChanged",
	playerEventsAdded = "Media.playerEventsAdded",
	playerMessagesLogged = "Media.playerMessagesLogged",
	playerErrorsRaised = "Media.playerErrorsRaised",
	playersCreated = "Media.playersCreated",
}

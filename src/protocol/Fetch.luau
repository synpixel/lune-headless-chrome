local Network = require("./Network")
local IO = require("./IO")
local Page = require("./Page")
export type RequestId = string
export type RequestStage = "Request" | "Response"
export type RequestPattern = { urlPattern: string?, resourceType: Network.ResourceType?, requestStage: RequestStage? }
export type HeaderEntry = { name: string, value: string }
export type AuthChallenge = { source: ("Server" | "Proxy")?, origin: string, scheme: string, realm: string }
export type AuthChallengeResponse = {
	response: "Default" | "CancelAuth" | "ProvideCredentials",
	username: string?,
	password: string?,
}
return {
	disable = "Fetch.disable",
	enable = "Fetch.enable",
	failRequest = "Fetch.failRequest",
	fulfillRequest = "Fetch.fulfillRequest",
	continueRequest = "Fetch.continueRequest",
	continueWithAuth = "Fetch.continueWithAuth",
	continueResponse = "Fetch.continueResponse",
	getResponseBody = "Fetch.getResponseBody",
	takeResponseBodyAsStream = "Fetch.takeResponseBodyAsStream",
}

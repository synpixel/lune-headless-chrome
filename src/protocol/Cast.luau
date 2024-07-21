export type Sink = { name: string, id: string, session: string? }
return {
	enable = "Cast.enable",
	disable = "Cast.disable",
	setSinkToUse = "Cast.setSinkToUse",
	startDesktopMirroring = "Cast.startDesktopMirroring",
	startTabMirroring = "Cast.startTabMirroring",
	stopCasting = "Cast.stopCasting",
	sinksUpdated = "Cast.sinksUpdated",
	issueUpdated = "Cast.issueUpdated",
}

local Transport = require("../transport")
local Page = require("../protocol/page")

export type Dialog = {
	session_id: string,
	transport: Transport.Transport,
	accept: (dialog: Dialog, text: string?) -> (),
	dismiss: (dialog: Dialog) -> (),
}

local function handle(dialog: Dialog, accept: boolean, text: string?)
	dialog.transport:call_method_on_target(
		Page.HandleJavaScriptDialog,
		{ accept = accept, prompt_text = text },
		dialog.session_id
	)
end

local function accept(dialog: Dialog, text: string?)
	handle(dialog, true, text)
end

local function dismiss(dialog: Dialog)
	handle(dialog, false)
end

local function create(session_id: string, transport: Transport.Transport): Dialog
	return {
		session_id = session_id,
		transport = transport,
		accept = accept,
		dismiss = dismiss,
	}
end

return { create = create }

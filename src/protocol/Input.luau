export type TouchPoint = {
	x: number,
	y: number,
	radiusX: number?,
	radiusY: number?,
	rotationAngle: number?,
	force: number?,
	tangentialPressure: number?,
	tiltX: number?,
	tiltY: number?,
	twist: number?,
	id: number?,
}
export type GestureSourceType = "default" | "touch" | "mouse"
export type MouseButton = "none" | "left" | "middle" | "right" | "back" | "forward"
export type TimeSinceEpoch = number
export type DragDataItem = { mimeType: string, data: string, title: string?, baseURL: string? }
export type DragData = { items: { DragDataItem }, files: { string }?, dragOperationsMask: number }
return {
	dispatchDragEvent = "Input.dispatchDragEvent",
	dispatchKeyEvent = "Input.dispatchKeyEvent",
	insertText = "Input.insertText",
	imeSetComposition = "Input.imeSetComposition",
	dispatchMouseEvent = "Input.dispatchMouseEvent",
	dispatchTouchEvent = "Input.dispatchTouchEvent",
	cancelDragging = "Input.cancelDragging",
	emulateTouchFromMouseEvent = "Input.emulateTouchFromMouseEvent",
	setIgnoreInputEvents = "Input.setIgnoreInputEvents",
	setInterceptDrags = "Input.setInterceptDrags",
	synthesizePinchGesture = "Input.synthesizePinchGesture",
	synthesizeScrollGesture = "Input.synthesizeScrollGesture",
	synthesizeTapGesture = "Input.synthesizeTapGesture",
	dragIntercepted = "Input.dragIntercepted",
}

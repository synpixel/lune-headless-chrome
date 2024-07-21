export type KeyDefinition = {
	key: string,
	keyCode: number?,
	code: string?,
	text: string?,
}

local keyboardLayout: { KeyDefinition } = {
	{
		code = "Tab",
		key = "Tab",
		keyCode = 9,
	},
	{
		code = "NumpadMultiply",
		key = "*",
		keyCode = 106,
	},
	{
		code = "MediaPlayPause",
		key = "MediaPlayPause",
		keyCode = 179,
	},
	{
		code = "Backquote",
		key = "`",
		keyCode = 192,
	},
	{
		code = "Help",
		key = "Help",
		keyCode = 6,
	},
	{
		code = "End",
		key = "End",
		keyCode = 35,
	},
	{
		code = "NonConvert",
		key = "NonConvert",
		keyCode = 29,
	},
	{
		code = "AltRight",
		key = "Alt",
		keyCode = 18,
	},
	{
		code = "Quote",
		key = '"',
		keyCode = 222,
	},
	{
		code = "MediaTrackPrevious",
		key = "MediaTrackPrevious",
		keyCode = 177,
	},
	{
		code = "F2",
		key = "F2",
		keyCode = 113,
	},
	{
		code = "AltGraph",
		key = "AltGraph",
		keyCode = 225,
	},
	{
		code = "Comma",
		key = ",",
		keyCode = 188,
	},
	{
		code = "Backslash",
		key = "|",
		keyCode = 220,
	},
	{
		code = "Open",
		key = "Execute",
		keyCode = 43,
	},
	{
		code = "KeyT",
		key = "t",
		keyCode = 84,
	},
	{
		code = "Enter",
		key = "Enter",
		keyCode = 13,
		text = "\r",
	},
	{
		code = "Period",
		key = ".",
		keyCode = 190,
	},
	{
		code = "MetaLeft",
		key = "Meta",
		keyCode = 91,
	},
	{
		code = "Slash",
		key = "?",
		keyCode = 191,
	},
	{
		code = "ArrowDown",
		key = "ArrowDown",
		keyCode = 40,
	},
	{
		code = "KeyG",
		key = "G",
		keyCode = 71,
	},
	{
		code = "Quote",
		key = "'",
		keyCode = 222,
	},
	{
		code = "Comma",
		key = "<",
		keyCode = 188,
	},
	{
		code = "KeyE",
		key = "e",
		keyCode = 69,
	},
	{
		code = "NumpadDecimal",
		key = "",
		keyCode = 46,
	},
	{
		code = "ArrowUp",
		key = "ArrowUp",
		keyCode = 38,
	},
	{
		code = "Semicolon",
		key = ":",
		keyCode = 186,
	},
	{
		key = "Attn",
		keyCode = 246,
	},
	{
		code = "PageUp",
		key = "PageUp",
		keyCode = 33,
	},
	{
		code = "KeyY",
		key = "Y",
		keyCode = 89,
	},
	{
		code = "KeyX",
		key = "X",
		keyCode = 88,
	},
	{
		code = "Digit6",
		key = "6",
		keyCode = 54,
	},
	{
		code = "KeyW",
		key = "W",
		keyCode = 87,
	},
	{
		code = "KeyM",
		key = "m",
		keyCode = 77,
	},
	{
		code = "Enter",
		key = "Enter",
		keyCode = 13,
		text = "\r",
	},
	{
		code = "Enter",
		key = "Enter",
		keyCode = 13,
		text = "\r",
	},
	{
		code = "NumpadSubtract",
		key = "-",
		keyCode = 109,
	},
	{
		code = "KeyU",
		key = "U",
		keyCode = 85,
	},
	{
		code = "KeyU",
		key = "u",
		keyCode = 85,
	},
	{
		key = "EraseEof",
		keyCode = 249,
	},
	{
		code = "KeyR",
		key = "R",
		keyCode = 82,
	},
	{
		code = "NumpadAdd",
		key = "+",
		keyCode = 107,
	},
	{
		code = "KeyP",
		key = "P",
		keyCode = 80,
	},
	{
		code = "F5",
		key = "F5",
		keyCode = 116,
	},
	{
		code = "BracketLeft",
		key = "[",
		keyCode = 219,
	},
	{
		key = "ZoomOut",
		keyCode = 251,
	},
	{
		code = "KeyM",
		key = "M",
		keyCode = 77,
	},
	{
		code = "F22",
		key = "F22",
		keyCode = 133,
	},
	{
		code = "Digit9",
		key = "(",
		keyCode = 57,
	},
	{
		code = "KeyK",
		key = "K",
		keyCode = 75,
	},
	{
		code = "KeyC",
		key = "C",
		keyCode = 67,
	},
	{
		code = "KeyF",
		key = "F",
		keyCode = 70,
	},
	{
		code = "Backslash",
		key = "\\",
		keyCode = 220,
	},
	{
		code = "Numpad4",
		key = "ArrowLeft",
		keyCode = 37,
	},
	{
		code = "KeyH",
		key = "H",
		keyCode = 72,
	},
	{
		code = "Digit1",
		key = "!",
		keyCode = 49,
	},
	{
		code = "MetaLeft",
		key = "Meta",
		keyCode = 91,
	},
	{
		code = "Digit3",
		key = "#",
		keyCode = 51,
	},
	{
		code = "F21",
		key = "F21",
		keyCode = 132,
	},
	{
		code = "Digit5",
		key = "%",
		keyCode = 53,
	},
	{
		code = "Digit4",
		key = "$",
		keyCode = 52,
	},
	{
		code = "KeyJ",
		key = "j",
		keyCode = 74,
	},
	{
		code = "Digit7",
		key = "&",
		keyCode = 55,
	},
	{
		code = "Digit0",
		key = ")",
		keyCode = 48,
	},
	{
		code = "KeyI",
		key = "i",
		keyCode = 73,
	},
	{
		code = "F20",
		key = "F20",
		keyCode = 131,
	},
	{
		code = "NumpadMultiply",
		key = "*",
		keyCode = 106,
	},
	{
		code = "NumpadSubtract",
		key = "-",
		keyCode = 109,
	},
	{
		code = "NumpadEqual",
		key = "=",
		keyCode = 187,
	},
	{
		code = "NumpadDivide",
		key = "/",
		keyCode = 111,
	},
	{
		code = "BracketRight",
		key = "]",
		keyCode = 221,
	},
	{
		code = "Digit1",
		key = "1",
		keyCode = 49,
	},
	{
		code = "Digit0",
		key = "0",
		keyCode = 48,
	},
	{
		code = "Digit3",
		key = "3",
		keyCode = 51,
	},
	{
		code = "Digit2",
		key = "2",
		keyCode = 50,
	},
	{
		code = "Digit5",
		key = "5",
		keyCode = 53,
	},
	{
		code = "Digit4",
		key = "4",
		keyCode = 52,
	},
	{
		code = "Digit7",
		key = "7",
		keyCode = 55,
	},
	{
		code = "Digit6",
		key = "6",
		keyCode = 54,
	},
	{
		code = "Digit9",
		key = "9",
		keyCode = 57,
	},
	{
		code = "Digit8",
		key = "8",
		keyCode = 56,
	},
	{
		code = "Semicolon",
		key = ";",
		keyCode = 186,
	},
	{
		code = "Equal",
		key = "=",
		keyCode = 187,
	},
	{
		code = "Equal",
		key = "=",
		keyCode = 187,
	},
	{
		code = "F16",
		key = "F16",
		keyCode = 127,
	},
	{
		code = "Pause",
		key = "Pause",
		keyCode = 19,
	},
	{
		code = "Period",
		key = ">",
		keyCode = 190,
	},
	{
		code = "KeyA",
		key = "A",
		keyCode = 65,
	},
	{
		code = "Digit2",
		key = "@",
		keyCode = 50,
	},
	{
		code = "MediaTrackNext",
		key = "MediaTrackNext",
		keyCode = 176,
	},
	{
		code = "KeyB",
		key = "B",
		keyCode = 66,
	},
	{
		code = "KeyE",
		key = "E",
		keyCode = 69,
	},
	{
		code = "KeyD",
		key = "D",
		keyCode = 68,
	},
	{
		key = "Print",
		keyCode = 42,
	},
	{
		code = "Convert",
		key = "Convert",
		keyCode = 28,
	},
	{
		code = "KeyI",
		key = "I",
		keyCode = 73,
	},
	{
		code = "CapsLock",
		key = "CapsLock",
		keyCode = 20,
	},
	{
		code = "Home",
		key = "Home",
		keyCode = 36,
	},
	{
		code = "KeyJ",
		key = "J",
		keyCode = 74,
	},
	{
		code = "Numpad8",
		key = "ArrowUp",
		keyCode = 38,
	},
	{
		code = "KeyL",
		key = "L",
		keyCode = 76,
	},
	{
		code = "KeyO",
		key = "O",
		keyCode = 79,
	},
	{
		code = "KeyN",
		key = "N",
		keyCode = 78,
	},
	{
		code = "KeyQ",
		key = "Q",
		keyCode = 81,
	},
	{
		code = "F23",
		key = "F23",
		keyCode = 134,
	},
	{
		code = "KeyS",
		key = "S",
		keyCode = 83,
	},
	{
		code = "Digit9",
		key = "9",
		keyCode = 57,
	},
	{
		code = "KeyY",
		key = "y",
		keyCode = 89,
	},
	{
		code = "KeyT",
		key = "T",
		keyCode = 84,
	},
	{
		code = "F7",
		key = "F7",
		keyCode = 118,
	},
	{
		code = "KeyV",
		key = "V",
		keyCode = 86,
	},
	{
		code = "KeyS",
		key = "s",
		keyCode = 83,
	},
	{
		code = "KeyV",
		key = "v",
		keyCode = 86,
	},
	{
		code = "Numpad1",
		key = "End",
		keyCode = 35,
	},
	{
		code = "KeyZ",
		key = "Z",
		keyCode = 90,
	},
	{
		code = "BracketRight",
		key = "]",
		keyCode = 221,
	},
	{
		code = "Backslash",
		key = "\\",
		keyCode = 220,
	},
	{
		code = "Minus",
		key = "_",
		keyCode = 189,
	},
	{
		code = "Digit6",
		key = "^",
		keyCode = 54,
	},
	{
		code = "AltLeft",
		key = "Alt",
		keyCode = 18,
	},
	{
		code = "Backquote",
		key = "`",
		keyCode = 192,
	},
	{
		code = "KeyC",
		key = "c",
		keyCode = 67,
	},
	{
		code = "Abort",
		key = "Cancel",
		keyCode = 3,
	},
	{
		code = "KeyE",
		key = "e",
		keyCode = 69,
	},
	{
		code = "KeyD",
		key = "d",
		keyCode = 68,
	},
	{
		code = "KeyG",
		key = "g",
		keyCode = 71,
	},
	{
		code = "KeyF",
		key = "f",
		keyCode = 70,
	},
	{
		code = "KeyI",
		key = "i",
		keyCode = 73,
	},
	{
		code = "Backspace",
		key = "Backspace",
		keyCode = 8,
	},
	{
		code = "KeyK",
		key = "k",
		keyCode = 75,
	},
	{
		code = "KeyJ",
		key = "j",
		keyCode = 74,
	},
	{
		code = "KeyM",
		key = "m",
		keyCode = 77,
	},
	{
		code = "KeyL",
		key = "l",
		keyCode = 76,
	},
	{
		code = "F24",
		key = "F24",
		keyCode = 135,
	},
	{
		code = "KeyN",
		key = "n",
		keyCode = 78,
	},
	{
		code = "KeyH",
		key = "h",
		keyCode = 72,
	},
	{
		code = "ArrowLeft",
		key = "ArrowLeft",
		keyCode = 37,
	},
	{
		code = "KeyS",
		key = "s",
		keyCode = 83,
	},
	{
		code = "KeyR",
		key = "r",
		keyCode = 82,
	},
	{
		code = "Escape",
		key = "Escape",
		keyCode = 27,
	},
	{
		code = "Numpad9",
		key = "PageUp",
		keyCode = 33,
	},
	{
		code = "KeyW",
		key = "w",
		keyCode = 87,
	},
	{
		code = "KeyG",
		key = "g",
		keyCode = 71,
	},
	{
		code = "KeyO",
		key = "o",
		keyCode = 79,
	},
	{
		code = "KeyX",
		key = "x",
		keyCode = 88,
	},
	{
		code = "BracketLeft",
		key = "{",
		keyCode = 219,
	},
	{
		code = "F12",
		key = "F12",
		keyCode = 123,
	},
	{
		code = "BracketRight",
		key = "}",
		keyCode = 221,
	},
	{
		code = "Numpad3",
		key = "PageDown",
		keyCode = 34,
	},
	{
		code = "NumpadAdd",
		key = "+",
		keyCode = 107,
	},
	{
		code = "Backquote",
		key = "~",
		keyCode = 192,
	},
	{
		code = "F11",
		key = "F11",
		keyCode = 122,
	},
	{
		code = "ArrowRight",
		key = "ArrowRight",
		keyCode = 39,
	},
	{
		code = "Numpad0",
		key = "Insert",
		keyCode = 45,
	},
	{
		code = "KeyZ",
		key = "z",
		keyCode = 90,
	},
	{
		code = "F19",
		key = "F19",
		keyCode = 130,
	},
	{
		code = "KeyY",
		key = "y",
		keyCode = 89,
	},
	{
		code = "F15",
		key = "F15",
		keyCode = 126,
	},
	{
		code = "KeyP",
		key = "p",
		keyCode = 80,
	},
	{
		code = "KeyV",
		key = "v",
		keyCode = 86,
	},
	{
		code = "Digit4",
		key = "4",
		keyCode = 52,
	},
	{
		code = "AltLeft",
		key = "Alt",
		keyCode = 18,
	},
	{
		key = "ExSel",
		keyCode = 248,
	},
	{
		code = "Quote",
		key = "'",
		keyCode = 222,
	},
	{
		code = "KeyT",
		key = "t",
		keyCode = 84,
	},
	{
		code = "Numpad2",
		key = "ArrowDown",
		keyCode = 40,
	},
	{
		code = "KeyQ",
		key = "q",
		keyCode = 81,
	},
	{
		code = "Minus",
		key = "-",
		keyCode = 189,
	},
	{
		code = "Numpad6",
		key = "ArrowRight",
		keyCode = 39,
	},
	{
		code = "KeyP",
		key = "p",
		keyCode = 80,
	},
	{
		code = "Insert",
		key = "Insert",
		keyCode = 45,
	},
	{
		code = "ShiftRight",
		key = "Shift",
		keyCode = 16,
	},
	{
		code = "NumpadEnter",
		key = "Enter",
		keyCode = 13,
		text = "\r",
	},
	{
		code = "KeyA",
		key = "a",
		keyCode = 65,
	},
	{
		code = "KeyO",
		key = "o",
		keyCode = 79,
	},
	{
		code = "KeyH",
		key = "h",
		keyCode = 72,
	},
	{
		code = "KeyB",
		key = "b",
		keyCode = 66,
	},
	{
		code = "KeyA",
		key = "a",
		keyCode = 65,
	},
	{
		code = "ContextMenu",
		key = "ContextMenu",
		keyCode = 93,
	},
	{
		code = "F9",
		key = "F9",
		keyCode = 120,
	},
	{
		code = "ShiftLeft",
		key = "Shift",
		keyCode = 16,
	},
	{
		code = "Numpad7",
		key = "Home",
		keyCode = 36,
	},
	{
		code = "KeyF",
		key = "f",
		keyCode = 70,
	},
	{
		code = "Space",
		key = " ",
		keyCode = 32,
	},
	{
		key = "ModeChange",
		keyCode = 31,
	},
	{
		key = "Accept",
		keyCode = 30,
	},
	{
		code = "KeyL",
		key = "l",
		keyCode = 76,
	},
	{
		code = "Comma",
		key = ",",
		keyCode = 188,
	},
	{
		code = "ControlLeft",
		key = "Control",
		keyCode = 17,
	},
	{
		code = "Digit7",
		key = "7",
		keyCode = 55,
	},
	{
		code = "F18",
		key = "F18",
		keyCode = 129,
	},
	{
		code = "ShiftLeft",
		key = "Shift",
		keyCode = 16,
	},
	{
		code = "KeyR",
		key = "r",
		keyCode = 82,
	},
	{
		code = "Numpad5",
		key = "Clear",
		keyCode = 12,
	},
	{
		code = "Abort",
		key = "Cancel",
		keyCode = 3,
	},
	{
		code = "Props",
		key = "CrSel",
		keyCode = 247,
	},
	{
		code = "BracketLeft",
		key = "[",
		keyCode = 219,
	},
	{
		code = "Eject",
		key = "Eject",
	},
	{
		code = "Slash",
		key = "/",
		keyCode = 191,
	},
	{
		code = "NumpadDivide",
		key = "/",
		keyCode = 111,
	},
	{
		code = "Period",
		key = ".",
		keyCode = 190,
	},
	{
		code = "AudioVolumeMute",
		key = "AudioVolumeMute",
		keyCode = 173,
	},
	{
		code = "Power",
		key = "Power",
	},
	{
		code = "KeyK",
		key = "k",
		keyCode = 75,
	},
	{
		code = "MediaStop",
		key = "MediaStop",
		keyCode = 178,
	},
	{
		code = "KeyD",
		key = "d",
		keyCode = 68,
	},
	{
		code = "AudioVolumeDown",
		key = "AudioVolumeDown",
		keyCode = 174,
	},
	{
		code = "Semicolon",
		key = ";",
		keyCode = 186,
	},
	{
		code = "KeyQ",
		key = "q",
		keyCode = 81,
	},
	{
		code = "NumLock",
		key = "NumLock",
		keyCode = 144,
	},
	{
		code = "ControlLeft",
		key = "Control",
		keyCode = 17,
	},
	{
		code = "F17",
		key = "F17",
		keyCode = 128,
	},
	{
		code = "KeyZ",
		key = "z",
		keyCode = 90,
	},
	{
		code = "F8",
		key = "F8",
		keyCode = 119,
	},
	{
		code = "F13",
		key = "F13",
		keyCode = 124,
	},
	{
		code = "Numpad5",
		key = "Clear",
		keyCode = 12,
	},
	{
		code = "MetaRight",
		key = "Meta",
		keyCode = 92,
	},
	{
		code = "F10",
		key = "F10",
		keyCode = 121,
	},
	{
		code = "Digit0",
		key = "0",
		keyCode = 48,
	},
	{
		code = "Open",
		key = "Execute",
		keyCode = 43,
	},
	{
		code = "F6",
		key = "F6",
		keyCode = 117,
	},
	{
		code = "PageDown",
		key = "PageDown",
		keyCode = 34,
	},
	{
		code = "PrintScreen",
		key = "PrintScreen",
		keyCode = 44,
	},
	{
		code = "F4",
		key = "F4",
		keyCode = 115,
	},
	{
		code = "ScrollLock",
		key = "ScrollLock",
		keyCode = 145,
	},
	{
		code = "ControlRight",
		key = "Control",
		keyCode = 17,
	},
	{
		code = "F1",
		key = "F1",
		keyCode = 112,
	},
	{
		code = "Space",
		key = " ",
		keyCode = 32,
	},
	{
		code = "Props",
		key = "CrSel",
		keyCode = 247,
	},
	{
		key = "Play",
		keyCode = 250,
	},
	{
		code = "F14",
		key = "F14",
		keyCode = 125,
	},
	{
		code = "KeyU",
		key = "u",
		keyCode = 85,
	},
	{
		code = "KeyX",
		key = "x",
		keyCode = 88,
	},
	{
		code = "KeyW",
		key = "w",
		keyCode = 87,
	},
	{
		code = "F3",
		key = "F3",
		keyCode = 114,
	},
	{
		code = "KeyN",
		key = "n",
		keyCode = 78,
	},
	{
		code = "AudioVolumeUp",
		key = "AudioVolumeUp",
		keyCode = 175,
	},
	{
		code = "KeyC",
		key = "c",
		keyCode = 67,
	},
	{
		code = "KeyB",
		key = "b",
		keyCode = 66,
	},
	{
		code = "Digit8",
		key = "8",
		keyCode = 56,
	},
	{
		code = "NumpadDecimal",
		key = "",
		keyCode = 46,
	},
	{
		code = "Digit5",
		key = "5",
		keyCode = 53,
	},
	{
		code = "Delete",
		key = "Delete",
		keyCode = 46,
	},
	{
		code = "Digit2",
		key = "2",
		keyCode = 50,
	},
	{
		code = "Digit1",
		key = "1",
		keyCode = 49,
	},
	{
		code = "Digit3",
		key = "3",
		keyCode = 51,
	},
	{
		code = "Select",
		key = "Select",
		keyCode = 41,
	},
}

local function findKeyDefinition(key: string): KeyDefinition?
	for _, definition in keyboardLayout do
		if definition.key == key then
			return definition
		end
	end

	return nil
end

return {
	keyboardLayout = keyboardLayout,
	findKeyDefinition = findKeyDefinition,
}

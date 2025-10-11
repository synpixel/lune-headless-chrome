local types = require("../types")
local Page = require("../protocol/page")

export type BoxModel = types.BoxModel

local function content_viewport(box_model: BoxModel): Page.Viewport
	return {
		x = box_model.content.top_left.x,
		y = box_model.content.top_left.y,
		width = box_model.content:width(),
		height = box_model.content:height(),
		scale = 1,
	}
end

local function padding_viewport(box_model: BoxModel): Page.Viewport
	return {
		x = box_model.padding.top_left.x,
		y = box_model.padding.top_left.y,
		width = box_model.padding:width(),
		height = box_model.padding:height(),
		scale = 1,
	}
end

local function border_viewport(box_model: BoxModel): Page.Viewport
	return {
		x = box_model.border.top_left.x,
		y = box_model.border.top_left.y,
		width = box_model.border:width(),
		height = box_model.border:height(),
		scale = 1,
	}
end

local function margin_viewport(box_model: BoxModel): Page.Viewport
	return {
		x = box_model.margin.top_left.x,
		y = box_model.margin.top_left.y,
		width = box_model.margin:width(),
		height = box_model.margin:height(),
		scale = 1,
	}
end

--- @within BoxModel
local function create(box_model: {
	content: types.ElementQuad,
	padding: types.ElementQuad,
	border: types.ElementQuad,
	margin: types.ElementQuad,
	width: number,
	height: number,
}): BoxModel
	return {
		content = box_model.content,
		padding = box_model.padding,
		border = box_model.border,
		margin = box_model.margin,
		width = box_model.width,
		height = box_model.height,
		content_viewport = content_viewport,
		padding_viewport = padding_viewport,
		border_viewport = border_viewport,
		margin_viewport = margin_viewport,
	}
end

return { create = create }

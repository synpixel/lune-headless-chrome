local types = require("../types")

export type ElementQuad = types.ElementQuad

local function height(element_quad: ElementQuad): number
	return element_quad.bottom_left.y - element_quad.top_left.y
end

local function width(element_quad: ElementQuad): number
	return element_quad.top_right.x - element_quad.top_left.x
end

local function aspect_ratio(element_quad: ElementQuad): number
	return element_quad:width() / element_quad:height()
end

local function most_left(element_quad: ElementQuad): number
	return math.min(
		element_quad.top_right.x,
		element_quad.top_left.x,
		element_quad.bottom_right.x,
		element_quad.bottom_left.x
	)
end

local function most_right(element_quad: ElementQuad): number
	return math.max(
		element_quad.top_right.x,
		element_quad.top_left.x,
		element_quad.bottom_right.x,
		element_quad.bottom_left.x
	)
end

local function most_top(element_quad: ElementQuad): number
	return math.min(
		element_quad.top_right.y,
		element_quad.top_left.y,
		element_quad.bottom_right.y,
		element_quad.bottom_left.y
	)
end

local function most_bottom(element_quad: ElementQuad): number
	return math.max(
		element_quad.top_right.y,
		element_quad.top_left.y,
		element_quad.bottom_right.y,
		element_quad.bottom_left.y
	)
end

local function strictly_above(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_bottom() < other:most_top()
end

local function above(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_bottom() <= other:most_top()
end

local function strictly_below(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_top() > other:most_bottom()
end

local function below(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_top() >= other:most_bottom()
end

local function strictly_left_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_right() < other:most_left()
end

local function left_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_right() <= other:most_left()
end

local function strictly_right_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_left() > other:most_right()
end

local function right_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_left() >= other:most_right()
end

local function within_horizontal_bounds_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_left() >= other:most_left() and element_quad:most_right() <= other:most_right()
end

local function within_vertical_bounds_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:most_top() >= other:most_top() and element_quad:most_bottom() <= other:most_bottom()
end

local function within_bounds_of(element_quad: ElementQuad, other: ElementQuad): boolean
	return element_quad:within_horizontal_bounds_of(other) and element_quad:within_vertical_bounds_of(other)
end

--- @within ElementQuad
local function from_raw_points(raw_quad: { number }): ElementQuad
	return {
		top_left = vector.create(raw_quad[1], raw_quad[2]),
		top_right = vector.create(raw_quad[3], raw_quad[4]),
		bottom_right = vector.create(raw_quad[5], raw_quad[6]),
		bottom_left = vector.create(raw_quad[7], raw_quad[8]),
		height = height,
		width = width,
		aspect_ratio = aspect_ratio,
		most_left = most_left,
		most_right = most_right,
		most_top = most_top,
		most_bottom = most_bottom,
		strictly_above = strictly_above,
		above = above,
		strictly_below = strictly_below,
		below = below,
		strictly_left_of = strictly_left_of,
		left_of = left_of,
		strictly_right_of = strictly_right_of,
		right_of = right_of,
		within_horizontal_bounds_of = within_horizontal_bounds_of,
		within_vertical_bounds_of = within_vertical_bounds_of,
		within_bounds_of = within_bounds_of,
	}
end

return { from_raw_points = from_raw_points }

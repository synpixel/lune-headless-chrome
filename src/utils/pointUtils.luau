local types = require("../types")

local function addPoints(pointA: types.Point, pointB: types.Point): types.Point
	return { x = pointA.x + pointB.x, y = pointA.y + pointB.y }
end

return { addPoints = addPoints }

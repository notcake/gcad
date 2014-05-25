GCAD.UnpackedCircle2d = {}

local GCAD_Vector2d_DistanceTo           = GCAD.Vector2d.DistanceTo
local GCAD_UnpackedVector2d_DistanceTo   = GCAD.UnpackedVector2d.DistanceTo
local GCAD_Vector2d_Unpack = GCAD.UnpackedVector2d.FromVector2d

function GCAD.UnpackedCircle2d.FromPositionAndRadius (position, radius)
	return position [1], position [2], radius
end

-- Circle properties
function GCAD.UnpackedCircle2d.GetPosition (x, y, r, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = x
	out [2] = y
	
	return out
end

function GCAD.UnpackedCircle2d.GetPositionUnpacked (x, y, r)
	return x, y
end

function GCAD.UnpackedCircle2d.GetRadius (x, y, r)
	return r
end

function GCAD.UnpackedCircle2d.SetPosition (x, y, r, pos)
	return pos [1], pos [2], r
end

function GCAD.UnpackedCircle2d.SetPositionUnpacked (x, y, r, x1, y1)
	return x1, y1, r
end

function GCAD.UnpackedCircle2d.SetRadius (x, y, r, r1)
	return x, y, r1
end

-- Circle queries
function GCAD.UnpackedCircle2d.DistanceToPoint (x, y, r, v2d)
	return GCAD_UnpackedVector2d_DistanceTo (x, y, v2d [1], v2d [2]) - r
end

function GCAD.UnpackedCircle2d.DistanceToUnpackedPoint (x, y, r, x1, y1)
	return GCAD_UnpackedVector2d_DistanceTo (x, y, x1, y1) - r
end

-- Intersection tests
-- Point
local GCAD_UnpackedCircle2d_DistanceToPoint         = GCAD.UnpackedCircle2d.DistanceToPoint
local GCAD_UnpackedCircle2d_DistanceToUnpackedPoint = GCAD.UnpackedCircle2d.DistanceToUnpackedPoint

function GCAD.UnpackedCircle2d.ContainsPoint (x, y, r, v2d)
	return GCAD_UnpackedCircle2d_DistanceToPoint (x, y, r, v2d) < 0
end

function GCAD.UnpackedCircle2d.ContainsUnpackedPoint (x, y, r, x1, y1)
	return GCAD_UnpackedCircle2d_DistanceToUnpackedPoint (x, y, r, x1, y1) < 0
end

-- Circle
function GCAD.UnpackedCircle2d.ContainsCircle (x, y, r, circle2d)
	local distance = GCAD_UnpackedVector2d_DistanceTo (x, y, circle2d:GetPositionUnpacked ())
	return distance + circle2d [3] < r
end

function GCAD.UnpackedCircle2d.ContainsUnpackedCircle (x, y, r, x1, y1, r1)
	local distance = GCAD_UnpackedVector2d_DistanceTo (x, y, x1, y1)
	return distance + r1 < r
end

function GCAD.UnpackedCircle2d.IntersectsCircle (x, y, r, circle2d)
	local distance = GCAD_UnpackedVector2d_DistanceTo (x, y, circle2d:GetPositionUnpacked ())
	local circleRadius = circle2d [3]
	if distance + circleRadius < r then return true, true  end -- circle lies within this circle
	if distance - circleRadius < r then return true, false end -- centre lies outside, but edge intersects this circle
	return false, false
end

function GCAD.UnpackedCircle2d.IntersectsUnpackedCircle (x, y, r, x1, y1, r1)
	local distance = GCAD_UnpackedVector2d_DistanceTo (x, y, x1, y1)
	if distance + r1 < r then return true, true  end -- circle lies within this circle
	if distance - r1 < r then return true, false end -- centre lies outside, but edge intersects this circle
	return false, false
end

-- Utility
function GCAD.UnpackedCircle2d.ToString (x, y, r)
	return "Circle [(" .. tostring (x) .. ", " .. tostring (y) .. "), " .. tostring (r) .. "]"
end

-- Construction
function GCAD.UnpackedCircle2d.Minimum ()
	return 0, 0, -math.huge
end

function GCAD.UnpackedCircle2d.Maximum ()
	return 0, 0, math.huge
end
GCAD.UnpackedPlane2d = {}

local GCAD_Vector2d_Dot            = GCAD.Vector2d.Dot
local GCAD_UnpackedVector2d_Dot    = GCAD.UnpackedVector2d.Dot
local GCAD_UnpackedVector2d_Length = GCAD.UnpackedVector2d.Length

function GCAD.UnpackedPlane2d.FromPositionAndNormal (position, normal)
	-- ax + by + c = 0
	-- c = -normal . position
	return normal [1], normal [2], -GCAD_Vector2d_Dot (position, normal)
end

-- Plane properties
function GCAD.UnpackedPlane2d.GetNormal (a, b, c, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a
	out [2] = b
	
	return out
end

function GCAD.UnpackedPlane2d.GetNormalUnpacked (a, b, c)
	return a, b
end

function GCAD.UnpackedPlane2d.GetNormalLength (a, b, c)
	return GCAD_UnpackedVector2d_Length (a, b)
end

function GCAD.UnpackedPlane2d.SetNormal (a, b, c, normal)
	return normal [1], normal [2], c
end

function GCAD.UnpackedPlane2d.SetNormalUnpacked (a, b, c, x, y)
	return x, y, c
end

-- Plane operations
local GCAD_UnpackedPlane2d_GetNormalLength = GCAD.UnpackedPlane2d.GetNormalLength

function GCAD.UnpackedPlane2d.Flip (a, b, c)
	return -a, -b, -c
end

function GCAD.UnpackedPlane2d.Normalize (a, b, c)
	local length = GCAD_UnpackedPlane2d_GetNormalLength (a, b, c)
	return a / length, b / length, c / length
end

-- Plane queries
function GCAD.UnpackedPlane2d.DistanceToPoint (a, b, c, v2d)
	return (GCAD_UnpackedVector2d_Dot (a, b, v2d [1], v2d [2]) + c) / GCAD_UnpackedPlane2d_GetNormalLength (a, b, c)
end

function GCAD.UnpackedPlane2d.DistanceToUnpackedPoint (self, x, y)
	return (GCAD_UnpackedVector2d_Dot (a, b, x, y) + c) / GCAD_UnpackedPlane2d_GetNormalLength (a, b, c)
end

function GCAD.UnpackedPlane2d.ScaledDistanceToPoint (a, b, c, v2d)
	return GCAD_UnpackedVector2d_Dot (a, b, v2d [1], v2d [2]) + c
end

function GCAD.UnpackedPlane2d.ScaledDistanceToUnpackedPoint (a, b, c, x, y)
	return GCAD_UnpackedVector2d_Dot (a, b, x, y) + c
end

-- Intersection tests
local GCAD_UnpackedPlane2d_DistanceToPoint               = GCAD.UnpackedPlane2d.DistanceToPoint
local GCAD_UnpackedPlane2d_DistanceToUnpackedPoint       = GCAD.UnpackedPlane2d.DistanceToUnpackedPoint
local GCAD_UnpackedPlane2d_ScaledDistanceToPoint         = GCAD.UnpackedPlane2d.ScaledDistanceToPoint
local GCAD_UnpackedPlane2d_ScaledDistanceToUnpackedPoint = GCAD.UnpackedPlane2d.ScaledDistanceToUnpackedPoint

-- Point
function GCAD.UnpackedPlane2d.ContainsPoint (a, b, c, v2d)
	return GCAD_UnpackedPlane2d_ScaledDistanceToPoint (a, b, c, v2d) < 0
end

function GCAD.UnpackedPlane2d.ContainsUnpackedPoint (a, b, c, x, y)
	return GCAD_UnpackedPlane2d_ScaledDistanceToUnpackedPoint (a, b, c, x, y) < 0
end

function GCAD.UnpackedPlane2d.ContainsCircle (a, b, c, circle2d)
	local distance = GCAD_UnpackedPlane2d_DistanceToPoint (a, b, c, circle2d)
	return distance + circle2d [3] < 0
end

function GCAD.UnpackedPlane2d.ContainsUnpackedCircle (a, b, c, x, y, r)
	local distance = GCAD_UnpackedPlane2d_DistanceToUnpackedPoint (a, b, c, x, y)
	return distance + r < 0
end

-- Circle
function GCAD.UnpackedPlane2d.IntersectsCircle (a, b, c, circle2d)
	local distance = GCAD_UnpackedPlane2d_DistanceToPoint (a, b, c, circle2d)
	local circleRadius = circle2d [3]
	if distance + circleRadius < 0 then return true, true  end -- circle lies within this plane
	if distance - circleRadius < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.UnpackedPlane2d.IntersectsUnpackedCircle (a, b, c, x, y, r)
	local distance = GCAD_UnpackedPlane2d_DistanceToUnpackedPoint (a, b, c, x, y)
	if distance + r < 0 then return true, true  end -- circle lies within this plane
	if distance - r < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

-- Box
local GCAD_UnpackedPlane2d_ContainsUnpackedPoint = GCAD.UnpackedPlane2d.ContainsUnpackedPoint

function GCAD.UnpackedPlane2d.ContainsAABB (a, b, c, aabb2d)
	local farCornerId, nearCornerId = aabb2d:GetExtremeCornerIdsUnpacked (a, b)
	
	return GCAD_UnpackedPlane2d_ContainsUnpackedPoint (a, b, c, aabb2d:GetCornerUnpacked (farCornerId))
end

function GCAD.UnpackedPlane2d.IntersectsAABB (a, b, c, aabb2d)
	local farCornerId, nearCornerId = aabb2d:GetExtremeCornerIdsUnpacked (a, b)
	
	return GCAD_UnpackedPlane2d_ContainsUnpackedPoint (a, b, c, aabb2d:GetCornerUnpacked (nearCornerId))
end

GCAD.UnpackedPlane2d.ContainsOBB   = GCAD.UnpackedPlane2d.ContainsAABB
GCAD.UnpackedPlane2d.IntersectsOBB = GCAD.UnpackedPlane2d.IntersectsAABB

-- Conversion
function GCAD.UnpackedPlane2d.FromLine2d (line)
	local a, b = line:GetDirectionUnpacked ()
	a, b = -b, a
	
	return a, b, -GCAD_UnpackedVector2d_Dot (a, b, line:GetPositionUnpacked ())
end

function GCAD.UnpackedPlane2d.ToLine2d (a, b, c, out)
	out = out or GCAD.Line2d ()
	
	out:SetDirectionUnpacked (-b, a)
	out:SetPositionUnpacked (-c * a, -c * b)
	
	return out
end

-- Utility
function GCAD.UnpackedPlane2d.ToString (a, b, c)
	return "Plane [(" .. tostring (a) .. ", " .. tostring (b) .. "), " .. tostring (c) .. "]"
end

-- Construction
function GCAD.UnpackedPlane2d.Minimum ()
	return 1, 0, math.huge
end

function GCAD.UnpackedPlane2d.Maximum ()
	return 1, 0, -math.huge
end
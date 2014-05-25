GCAD.UnpackedNormalizedPlane2d = {}

local GCAD_Vector2d_Dot               = GCAD.Vector2d.Dot
local GCAD_Vector2d_Length            = GCAD.Vector2d.Length
local GCAD_UnpackedVector2d_Length    = GCAD.UnpackedVector2d.Length
local GCAD_UnpackedVector2d_Normalize = GCAD.UnpackedVector2d.Normalize

function GCAD.UnpackedNormalizedPlane2d.FromPositionAndNormal (position, normal)
	-- ax + by + c = 0
	-- c = -normal . position
	local length = GCAD_Vector2d_Length (normal)
	return normal [1] / length, normal [2] / length, -GCAD_Vector2d_Dot (position, normal) / length
end

-- Plane properties
GCAD.UnpackedNormalizedPlane2d.GetNormal                     = GCAD.UnpackedPlane2d.GetNormal
GCAD.UnpackedNormalizedPlane2d.GetNormalUnpacked             = GCAD.UnpackedPlane2d.GetNormalUnpacked
GCAD.UnpackedNormalizedPlane2d.GetNormalLength               = GCAD.UnpackedPlane2d.GetNormalLength

function GCAD.UnpackedNormalizedPlane2d.SetNormal (a, b, c, normal)
	local length = GCAD_Vector2d_Length (normal)
	return normal [1] / length, normal [2] / length, c
end

function GCAD.UnpackedNormalizedPlane2d.SetNormalUnpacked (a, b, c, x, y)
	local length = GCAD_UnpackedVector2d_Length (x, y)
	return x / length, y / length, c
end

-- Plane operations
GCAD.UnpackedNormalizedPlane2d.Flip                          = GCAD.UnpackedPlane2d.Flip
GCAD.UnpackedNormalizedPlane2d.Normalize                     = GCAD.UnpackedPlane2d.Normalize

-- Plane queries
GCAD.UnpackedNormalizedPlane2d.DistanceToPoint               = GCAD.UnpackedPlane2d.ScaledDistanceToPoint
GCAD.UnpackedNormalizedPlane2d.DistanceToUnpackedPoint       = GCAD.UnpackedPlane2d.ScaledDistanceToUnpackedPoint
GCAD.UnpackedNormalizedPlane2d.ScaledDistanceToPoint         = GCAD.UnpackedPlane2d.ScaledDistanceToPoint
GCAD.UnpackedNormalizedPlane2d.ScaledDistanceToUnpackedPoint = GCAD.UnpackedPlane2d.ScaledDistanceToUnpackedPoint

-- Intersection tests
local GCAD_UnpackedNormalizedPlane2d_DistanceToPoint         = GCAD.UnpackedNormalizedPlane2d.DistanceToPoint
local GCAD_UnpackedNormalizedPlane2d_DistanceToUnpackedPoint = GCAD.UnpackedNormalizedPlane2d.DistanceToUnpackedPoint

-- Point
GCAD.UnpackedNormalizedPlane2d.ContainsPoint                 = GCAD.UnpackedPlane2d.ContainsPoint
GCAD.UnpackedNormalizedPlane2d.ContainsUnpackedPoint         = GCAD.UnpackedPlane2d.ContainsUnpackedPoint

-- Circle
function GCAD.UnpackedNormalizedPlane2d.ContainsCircle (a, b, c, circle2d)
	local distance = GCAD_UnpackedNormalizedPlane2d_DistanceToPoint (a, b, c, circle2d)
	return distance + circle2d [3] < 0
end

function GCAD.UnpackedNormalizedPlane2d.ContainsUnpackedCircle (a, b, c, x, y, r)
	local distance = GCAD_UnpackedNormalizedPlane2d_DistanceToUnpackedPoint (a, b, c, x, y)
	return distance + r < 0
end

function GCAD.UnpackedNormalizedPlane2d.IntersectsCircle (a, b, c, circle2d)
	local distance = GCAD_UnpackedNormalizedPlane2d_DistanceToPoint (a, b, c, circle2d)
	local circleRadius = circle2d [3]
	if distance + circleRadius < 0 then return true, true  end -- circle lies within this plane
	if distance - circleRadius < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.UnpackedNormalizedPlane2d.IntersectsUnpackedCircle (a, b, c, x, y, r)
	local distance = GCAD_UnpackedNormalizedPlane2d_DistanceToUnpackedPoint (a, b, c, x, y)
	if distance + r < 0 then return true, true  end -- circle lies within this plane
	if distance - r < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

-- Box
GCAD.UnpackedNormalizedPlane2d.ContainsAABB                  = GCAD.UnpackedPlane2d.ContainsAABB
GCAD.UnpackedNormalizedPlane2d.IntersectsAABB                = GCAD.UnpackedPlane2d.IntersectsAABB
GCAD.UnpackedNormalizedPlane2d.ContainsOBB                   = GCAD.UnpackedPlane2d.ContainsOBB
GCAD.UnpackedNormalizedPlane2d.IntersectsOBB                 = GCAD.UnpackedPlane2d.IntersectsOBB

-- Conversion
function GCAD.UnpackedNormalizedPlane2d.FromLine2d (line)
	local a, b = line:GetDirectionUnpacked ()
	a, b = GCAD_UnpackedVector2d_Normalize (-b, a)
	
	return a, b, -GCAD_UnpackedVector2d_Dot (a, b, line:GetPositionUnpacked ())
end

GCAD.UnpackedNormalizedPlane2d.ToLine2d                      = GCAD.UnpackedPlane2d.ToLine2d

-- Utility
GCAD.UnpackedNormalizedPlane2d.ToString                      = GCAD.UnpackedPlane2d.ToString

-- Construction
GCAD.UnpackedNormalizedPlane2d.Minimum                       = GCAD.UnpackedPlane2d.Minimum
GCAD.UnpackedNormalizedPlane2d.Maximum                       = GCAD.UnpackedPlane2d.Maximum
GCAD.UnpackedEulerAngle = {}

local Angle                                = Angle

local Angle___index                        = debug.getregistry ().Angle.__index
local Angle___newindex                     = debug.getregistry ().Angle.__newindex

local math_atan2                           = math.atan2
local math_cos                             = math.cos
local math_deg                             = math.deg
local math_rad                             = math.rad
local math_sin                             = math.sin

local GCAD_Vector2d_Length                 = GCAD.Vector2d.Length
local GCAD_UnpackedVector2d_Length         = GCAD.UnpackedVector2d.Length
local GCAD_UnpackedVector3d_ToNativeVector = GCAD.UnpackedVector3d.ToNativeVector
local GCAD_UnpackedVector3d_ToVector3d     = GCAD.UnpackedVector3d.ToVector3d

-- Equality
function GCAD.UnpackedEulerAngle.Equals (p1, y1, r1, p2, y2, r2)
	return p1 == p2 and
	       y1 == y2 and
		   r1 == r2
end

-- NaN
function GCAD.UnpackedEulerAngle.ContainsNaN (p, y, r)
	return p ~= p or
	       y ~= y or
		   r ~= r
end

-- Directions

-- Pitch
-- Anticlockwise about the y axis, looking from positive y towards the origin
-- Tilts the camera down

-- Yaw
-- Anticlockwise about the z axis, looking from above (positive z towards down towards the origin)
-- Turns the camera left

-- Roll
-- Anticlockwise about the x axis, looking from position x towards the origin
-- Clockwise about the x axis, looking out from the origin
-- Rotates the camera clockwise about its axis

function GCAD.UnpackedEulerAngle.GetPositiveXUnpacked (p, y, r)
	local p = math_rad (p)
	local y = math_rad (y)
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	
	return cosp * cosy,
	       cosp * siny,
	             -sinp
end

function GCAD.UnpackedEulerAngle.GetPositiveYUnpacked (p, y, r)
	local p = math_rad (p)
	local y = math_rad (y)
	local r = math_rad (r)
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	local cosr, sinr = math_cos (r), math_sin (r)
	
	return sinp * sinr * cosy - cosr * siny,
	       sinp * sinr * siny + cosr * cosy,
	                            cosp * sinr
end

function GCAD.UnpackedEulerAngle.GetPositiveZUnpacked (p, y, r)
	local p = math_rad (p)
	local y = math_rad (y)
	local r = math_rad (r)
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	local cosr, sinr = math_cos (r), math_sin (r)
	
	return cosr * sinp * cosy + sinr * siny,
	       cosr * sinp * siny - sinr * cosy,
	                            cosp * cosr
end

local GCAD_UnpackedEulerAngle_GetPositiveXUnpacked = GCAD.UnpackedEulerAngle.GetPositiveXUnpacked
local GCAD_UnpackedEulerAngle_GetPositiveYUnpacked = GCAD.UnpackedEulerAngle.GetPositiveYUnpacked
local GCAD_UnpackedEulerAngle_GetPositiveZUnpacked = GCAD.UnpackedEulerAngle.GetPositiveZUnpacked

function GCAD.UnpackedEulerAngle.GetPositiveX (p, y, r, out)
	local x, y, z = GCAD_UnpackedEulerAngle_GetPositiveXUnpacked (p, y, r)
	return GCAD_UnpackedVector3d_ToVector3d (x, y, z, out)
end

function GCAD.UnpackedEulerAngle.GetPositiveXNative (p, y, r, out)
	local x, y, z = GCAD_UnpackedEulerAngle_GetPositiveXUnpacked (p, y, r)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

function GCAD.UnpackedEulerAngle.GetPositiveY (p, y, r, out)
	local x, y, z = GCAD_UnpackedEulerAngle_GetPositiveYUnpacked (p, y, r)
	return GCAD_UnpackedVector3d_ToVector3d (x, y, z, out)
end

function GCAD.UnpackedEulerAngle.GetPositiveYNative (p, y, r, out)
	local x, y, z = GCAD_UnpackedEulerAngle_GetPositiveYUnpacked (p, y, r)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

function GCAD.UnpackedEulerAngle.GetPositiveZ (p, y, r, out)
	local x, y, z = GCAD_UnpackedEulerAngle_GetPositiveZUnpacked (p, y, r)
	return GCAD_UnpackedVector3d_ToVector3d (x, y, z, out)
end

function GCAD.UnpackedEulerAngle.GetPositiveZNative (p, y, r, out)
	local x, y, z = GCAD_UnpackedEulerAngle_GetPositiveZUnpacked (p, y, r)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

GCAD.UnpackedEulerAngle.GetForwards         = GCAD.UnpackedEulerAngle.GetPositiveX
GCAD.UnpackedEulerAngle.GetForwardsNative   = GCAD.UnpackedEulerAngle.GetPositiveXNative
GCAD.UnpackedEulerAngle.GetForwardsUnpacked = GCAD.UnpackedEulerAngle.GetPositiveXUnpacked
GCAD.UnpackedEulerAngle.GetLeft             = GCAD.UnpackedEulerAngle.GetPositiveY
GCAD.UnpackedEulerAngle.GetLeftNative       = GCAD.UnpackedEulerAngle.GetPositiveYNative
GCAD.UnpackedEulerAngle.GetLeftUnpacked     = GCAD.UnpackedEulerAngle.GetPositiveYUnpacked
GCAD.UnpackedEulerAngle.GetUp               = GCAD.UnpackedEulerAngle.GetPositiveZ
GCAD.UnpackedEulerAngle.GetUpNative         = GCAD.UnpackedEulerAngle.GetPositiveZNative
GCAD.UnpackedEulerAngle.GetUpUnpacked       = GCAD.UnpackedEulerAngle.GetPositiveZUnpacked

-- Conversion
function GCAD.UnpackedEulerAngle.ToMatrix3x3 (p, y, r, out)
	out = out or GCAD.Matrix3x3 ()
	
	local p = math_rad (p)
	local y = math_rad (y)
	local r = math_rad (r)
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	local cosr, sinr = math_cos (r), math_sin (r)
	
	out:Set (
		cosp * cosy, sinp * sinr * cosy - cosr * siny, cosr * sinp * cosy + sinr * siny,
		cosp * siny, sinp * sinr * siny + cosr * cosy, cosr * sinp * siny - sinr * cosy,
		      -sinp,                      cosp * sinr,                      cosp * cosr
	)
	
	return out
end

function GCAD.UnpackedEulerAngle.ToMatrix4x4 (p, y, r, out)
	out = out or GCAD.Matrix4x4 ()
	
	local p = math_rad (p)
	local y = math_rad (y)
	local r = math_rad (r)
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	local cosr, sinr = math_cos (r), math_sin (r)
	
	out:Set (
		cosp * cosy, sinp * sinr * cosy - cosr * siny, cosr * sinp * cosy + sinr * siny, 0,
		cosp * siny, sinp * sinr * siny + cosr * cosy, cosr * sinp * siny - sinr * cosy, 0,
		      -sinp,                      cosp * sinr,                      cosp * cosr, 0,
		          0,                                0,                                0, 1
	)
	
	return out
end

function GCAD.UnpackedEulerAngle.FromDirection (forwards)
	return math_deg (math_atan2 (forwards [3], GCAD_Vector2d_Length (forwards))),
	       math_deg (math_atan2 (forwards [2], forwards [1])),
		   0
end

function GCAD.UnpackedEulerAngle.FromUnpackedDirection (x, y, z)
	return math_deg (math_atan2 (z, GCAD_UnpackedVector2d_Length (x, y))),
	       math_deg (math_atan2 (y, x)),
		   0
end

function GCAD.UnpackedEulerAngle.FromNativeAngle (angle)
	return Angle___index (out, 1), Angle___index (out, 2), Angle___index (out, 3)
end

function GCAD.UnpackedEulerAngle.ToNativeAngle (p, y, r, out)
	out = out or Angle ()
	
	Angle___newindex (out, 1, p)
	Angle___newindex (out, 2, y)
	Angle___newindex (out, 3, r)
	
	return out
end

-- Utility
function GCAD.UnpackedEulerAngle.ToString (p, y, r)
	return "(" .. tostring (p) .. ", " .. tostring (y) .. ", " .. tostring (r) .. ")"
end
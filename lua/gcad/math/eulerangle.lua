local self = {}
GCAD.EulerAngle = GCAD.MakeConstructor (self)

local math_atan2                           = math.atan2
local math_cos                             = math.cos
local math_deg                             = math.deg
local math_rad                             = math.rad
local math_sin                             = math.sin

local Angle                                = Angle

local Angle___index                        = debug.getregistry ().Angle.__index
local Angle___newindex                     = debug.getregistry ().Angle.__newindex

local GCAD_Vector2d_Length                 = GCAD.Vector2d.Length
local GCAD_UnpackedVector2d_Length         = GCAD.UnpackedVector2d.Length
local GCAD_UnpackedVector3d_ToNativeVector = GCAD.UnpackedVector3d.ToNativeVector
local GCAD_UnpackedVector3d_ToVector3d     = GCAD.UnpackedVector3d.ToVector3d

-- Copying
function GCAD.EulerAngle.Clone (self, out)
	out = out or GCAD.EulerAngle ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function GCAD.EulerAngle.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	
	return self
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

function GCAD.EulerAngle.GetPositiveXUnpacked (self)
	local p = math_rad (self [1])
	local y = math_rad (self [2])
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	
	return cosp * cosy,
	       cosp * siny,
	             -sinp
end

function GCAD.EulerAngle.GetPositiveYUnpacked (self)
	local p = math_rad (self [1])
	local y = math_rad (self [2])
	local r = math_rad (self [3])
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	local cosr, sinr = math_cos (r), math_sin (r)
	
	return sinp * sinr * cosy - cosr * siny,
	       sinp * sinr * siny + cosr * cosy,
	                            cosp * sinr
end

function GCAD.EulerAngle.GetPositiveZUnpacked (self)
	local p = math_rad (self [1])
	local y = math_rad (self [2])
	local r = math_rad (self [3])
	local cosp, sinp = math_cos (p), math_sin (p)
	local cosy, siny = math_cos (y), math_sin (y)
	local cosr, sinr = math_cos (r), math_sin (r)
	
	return cosr * sinp * cosy + sinr * siny,
	       cosr * sinp * siny - sinr * cosy,
	                            cosp * cosr
end

local GCAD_EulerAngle_GetPositiveXUnpacked = GCAD.EulerAngle.GetPositiveXUnpacked
local GCAD_EulerAngle_GetPositiveYUnpacked = GCAD.EulerAngle.GetPositiveYUnpacked
local GCAD_EulerAngle_GetPositiveZUnpacked = GCAD.EulerAngle.GetPositiveZUnpacked

function GCAD.EulerAngle.GetPositiveX (self, out)
	local x, y, z = GCAD_EulerAngle_GetPositiveXUnpacked (self)
	return GCAD_UnpackedVector3d_ToVector3d (x, y, z, out)
end

function GCAD.EulerAngle.GetPositiveXNative (self, out)
	local x, y, z = GCAD_EulerAngle_GetPositiveXUnpacked (self)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

function GCAD.EulerAngle.GetPositiveY (self, out)
	local x, y, z = GCAD_EulerAngle_GetPositiveYUnpacked (self)
	return GCAD_UnpackedVector3d_ToVector3d (x, y, z, out)
end

function GCAD.EulerAngle.GetPositiveYNative (self, out)
	local x, y, z = GCAD_EulerAngle_GetPositiveYUnpacked (self)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

function GCAD.EulerAngle.GetPositiveZ (self, out)
	local x, y, z = GCAD_EulerAngle_GetPositiveZUnpacked (self)
	return GCAD_UnpackedVector3d_ToVector3d (x, y, z, out)
end

function GCAD.EulerAngle.GetPositiveZNative (self, out)
	local x, y, z = GCAD_EulerAngle_GetPositiveZUnpacked (self)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

GCAD.EulerAngle.GetForwards         = GCAD.EulerAngle.GetPositiveX
GCAD.EulerAngle.GetForwardsNative   = GCAD.EulerAngle.GetPositiveXNative
GCAD.EulerAngle.GetForwardsUnpacked = GCAD.EulerAngle.GetPositiveXUnpacked
GCAD.EulerAngle.GetLeft             = GCAD.EulerAngle.GetPositiveY
GCAD.EulerAngle.GetLeftNative       = GCAD.EulerAngle.GetPositiveYNative
GCAD.EulerAngle.GetLeftUnpacked     = GCAD.EulerAngle.GetPositiveYUnpacked
GCAD.EulerAngle.GetUp               = GCAD.EulerAngle.GetPositiveZ
GCAD.EulerAngle.GetUpNative         = GCAD.EulerAngle.GetPositiveZNative
GCAD.EulerAngle.GetUpUnpacked       = GCAD.EulerAngle.GetPositiveZUnpacked

-- Conversion
function GCAD.EulerAngle.ToMatrix3x3 (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	local p = math_rad (self [1])
	local y = math_rad (self [2])
	local r = math_rad (self [3])
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

function GCAD.EulerAngle.ToMatrix4x4 (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	local p = math_rad (self [1])
	local y = math_rad (self [2])
	local r = math_rad (self [3])
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

function GCAD.EulerAngle.FromDirection (forwards, out)
	out = out or GCAD.EulerAngle ()
	
	out [1] = math_deg (math_atan2 (forwards [3], GCAD_Vector2d_Length (forwards)))
	out [2] = math_deg (math_atan2 (forwards [2], forwards [1]))
	out [3] = 0
	
	return out
end

function GCAD.EulerAngle.FromUnpackedDirection (x, y, z, out)
	out = out or GCAD.EulerAngle ()
	
	out [1] = math_deg (math_atan2 (z, GCAD_UnpackedVector2d_Length (x, y)))
	out [2] = math_deg (math_atan2 (y, x))
	out [3] = 0
	
	return out
end

function GCAD.EulerAngle.FromNativeAngle (angle, out)
	out = out or GCAD.EulerAngle ()
	
	out [1] = Angle___index (angle, "p")
	out [2] = Angle___index (angle, "y")
	out [3] = Angle___index (angle, "r")
	
	return out
end

function GCAD.EulerAngle.ToNativeAngle (self, out)
	out = out or Angle ()
	
	Angle___newindex (out, "p", self [1])
	Angle___newindex (out, "y", self [2])
	Angle___newindex (out, "r", self [3])
	
	return out
end

-- Utility
function GCAD.EulerAngle.Unpack (self)
	return self [1], self [2], self [3]
end

function GCAD.EulerAngle.ToString (self)
	return "(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .. ")"
end

-- Constructor
function self:ctor (p, y, r)
	self [1] = p or 0
	self [2] = y or 0
	self [3] = r or 0
end

-- Initialization
function self:Set (p, y, r)
	self [1] = p
	self [2] = y
	self [3] = r
	
	return self
end

function self:Zero ()
	self [1] = 0
	self [2] = 0
	self [3] = 0
	
	return self
end

-- Copying
self.Clone                = GCAD.EulerAngle.Clone
self.Copy                 = GCAD.EulerAngle.Copy

-- Directions
self.GetPositiveX         = GCAD.EulerAngle.GetPositiveX
self.GetPositiveXNative   = GCAD.EulerAngle.GetPositiveXNative
self.GetPositiveXUnpacked = GCAD.EulerAngle.GetPositiveXUnpacked
self.GetPositiveY         = GCAD.EulerAngle.GetPositiveY
self.GetPositiveYNative   = GCAD.EulerAngle.GetPositiveYNative
self.GetPositiveYUnpacked = GCAD.EulerAngle.GetPositiveYUnpacked
self.GetPositiveZ         = GCAD.EulerAngle.GetPositiveZ
self.GetPositiveZNative   = GCAD.EulerAngle.GetPositiveZNative
self.GetPositiveZUnpacked = GCAD.EulerAngle.GetPositiveZUnpacked

self.GetForwards          = GCAD.EulerAngle.GetForwards
self.GetForwardsNative    = GCAD.EulerAngle.GetForwardsNative
self.GetForwardsUnpacked  = GCAD.EulerAngle.GetForwardsUnpacked
self.GetLeft              = GCAD.EulerAngle.GetLeft
self.GetLeftNative        = GCAD.EulerAngle.GetLeftNative
self.GetLeftUnpacked      = GCAD.EulerAngle.GetLeftUnpacked
self.GetUp                = GCAD.EulerAngle.GetUp
self.GetUpNative          = GCAD.EulerAngle.GetUpNative
self.GetUpUnpacked        = GCAD.EulerAngle.GetUpUnpacked

-- Conversion
self.ToMatrix3x3          = GCAD.EulerAngle.ToMatrix3x3
self.ToNativeAngle        = GCAD.EulerAngle.ToNativeAngle

-- Utility
self.Unpack               = GCAD.EulerAngle.Unpack
self.ToString             = GCAD.EulerAngle.ToString
self.__tostring           = GCAD.EulerAngle.ToString

GCAD.EulerAngle.Identity  = GCAD.EulerAngle (0, 0, 0)
GCAD.EulerAngle.Zero      = GCAD.EulerAngle (0, 0, 0)
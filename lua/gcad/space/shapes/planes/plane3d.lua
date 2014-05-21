local self = {}
GCAD.Plane3d = GCAD.MakeConstructor (self)

local Vector___index               = debug.getregistry ().Vector.__index

local GCAD_Vector3d_Clone          = GCAD.Vector3d.Clone
local GCAD_Vector3d_Dot            = GCAD.Vector3d.Dot
local GCAD_Vector3d_Length         = GCAD.Vector3d.Length
local GCAD_Vector3d_ToNativeVector = GCAD.Vector3d.ToNativeVector
local GCAD_UnpackedVector3d_Dot    = GCAD.UnpackedVector3d.Dot

function GCAD.Plane3d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.Plane3d ()
	
	-- ax + by + cz + d = 0
	-- d = -normal . position
	out [1] = normal [1]
	out [2] = normal [2]
	out [3] = normal [3]
	out [4] = -GCAD_Vector3d_Dot (position, normal)
	
	return out
end

-- Copying
function GCAD.Plane3d.Clone (self, out)
	out = out or GCAD.Plane3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	
	return out
end

function GCAD.Plane3d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	
	return self
end

-- Plane properties
function GCAD.Plane3d.GetNormal (self, out)
	return GCAD_Vector3d_Clone (self, out)
end

function GCAD.Plane3d.GetNormalNative (self, out)
	return GCAD_Vector3d_ToNativeVector (self, out)
end

function GCAD.Plane3d.GetNormalUnpacked (self)
	return self [1], self [2], self [3]
end

function GCAD.Plane3d.GetNormalLength (self)
	return GCAD_Vector3d_Length (self)
end

function GCAD.Plane3d.SetNormal (self, normal)
	self [1] = normal [1]
	self [2] = normal [2]
	self [3] = normal [3]
	
	return self
end

function GCAD.Plane3d.SetNormalNative (self, normal)
	self [1] = Vector___index (normal, "x")
	self [2] = Vector___index (normal, "y")
	self [3] = Vector___index (normal, "z")
	
	return self
end

function GCAD.Plane3d.SetNormalUnpacked (self, x, y, z)
	self [1] = x
	self [2] = y
	self [3] = z
	
	return self
end

-- Plane operations
local GCAD_Plane3d_GetNormalLength = GCAD.Plane3d.GetNormalLength

function GCAD.Plane3d.Flip (self, out)
	out [1] = -self [1]
	out [2] = -self [2]
	out [3] = -self [3]
	out [4] = -self [4]
	
	return out
end

function GCAD.Plane3d.Normalize (self, out)
	out = out or GCAD.Plane3d ()
	
	local length = GCAD_Plane3d_GetNormalLength (self)
	out [1] = self [1] / length
	out [2] = self [2] / length
	out [3] = self [3] / length
	out [4] = self [4] / length
	
	return out
end

-- Plane queries
local GCAD_Plane3d_GetNormalLength = GCAD.Plane3d.GetNormalLength

function GCAD.Plane3d.DistanceToPoint (self, v3d)
	return (GCAD_Vector3d_Dot (self, v3d) + self [4]) / GCAD_Plane3d_GetNormalLength (self)
end

GCAD.Plane3d.DistanceToNativePoint = GCAD.Plane3d.DistanceToPoint

function GCAD.Plane3d.DistanceToUnpackedPoint (self, x, y, z)
	return (GCAD_UnpackedVector3d_Dot (self [1], self [2], self [3], x, y, z) + self [4]) / GCAD_Plane3d_GetNormalLength (self)
end

function GCAD.Plane3d.ScaledDistanceToPoint (self, v3d)
	return GCAD_Vector3d_Dot (self, v3d) + self [4]
end

GCAD.Plane3d.ScaledDistanceToNativePoint = GCAD.Plane3d.ScaledDistanceToPoint

function GCAD.Plane3d.ScaledDistanceToUnpackedPoint (self, x, y, z)
	return GCAD_UnpackedVector3d_Dot (self [1], self [2], self [3], x, y, z) + self [4]
end

-- Intersection tests
local GCAD_Plane3d_DistanceToPoint               = GCAD.Plane3d.DistanceToPoint
local GCAD_Plane3d_DistanceToUnpackedPoint       = GCAD.Plane3d.DistanceToUnpackedPoint
local GCAD_Plane3d_ScaledDistanceToPoint         = GCAD.Plane3d.ScaledDistanceToPoint
local GCAD_Plane3d_ScaledDistanceToNativePoint   = GCAD.Plane3d.ScaledDistanceToNativePoint
local GCAD_Plane3d_ScaledDistanceToUnpackedPoint = GCAD.Plane3d.ScaledDistanceToUnpackedPoint

function GCAD.Plane3d.ContainsPoint (self, v3d)
	return GCAD_Plane3d_ScaledDistanceToPoint (self, v3d) < 0
end

function GCAD.Plane3d.ContainsNativePoint (self, v)
	return GCAD_Plane3d_ScaledDistanceToNativePoint (self, v) < 0
end

function GCAD.Plane3d.ContainsUnpackedPoint (self, x, y)
	return GCAD_Plane3d_ScaledDistanceToUnpackedPoint (self, x, y) < 0
end

function GCAD.Plane3d.ContainsSphere (self, sphere3d)
	local distance = GCAD_Plane3d_DistanceToPoint (self, sphere3d)
	return distance + sphere3d [4] < 0
end

function GCAD.Plane3d.ContainsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_Plane3d_DistanceToUnpackedPoint (self, nativeSphere3d:GetPositionUnpacked ())
	return distance + nativeSphere3d [4] < 0
end

function GCAD.Plane3d.ContainsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_Plane3d_DistanceToUnpackedPoint (self, x, y, z)
	return distance + r < 0
end

function GCAD.Plane3d.IntersectsSphere (self, sphere3d)
	local distance = GCAD_Plane3d_DistanceToPoint (self, sphere3d)
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.Plane3d.IntersectsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_Plane3d_DistanceToUnpackedPoint (self, nativeSphere3d:GetPositionUnpacked ())
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.Plane3d.IntersectsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_Plane3d_DistanceToUnpackedPoint (self, x, y, z)
	if distance + r < 0 then return true, true  end -- sphere lies within this plane
	if distance - r < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

-- Conversion
function GCAD.Plane3d.FromNativePlane3d (nativePlane3d, out)
	out = out or GCAD.Plane3d ()
	
	out [1], out [2], out [3] = nativePlane3d:GetNormalUnpacked ()
	out [4] = nativePlane3d [4]
	
	return out
end

function GCAD.Plane3d.ToNativePlane3d (self, out)
	out = out or GCAD.NativePlane3d ()
	
	out:SetNormalUnpacked (self [1], self [2], self [3])
	out [4] = self [4]
	
	return out
end

-- Utility
function GCAD.Plane3d.Unpack (self)
	return self [1], self [2], self [3], self [4]
end

function GCAD.Plane3d.ToString (self)
	return "Plane [(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .. "), " .. tostring (self [4]) .. "]"
end

-- Construction
function GCAD.Plane3d.Minimum (out)
	out = out or GCAD.Plane3d (1, 0, 0)
	
	out [4] = math.huge
	
	return out
end

function GCAD.Plane3d.Maximum (out)
	out = out or GCAD.Plane3d (1, 0, 0)
	
	out [4] = -math.huge
	
	return out
end

function self:ctor (a, b, c, d)
	self [1] = a or 0
	self [2] = b or 0
	self [3] = c or 0
	self [4] = d or 0
end

-- Initialization
function self:Set (a, b, c, d)
	self [1] = a
	self [2] = b
	self [3] = c
	self [4] = d
	
	return self
end

local GCAD_Plane3d_Minimum = GCAD.Plane3d.Minimum
local GCAD_Plane3d_Maximum = GCAD.Plane3d.Maximum

function self:Minimize () return GCAD_Plane3d_Minimum (self) end
function self:Maximize () return GCAD_Plane3d_Maximum (self) end

-- Copying
self.Clone                         = GCAD.Plane3d.Clone
self.Copy                          = GCAD.Plane3d.Copy

-- Plane properties
self.GetNormal                     = GCAD.Plane3d.GetNormal
self.GetNormalUnpacked             = GCAD.Plane3d.GetNormalUnpacked
self.GetNormalLength               = GCAD.Plane3d.GetNormalLength
self.SetNormal                     = GCAD.Plane3d.SetNormal
self.SetNormalUnpacked             = GCAD.Plane3d.SetNormalUnpacked

-- Plane operations
self.Flip                          = GCAD.Plane3d.Flip
self.Normalize                     = GCAD.Plane3d.Normalize

-- Plane queries
self.DistanceToPoint               = GCAD.Plane3d.DistanceToPoint
self.DistanceToNativePoint         = GCAD.Plane3d.DistanceToNativePoint
self.DistanceToUnpackedPoint       = GCAD.Plane3d.DistanceToUnpackedPoint
self.ScaledDistanceToPoint         = GCAD.Plane3d.ScaledDistanceToPoint
self.ScaledDistanceToNativePoint   = GCAD.Plane3d.ScaledDistanceToNativePoint
self.ScaledDistanceToUnpackedPoint = GCAD.Plane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
self.ContainsPoint                 = GCAD.Plane3d.ContainsPoint
self.ContainsNativePoint           = GCAD.Plane3d.ContainsNativePoint
self.ContainsUnpackedPoint         = GCAD.Plane3d.ContainsUnpackedPoint
self.ContainsSphere                = GCAD.Plane3d.ContainsSphere
self.ContainsNativeSphere          = GCAD.Plane3d.ContainsNativeSphere
self.ContainsUnpackedSphere        = GCAD.Plane3d.ContainsUnpackedSphere
self.IntersectsSphere              = GCAD.Plane3d.IntersectsSphere
self.IntersectsNativeSphere        = GCAD.Plane3d.IntersectsNativeSphere
self.IntersectsUnpackedSphere      = GCAD.Plane3d.IntersectsUnpackedSphere

-- Conversion
self.ToNativePlane3d               = GCAD.Plane3d.ToNativePlane3d

-- Utility
self.Unpack                        = GCAD.Plane3d.Unpack
self.ToString                      = GCAD.Plane3d.ToString
self.__tostring                    = GCAD.Plane3d.ToString
local self = {}
GCAD.NormalizedPlane3d = GCAD.MakeConstructor (self)

local Vector_Length                = debug.getregistry ().Vector.Length
local Vector___index               = debug.getregistry ().Vector.__index

local GCAD_Vector3d_Dot            = GCAD.Vector3d.Dot
local GCAD_Vector3d_Length         = GCAD.Vector3d.Length
local GCAD_UnpackedVector3d_Length = GCAD.UnpackedVector3d.Length

function GCAD.NormalizedPlane3d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.NormalizedPlane3d ()
	
	-- ax + by + cz + d = 0
	-- d = -normal . position
	local length = GCAD_Vector3d_Length (normal)
	out [1] = normal [1] / length
	out [2] = normal [2] / length
	out [3] = normal [3] / length
	out [4] = -GCAD_Vector3d_Dot (position, normal) / length
	
	return out
end

-- Copying
GCAD.NormalizedPlane3d.Clone                         = GCAD.Plane3d.Clone
GCAD.NormalizedPlane3d.Copy                          = GCAD.Plane3d.Copy

-- Plane properties
GCAD.NormalizedPlane3d.GetNormal                     = GCAD.Plane3d.GetNormal
GCAD.NormalizedPlane3d.GetNormalNative               = GCAD.Plane3d.GetNormalNative
GCAD.NormalizedPlane3d.GetNormalUnpacked             = GCAD.Plane3d.GetNormalUnpacked
GCAD.NormalizedPlane3d.GetNormalLength               = GCAD.Plane3d.GetNormalLength

function GCAD.NormalizedPlane3d.SetNormal (self, normal)
	local length = GCAD_Vector3d_Length (normal)
	self [1] = normal [1] / length
	self [2] = normal [2] / length
	self [3] = normal [3] / length
	
	return self
end

function GCAD.NormalizedPlane3d.SetNormalNative (self, normal)
	local length = Vector_Length (normal)
	self [1] = Vector___index (normal, "x") / length
	self [2] = Vector___index (normal, "y") / length
	self [3] = Vector___index (normal, "z") / length
	
	return self
end

function GCAD.NormalizedPlane3d.SetNormalUnpacked (self, x, y, z)
	local length = GCAD_UnpackedVector3d_Length (x, y, z)
	self [1] = x / length
	self [2] = y / length
	self [3] = z / length
	
	return self
end

-- Plane operations
GCAD.NormalizedPlane3d.Flip                          = GCAD.Plane3d.Flip
GCAD.NormalizedPlane3d.Normalize                     = GCAD.Plane3d.Normalize

-- Plane queries
GCAD.NormalizedPlane3d.DistanceToPoint               = GCAD.Plane3d.ScaledDistanceToPoint
GCAD.NormalizedPlane3d.DistanceToNativePoint         = GCAD.Plane3d.ScaledDistanceToNativePoint
GCAD.NormalizedPlane3d.DistanceToUnpackedPoint       = GCAD.Plane3d.ScaledDistanceToUnpackedPoint
GCAD.NormalizedPlane3d.ScaledDistanceToPoint         = GCAD.Plane3d.ScaledDistanceToPoint
GCAD.NormalizedPlane3d.ScaledDistanceToNativePoint   = GCAD.Plane3d.ScaledDistanceToNativePoint
GCAD.NormalizedPlane3d.ScaledDistanceToUnpackedPoint = GCAD.Plane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
local GCAD_NormalizedPlane3d_DistanceToPoint         = GCAD.NormalizedPlane3d.DistanceToPoint
local GCAD_NormalizedPlane3d_DistanceToUnpackedPoint = GCAD.NormalizedPlane3d.DistanceToUnpackedPoint

-- Point
GCAD.NormalizedPlane3d.ContainsPoint                 = GCAD.Plane3d.ContainsPoint
GCAD.NormalizedPlane3d.ContainsNativePoint           = GCAD.Plane3d.ContainsNativePoint
GCAD.NormalizedPlane3d.ContainsUnpackedPoint         = GCAD.Plane3d.ContainsUnpackedPoint

-- Sphere
function GCAD.NormalizedPlane3d.ContainsSphere (self, sphere3d)
	local distance = GCAD_NormalizedPlane3d_DistanceToPoint (self, sphere3d)
	return distance + sphere3d [4] < 0
end

function GCAD.NormalizedPlane3d.ContainsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_NormalizedPlane3d_DistanceToUnpackedPoint (self, nativeSphere3d:GetPositionUnpacked ())
	return distance + nativeSphere3d [4] < 0
end

function GCAD.NormalizedPlane3d.ContainsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_NormalizedPlane3d_DistanceToUnpackedPoint (self, x, y, z)
	return distance + r < 0
end

function GCAD.NormalizedPlane3d.IntersectsSphere (self, sphere3d)
	local distance = GCAD_NormalizedPlane3d_DistanceToPoint (self, sphere3d)
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NormalizedPlane3d.IntersectsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_NormalizedPlane3d_DistanceToUnpackedPoint (self, nativeSphere3d:GetPositionUnpacked ())
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NormalizedPlane3d.IntersectsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_NormalizedPlane3d_DistanceToUnpackedPoint (self, x, y, z)
	if distance + r < 0 then return true, true  end -- sphere lies within this plane
	if distance - r < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

-- Box
GCAD.NormalizedPlane3d.ContainsOBB                   = GCAD.Plane3d.ContainsOBB
GCAD.NormalizedPlane3d.IntersectsOBB                 = GCAD.Plane3d.IntersectsOBB
GCAD.NormalizedPlane3d.ContainsAABB                  = GCAD.Plane3d.ContainsAABB
GCAD.NormalizedPlane3d.IntersectsAABB                = GCAD.Plane3d.IntersectsAABB

-- Conversion
function GCAD.NormalizedPlane3d.FromNativeNormalizedPlane3d (nativeNormalizedPlane3d, out)
	out = out or GCAD.NormalizedPlane3d ()
	
	out [1], out [2], out [3] = nativeNormalizedPlane3d:GetNormalUnpacked ()
	out [4] = nativeNormalizedPlane3d [4]
	
	return out
end

function GCAD.NormalizedPlane3d.ToNativeNormalizedPlane3d (self, out)
	out = out or GCAD.NativeNormalizedPlane3d ()
	
	out:SetNormalUnpacked (self [1], self [2], self [3])
	out [4] = self [4]
	
	return out
end

-- Utility
GCAD.NormalizedPlane3d.Unpack                        = GCAD.Plane3d.Unpack
GCAD.NormalizedPlane3d.ToString                      = GCAD.Plane3d.ToString

-- Construction
GCAD.NormalizedPlane3d.Minimum                       = GCAD.Plane3d.Minimum
GCAD.NormalizedPlane3d.Maximum                       = GCAD.Plane3d.Maximum

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

local GCAD_NormalizedPlane3d_Minimum = GCAD.NormalizedPlane3d.Minimum
local GCAD_NormalizedPlane3d_Maximum = GCAD.NormalizedPlane3d.Maximum

function self:Minimize () return GCAD_NormalizedPlane3d_Minimum (self) end
function self:Maximize () return GCAD_NormalizedPlane3d_Maximum (self) end

-- Copying
self.Clone                         = GCAD.NormalizedPlane3d.Clone
self.Copy                          = GCAD.NormalizedPlane3d.Copy

-- Plane properties
self.GetNormal                     = GCAD.NormalizedPlane3d.GetNormal
self.GetNormalUnpacked             = GCAD.NormalizedPlane3d.GetNormalUnpacked
self.GetNormalLength               = GCAD.NormalizedPlane3d.GetNormalLength
self.SetNormal                     = GCAD.NormalizedPlane3d.SetNormal
self.SetNormalUnpacked             = GCAD.NormalizedPlane3d.SetNormalUnpacked

-- Plane operations
self.Flip                          = GCAD.NormalizedPlane3d.Flip
self.Normalize                     = GCAD.NormalizedPlane3d.Normalize

-- Plane queries
self.DistanceToPoint               = GCAD.NormalizedPlane3d.DistanceToPoint
self.DistanceToNativePoint         = GCAD.NormalizedPlane3d.DistanceToNativePoint
self.DistanceToUnpackedPoint       = GCAD.NormalizedPlane3d.DistanceToUnpackedPoint
self.ScaledDistanceToPoint         = GCAD.NormalizedPlane3d.ScaledDistanceToPoint
self.ScaledDistanceToNativePoint   = GCAD.NormalizedPlane3d.ScaledDistanceToNativePoint
self.ScaledDistanceToUnpackedPoint = GCAD.NormalizedPlane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
-- Point
self.ContainsPoint                 = GCAD.NormalizedPlane3d.ContainsPoint
self.ContainsNativePoint           = GCAD.NormalizedPlane3d.ContainsNativePoint
self.ContainsUnpackedPoint         = GCAD.NormalizedPlane3d.ContainsUnpackedPoint

-- Sphere
self.ContainsSphere                = GCAD.NormalizedPlane3d.ContainsSphere
self.ContainsNativeSphere          = GCAD.NormalizedPlane3d.ContainsNativeSphere
self.ContainsUnpackedSphere        = GCAD.NormalizedPlane3d.ContainsUnpackedSphere
self.IntersectsSphere              = GCAD.NormalizedPlane3d.IntersectsSphere
self.IntersectsNativeSphere        = GCAD.NormalizedPlane3d.IntersectsNativeSphere
self.IntersectsUnpackedSphere      = GCAD.NormalizedPlane3d.IntersectsUnpackedSphere

-- Box
self.ContainsAABB                  = GCAD.NormalizedPlane3d.ContainsAABB
self.IntersectsAABB                = GCAD.NormalizedPlane3d.IntersectsAABB
self.ContainsOBB                   = GCAD.NormalizedPlane3d.ContainsOBB
self.IntersectsOBB                 = GCAD.NormalizedPlane3d.IntersectsOBB

-- Conversion
self.ToNativeNormalizedPlane3d     = GCAD.NormalizedPlane3d.ToNativeNormalizedPlane3d

-- Utility
self.Unpack                        = GCAD.NormalizedPlane3d.Unpack
self.ToString                      = GCAD.NormalizedPlane3d.ToString
self.__tostring                    = GCAD.NormalizedPlane3d.ToString
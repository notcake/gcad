local self = {}
GCAD.NativeNormalizedPlane3d = GCAD.MakeConstructor (self)

local Vector_Length        = debug.getregistry ().Vector.Length
local Vector_Normalize     = debug.getregistry ().Vector.Normalize

local GCAD_Vector3d_Dot    = GCAD.Vector3d.Dot
local GCAD_Vector3d_Length = GCAD.Vector3d.Length

function GCAD.NativeNormalizedPlane3d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.NativeNormalizedPlane3d ()
	
	-- ax + by + cz + d = 0
	-- d = -normal . position
	local length = GCAD_Vector3d_Length (normal)
	out.Normal = GCAD_Vector3d_ToNativeVector (normal, out.Normal)
	Vector_Normalize (out.Normal)
	out [4] = -GCAD_Vector3d_Dot (position, normal) / length
	
	return out
end

-- Copying
GCAD.NativeNormalizedPlane3d.Clone                         = GCAD.NativePlane3d.Clone
GCAD.NativeNormalizedPlane3d.Copy                          = GCAD.NativePlane3d.Copy

-- Plane properties
GCAD.NativeNormalizedPlane3d.GetNormal                     = GCAD.NativePlane3d.GetNormal
GCAD.NativeNormalizedPlane3d.GetNormalNative               = GCAD.NativePlane3d.GetNormalNative
GCAD.NativeNormalizedPlane3d.GetNormalUnpacked             = GCAD.NativePlane3d.GetNormalUnpacked
GCAD.NativeNormalizedPlane3d.GetNormalLength               = GCAD.NativePlane3d.GetNormalLength

function GCAD.NativeNormalizedPlane3d.SetNormal (self, normal)
	self.Normal = GCAD_Vector3d_ToNativeVector (normal, self.Normal)
	Vector_Normalize (self.Normal)
	
	return self
end

function GCAD.NativeNormalizedPlane3d.SetNormalNative (self, normal)
	Vector_Set (self.Normal, normal)
	Vector_Normalize (self.Normal)
	
	return self
end

function GCAD.NativeNormalizedPlane3d.SetNormalUnpacked (self, x, y, z)
	self.Normal = GCAD_UnpackedVector3d_ToNativeVector (x, y, z, self.Normal)
	Vector_Normalize (self.Normal)
	
	return self
end

-- Plane operations
GCAD.NativeNormalizedPlane3d.Flip                          = GCAD.NativePlane3d.Flip
GCAD.NativeNormalizedPlane3d.Normalize                     = GCAD.NativePlane3d.Normalize

-- Plane queries
GCAD.NativeNormalizedPlane3d.DistanceToPoint               = GCAD.NativePlane3d.ScaledDistanceToPoint
GCAD.NativeNormalizedPlane3d.DistanceToNativePoint         = GCAD.NativePlane3d.ScaledDistanceToNativePoint
GCAD.NativeNormalizedPlane3d.DistanceToUnpackedPoint       = GCAD.NativePlane3d.ScaledDistanceToUnpackedPoint
GCAD.NativeNormalizedPlane3d.ScaledDistanceToPoint         = GCAD.NativePlane3d.ScaledDistanceToPoint
GCAD.NativeNormalizedPlane3d.ScaledDistanceToNativePoint   = GCAD.NativePlane3d.ScaledDistanceToNativePoint
GCAD.NativeNormalizedPlane3d.ScaledDistanceToUnpackedPoint = GCAD.NativePlane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
local GCAD_NativeNormalizedPlane3d_DistanceToPoint         = GCAD.NativeNormalizedPlane3d.DistanceToPoint
local GCAD_NativeNormalizedPlane3d_DistanceToNativePoint   = GCAD.NativeNormalizedPlane3d.DistanceToNativePoint
local GCAD_NativeNormalizedPlane3d_DistanceToUnpackedPoint = GCAD.NativeNormalizedPlane3d.DistanceToUnpackedPoint

GCAD.NativeNormalizedPlane3d.ContainsPoint                 = GCAD.NativePlane3d.ContainsPoint
GCAD.NativeNormalizedPlane3d.ContainsNativePoint           = GCAD.NativePlane3d.ContainsNativePoint
GCAD.NativeNormalizedPlane3d.ContainsUnpackedPoint         = GCAD.NativePlane3d.ContainsUnpackedPoint

function GCAD.NativeNormalizedPlane3d.ContainsSphere (self, sphere3d)
	local distance = GCAD_NativeNormalizedPlane3d_DistanceToPoint (self, sphere3d)
	return distance + sphere3d [4] < 0
end

function GCAD.NativeNormalizedPlane3d.ContainsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_NativeNormalizedPlane3d_DistanceToNativePoint (self, nativeSphere3d.Position)
	return distance + nativeSphere3d [4] < 0
end

function GCAD.NativeNormalizedPlane3d.ContainsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_NativeNormalizedPlane3d_DistanceToUnpackedPoint (self, x, y, z)
	return distance + r < 0
end

function GCAD.NativeNormalizedPlane3d.IntersectsSphere (self, sphere3d)
	local distance = GCAD_NativeNormalizedPlane3d_DistanceToPoint (self, sphere3d)
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NativeNormalizedPlane3d.IntersectsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_NativeNormalizedPlane3d_DistanceToNativePoint (self, nativeSphere3d.Position)
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NativeNormalizedPlane3d.IntersectsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_NativeNormalizedPlane3d_DistanceToUnpackedPoint (self, x, y, z)
	if distance + r < 0 then return true, true  end -- sphere lies within this plane
	if distance - r < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

-- Conversion
local GCAD_NativeNormalizedPlane3d_SetNormal = GCAD.NativeNormalizedPlane3d.SetNormal
function GCAD.NativeNormalizedPlane3d.FromNormalizedPlane3d (normalizedPlane3d, out)
	out = out or GCAD.NativeNormalizedPlane3d ()
	
	GCAD_NativePlane3d_SetNormal (out, normalizedPlane3d)
	out [4] = normalizedPlane3d [4]
	
	return out
end

function GCAD.NativePlane3d.ToNormalizedPlane3d (self, out)
	out = out or GCAD.NormalizedPlane3d ()
	
	out:SetNormalNative (self.Normal)
	out [4] = self [4]
	
	return out
end

-- Utility
GCAD.NativeNormalizedPlane3d.Unpack                        = GCAD.NativePlane3d.Unpack
GCAD.NativeNormalizedPlane3d.ToString                      = GCAD.NativePlane3d.ToString

-- Construction
GCAD.NativeNormalizedPlane3d.Minimum                       = GCAD.NativePlane3d.Minimum
GCAD.NativeNormalizedPlane3d.Maximum                       = GCAD.NativePlane3d.Maximum

function self:ctor (a, b, c, d)
	self.Normal = Vector (a or 0, b or 0, c or 0)
	self [4] = d or 0
end

-- Initialization
function self:Set (a, b, c, d)
	self.Normal = GCAD_UnpackedVector3d_ToNativeVector (a, b, c, self.Normal)
	self [4] = d
	
	return self
end

local GCAD_NativeNormalizedPlane3d_Minimum = GCAD.NativeNormalizedPlane3d.Minimum
local GCAD_NativeNormalizedPlane3d_Maximum = GCAD.NativeNormalizedPlane3d.Maximum

function self:Minimize () return GCAD_NativeNormalizedPlane3d_Minimum (self) end
function self:Maximize () return GCAD_NativeNormalizedPlane3d_Maximum (self) end

-- Copying
self.Clone                         = GCAD.NativeNormalizedPlane3d.Clone
self.Copy                          = GCAD.NativeNormalizedPlane3d.Copy

-- Plane properties
self.GetNormal                     = GCAD.NativeNormalizedPlane3d.GetNormal
self.GetNormalUnpacked             = GCAD.NativeNormalizedPlane3d.GetNormalUnpacked
self.GetNormalLength               = GCAD.NativeNormalizedPlane3d.GetNormalLength
self.SetNormal                     = GCAD.NativeNormalizedPlane3d.SetNormal
self.SetNormalUnpacked             = GCAD.NativeNormalizedPlane3d.SetNormalUnpacked

-- Plane operations
self.Flip                          = GCAD.NativeNormalizedPlane3d.Flip
self.Normalize                     = GCAD.NativeNormalizedPlane3d.Normalize

-- Plane queries
self.DistanceToPoint               = GCAD.NativeNormalizedPlane3d.DistanceToPoint
self.DistanceToNativePoint         = GCAD.NativeNormalizedPlane3d.DistanceToNativePoint
self.DistanceToUnpackedPoint       = GCAD.NativeNormalizedPlane3d.DistanceToUnpackedPoint
self.ScaledDistanceToPoint         = GCAD.NativeNormalizedPlane3d.ScaledDistanceToPoint
self.ScaledDistanceToNativePoint   = GCAD.NativeNormalizedPlane3d.ScaledDistanceToNativePoint
self.ScaledDistanceToUnpackedPoint = GCAD.NativeNormalizedPlane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
self.ContainsPoint                 = GCAD.NativeNormalizedPlane3d.ContainsPoint
self.ContainsNativePoint           = GCAD.NativeNormalizedPlane3d.ContainsNativePoint
self.ContainsUnpackedPoint         = GCAD.NativeNormalizedPlane3d.ContainsUnpackedPoint
self.ContainsSphere                = GCAD.NativeNormalizedPlane3d.ContainsSphere
self.ContainsNativeSphere          = GCAD.NativeNormalizedPlane3d.ContainsNativeSphere
self.ContainsUnpackedSphere        = GCAD.NativeNormalizedPlane3d.ContainsUnpackedSphere
self.IntersectsSphere              = GCAD.NativeNormalizedPlane3d.IntersectsSphere
self.IntersectsNativeSphere        = GCAD.NativeNormalizedPlane3d.IntersectsNativeSphere
self.IntersectsUnpackedSphere      = GCAD.NativeNormalizedPlane3d.IntersectsUnpackedSphere

-- Conversion
self.ToNormalizedPlane3d           = GCAD.NativeNormalizedPlane3d.ToNormalizedPlane3d

-- Utility
self.Unpack                        = GCAD.NativeNormalizedPlane3d.Unpack
self.ToString                      = GCAD.NativeNormalizedPlane3d.ToString
self.__tostring                    = GCAD.NativeNormalizedPlane3d.ToString
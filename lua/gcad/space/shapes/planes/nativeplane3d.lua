local self = {}
GCAD.NativePlane3d = GCAD.MakeConstructor (self)

local Vector                                 = Vector

local Vector_Dot                             = debug.getregistry ().Vector.Dot
local Vector_Length                          = debug.getregistry ().Vector.Length
local Vector_Normalize                       = debug.getregistry ().Vector.Normalize
local Vector_Set                             = debug.getregistry ().Vector.Set
local Vector___index                         = debug.getregistry ().Vector.__index
local Vector___unm                           = debug.getregistry ().Vector.__unm

local GCAD_Vector3d_Dot                      = GCAD.Vector3d.Dot
local GCAD_Vector3d_FromNativeVector         = GCAD.Vector3d.FromNativeVector
local GCAD_Vector3d_ToNativeVector           = GCAD.Vector3d.ToNativeVector
local GCAD_UnpackedVector3d_Dot              = GCAD.UnpackedVector3d.Dot
local GCAD_UnpackedVector3d_FromNativeVector = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_ToNativeVector   = GCAD.UnpackedVector3d.ToNativeVector

function GCAD.NativePlane3d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.NativePlane3d ()
	
	-- ax + by + cz + d = 0
	-- d = -normal . position
	out.Normal = GCAD_Vector3d_ToNativeVector (normal, out.Normal)
	out [4] = -GCAD_Vector3d_Dot (position, normal)
	
	return out
end

-- Copying
function GCAD.NativePlane3d.Clone (self, out)
	out = out or GCAD.NativePlane3d ()
	
	Vector_Set (out.Normal, self.Normal)
	out [4] = self [4]
	
	return out
end

function GCAD.NativePlane3d.Copy (self, source)
	Vector_Set (self.Normal, source.Normal)
	self [4] = source [4]
	
	return self
end

-- Plane properties
function GCAD.NativePlane3d.GetNormal (self, out)
	return GCAD_Vector3d_FromNativeVector (self.Normal, out)
end

function GCAD.NativePlane3d.GetNormalNative (self, out)
	out = out or Vector ()
	
	Vector_Set (out, self.Normal)
	
	return out
end

function GCAD.NativePlane3d.GetNormalUnpacked (self)
	return GCAD_UnpackedVector3d_FromNativeVector (self.Normal)
end

function GCAD.NativePlane3d.GetNormalLength (self)
	return Vector_Length (self.Normal)
end

function GCAD.NativePlane3d.SetNormal (self, normal)
	self.Normal = GCAD_Vector3d_ToNativeVector (normal, self.Normal)
	
	return self
end

function GCAD.NativePlane3d.SetNormalNative (self, normal)
	Vector_Set (self.Normal, normal)
	
	return self
end

function GCAD.NativePlane3d.SetNormalUnpacked (self, x, y, z)
	self.Normal = GCAD_UnpackedVector3d_ToNativeVector (x, y, z, self.Normal)
	
	return self
end

-- Plane operations
local GCAD_NativePlane3d_GetNormalLength = GCAD.NativePlane3d.GetNormalLength

function GCAD.NativePlane3d.Flip (self, out)
	out.Normal = Vector___unm (self.Normal)
	out [4] = -self [4]
	
	return out
end

function GCAD.NativePlane3d.Normalize (self, out)
	out = out or GCAD.NativePlane3d ()
	
	local length = GCAD_NativePlane3d_GetNormalLength (self)
	Vector_Normalize (self.Normal)
	out [4] = self [4] / length
	
	return out
end

-- Plane queries
local GCAD_NativePlane3d_GetNormalLength = GCAD.NativePlane3d.GetNormalLength

function GCAD.NativePlane3d.DistanceToPoint (self, v3d)
	return (GCAD_Vector3d_Dot (self.Normal, v3d) + self [4]) / GCAD_NativePlane3d_GetNormalLength (self)
end

function GCAD.NativePlane3d.DistanceToNativePoint (self, v)
	return (Vector_Dot (self.Normal, v) + self [4]) / GCAD_NativePlane3d_GetNormalLength (self)
end

function GCAD.NativePlane3d.DistanceToUnpackedPoint (self, x, y, z)
	return (GCAD_UnpackedVector3d_Dot (x, y, z, GCAD_UnpackedVector3d_FromNativeVector (self.Normal)) + self [4]) / GCAD_NativePlane3d_GetNormalLength (self)
end

function GCAD.NativePlane3d.ScaledDistanceToPoint (self, v3d)
	return GCAD_Vector3d_Dot (self.Normal, v3d) + self [4]
end

function GCAD.NativePlane3d.ScaledDistanceToNativePoint (self, v)
	return Vector_Dot (self.Normal, v) + self [4]
end

function GCAD.NativePlane3d.ScaledDistanceToUnpackedPoint (self, x, y, z)
	return GCAD_UnpackedVector3d_Dot (x, y, z, GCAD_UnpackedVector3d_FromNativeVector (self.Normal)) + self [4]
end

-- Intersection tests
local GCAD_NativePlane3d_DistanceToPoint               = GCAD.NativePlane3d.DistanceToPoint
local GCAD_NativePlane3d_DistanceToNativePoint         = GCAD.NativePlane3d.DistanceToNativePoint
local GCAD_NativePlane3d_DistanceToUnpackedPoint       = GCAD.NativePlane3d.DistanceToUnpackedPoint
local GCAD_NativePlane3d_ScaledDistanceToPoint         = GCAD.NativePlane3d.ScaledDistanceToPoint
local GCAD_NativePlane3d_ScaledDistanceToNativePoint   = GCAD.NativePlane3d.ScaledDistanceToNativePoint
local GCAD_NativePlane3d_ScaledDistanceToUnpackedPoint = GCAD.NativePlane3d.ScaledDistanceToUnpackedPoint

-- Point
function GCAD.NativePlane3d.ContainsPoint (self, v3d)
	return GCAD_NativePlane3d_ScaledDistanceToPoint (self, v3d) < 0
end

function GCAD.NativePlane3d.ContainsNativePoint (self, v)
	return GCAD_NativePlane3d_ScaledDistanceToNativePoint (self, v) < 0
end

function GCAD.NativePlane3d.ContainsUnpackedPoint (self, x, y, z)
	return GCAD_NativePlane3d_ScaledDistanceToUnpackedPoint (self, x, y, z) < 0
end

-- Sphere
function GCAD.NativePlane3d.ContainsSphere (self, sphere3d)
	local distance = GCAD_NativePlane3d_DistanceToPoint (self, sphere3d)
	return distance + sphere3d [4] < 0
end

function GCAD.NativePlane3d.ContainsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_NativePlane3d_DistanceToNativePoint (self, nativeSphere3d.Position)
	return distance + nativeSphere3d [4] < 0
end

function GCAD.NativePlane3d.ContainsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_NativePlane3d_DistanceToUnpackedPoint (self, x, y, z)
	return distance + r < 0
end

function GCAD.NativePlane3d.IntersectsSphere (self, sphere3d)
	local distance = GCAD_NativePlane3d_DistanceToPoint (self, sphere3d)
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NativePlane3d.IntersectsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_NativePlane3d_DistanceToNativePoint (self, nativeSphere3d.Position)
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NativePlane3d.IntersectsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_NativePlane3d_DistanceToUnpackedPoint (self, x, y, z)
	if distance + r < 0 then return true, true  end -- sphere lies within this plane
	if distance - r < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

-- Box
local GCAD_NativePlane3d_ContainsUnpackedPoint = GCAD.NativePlane3d.ContainsUnpackedPoint

function GCAD.NativePlane3d.ContainsAABB (self, aabb3d)
	local farCornerId, nearCornerId = aabb3d:GetExtremeCornerIds (self)
	
	return GCAD_NativePlane3d_ContainsUnpackedPoint (self, aabb3d:GetCornerUnpacked (farCornerId))
end

function GCAD.NativePlane3d.IntersectsAABB (self, aabb3d)
	local farCornerId, nearCornerId = aabb3d:GetExtremeCornerIds (self)
	
	return GCAD_NativePlane3d_ContainsUnpackedPoint (self, aabb3d:GetCornerUnpacked (nearCornerId))
end

GCAD.NativePlane3d.ContainsOBB   = GCAD.NativePlane3d.ContainsAABB
GCAD.NativePlane3d.IntersectsOBB = GCAD.NativePlane3d.IntersectsAABB

-- Conversion
local GCAD_NativePlane3d_SetNormal = GCAD.NativePlane3d.SetNormal
function GCAD.NativePlane3d.FromPlane3d (plane3d, out)
	out = out or GCAD.NativePlane3d ()
	
	GCAD_NativePlane3d_SetNormal (out, plane3d)
	out [4] = plane3d [4]
	
	return out
end

function GCAD.NativePlane3d.ToPlane3d (self, out)
	out = out or GCAD.Plane3d ()
	
	out:SetNormalNative (self.Normal)
	out [4] = self [4]
	
	return out
end

-- Utility
function GCAD.NativePlane3d.Unpack (self)
	return Vector___index (self.Normal, 1), Vector___index (self.Normal, 2), Vector___index (self.Normal, 3), self [4]
end

function GCAD.NativePlane3d.ToString (self)
	return "Plane [(" .. tostring (Vector___index (self.Normal, 1)) .. ", " .. tostring (Vector___index (self.Normal, 2)) .. ", " .. tostring (Vector___index (self.Normal, 3)) .. "), " .. tostring (self [4]) .. "]"
end

-- Construction
function GCAD.NativePlane3d.Minimum (out)
	out = out or GCAD.NativePlane3d (1, 0, 0)
	
	out [4] = math.huge
	
	return out
end

function GCAD.NativePlane3d.Maximum (out)
	out = out or GCAD.NativePlane3d (1, 0, 0)
	
	out [4] = -math.huge
	
	return out
end

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

local GCAD_NativePlane3d_Minimum = GCAD.NativePlane3d.Minimum
local GCAD_NativePlane3d_Maximum = GCAD.NativePlane3d.Maximum

function self:Minimize () return GCAD_NativePlane3d_Minimum (self) end
function self:Maximize () return GCAD_NativePlane3d_Maximum (self) end

-- Copying
self.Clone                         = GCAD.NativePlane3d.Clone
self.Copy                          = GCAD.NativePlane3d.Copy

-- Plane properties
self.GetNormal                     = GCAD.NativePlane3d.GetNormal
self.GetNormalUnpacked             = GCAD.NativePlane3d.GetNormalUnpacked
self.GetNormalLength               = GCAD.NativePlane3d.GetNormalLength
self.SetNormal                     = GCAD.NativePlane3d.SetNormal
self.SetNormalUnpacked             = GCAD.NativePlane3d.SetNormalUnpacked

-- Plane operations
self.Flip                          = GCAD.NativePlane3d.Flip
self.Normalize                     = GCAD.NativePlane3d.Normalize

-- Plane queries
self.DistanceToPoint               = GCAD.NativePlane3d.DistanceToPoint
self.DistanceToNativePoint         = GCAD.NativePlane3d.DistanceToNativePoint
self.DistanceToUnpackedPoint       = GCAD.NativePlane3d.DistanceToUnpackedPoint
self.ScaledDistanceToPoint         = GCAD.NativePlane3d.ScaledDistanceToPoint
self.ScaledDistanceToNativePoint   = GCAD.NativePlane3d.ScaledDistanceToNativePoint
self.ScaledDistanceToUnpackedPoint = GCAD.NativePlane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
-- Point
self.ContainsPoint                 = GCAD.NativePlane3d.ContainsPoint
self.ContainsNativePoint           = GCAD.NativePlane3d.ContainsNativePoint
self.ContainsUnpackedPoint         = GCAD.NativePlane3d.ContainsUnpackedPoint

-- Sphere
self.ContainsSphere                = GCAD.NativePlane3d.ContainsSphere
self.ContainsNativeSphere          = GCAD.NativePlane3d.ContainsNativeSphere
self.ContainsUnpackedSphere        = GCAD.NativePlane3d.ContainsUnpackedSphere
self.IntersectsSphere              = GCAD.NativePlane3d.IntersectsSphere
self.IntersectsNativeSphere        = GCAD.NativePlane3d.IntersectsNativeSphere
self.IntersectsUnpackedSphere      = GCAD.NativePlane3d.IntersectsUnpackedSphere

-- Box
self.ContainsAABB                  = GCAD.NativePlane3d.ContainsAABB
self.IntersectsAABB                = GCAD.NativePlane3d.IntersectsAABB
self.ContainsOBB                   = GCAD.NativePlane3d.ContainsOBB
self.IntersectsOBB                 = GCAD.NativePlane3d.IntersectsOBB

-- Conversion
self.ToPlane3d                     = GCAD.NativePlane3d.ToPlane3d

-- Utility
self.Unpack                        = GCAD.NativePlane3d.Unpack
self.ToString                      = GCAD.NativePlane3d.ToString
self.__tostring                    = GCAD.NativePlane3d.ToString
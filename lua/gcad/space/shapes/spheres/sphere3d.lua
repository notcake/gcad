local self = {}
GCAD.Sphere3d = GCAD.MakeConstructor (self)

local Entity_BoundingRadius            = debug.getregistry ().Entity.BoundingRadius
local Entity_GetPos                    = debug.getregistry ().Entity.GetPos
local Entity_OBBCenter                 = debug.getregistry ().Entity.OBBCenter
local Vector___add                     = debug.getregistry ().Vector.__add
local Vector___index                   = debug.getregistry ().Vector.__index

local GCAD_Vector3d_DistanceTo         = GCAD.Vector3d.DistanceTo
local GCAD_UnpackedVector3d_DistanceTo = GCAD.UnpackedVector3d.DistanceTo

function GCAD.Sphere3d.FromEntityBoundingSphere (ent, out)
	out = out or GCAD.Sphere3d ()
	
	local pos = Vector___add (Entity_GetPos (ent), Entity_OBBCenter (ent))
	out [1] = Vector___index (pos, "x")
	out [2] = Vector___index (pos, "y")
	out [3] = Vector___index (pos, "z")
	out [4] = Entity_BoundingRadius (ent)
	
	return out
end

function GCAD.Sphere3d.FromPositionAndRadius (position, radius, out)
	out = out or GCAD.Sphere3d ()
	
	out [1] = position [1]
	out [2] = position [2]
	out [3] = position [3]
	out [4] = radius
	
	return out
end

-- Copying
function GCAD.Sphere3d.Clone (self, out)
	out = out or GCAD.Sphere3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	
	return out
end

function GCAD.Sphere3d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	
	return self
end

-- Circle properties
function GCAD.Sphere3d.GetPosition (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function GCAD.Sphere3d.GetPositionNative (self, out)
	return GCAD_Vector3d_ToNativeVector (self, out)
end

function GCAD.Sphere3d.GetPositionUnpacked (self)
	return self [1], self [2], self [3]
end

function GCAD.Sphere3d.GetRadius (self)
	return self [4]
end

function GCAD.Sphere3d.SetPosition (self, pos)
	self [1] = pos [1]
	self [2] = pos [2]
	self [3] = pos [3]
	
	return self
end

function GCAD.Sphere3d.SetPositionNative (self, pos)
	self [1] = Vector___index (pos, "x")
	self [2] = Vector___index (pos, "y")
	self [3] = Vector___index (pos, "z")
	
	return self
end

function GCAD.Sphere3d.SetPositionUnpacked (self, x, y, z)
	self [1] = x
	self [2] = y
	self [3] = z
	
	return self
end

function GCAD.Sphere3d.SetRadius (self, r)
	self [4] = r
	
	return self
end

-- Circle queries
function GCAD.Sphere3d.DistanceToPoint (self, v3d)
	return GCAD_Vector3d_DistanceTo (self, v3d) - self [4]
end

GCAD.Sphere3d.DistanceToNativePoint = GCAD.Sphere3d.DistanceToPoint

function GCAD.Sphere3d.DistanceToUnpackedPoint (self, x, y, z)
	return GCAD_UnpackedVector3d_DistanceTo (self [1], self [2], self [3], x, y, z) - self [4]
end

-- Intersection tests
local GCAD_Sphere3d_DistanceToPoint         = GCAD.Sphere3d.DistanceToPoint
local GCAD_Sphere3d_DistanceToNativePoint   = GCAD.Sphere3d.DistanceToNativePoint
local GCAD_Sphere3d_DistanceToUnpackedPoint = GCAD.Sphere3d.DistanceToUnpackedPoint

function GCAD.Sphere3d.ContainsPoint (self, v3d)
	return GCAD_Sphere3d_DistanceToPoint (self, v3d) < 0
end

function GCAD.Sphere3d.ContainsNativePoint (self, v)
	return GCAD_Sphere3d_DistanceToNativePoint (self, v) < 0
end

function GCAD.Sphere3d.ContainsUnpackedPoint (self, x, y, z)
	return GCAD_Sphere3d_DistanceToUnpackedPoint (self, x, y, z) < 0
end

function GCAD.Sphere3d.ContainsSphere (self, sphere3d)
	local distance = GCAD_Vector3d_DistanceTo (self, sphere3d)
	return distance + sphere3d [4] < self [4]
end

function GCAD.Sphere3d.ContainsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_UnpackedVector3d_DistanceTo (self [1], self [2], self [3], nativeSphere3d:GetPositionUnpacked ())
	return distance + nativeSphere3d [4] < self [4]
end

function GCAD.Sphere3d.ContainsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_UnpackedVector3d_DistanceTo (self [1], self [2], self [3], x, y, z)
	return distance + r < self [4]
end

function GCAD.Sphere3d.IntersectsSphere (self, sphere3d)
	local distance = GCAD_Vector3d_DistanceTo (self, sphere3d)
	local thisRadius   = self [4]
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

function GCAD.Sphere3d.IntersectsNativeSphere (self, nativeSphere3d)
	local distance = GCAD_UnpackedVector3d_DistanceTo (self [1], self [2], self [3], nativeSphere3d:GetPositionUnpacked ())
	local thisRadius   = self [4]
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

function GCAD.Sphere3d.IntersectsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_UnpackedVector3d_DistanceTo (self [1], self [2], self [3], x, y, z)
	local thisRadius = self [4]
	if distance + r < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - r < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

-- Conversion
function GCAD.Sphere3d.FromNativeSphere3d (nativeSphere3d, out)
	out = out or GCAD.Sphere3d ()
	
	out [1], out [2], out [3] = nativeSphere3d:GetPositionUnpacked ()
	out [4] = nativeSphere3d [4]
	
	return out
end

function GCAD.Sphere3d.ToNativeSphere3d (self, out)
	out = out or GCAD.NativeSphere3d ()
	
	out:SetPositionUnpacked (self [1], self [2], self [3])
	out [4] = self [4]
	
	return out
end

-- Utility
function GCAD.Sphere3d.Unpack (self)
	return self [1], self [2], self [3], self [4]
end

function GCAD.Sphere3d.ToString (self)
	return "Sphere [(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .."), " .. tostring (self [4]) .. "]"
end

-- Construction
function GCAD.Sphere3d.Minimum (out)
	out = out or GCAD.Sphere3d ()
	
	out [4] = -math.huge
	
	return out
end

function GCAD.Sphere3d.Maximum (out)
	out = out or GCAD.Sphere3d ()
	
	out [4] = math.huge
	
	return out
end

function self:ctor (x, y, z, r)
	self [1] = x or 0
	self [2] = y or 0
	self [3] = z or 0
	self [4] = r or 0
end

-- Initialization
function self:Set (x, y, z, r)
	self [1] = x
	self [2] = y
	self [3] = z
	self [4] = r
end

local GCAD_Sphere3d_Minimum = GCAD.Sphere3d.Minimum
local GCAD_Sphere3d_Maximum = GCAD.Sphere3d.Maximum

function self:Minimize () return GCAD_Sphere3d_Minimum (self) end
function self:Maximize () return GCAD_Sphere3d_Maximum (self) end

-- Copying
self.Clone                    = GCAD.Sphere3d.Clone
self.Copy                     = GCAD.Sphere3d.Copy

-- Circle properties
self.GetPosition              = GCAD.Sphere3d.GetPosition
self.GetPositionNative        = GCAD.Sphere3d.GetPositionNative
self.GetPositionUnpacked      = GCAD.Sphere3d.GetPositionUnpacked
self.GetRadius                = GCAD.Sphere3d.GetRadius
self.SetPosition              = GCAD.Sphere3d.SetPosition
self.SetPositionNative        = GCAD.Sphere3d.SetPositionNative
self.SetPositionUnpacked      = GCAD.Sphere3d.SetPositionUnpacked
self.SetRadius                = GCAD.Sphere3d.SetRadius

-- Circle queries
self.DistanceToPoint          = GCAD.Sphere3d.DistanceToPoint
self.DistanceToNativePoint    = GCAD.Sphere3d.DistanceToNativePoint
self.DistanceToUnpackedPoint  = GCAD.Sphere3d.DistanceToUnpackedPoint

-- Intersection tests
self.ContainsPoint            = GCAD.Sphere3d.ContainsPoint
self.ContainsNativePoint      = GCAD.Sphere3d.ContainsNativePoint
self.ContainsUnpackedPoint    = GCAD.Sphere3d.ContainsUnpackedPoint
self.ContainsSphere           = GCAD.Sphere3d.ContainsSphere
self.ContainsNativeSphere     = GCAD.Sphere3d.ContainsNativeSphere
self.ContainsUnpackedSphere   = GCAD.Sphere3d.ContainsUnpackedSphere
self.IntersectsSphere         = GCAD.Sphere3d.IntersectsSphere
self.IntersectsNativeSphere   = GCAD.Sphere3d.IntersectsNativeSphere
self.IntersectsUnpackedSphere = GCAD.Sphere3d.IntersectsUnpackedSphere

-- Conversion
self.ToNativeSphere3d         = GCAD.Sphere3d.ToNativeSphere3d

-- Utility
self.Unpack                   = GCAD.Sphere3d.Unpack
self.ToString                 = GCAD.Sphere3d.ToString
self.__tostring               = GCAD.Sphere3d.ToString
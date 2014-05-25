local self = {}
GCAD.NativeSphere3d = GCAD.MakeConstructor (self)

local Entity_BoundingRadius                  = debug.getregistry ().Entity.BoundingRadius
local Entity_GetPos                          = debug.getregistry ().Entity.GetPos
local Entity_OBBCenter                       = debug.getregistry ().Entity.OBBCenter
local Vector_Distance                        = debug.getregistry ().Vector.Distance
local Vector_Set                             = debug.getregistry ().Vector.Set
local Vector___add                           = debug.getregistry ().Vector.__add
local Vector___index                         = debug.getregistry ().Vector.__index

local GCAD_Vector3d_DistanceTo               = GCAD.Vector3d.DistanceTo
local GCAD_Vector3d_ToNativeVector           = GCAD.Vector3d.ToNativeVector
local GCAD_UnpackedVector3d_DistanceTo       = GCAD.UnpackedVector3d.DistanceTo
local GCAD_UnpackedVector3d_FromNativeVector = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_ToNativeVector   = GCAD.UnpackedVector3d.ToNativeVector

function GCAD.NativeSphere3d.FromEntityBoundingSphere (ent, out)
	out = out or GCAD.NativeSphere3d ()
	
	local pos = Vector___add (Entity_GetPos (ent), Entity_OBBCenter (ent))
	Vector_Set (out.Position, pos)
	out [4] = Entity_BoundingRadius (ent)
	
	return out
end

function GCAD.NativeSphere3d.FromPositionAndRadius (position, radius, out)
	out = out or GCAD.NativeSphere3d ()
	
	out.Position = GCAD_Vector3d_ToNativeVector (position, out.Position)
	out [4] = radius
	
	return out
end

-- Copying
function GCAD.NativeSphere3d.Clone (self, out)
	out = out or GCAD.NativeSphere3d ()
	
	Vector_Set (out.Position, self.Position)
	out [4] = self [4]
	
	return out
end

function GCAD.NativeSphere3d.Copy (self, source)
	Vector_Set (self.Position, source.Position)
	self [4] = source [4]
	
	return self
end

-- Circle properties
function GCAD.NativeSphere3d.GetPosition (self, out)
	return GCAD_Vector3d_FromNativeVector (self.Position, out)
end

function GCAD.NativeSphere3d.GetPositionNative (self, out)
	out = out or Vector ()
	
	Vector_Set (out, self.Position)
	
	return out
end

function GCAD.NativeSphere3d.GetPositionUnpacked (self)
	return GCAD_UnpackedVector3d_FromNativeVector (self.Position)
end

function GCAD.NativeSphere3d.GetRadius (self)
	return self [4]
end

function GCAD.NativeSphere3d.SetPosition (self, pos)
	self.Position = GCAD_Vector3d_ToNativeVector (pos, self.Position)
	
	return self
end

function GCAD.NativeSphere3d.SetPositionNative (self, pos)
	Vector_Set (self.Position, pos)
	
	return self
end

function GCAD.NativeSphere3d.SetPositionUnpacked (self, x, y, z)
	self.Position = GCAD_UnpackedVector3d_ToNativeVector (x, y, z, self.Position)
	
	return self
end

function GCAD.NativeSphere3d.SetRadius (self, r)
	self [4] = r
	
	return self
end

-- Circle queries
function GCAD.NativeSphere3d.DistanceToPoint (self, v3d)
	return GCAD_Vector3d_DistanceTo (self.Position, v3d) - self [4]
end

function GCAD.NativeSphere3d.DistanceToNativePoint (self, v)
	return Vector_Distance (self.Position, v) - self [4]
end

function GCAD.NativeSphere3d.DistanceToUnpackedPoint (self, x, y, z)
	return GCAD_UnpackedVector3d_DistanceTo (x, y, z, GCAD_UnpackedVector3d_FromNativeVector (self.Position)) - self [4]
end

-- Intersection tests
-- Point
local GCAD_NativeSphere3d_DistanceToPoint         = GCAD.NativeSphere3d.DistanceToPoint
local GCAD_NativeSphere3d_DistanceToNativePoint   = GCAD.NativeSphere3d.DistanceToNativePoint
local GCAD_NativeSphere3d_DistanceToUnpackedPoint = GCAD.NativeSphere3d.DistanceToUnpackedPoint

function GCAD.NativeSphere3d.ContainsPoint (self, v3d)
	return GCAD_NativeSphere3d_DistanceToPoint (self, v3d) < 0
end

function GCAD.NativeSphere3d.ContainsNativePoint (self, v)
	return GCAD_NativeSphere3d_DistanceToNativePoint (self, v) < 0
end

function GCAD.NativeSphere3d.ContainsUnpackedPoint (self, x, y, z)
	return GCAD_NativeSphere3d_DistanceToUnpackedPoint (self, x, y, z) < 0
end

-- Sphere
function GCAD.NativeSphere3d.ContainsSphere (self, sphere3d)
	local distance = GCAD_Vector3d_DistanceTo (self.Position, sphere3d)
	return distance + sphere3d [4] < self [4]
end

function GCAD.NativeSphere3d.ContainsNativeSphere (self, nativeSphere3d)
	local distance = Vector_Distance (self.Position, nativeSphere3d.Position)
	return distance + nativeSphere3d [4] < self [4]
end

function GCAD.NativeSphere3d.ContainsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, GCAD_UnpackedVector3d_FromNativeVector (self.Position))
	return distance + r < self [4]
end

function GCAD.NativeSphere3d.IntersectsSphere (self, sphere3d)
	local distance = GCAD_Vector3d_DistanceTo (self.Position, sphere3d)
	local thisRadius   = self [4]
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

function GCAD.NativeSphere3d.IntersectsNativeSphere (self, nativeSphere3d)
	local distance = Vector_Distance (self.Position, nativeSphere3d.Position)
	local thisRadius   = self [4]
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

function GCAD.NativeSphere3d.IntersectsUnpackedSphere (self, x, y, z, r)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, GCAD_UnpackedVector3d_FromNativeVector (self.Position))
	local thisRadius = self [4]
	if distance + r < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - r < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

-- Conversion
local GCAD_NativeSphere3d_SetPosition = GCAD.NativeSphere3d.SetPosition
function GCAD.NativeSphere3d.FromSphere3d (sphere3d, out)
	out = out or GCAD.NativeSphere3d ()
	
	GCAD_NativeSphere3d_SetPosition (out, sphere3d)
	out [4] = sphere3d [4]
	
	return out
end

function GCAD.NativeSphere3d.ToSphere3d (self, out)
	out = out or GCAD.Sphere3d ()
	
	out:SetPositionNative (self.Position)
	out [4] = self [4]
	
	return out
end

-- Utility
function GCAD.NativeSphere3d.Unpack (self)
	return Vector___index (self.Position, "x"), Vector___index (self.Position, "y"), Vector___index (self.Position, "z"), self [4]
end

function GCAD.NativeSphere3d.ToString (self)
	return "Sphere [(" .. tostring (Vector___index (self.Position, "x")) .. ", " .. tostring (Vector___index (self.Position, "y")) .. ", " .. tostring (Vector___index (self.Position, "z")) .."), " .. tostring (self [4]) .. "]"
end

-- Construction
function GCAD.NativeSphere3d.Minimum (out)
	out = out or GCAD.NativeSphere3d ()
	
	out [4] = -math.huge
	
	return out
end

function GCAD.NativeSphere3d.Maximum (out)
	out = out or GCAD.NativeSphere3d ()
	
	out [4] = math.huge
	
	return out
end

function self:ctor (x, y, z, r)
	self.Position = Vector (x or 0, y or 0, z or 0)
	self [4] = r or 0
end

-- Initialization
function self:Set (x, y, z, r)
	self.Position = GCAD_UnpackedVector3d_ToNativeVector (x, y, z, self.Position)
	self [4] = r
	
	return self
end

local GCAD_NativeSphere3d_Minimum = GCAD.NativeSphere3d.Minimum
local GCAD_NativeSphere3d_Maximum = GCAD.NativeSphere3d.Maximum

function self:Minimize () return GCAD_NativeSphere3d_Minimum (self) end
function self:Maximize () return GCAD_NativeSphere3d_Maximum (self) end

-- Copying
self.Clone                    = GCAD.NativeSphere3d.Clone
self.Copy                     = GCAD.NativeSphere3d.Copy

-- Circle properties
self.GetPosition              = GCAD.NativeSphere3d.GetPosition
self.GetPositionNative        = GCAD.NativeSphere3d.GetPositionNative
self.GetPositionUnpacked      = GCAD.NativeSphere3d.GetPositionUnpacked
self.GetRadius                = GCAD.NativeSphere3d.GetRadius
self.SetPosition              = GCAD.NativeSphere3d.SetPosition
self.SetPositionNative        = GCAD.NativeSphere3d.SetPositionNative
self.SetPositionUnpacked      = GCAD.NativeSphere3d.SetPositionUnpacked
self.SetRadius                = GCAD.NativeSphere3d.SetRadius

-- Circle queries
self.DistanceToPoint          = GCAD.NativeSphere3d.DistanceToPoint
self.DistanceToNativePoint    = GCAD.NativeSphere3d.DistanceToNativePoint
self.DistanceToUnpackedPoint  = GCAD.NativeSphere3d.DistanceToUnpackedPoint

-- Intersection tests
-- Point
self.ContainsPoint            = GCAD.NativeSphere3d.ContainsPoint
self.ContainsNativePoint      = GCAD.NativeSphere3d.ContainsNativePoint
self.ContainsUnpackedPoint    = GCAD.NativeSphere3d.ContainsUnpackedPoint

-- Sphere
self.ContainsSphere           = GCAD.NativeSphere3d.ContainsSphere
self.ContainsNativeSphere     = GCAD.NativeSphere3d.ContainsNativeSphere
self.ContainsUnpackedSphere   = GCAD.NativeSphere3d.ContainsUnpackedSphere
self.IntersectsSphere         = GCAD.NativeSphere3d.IntersectsSphere
self.IntersectsNativeSphere   = GCAD.NativeSphere3d.IntersectsNativeSphere
self.IntersectsUnpackedSphere = GCAD.NativeSphere3d.IntersectsUnpackedSphere

-- Conversion
self.ToSphere3d               = GCAD.NativeSphere3d.ToSphere3d

-- Utility
self.Unpack                   = GCAD.NativeSphere3d.Unpack
self.ToString                 = GCAD.NativeSphere3d.ToString
self.__tostring               = GCAD.NativeSphere3d.ToString
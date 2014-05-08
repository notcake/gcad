local self = {}
GCAD.NativeSphere3d = GCAD.MakeConstructor (self)

local Entity_BoundingRadius = debug.getregistry ().Entity.BoundingRadius
local Entity_GetPos         = debug.getregistry ().Entity.GetPos
local Entity_OBBCenter      = debug.getregistry ().Entity.OBBCenter
local Vector___add          = debug.getregistry ().Vector.__add
local Vector_Set            = debug.getregistry ().Vector.Set

function GCAD.NativeSphere3d.FromEntity (ent, out)
	out = out or GCAD.NativeSphere3d ()
	
	local pos = Vector___add (Entity_GetPos (ent), Entity_OBBCenter (ent))
	Vector_Set (out.Position, pos)
	out [4] = Entity_BoundingRadius (ent)
	
	return out
end

function self:ctor ()
	self.Position = Vector ()
	self [4] = 0
end

function self:GetPosition (out)
	out = out or Vector ()
	out:Set (self.Position)
	return out
end

function self:GetRadius ()
	return self [4]
end

function self:SetPosition (position)
	self.Position:Set (position)
end

function self:SetRadius (radius)	
	 self [4] = radius
end

-- Geometry
function self:DistanceFromCenterToNativePoint (pos)
	return self.Position:Distance (pos)
end

function self:DistanceFromCenterToNativePointSquared (pos)
	return self.Position:DistToSqr (pos)
end

-- Intersection tests
function self:ContainsNativePoint (pos)
	local distanceSquared = self:DistanceFromCenterToNativePointSquared (pos)
	return distanceSquared < self [4] * self [4]
end

function self:ContainsNativeSphere (nativeSphere)
	local distance = self:DistanceFromCenterToNativePoint (nativeSphere.Position)
	return distance + nativeSphere [4] < self [4]
end

function self:IntersectsNativeSphere (nativeSphere)
	local distance = self:DistanceFromCenterToNativePoint (nativeSphere.Position)
	local thisRadius   = self [4]
	local sphereRadius = nativeSphere [4]
	if distance + sphereRadius < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end
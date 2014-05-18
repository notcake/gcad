local self = {}
GCAD.Sphere3d = GCAD.MakeConstructor (self)

local Entity_BoundingRadius = debug.getregistry ().Entity.BoundingRadius
local Entity_GetPos         = debug.getregistry ().Entity.GetPos
local Entity_OBBCenter      = debug.getregistry ().Entity.OBBCenter
local Vector___add          = debug.getregistry ().Vector.__add
local Vector___index        = debug.getregistry ().Vector.__index

function GCAD.Sphere3d.FromEntityBoundingSphere (ent, out)
	out = out or GCAD.Sphere3d ()
	
	local pos = Vector___add (Entity_GetPos (ent), Entity_OBBCenter (ent))
	out [1] = Vector___index (pos, "x")
	out [2] = Vector___index (pos, "y")
	out [3] = Vector___index (pos, "z")
	out [4] = Entity_BoundingRadius (ent)
	
	return out
end

function self:ctor (x, y, z, r)
	self [1] = x or 0
	self [2] = y or 0
	self [3] = z or 0
	self [4] = r or 0
end

function self:GetPosition (out)
	out = out or GLib.ColumnVector (3)
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function self:GetRadius ()
	return self [4]
end

function self:SetPosition (position)
	self [1] = position [1]
	self [2] = position [2]
	self [3] = position [3]
	
	return self
end

function self:SetRadius (radius)	
	 self [4] = radius
end

-- Geometry
function self:DistanceFromCenterToPoint (pos)
	local dx = pos [1] - self [1]
	local dy = pos [2] - self [2]
	local dz = pos [3] - self [3]
	return math.sqrt (dx * dx + dy * dy + dz * dz)
end

function self:DistanceFromCenterToPointSquared (pos)
	local dx = pos [1] - self [1]
	local dy = pos [2] - self [2]
	local dz = pos [3] - self [3]
	return dx * dx + dy * dy + dz * dz
end

-- Intersection tests
function self:ContainsPoint (pos)
	local distanceSquared = self:DistanceFromCenterToPointSquared (pos)
	return distanceSquared < self [4] * self [4]
end

function self:ContainsAnyVertex (vertexEnumerable, tmp)
	tmp = tmp or GLib.ColumnVector (3)
	for vertex in vertexEnumerable:GetVertexEnumerator (tmp) do
		if self:ContainsPoint (vertex) then return true end
	end
	
	return false
end

function self:ContainsVertices (vertexEnumerable, tmp)
	tmp = tmp or GLib.ColumnVector (3)
	for vertex in vertexEnumerable:GetVertexEnumerator (tmp) do
		if not self:ContainsPoint (vertex) then return false end
	end
	
	return true
end

function self:ContainsSphere (sphere)
	local distance = self:DistanceFromCenterToPoint (sphere)
	return distance + sphere [4] < self [4]
end

function self:IntersectsSphere (sphere)
	local distance = self:DistanceFromCenterToPoint (sphere)
	local thisRadius   = self [4]
	local sphereRadius = sphere [4]
	if distance + sphereRadius < thisRadius then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < thisRadius then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end
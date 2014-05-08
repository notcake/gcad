local self = {}
GCAD.Plane3d = GCAD.MakeConstructor (self)

local Vector___unm         = debug.getregistry ().Vector.__unm
local Vector_Dot           = debug.getregistry ().Vector.Dot
local Vector_GetNormalized = debug.getregistry ().Vector.GetNormalized
local Vector_Set           = debug.getregistry ().Vector.Set

function GCAD.Plane3d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.Plane3d ()
	
	-- ax + by + cz + d = 0
	-- d = -normal . position
	out:SetNormal (normal)
	out [4] = -position [1] * normal [1] - position [2] * normal [2] - position [3] * normal [3]
	
	return out
end

function self:ctor (a, b, c, d)
	self [1] = a or 0
	self [2] = b or 0
	self [3] = c or 0
	self [4] = d or 0
	
	self.NativeNormal = Vector ()
end

function self:Flip (out)
	out = out or GCAD.Plane3d ()
	
	out [1] = -self [1]
	out [2] = -self [2]
	out [3] = -self [3]
	out [4] = -self [4]
	
	Vector_Set (out.NativeNormal, Vector___unm (self.NativeNormal))
	
	return out
end

function self:GetNormal (out)
	out = out or GLib.ColumnVector (3)
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function self:Normalize (out)
	out = out or GCAD.Plane3d ()
	
	local length = math.sqrt (self [1] * self [1] + self [2] * self [2] + self [3] * self [3])
	
	out [1] = self [1] / length
	out [2] = self [2] / length
	out [3] = self [3] / length
	out [4] = self [4] / length
	
	out.NativeNormal = Vector_GetNormalized (self.NativeNormal)
	
	return out
end

function self:SetNormal (normal)
	self [1] = normal [1]
	self [2] = normal [2]
	self [3] = normal [3]
	
	if type (normal) == "Vector" then
		Vector_Set (self.NativeNormal, normal)
	else
		self.NativeNormal [1] = normal [1]
		self.NativeNormal [2] = normal [2]
		self.NativeNormal [3] = normal [3]
	end
	
	return self
end

-- Geometry
function self:DistanceToNativePoint (pos)
	return Vector_Dot (self.NativeNormal, pos) + self [4]
end

function self:DistanceToPoint (pos)
	return self [1] * pos [1] + self [2] * pos [2] + self [3] * pos [3] + self [4]
end

-- Intersection tests
function self:ContainsNativePoint (pos)
	return self:DistanceToNativePoint (pos) < 0
end

function self:ContainsPoint (pos)
	return self:DistanceToPoint (pos) < 0
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

function self:ContainsNativeSphere (nativeSphere)
	local distance = self:DistanceToNativePoint (nativeSphere.Position)
	return distance + nativeSphere [4] < 0
end

function self:ContainsSphere (sphere)
	local distance = self:DistanceToPoint (sphere)
	return distance + sphere [4] < 0
end

function self:IntersectsNativeSphere (nativeSphere)
	local distance = self:DistanceToNativePoint (nativeSphere.Position)
	local sphereRadius = nativeSphere [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function self:IntersectsSphere (sphere)
	local distance = self:DistanceToPoint (sphere)
	local sphereRadius = sphere [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end
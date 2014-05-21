local self = {}
GCAD.Frustum3d = GCAD.MakeConstructor (self)

if CLIENT then
	function GCAD.Frustum3d.FromScreenAABB (x1, y1, x2, y2, out)
		GCAD.Profiler:Begin ("Frustum3d.FromScreenAABB")
		
		out = out or GCAD.Frustum3d ()
		
		local pos = LocalPlayer ():EyePos ()
		local ang = LocalPlayer ():EyeAngles ()
		local right = ang:Right ()
		local up    = ang:Up ()
		
		local topLeft     = gui.ScreenToVector (x1, y1)
		local bottomRight = gui.ScreenToVector (x2, y2)
		
		GCAD.Plane3d.FromPositionAndNormal (pos, up         :Cross (topLeft), out.LeftPlane  )
		GCAD.Plane3d.FromPositionAndNormal (pos, bottomRight:Cross (up     ), out.RightPlane )
		GCAD.Plane3d.FromPositionAndNormal (pos, right      :Cross (topLeft), out.TopPlane   )
		GCAD.Plane3d.FromPositionAndNormal (pos, bottomRight:Cross (right  ), out.BottomPlane)
		
		out.LeftPlane  :Normalize (out.LeftPlane  )
		out.RightPlane :Normalize (out.RightPlane )
		out.TopPlane   :Normalize (out.TopPlane   )
		out.BottomPlane:Normalize (out.BottomPlane)
		
		GCAD.Profiler:End ()
		return out
	end
end

function self:ctor ()
	self.LeftPlane   = GCAD.Plane3d ()
	self.RightPlane  = GCAD.Plane3d ()
	self.TopPlane    = GCAD.Plane3d ()
	self.BottomPlane = GCAD.Plane3d ()
end

function self:ContainsPoint (pos)
	return self.LeftPlane  :ContainsPoint (pos) and
	       self.RightPlane :ContainsPoint (pos) and
		   self.TopPlane   :ContainsPoint (pos) and
		   self.BottomPlane:ContainsPoint (pos)
end

function self:ContainsAnyVertex (vertexEnumerable, tmp)
	return self:ContainsAnyVertexLiberal (vertexEnumerable, tmp)
end
self.ContainsAnyVertex = GCAD.Profiler:Wrap (self.ContainsAnyVertex, "Frustum3d:ContainsAnyVertex")

function self:ContainsAnyVertexConservative (vertexEnumerable, tmp)
	tmp = tmp or GLib.ColumnVector (3)
	
	for vertex in vertexEnumerable:GetVertexEnumerator (tmp) do
		if self:ContainsPoint (vertex) then return true end
	end
	
	return false
end

function self:ContainsAnyVertexLiberal (vertexEnumerable, tmp)
	tmp = tmp or GLib.ColumnVector (3)
	
	return self.LeftPlane  :ContainsAnyVertex (vertexEnumerable, tmp) and
	       self.RightPlane :ContainsAnyVertex (vertexEnumerable, tmp) and
	       self.TopPlane   :ContainsAnyVertex (vertexEnumerable, tmp) and
	       self.BottomPlane:ContainsAnyVertex (vertexEnumerable, tmp)
end

function self:ContainsVertices (vertexEnumerable, tmp)
	tmp = tmp or GLib.ColumnVector (3)
	for vertex in vertexEnumerable:GetVertexEnumerator (tmp) do
		if not self:ContainsPoint (vertex) then return false end
	end
	
	return true
end
self.ContainsVertices = GCAD.Profiler:Wrap (self.ContainsVertices, "Frustum3d:ContainsVertices")

function self:ContainsNativeSphere (nativeSphere)
	return self.LeftPlane  :ContainsNativeSphere (nativeSphere) and
	       self.RightPlane :ContainsNativeSphere (nativeSphere) and
	       self.TopPlane   :ContainsNativeSphere (nativeSphere) and
	       self.BottomPlane:ContainsNativeSphere (nativeSphere)
end

function self:ContainsSphere (sphere)
	return self.LeftPlane  :ContainsSphere (sphere) and
	       self.RightPlane :ContainsSphere (sphere) and
	       self.TopPlane   :ContainsSphere (sphere) and
	       self.BottomPlane:ContainsSphere (sphere)
end

function self:IntersectsNativeSphere (nativeSphere)
	local intersects1, contains1 = self.LeftPlane  :IntersectsNativeSphere (nativeSphere)
	if not intersects1 then return false, false end
	local intersects2, contains2 = self.RightPlane :IntersectsNativeSphere (nativeSphere)
	if not intersects2 then return false, false end
	local intersects3, contains3 = self.TopPlane   :IntersectsNativeSphere (nativeSphere)
	if not intersects3 then return false, false end
	local intersects4, contains4 = self.BottomPlane:IntersectsNativeSphere (nativeSphere)
	if not intersects4 then return false, false end
	
	return true, (contains1 and contains2 and contains3 and contains4)
end
self.IntersectsNativeSphere = GCAD.Profiler:Wrap (self.IntersectsNativeSphere, "Frustum3d:IntersectsNativeSphere")

function self:IntersectsSphere (sphere)
	local intersects1, contains1 = self.LeftPlane  :IntersectsSphere (sphere)
	if not intersects1 then return false, false end
	local intersects2, contains2 = self.RightPlane :IntersectsSphere (sphere)
	if not intersects2 then return false, false end
	local intersects3, contains3 = self.TopPlane   :IntersectsSphere (sphere)
	if not intersects3 then return false, false end
	local intersects4, contains4 = self.BottomPlane:IntersectsSphere (sphere)
	if not intersects4 then return false, false end
	
	return true, (contains1 and contains2 and contains3 and contains4)
end
self.IntersectsSphere = GCAD.Profiler:Wrap (self.IntersectsSphere, "Frustum3d:IntersectsSphere")
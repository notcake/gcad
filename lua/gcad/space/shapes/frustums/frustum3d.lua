local self = {}
GCAD.Frustum3d = GCAD.MakeConstructor (self)

local GCAD_NormalizedPlane3d_Clone                       = GCAD.NormalizedPlane3d.Clone
local GCAD_NormalizedPlane3d_ContainsNativePoint         = GCAD.NormalizedPlane3d.ContainsNativePoint
local GCAD_NormalizedPlane3d_ContainsNativeSphere        = GCAD.NormalizedPlane3d.ContainsNativeSphere
local GCAD_NormalizedPlane3d_ContainsOBB                 = GCAD.NormalizedPlane3d.ContainsOBB
local GCAD_NormalizedPlane3d_ContainsPoint               = GCAD.NormalizedPlane3d.ContainsPoint
local GCAD_NormalizedPlane3d_ContainsSphere              = GCAD.NormalizedPlane3d.ContainsSphere
local GCAD_NormalizedPlane3d_Copy                        = GCAD.NormalizedPlane3d.Copy
local GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d = GCAD.NormalizedPlane3d.FromNativeNormalizedPlane3d
local GCAD_NormalizedPlane3d_FromPositionAndNormal       = GCAD.NormalizedPlane3d.FromPositionAndNormal
local GCAD_NormalizedPlane3d_IntersectsNativeSphere      = GCAD.NormalizedPlane3d.IntersectsNativeSphere
local GCAD_NormalizedPlane3d_IntersectsOBB               = GCAD.NormalizedPlane3d.IntersectsOBB
local GCAD_NormalizedPlane3d_IntersectsSphere            = GCAD.NormalizedPlane3d.IntersectsSphere
local GCAD_NormalizedPlane3d_Maximum                     = GCAD.NormalizedPlane3d.Maximum
local GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d   = GCAD.NormalizedPlane3d.ToNativeNormalizedPlane3d

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
		
		out.LeftPlane   = GCAD_NormalizedPlane3d_FromPositionAndNormal (pos, up         :Cross (topLeft), out.LeftPlane  )
		out.RightPlane  = GCAD_NormalizedPlane3d_FromPositionAndNormal (pos, bottomRight:Cross (up     ), out.RightPlane )
		out.TopPlane    = GCAD_NormalizedPlane3d_FromPositionAndNormal (pos, right      :Cross (topLeft), out.TopPlane   )
		out.BottomPlane = GCAD_NormalizedPlane3d_FromPositionAndNormal (pos, bottomRight:Cross (right  ), out.BottomPlane)
		
		GCAD.Profiler:End ()
		return out
	end
end

-- Copying
function GCAD.Frustum3d.Clone (self, out)
	out = out or GCAD.Frustum3d ()
	
	out.LeftPlane   = GCAD_NormalizedPlane3d_Clone (self.LeftPlane,   out.LeftPlane  )
	out.RightPlane  = GCAD_NormalizedPlane3d_Clone (self.RightPlane,  out.RightPlane )
	out.TopPlane    = GCAD_NormalizedPlane3d_Clone (self.TopPlane,    out.TopPlane   )
	out.BottomPlane = GCAD_NormalizedPlane3d_Clone (self.BottomPlane, out.BottomPlane)
	out.NearPlane   = GCAD_NormalizedPlane3d_Clone (self.NearPlane,   out.NearPlane  )
	out.FarPlane    = GCAD_NormalizedPlane3d_Clone (self.FarPlane,    out.FarPlane   )
	
	return out
end

function GCAD.Frustum3d.Copy (self, source)
	self.LeftPlane   = GCAD_NormalizedPlane3d_Copy (self.LeftPlane,   out.LeftPlane  )
	self.RightPlane  = GCAD_NormalizedPlane3d_Copy (self.RightPlane,  out.RightPlane )
	self.TopPlane    = GCAD_NormalizedPlane3d_Copy (self.TopPlane,    out.TopPlane   )
	self.BottomPlane = GCAD_NormalizedPlane3d_Copy (self.BottomPlane, out.BottomPlane)
	self.NearPlane   = GCAD_NormalizedPlane3d_Copy (self.NearPlane,   out.NearPlane  )
	self.FarPlane    = GCAD_NormalizedPlane3d_Copy (self.FarPlane,    out.FarPlane   )
	
	return self
end

-- Intersection tests
function GCAD.Frustum3d.ContainsPoint (v3d)
	return GCAD_NormalizedPlane3d_ContainsPoint (self.LeftPlane,   v3d) and
	       GCAD_NormalizedPlane3d_ContainsPoint (self.RightPlane,  v3d) and
		   GCAD_NormalizedPlane3d_ContainsPoint (self.TopPlane,    v3d) and
		   GCAD_NormalizedPlane3d_ContainsPoint (self.BottomPlane, v3d) and
		   GCAD_NormalizedPlane3d_ContainsPoint (self.NearPlane,   v3d) and
		   GCAD_NormalizedPlane3d_ContainsPoint (self.FarPlane,    v3d)
end

function GCAD.Frustum3d.ContainsNativePoint (v)
	return GCAD_NormalizedPlane3d_ContainsNativePoint (self.LeftPlane,   v) and
	       GCAD_NormalizedPlane3d_ContainsNativePoint (self.RightPlane,  v) and
		   GCAD_NormalizedPlane3d_ContainsNativePoint (self.TopPlane,    v) and
		   GCAD_NormalizedPlane3d_ContainsNativePoint (self.BottomPlane, v) and
		   GCAD_NormalizedPlane3d_ContainsNativePoint (self.NearPlane,   v) and
		   GCAD_NormalizedPlane3d_ContainsNativePoint (self.FarPlane,    v)
end

function GCAD.Frustum3d.ContainsSphere (self, sphere3d)
	return GCAD_NormalizedPlane3d_ContainsSphere (self.LeftPlane,   sphere3d) and
	       GCAD_NormalizedPlane3d_ContainsSphere (self.RightPlane,  sphere3d) and
	       GCAD_NormalizedPlane3d_ContainsSphere (self.TopPlane,    sphere3d) and
	       GCAD_NormalizedPlane3d_ContainsSphere (self.BottomPlane, sphere3d) and
	       GCAD_NormalizedPlane3d_ContainsSphere (self.NearPlane,   sphere3d) and
	       GCAD_NormalizedPlane3d_ContainsSphere (self.FarPlane,    sphere3d)
end

function GCAD.Frustum3d.ContainsNativeSphere (self, nativeSphere3d)
	return GCAD_NormalizedPlane3d_ContainsNativeSphere (self.LeftPlane,   nativeSphere3d) and
	       GCAD_NormalizedPlane3d_ContainsNativeSphere (self.RightPlane,  nativeSphere3d) and
	       GCAD_NormalizedPlane3d_ContainsNativeSphere (self.TopPlane,    nativeSphere3d) and
	       GCAD_NormalizedPlane3d_ContainsNativeSphere (self.BottomPlane, nativeSphere3d) and
	       GCAD_NormalizedPlane3d_ContainsNativeSphere (self.NearPlane,   nativeSphere3d) and
	       GCAD_NormalizedPlane3d_ContainsNativeSphere (self.FarPlane,    nativeSphere3d)
end

function GCAD.Frustum3d.IntersectsSphere (self, sphere3d)
	local intersects1, contains1 = GCAD_NormalizedPlane3d_IntersectsSphere (self.LeftPlane,   sphere3d)
	if not intersects1 then return false, false end
	local intersects2, contains2 = GCAD_NormalizedPlane3d_IntersectsSphere (self.RightPlane,  sphere3d)
	if not intersects2 then return false, false end
	local intersects3, contains3 = GCAD_NormalizedPlane3d_IntersectsSphere (self.TopPlane,    sphere3d)
	if not intersects3 then return false, false end
	local intersects4, contains4 = GCAD_NormalizedPlane3d_IntersectsSphere (self.BottomPlane, sphere3d)
	if not intersects4 then return false, false end
	local intersects5, contains5 = GCAD_NormalizedPlane3d_IntersectsSphere (self.NearPlane,   sphere3d)
	if not intersects5 then return false, false end
	local intersects6, contains6 = GCAD_NormalizedPlane3d_IntersectsSphere (self.FarPlane,    sphere3d)
	if not intersects6 then return false, false end
	
	return true, (contains1 and contains2 and contains3 and contains4 and contains5 and contains6)
end
-- GCAD.Frustum3d.IntersectsSphere = GCAD.Profiler:Wrap (GCAD.Frustum3d.IntersectsSphere, "Frustum3d:IntersectsSphere")

local sphere3d = GCAD.Sphere3d ()
function GCAD.Frustum3d.IntersectsNativeSphere (self, nativeSphere3d)
	local intersects1, contains1 = GCAD_NormalizedPlane3d_IntersectsNativeSphere (self.LeftPlane,   nativeSphere3d)
	if not intersects1 then return false, false end
	local intersects2, contains2 = GCAD_NormalizedPlane3d_IntersectsNativeSphere (self.RightPlane,  nativeSphere3d)
	if not intersects2 then return false, false end
	local intersects3, contains3 = GCAD_NormalizedPlane3d_IntersectsNativeSphere (self.TopPlane,    nativeSphere3d)
	if not intersects3 then return false, false end
	local intersects4, contains4 = GCAD_NormalizedPlane3d_IntersectsNativeSphere (self.BottomPlane, nativeSphere3d)
	if not intersects4 then return false, false end
	local intersects5, contains5 = GCAD_NormalizedPlane3d_IntersectsNativeSphere (self.NearPlane,   nativeSphere3d)
	if not intersects5 then return false, false end
	local intersects6, contains6 = GCAD_NormalizedPlane3d_IntersectsNativeSphere (self.FarPlane,    nativeSphere3d)
	if not intersects6 then return false, false end
	
	return true, (contains1 and contains2 and contains3 and contains4 and contains5 and contains6)
end
-- GCAD.Frustum3d.IntersectsNativeSphere = GCAD.Profiler:Wrap (GCAD.Frustum3d.IntersectsNativeSphere, "Frustum3d:IntersectsNativeSphere")

local GCAD_Frustum3d_ContainsPoint = GCAD.Frustum3d.ContainsPoint

local temp = GCAD.Vector3d ()
function GCAD.Frustum3d.ContainsOBB (self, obb3d)
	for vertex in obb3d:GetCornerEnumerator (temp) do
		if not GCAD_Frustum3d_ContainsPoint (self, vertex) then return false end
	end
	
	return true
end
GCAD.Frustum3d.ContainsOBB = GCAD.Profiler:Wrap (GCAD.Frustum3d.ContainsOBB, "Frustum3d:ContainsOBB")

function GCAD.Frustum3d.IntersectsOBB (self, obb3d)
	return GCAD_NormalizedPlane3d_IntersectsOBB (self.LeftPlane,   obb3d) and
	       GCAD_NormalizedPlane3d_IntersectsOBB (self.RightPlane,  obb3d) and
	       GCAD_NormalizedPlane3d_IntersectsOBB (self.TopPlane,    obb3d) and
	       GCAD_NormalizedPlane3d_IntersectsOBB (self.BottomPlane, obb3d) and
	       GCAD_NormalizedPlane3d_IntersectsOBB (self.NearPlane,   obb3d) and
	       GCAD_NormalizedPlane3d_IntersectsOBB (self.FarPlane,    obb3d)
end
GCAD.Frustum3d.IntersectsOBB = GCAD.Profiler:Wrap (GCAD.Frustum3d.IntersectsOBB, "Frustum3d:IntersectsOBB")

-- Conversion
function GCAD.Frustum3d.FromNativeFrustum3d (nativeFrustum3d, out)
	out = out or GCAD.Frustum3d ()
	
	out.LeftPlane   = GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d (nativeFrustum3d.LeftPlane,   out.LeftPlane  )
	out.RightPlane  = GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d (nativeFrustum3d.RightPlane,  out.RightPlane )
	out.TopPlane    = GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d (nativeFrustum3d.TopPlane,    out.TopPlane   )
	out.BottomPlane = GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d (nativeFrustum3d.BottomPlane, out.BottomPlane)
	out.NearPlane   = GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d (nativeFrustum3d.NearPlane,   out.NearPlane  )
	out.FarPlane    = GCAD_NormalizedPlane3d_FromNativeNormalizedPlane3d (nativeFrustum3d.FarPlane,    out.FarPlane   )
	
	return out
end

function GCAD.Frustum3d.ToNativeFrustum3d (self, out)
	out = out or GCAD.NativeFrustum3d ()
	
	out.LeftPlane   = GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d (self.LeftPlane,   out.LeftPlane  )
	out.RightPlane  = GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d (self.RightPlane,  out.RightPlane )
	out.TopPlane    = GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d (self.TopPlane,    out.TopPlane   )
	out.BottomPlane = GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d (self.BottomPlane, out.BottomPlane)
	out.NearPlane   = GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d (self.NearPlane,   out.NearPlane  )
	out.FarPlane    = GCAD_NormalizedPlane3d_ToNativeNormalizedPlane3d (self.FarPlane,    out.FarPlane   )
	
	return out
end

-- Construction
function self:ctor ()
	self.LeftPlane   = GCAD_NormalizedPlane3d_Maximum ()
	self.RightPlane  = GCAD_NormalizedPlane3d_Maximum ()
	self.TopPlane    = GCAD_NormalizedPlane3d_Maximum ()
	self.BottomPlane = GCAD_NormalizedPlane3d_Maximum ()
	self.NearPlane   = GCAD_NormalizedPlane3d_Maximum ()
	self.FarPlane    = GCAD_NormalizedPlane3d_Maximum ()
end

-- Copying
self.Clone                  = GCAD.Frustum3d.Clone
self.Copy                   = GCAD.Frustum3d.Copy

-- Intersection tests
self.ContainsPoint          = GCAD.Frustum3d.ContainsPoint
self.ContainsNativePoint    = GCAD.Frustum3d.ContainsNativePoint
self.ContainsSphere         = GCAD.Frustum3d.ContainsSphere
self.ContainsNativeSphere   = GCAD.Frustum3d.ContainsNativeSphere
self.IntersectsSphere       = GCAD.Frustum3d.IntersectsSphere
self.IntersectsNativeSphere = GCAD.Frustum3d.IntersectsNativeSphere
self.ContainsOBB            = GCAD.Frustum3d.ContainsOBB
self.IntersectsOBB          = GCAD.Frustum3d.IntersectsOBB

-- Conversion
self.ToNativeFrustum3d      = GCAD.Frustum3d.ToNativeFrustum3d
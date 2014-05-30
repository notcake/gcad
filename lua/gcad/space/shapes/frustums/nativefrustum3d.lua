local self = {}
GCAD.NativeFrustum3d = GCAD.MakeConstructor (self)

local Angle_Forward                                      = debug.getregistry ().Angle.Forward
local Angle_Right                                        = debug.getregistry ().Angle.Right
local Angle_Up                                           = debug.getregistry ().Angle.Up
local Entity_EyeAngles                                   = debug.getregistry ().Entity.EyeAngles
local Entity_EyePos                                      = debug.getregistry ().Entity.EyePos
local Vector_Cross                                       = debug.getregistry ().Vector.Cross
local Vector___unm                                       = debug.getregistry ().Vector.__unm

local gui_ScreenToVector                                 = gui and gui.ScreenToVector

local GCAD_NativeNormalizedPlane3d_Clone                  = GCAD.NativeNormalizedPlane3d.Clone
local GCAD_NativeNormalizedPlane3d_ContainsNativePoint    = GCAD.NativeNormalizedPlane3d.ContainsNativePoint
local GCAD_NativeNormalizedPlane3d_ContainsNativeSphere   = GCAD.NativeNormalizedPlane3d.ContainsNativeSphere
local GCAD_NativeNormalizedPlane3d_ContainsOBB            = GCAD.NativeNormalizedPlane3d.ContainsOBB
local GCAD_NativeNormalizedPlane3d_ContainsPoint          = GCAD.NativeNormalizedPlane3d.ContainsPoint
local GCAD_NativeNormalizedPlane3d_ContainsSphere         = GCAD.NativeNormalizedPlane3d.ContainsSphere
local GCAD_NativeNormalizedPlane3d_Copy                   = GCAD.NativeNormalizedPlane3d.Copy
local GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d  = GCAD.NativeNormalizedPlane3d.FromNormalizedPlane3d
local GCAD_NativeNormalizedPlane3d_FromPositionAndNormal  = GCAD.NativeNormalizedPlane3d.FromPositionAndNormal
local GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere = GCAD.NativeNormalizedPlane3d.IntersectsNativeSphere
local GCAD_NativeNormalizedPlane3d_IntersectsOBB          = GCAD.NativeNormalizedPlane3d.IntersectsOBB
local GCAD_NativeNormalizedPlane3d_IntersectsSphere       = GCAD.NativeNormalizedPlane3d.IntersectsSphere
local GCAD_NativeNormalizedPlane3d_Maximum                = GCAD.NativeNormalizedPlane3d.Maximum
local GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d    = GCAD.NativeNormalizedPlane3d.ToNormalizedPlane3d

if CLIENT then
	function GCAD.NativeFrustum3d.FromScreenAABB (x1, y1, x2, y2, out)
		GCAD.Profiler:Begin ("NativeFrustum3d.FromScreenAABB")
		
		out = out or GCAD.NativeFrustum3d ()
		
		GCAD.Profiler:Begin ("Frustum3d.FromScreenAABB : Get camera data")
		local pos = Entity_EyePos    (LocalPlayer ())
		local ang = Entity_EyeAngles (LocalPlayer ())
		local forward = Angle_Forward (ang)
		local right   = Angle_Right   (ang)
		local up      = Angle_Up      (ang)
		GCAD.Profiler:End ()
		
		GCAD.Profiler:Begin ("gui.ScreenToVector")
		local topLeft     = gui_ScreenToVector (x1, y1)
		local bottomRight = gui_ScreenToVector (x2, y2)
		GCAD.Profiler:End ()
		
		GCAD.Profiler:Begin ("NativeFrustum3d.FromScreenAABB : Construct planes")
		out.LeftPlane   = GCAD_NativeNormalizedPlane3d_FromPositionAndNormal (pos, Vector_Cross (up,          topLeft), out.LeftPlane  )
		out.RightPlane  = GCAD_NativeNormalizedPlane3d_FromPositionAndNormal (pos, Vector_Cross (bottomRight, up     ), out.RightPlane )
		out.TopPlane    = GCAD_NativeNormalizedPlane3d_FromPositionAndNormal (pos, Vector_Cross (right,       topLeft), out.TopPlane   )
		out.BottomPlane = GCAD_NativeNormalizedPlane3d_FromPositionAndNormal (pos, Vector_Cross (bottomRight, right  ), out.BottomPlane)
		out.NearPlane   = GCAD_NativeNormalizedPlane3d_FromPositionAndNormal (pos, Vector___unm (forward             ), out.NearPlane  )
		GCAD.Profiler:End ()
		
		GCAD.Profiler:End ()
		return out
	end
end

-- Copying
function GCAD.NativeFrustum3d.Clone (self, out)
	out = out or GCAD.NativeFrustum3d ()
	
	out.LeftPlane   = GCAD_NativeNormalizedPlane3d_Clone (self.LeftPlane,   out.LeftPlane  )
	out.RightPlane  = GCAD_NativeNormalizedPlane3d_Clone (self.RightPlane,  out.RightPlane )
	out.TopPlane    = GCAD_NativeNormalizedPlane3d_Clone (self.TopPlane,    out.TopPlane   )
	out.BottomPlane = GCAD_NativeNormalizedPlane3d_Clone (self.BottomPlane, out.BottomPlane)
	out.NearPlane   = GCAD_NativeNormalizedPlane3d_Clone (self.NearPlane,   out.NearPlane  )
	out.FarPlane    = GCAD_NativeNormalizedPlane3d_Clone (self.FarPlane,    out.FarPlane   )
	
	return out
end

function GCAD.NativeFrustum3d.Copy (self, source)
	self.LeftPlane   = GCAD_NativeNormalizedPlane3d_Copy (self.LeftPlane,   out.LeftPlane  )
	self.RightPlane  = GCAD_NativeNormalizedPlane3d_Copy (self.RightPlane,  out.RightPlane )
	self.TopPlane    = GCAD_NativeNormalizedPlane3d_Copy (self.TopPlane,    out.TopPlane   )
	self.BottomPlane = GCAD_NativeNormalizedPlane3d_Copy (self.BottomPlane, out.BottomPlane)
	self.NearPlane   = GCAD_NativeNormalizedPlane3d_Copy (self.NearPlane,   out.NearPlane  )
	self.FarPlane    = GCAD_NativeNormalizedPlane3d_Copy (self.FarPlane,    out.FarPlane   )
	
	return self
end

-- Intersection tests
function GCAD.NativeFrustum3d.ContainsPoint (v3d)
	return GCAD_NativeNormalizedPlane3d_ContainsPoint (self.LeftPlane,   v3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsPoint (self.RightPlane,  v3d) and
		   GCAD_NativeNormalizedPlane3d_ContainsPoint (self.TopPlane,    v3d) and
		   GCAD_NativeNormalizedPlane3d_ContainsPoint (self.BottomPlane, v3d) and
		   GCAD_NativeNormalizedPlane3d_ContainsPoint (self.NearPlane,   v3d) and
		   GCAD_NativeNormalizedPlane3d_ContainsPoint (self.FarPlane,    v3d)
end

function GCAD.NativeFrustum3d.ContainsNativePoint (v)
	return GCAD_NativeNormalizedPlane3d_ContainsNativePoint (self.LeftPlane,   v) and
	       GCAD_NativeNormalizedPlane3d_ContainsNativePoint (self.RightPlane,  v) and
		   GCAD_NativeNormalizedPlane3d_ContainsNativePoint (self.TopPlane,    v) and
		   GCAD_NativeNormalizedPlane3d_ContainsNativePoint (self.BottomPlane, v) and
		   GCAD_NativeNormalizedPlane3d_ContainsNativePoint (self.NearPlane,   v) and
		   GCAD_NativeNormalizedPlane3d_ContainsNativePoint (self.FarPlane,    v)
end

function GCAD.NativeFrustum3d.ContainsSphere (self, sphere3d)
	return GCAD_NativeNormalizedPlane3d_ContainsSphere (self.LeftPlane,   sphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsSphere (self.RightPlane,  sphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsSphere (self.TopPlane,    sphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsSphere (self.BottomPlane, sphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsSphere (self.NearPlane,   sphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsSphere (self.FarPlane,    sphere3d)
end

function GCAD.NativeFrustum3d.ContainsNativeSphere (self, nativeSphere3d)
	return GCAD_NativeNormalizedPlane3d_ContainsNativeSphere (self.LeftPlane,   nativeSphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsNativeSphere (self.RightPlane,  nativeSphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsNativeSphere (self.TopPlane,    nativeSphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsNativeSphere (self.BottomPlane, nativeSphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsNativeSphere (self.NearPlane,   nativeSphere3d) and
	       GCAD_NativeNormalizedPlane3d_ContainsNativeSphere (self.FarPlane,    nativeSphere3d)
end

function GCAD.NativeFrustum3d.IntersectsSphere (self, sphere3d)
	local intersects1, contains1 = GCAD_NativeNormalizedPlane3d_IntersectsSphere (self.LeftPlane,   sphere3d)
	if not intersects1 then return false, false end
	local intersects2, contains2 = GCAD_NativeNormalizedPlane3d_IntersectsSphere (self.RightPlane,  sphere3d)
	if not intersects2 then return false, false end
	local intersects3, contains3 = GCAD_NativeNormalizedPlane3d_IntersectsSphere (self.TopPlane,    sphere3d)
	if not intersects3 then return false, false end
	local intersects4, contains4 = GCAD_NativeNormalizedPlane3d_IntersectsSphere (self.BottomPlane, sphere3d)
	if not intersects4 then return false, false end
	local intersects5, contains5 = GCAD_NativeNormalizedPlane3d_IntersectsSphere (self.NearPlane,   sphere3d)
	if not intersects5 then return false, false end
	local intersects6, contains6 = GCAD_NativeNormalizedPlane3d_IntersectsSphere (self.FarPlane,    sphere3d)
	if not intersects6 then return false, false end
	
	return true, (contains1 and contains2 and contains3 and contains4 and contains5 and contains6)
end
-- GCAD.NativeFrustum3d.IntersectsSphere = GCAD.Profiler:Wrap (GCAD.NativeFrustum3d.IntersectsSphere, "NativeFrustum3d:IntersectsSphere")

function GCAD.NativeFrustum3d.IntersectsNativeSphere (self, nativeSphere3d)
	local intersects1, contains1 = GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere (self.LeftPlane,   nativeSphere3d)
	if not intersects1 then return false, false end
	local intersects2, contains2 = GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere (self.RightPlane,  nativeSphere3d)
	if not intersects2 then return false, false end
	local intersects3, contains3 = GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere (self.TopPlane,    nativeSphere3d)
	if not intersects3 then return false, false end
	local intersects4, contains4 = GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere (self.BottomPlane, nativeSphere3d)
	if not intersects4 then return false, false end
	local intersects5, contains5 = GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere (self.NearPlane,   nativeSphere3d)
	if not intersects5 then return false, false end
	local intersects6, contains6 = GCAD_NativeNormalizedPlane3d_IntersectsNativeSphere (self.FarPlane,    nativeSphere3d)
	if not intersects6 then return false, false end
	
	return true, (contains1 and contains2 and contains3 and contains4 and contains5 and contains6)
end
-- GCAD.NativeFrustum3d.IntersectsNativeSphere = GCAD.Profiler:Wrap (GCAD.NativeFrustum3d.IntersectsNativeSphere, "NativeFrustum3d:IntersectsNativeSphere")

local GCAD_NativeFrustum3d_ContainsPoint = GCAD.NativeFrustum3d.ContainsPoint

local temp = GCAD.Vector3d ()
function GCAD.NativeFrustum3d.ContainsOBB (self, obb3d)
	for vertex in obb3d:GetCornerEnumerator (temp) do
		if not GCAD_NativeFrustum3d_ContainsPoint (self, vertex) then return false end
	end
	
	return true
end
GCAD.NativeFrustum3d.ContainsOBB = GCAD.Profiler:Wrap (GCAD.NativeFrustum3d.ContainsOBB, "NativeFrustum3d:ContainsOBB")

function GCAD.NativeFrustum3d.IntersectsOBB (self, obb3d)
	return GCAD_NativeNormalizedPlane3d_IntersectsOBB (self.LeftPlane,   obb3d) and
	       GCAD_NativeNormalizedPlane3d_IntersectsOBB (self.RightPlane,  obb3d) and
	       GCAD_NativeNormalizedPlane3d_IntersectsOBB (self.TopPlane,    obb3d) and
	       GCAD_NativeNormalizedPlane3d_IntersectsOBB (self.BottomPlane, obb3d) and
	       GCAD_NativeNormalizedPlane3d_IntersectsOBB (self.NearPlane,   obb3d) and
	       GCAD_NativeNormalizedPlane3d_IntersectsOBB (self.FarPlane,    obb3d)
end
GCAD.NativeFrustum3d.IntersectsOBB = GCAD.Profiler:Wrap (GCAD.NativeFrustum3d.IntersectsOBB, "NativeFrustum3d:IntersectsOBB")

-- Conversion
function GCAD.NativeFrustum3d.FromFrustum3d (frustum3d, out)
	out = out or GCAD.NativeFrustum3d ()
	
	out.LeftPlane   = GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d (frustum3d.LeftPlane,   out.LeftPlane  )
	out.RightPlane  = GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d (frustum3d.RightPlane,  out.RightPlane )
	out.TopPlane    = GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d (frustum3d.TopPlane,    out.TopPlane   )
	out.BottomPlane = GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d (frustum3d.BottomPlane, out.BottomPlane)
	out.NearPlane   = GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d (frustum3d.NearPlane,   out.NearPlane  )
	out.FarPlane    = GCAD_NativeNormalizedPlane3d_FromNormalizedPlane3d (frustum3d.FarPlane,    out.FarPlane   )
	
	return out
end

function GCAD.NativeFrustum3d.ToNativeNativeFrustum3d (self, out)
	out = out or GCAD.Frustum3d ()
	
	out.LeftPlane   = GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d (self.LeftPlane,   out.LeftPlane  )
	out.RightPlane  = GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d (self.RightPlane,  out.RightPlane )
	out.TopPlane    = GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d (self.TopPlane,    out.TopPlane   )
	out.BottomPlane = GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d (self.BottomPlane, out.BottomPlane)
	out.NearPlane   = GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d (self.NearPlane,   out.NearPlane  )
	out.FarPlane    = GCAD_NativeNormalizedPlane3d_ToNormalizedPlane3d (self.FarPlane,    out.FarPlane   )
	
	return out
end

-- Construction
function self:ctor ()
	self.LeftPlane   = GCAD_NativeNormalizedPlane3d_Maximum ()
	self.RightPlane  = GCAD_NativeNormalizedPlane3d_Maximum ()
	self.TopPlane    = GCAD_NativeNormalizedPlane3d_Maximum ()
	self.BottomPlane = GCAD_NativeNormalizedPlane3d_Maximum ()
	self.NearPlane   = GCAD_NativeNormalizedPlane3d_Maximum ()
	self.FarPlane    = GCAD_NativeNormalizedPlane3d_Maximum ()
end

-- Copying
self.Clone                  = GCAD.NativeFrustum3d.Clone
self.Copy                   = GCAD.NativeFrustum3d.Copy

-- Intersection tests
self.ContainsPoint          = GCAD.NativeFrustum3d.ContainsPoint
self.ContainsNativePoint    = GCAD.NativeFrustum3d.ContainsNativePoint
self.ContainsSphere         = GCAD.NativeFrustum3d.ContainsSphere
self.ContainsNativeSphere   = GCAD.NativeFrustum3d.ContainsNativeSphere
self.IntersectsSphere       = GCAD.NativeFrustum3d.IntersectsSphere
self.IntersectsNativeSphere = GCAD.NativeFrustum3d.IntersectsNativeSphere
self.ContainsOBB            = GCAD.NativeFrustum3d.ContainsOBB
self.IntersectsOBB          = GCAD.NativeFrustum3d.IntersectsOBB

-- Conversion
self.ToFrustum3d            = GCAD.NativeFrustum3d.ToFrustum3d
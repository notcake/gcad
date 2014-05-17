GCAD.UnpackedPlane3d = {}

local Vector                    = Vector

local Vector___index            = debug.getregistry ().Vector.__index
local Vector___newindex         = debug.getregistry ().Vector.__newindex

local GCAD_Vector3d_Dot            = GCAD.Vector3d.Dot
local GCAD_UnpackedVector3d_Dot    = GCAD.UnpackedVector3d.Dot
local GCAD_UnpackedVector3d_Length = GCAD.UnpackedVector3d.Length

function GCAD.UnpackedPlane3d.FromPositionAndNormal (position, normal)
	-- ax + by + cz + d = 0
	-- d = -normal . position
	return normal [1], normal [2], normal [3], -GCAD_Vector3d_Dot (position, normal)
end

-- Plane properties
function GCAD.UnpackedPlane3d.GetNormal (a, b, c, d, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a
	out [2] = b
	out [3] = c
	
	return out
end

function GCAD.UnpackedPlane3d.GetNormalNative (a, b, c, d, out)
	out = out or Vector ()
	
	Vector___newindex (out, "x", a)
	Vector___newindex (out, "y", b)
	Vector___newindex (out, "z", c)
	
	return out
end

function GCAD.UnpackedPlane3d.GetNormalUnpacked (a, b, c, d)
	return a, b, c
end

function GCAD.UnpackedPlane3d.GetNormalLength (a, b, c, d)
	return GCAD_UnpackedVector3d_Length (a, b, c)
end

function GCAD.UnpackedPlane3d.SetNormal (a, b, c, d, normal)
	return normal [1], normal [2], normal [3], d
end

function GCAD.UnpackedPlane3d.SetNormalNative (a, b, c, d, normal)
	return Vector___index (normal, "x"), Vector___index (normal, "y"), Vector___index (normal, "z"), d
end

function GCAD.UnpackedPlane3d.SetNormalUnpacked (a, b, c, d, x, y, z)
	return x, y, z, d
end

-- Plane operations
local GCAD_UnpackedPlane3d_GetNormalLength = GCAD.UnpackedPlane3d.GetNormalLength

function GCAD.UnpackedPlane3d.Flip (a, b, c, d)
	return -a, -b, -c, -d
end

function GCAD.UnpackedPlane3d.Normalize (a, b, c, d)
	local length = GCAD_UnpackedPlane3d_GetNormalLength (a, b, c, d)
	return a / length, b / length, c / length, d / length
end

-- Plane queries
function GCAD.UnpackedPlane3d.DistanceToPoint (a, b, c, d, v3d)
	return (GCAD_UnpackedVector3d_Dot (a, b, c, v3d [1], v3d [2], v3d [3]) + d) / GCAD_UnpackedPlane3d_GetNormalLength (a, b, c, d)
end

GCAD.UnpackedPlane3d.DistanceToNativePoint = GCAD.UnpackedPlane3d.DistanceToPoint

function GCAD.UnpackedPlane3d.DistanceToUnpackedPoint (a, b, c, d, x, y, z)
	return (GCAD_UnpackedVector3d_Dot (a, b, c, x, y, z) + d) / GCAD_UnpackedPlane3d_GetNormalLength (a, b, c, d)
end

function GCAD.UnpackedPlane3d.ScaledDistanceToPoint (a, b, c, d, v3d)
	return GCAD_UnpackedVector3d_Dot (a, b, c, v3d [1], v3d [2], v3d [3]) + d
end

GCAD.UnpackedPlane3d.ScaledDistanceToNativePoint = GCAD.UnpackedPlane3d.ScaledDistanceToPoint

function GCAD.UnpackedPlane3d.ScaledDistanceToUnpackedPoint (a, b, c, d, x, y, z)
	return GCAD_UnpackedVector3d_Dot (a, b, c, x, y, z) + d
end

-- Intersection tests
local GCAD_UnpackedPlane3d_DistanceToPoint               = GCAD.UnpackedPlane3d.DistanceToPoint
local GCAD_UnpackedPlane3d_DistanceToUnpackedPoint       = GCAD.UnpackedPlane3d.DistanceToUnpackedPoint
local GCAD_UnpackedPlane3d_ScaledDistanceToPoint         = GCAD.UnpackedPlane3d.ScaledDistanceToPoint
local GCAD_UnpackedPlane3d_ScaledDistanceToNativePoint   = GCAD.UnpackedPlane3d.ScaledDistanceToNativePoint
local GCAD_UnpackedPlane3d_ScaledDistanceToUnpackedPoint = GCAD.UnpackedPlane3d.ScaledDistanceToUnpackedPoint

function GCAD.UnpackedPlane3d.ContainsPoint (a, b, c, d, v3d)
	return GCAD_UnpackedPlane3d_ScaledDistanceToPoint (a, b, c, d, v3d) < 0
end

function GCAD.UnpackedPlane3d.ContainsNativePoint (a, b, c, d, v)
	return GCAD_UnpackedPlane3d_ScaledDistanceToNativePoint (a, b, c, d, v) < 0
end

function GCAD.UnpackedPlane3d.ContainsUnpackedPoint (a, b, c, d, x, y, z)
	return GCAD_UnpackedPlane3d_ScaledDistanceToUnpackedPoint (a, b, c, d, x, y, z) < 0
end

function GCAD.UnpackedPlane3d.ContainsSphere (a, b, c, d, sphere3d)
	local distance = GCAD_UnpackedPlane3d_DistanceToPoint (a, b, c, d, sphere3d)
	return distance + sphere3d [4] < 0
end

function GCAD.UnpackedPlane3d.ContainsNativeSphere (a, b, c, d, nativeSphere3d)
	local distance = GCAD_UnpackedPlane3d_DistanceToUnpackedPoint (a, b, c, d, nativeSphere3d:GetPositionUnpacked ())
	return distance + nativeSphere3d [4] < 0
end

function GCAD.UnpackedPlane3d.ContainsUnpackedSphere (a, b, c, d, x, y, z, r)
	local distance = GCAD_UnpackedPlane3d_DistanceToUnpackedPoint (a, b, c, d, x, y, z)
	return distance + r < 0
end

function GCAD.UnpackedPlane3d.IntersectsSphere (a, b, c, d, sphere3d)
	local distance = GCAD_UnpackedPlane3d_DistanceToPoint (a, b, c, d, sphere3d)
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.UnpackedPlane3d.IntersectsNativeSphere (a, b, c, d, nativeSphere3d)
	local distance = GCAD_UnpackedPlane3d_DistanceToUnpackedPoint (a, b, c, d, nativeSphere3d:GetPositionUnpacked ())
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.UnpackedPlane3d.IntersectsUnpackedSphere (a, b, c, d, x, y, z, r)
	local distance = GCAD_UnpackedPlane3d_DistanceToUnpackedPoint (a, b, c, d, x, y, z)
	if distance + r < 0 then return true, true  end -- sphere lies within this plane
	if distance - r < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

-- Conversion
function GCAD.Plane3d.FromNativePlane3d (nativePlane3d)
	local a, b, c = nativePlane3d:GetNormalUnpacked ()
	return a, b, c, nativePlane3d [4]
end

function GCAD.Plane3d.ToNativePlane3d (a, b, c, d, out)
	out = out or GCAD.NativePlane3d ()
	
	out:SetNormalUnpacked (a, b, c)
	out [4] = d
	
	return out
end

-- Utility
function GCAD.UnpackedPlane3d.ToString (a, b, c, d)
	return "Plane [(" .. tostring (a) .. ", " .. tostring (b) .. ", " .. tostring (c) .. "), " .. tostring (d) .. "]"
end

-- Construction
function GCAD.UnpackedPlane3d.Minimum ()
	return 1, 0, 0, math.huge
end

function GCAD.UnpackedPlane3d.Maximum ()
	return 1, 0, 0, -math.huge
end
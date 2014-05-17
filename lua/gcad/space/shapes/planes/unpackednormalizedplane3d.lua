GCAD.UnpackedNormalizedPlane3d = {}

local Vector_Length                   = debug.getregistry ().Vector.Length

local GCAD_Vector3d_Dot               = GCAD.Vector3d.Dot
local GCAD_Vector3d_Length            = GCAD.Vector3d.Length
local GCAD_UnpackedVector3d_Length    = GCAD.UnpackedVector3d.Length
local GCAD_UnpackedVector3d_Normalize = GCAD.UnpackedVector3d.Normalize

function GCAD.UnpackedNormalizedPlane3d.FromPositionAndNormal (position, normal)
	-- ax + by + cz + d = 0
	-- d = -normal . position
	local length = GCAD_Vector3d_Length (normal)
	return normal [1] / length, normal [2] / length, normal [3] / length, -GCAD_Vector3d_Dot (position, normal) / length
end

-- Plane properties
GCAD.UnpackedNormalizedPlane3d.GetNormal                     = GCAD.UnpackedPlane3d.GetNormal
GCAD.UnpackedNormalizedPlane3d.GetNormalNative               = GCAD.UnpackedPlane3d.GetNormalNative
GCAD.UnpackedNormalizedPlane3d.GetNormalUnpacked             = GCAD.UnpackedPlane3d.GetNormalUnpacked
GCAD.UnpackedNormalizedPlane3d.GetNormalLength               = GCAD.UnpackedPlane3d.GetNormalLength

function GCAD.UnpackedNormalizedPlane3d.SetNormal (a, b, c, d, normal)
	local length = GCAD_Vector3d_Length (normal)
	return normal [1] / length, normal [2] / length, normal [3] / length, d
end

function GCAD.UnpackedNormalizedPlane3d.SetNormalNative (a, b, c, d, normal)
	local length = Vector_Length (normal)
	return Vector___index (normal, "x") / length, Vector___index (normal, "y") / length, Vector___index (normal, "z") / length, d
end

function GCAD.UnpackedNormalizedPlane3d.SetNormalUnpacked (a, b, c, d, x, y, z)
	local length = GCAD_UnpackedVector3d_Length (x, y, z)
	return x / length, y / length, z / length, d
end

-- Plane operations
GCAD.UnpackedNormalizedPlane3d.Flip                          = GCAD.UnpackedPlane3d.Flip
GCAD.UnpackedNormalizedPlane3d.Normalize                     = GCAD.UnpackedPlane3d.Normalize

-- Plane queries
GCAD.UnpackedNormalizedPlane3d.DistanceToPoint               = GCAD.UnpackedPlane3d.ScaledDistanceToPoint
GCAD.UnpackedNormalizedPlane3d.DistanceToNativePoint         = GCAD.UnpackedPlane3d.ScaledDistanceToNativePoint
GCAD.UnpackedNormalizedPlane3d.DistanceToUnpackedPoint       = GCAD.UnpackedPlane3d.ScaledDistanceToUnpackedPoint
GCAD.UnpackedNormalizedPlane3d.ScaledDistanceToPoint         = GCAD.UnpackedPlane3d.ScaledDistanceToPoint
GCAD.UnpackedNormalizedPlane3d.ScaledDistanceToNativePoint   = GCAD.UnpackedPlane3d.ScaledDistanceToNativePoint
GCAD.UnpackedNormalizedPlane3d.ScaledDistanceToUnpackedPoint = GCAD.UnpackedPlane3d.ScaledDistanceToUnpackedPoint

-- Intersection tests
local GCAD_UnpackedNormalizedPlane3d_DistanceToPoint         = GCAD.UnpackedNormalizedPlane3d.DistanceToPoint
local GCAD_UnpackedNormalizedPlane3d_DistanceToUnpackedPoint = GCAD.UnpackedNormalizedPlane3d.DistanceToUnpackedPoint

GCAD.UnpackedNormalizedPlane3d.ContainsPoint                 = GCAD.UnpackedPlane3d.ContainsPoint
GCAD.UnpackedNormalizedPlane3d.ContainsNativePoint           = GCAD.UnpackedPlane3d.ContainsNativePoint
GCAD.UnpackedNormalizedPlane3d.ContainsUnpackedPoint         = GCAD.UnpackedPlane3d.ContainsUnpackedPoint

function GCAD.UnpackedNormalizedPlane3d.ContainsSphere (a, b, c, d, sphere3d)
	local distance = GCAD_UnpackedNormalizedPlane3d_DistanceToPoint (a, b, c, d, sphere3d)
	return distance + sphere3d [4] < 0
end

function GCAD.UnpackedNormalizedPlane3d.ContainsNativeSphere (a, b, c, d, nativeSphere3d)
	local distance = GCAD_UnpackedNormalizedPlane3d_DistanceToUnpackedPoint (a, b, c, d, nativeSphere3d:GetPositionUnpacked ())
	return distance + nativeSphere3d [4] < 0
end

function GCAD.UnpackedNormalizedPlane3d.ContainsUnpackedSphere (a, b, c, d, x, y, z, r)
	local distance = GCAD_UnpackedNormalizedPlane3d_DistanceToUnpackedPoint (a, b, c, d, x, y, z)
	return distance + r < 0
end

function GCAD.UnpackedNormalizedPlane3d.IntersectsSphere (a, b, c, d, sphere3d)
	local distance = GCAD_UnpackedNormalizedPlane3d_DistanceToPoint (a, b, c, d, sphere3d)
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.UnpackedNormalizedPlane3d.IntersectsNativeSphere (a, b, c, d, nativeSphere3d)
	local distance = GCAD_UnpackedNormalizedPlane3d_DistanceToUnpackedPoint (a, b, c, d, nativeSphere3d:GetPositionUnpacked ())
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < 0 then return true, true  end -- sphere lies within this plane
	if distance - sphereRadius < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.UnpackedNormalizedPlane3d.IntersectsUnpackedSphere (a, b, c, d, x, y, z, r)
	local distance = GCAD_UnpackedNormalizedPlane3d_DistanceToUnpackedPoint (a, b, c, d, x, y, z)
	if distance + r < 0 then return true, true  end -- sphere lies within this plane
	if distance - r < 0 then return true, false end -- sphere centre lies outside, but surface intersects this plane
	return false, false
end

-- Conversion
function GCAD.Plane3d.FromNativeNormalizedPlane3d (nativeNormalizedPlane3d)
	local a, b, c = nativeNormalizedPlane3d:GetNormalUnpacked ()
	return a, b, c, nativeNormalizedPlane3d [4]
end

function GCAD.Plane3d.ToNativePlane3d (a, b, c, d, out)
	out = out or GCAD.NativeNormalizedPlane3d ()
	
	out:SetNormalUnpacked (a, b, c)
	out [4] = d
	
	return out
end

function GCAD.UnpackedNormalizedPlane3d.FromLine3d (line)
	local a, b = line:GetDirectionUnpacked ()
	a, b = GCAD_UnpackedVector3d_Normalize (-b, a)
	
	return a, b, -GCAD_UnpackedVector3d_Dot (a, b, line:GetPositionUnpacked ())
end

GCAD.UnpackedNormalizedPlane3d.ToLine3d                      = GCAD.UnpackedPlane3d.ToLine3d

-- Utility
GCAD.UnpackedNormalizedPlane3d.ToString                      = GCAD.UnpackedPlane3d.ToString

-- Construction
GCAD.UnpackedNormalizedPlane3d.Minimum                       = GCAD.UnpackedPlane3d.Minimum
GCAD.UnpackedNormalizedPlane3d.Maximum                       = GCAD.UnpackedPlane3d.Maximum
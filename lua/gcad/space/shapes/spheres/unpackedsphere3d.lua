GCAD.UnpackedSphere3d = {}

local Entity_BoundingRadius                  = debug.getregistry ().Entity.BoundingRadius
local Entity_GetPos                          = debug.getregistry ().Entity.GetPos
local Entity_OBBCenter                       = debug.getregistry ().Entity.OBBCenter
local Vector___add                           = debug.getregistry ().Vector.__add
local Vector___index                         = debug.getregistry ().Vector.__index

local GCAD_Vector3d_DistanceTo               = GCAD.Vector3d.DistanceTo
local GCAD_UnpackedVector3d_DistanceTo       = GCAD.UnpackedVector3d.DistanceTo
local GCAD_UnpackedVector3d_FromNativeVector = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_ToNativeVector   = GCAD.UnpackedVector3d.ToNativeVector

function GCAD.UnpackedSphere3d.FromEntityBoundingSphere (ent)
	local pos = Vector___add (Entity_GetPos (ent), Entity_OBBCenter (ent))
	return Vector___index (pos, "x"), Vector___index (pos, "y"), Vector___index (pos, "z"), Entity_BoundingRadius (ent)
end
GCAD.UnpackedSphere3d.FromEntityBoundingSphere = GCAD.Profiler:Wrap (GCAD.UnpackedSphere3d.FromEntityBoundingSphere, "UnpackedSphere3d.FromEntityBoundingSphere")

function GCAD.UnpackedSphere3d.FromPositionAndRadius (position, radius)
	return position [1], position [2], position [3], radius
end

-- Circle properties
function GCAD.UnpackedSphere3d.GetPosition (x, y, z, r, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = x
	out [2] = y
	out [3] = z
	
	return out
end

function GCAD.UnpackedSphere3d.GetPositionNative (x, y, z, r, out)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

function GCAD.UnpackedSphere3d.GetPositionUnpacked (x, y, z, r)
	return x, y, z
end

function GCAD.UnpackedSphere3d.GetRadius (x, y, z, r)
	return r
end

function GCAD.UnpackedSphere3d.SetPosition (x, y, z, r, pos)
	return pos [1], pos [2], pos [3], r
end

function GCAD.UnpackedSphere3d.SetPositionNative (x, y, z, r, pos)
	return Vector___index (pos, "x"), Vector___index (pos, "y"), Vector___index (pos, "z"), r
end

function GCAD.UnpackedSphere3d.SetPositionUnpacked (x, y, z, r, x1, y1, z1)
	return x1, y1, z1, r
end

function GCAD.UnpackedSphere3d.SetRadius (x, y, z, r1)
	return x, y, z, r1
end

-- Circle queries
function GCAD.UnpackedSphere3d.DistanceToPoint (x, y, z, r, v3d)
	return GCAD_UnpackedVector3d_DistanceTo (x, y, z, v3d [1], v3d [2], v3d [3]) - r
end

function GCAD.UnpackedSphere3d.DistanceToNativePoint (x, y, z, r, v)
	return GCAD_UnpackedVector3d_DistanceTo (x, y, z, GCAD_UnpackedVector3d_FromNativeVector (v)) - r
end

function GCAD.UnpackedSphere3d.DistanceToUnpackedPoint (x, y, z, r, x1, y1, z1)
	return GCAD_UnpackedVector3d_DistanceTo (x, y, z, x1, y1, z1) - r
end

-- Intersection tests
-- Point
local GCAD_UnpackedSphere3d_DistanceToPoint         = GCAD.UnpackedSphere3d.DistanceToPoint
local GCAD_UnpackedSphere3d_DistanceToNativePoint   = GCAD.UnpackedSphere3d.DistanceToNativePoint
local GCAD_UnpackedSphere3d_DistanceToUnpackedPoint = GCAD.UnpackedSphere3d.DistanceToUnpackedPoint

function GCAD.UnpackedSphere3d.ContainsPoint (x, y, z, r, v3d)
	return GCAD_UnpackedSphere3d_DistanceToPoint (x, y, z, r, v3d) < 0
end

function GCAD.UnpackedSphere3d.ContainsNativePoint (x, y, z, r, v)
	return GCAD_UnpackedSphere3d_DistanceToNativePoint (x, y, z, r, v) < 0
end

function GCAD.UnpackedSphere3d.ContainsUnpackedPoint (x, y, z, r, x, y, z)
	return GCAD_UnpackedSphere3d_DistanceToUnpackedPoint (x, y, z, r, x, y, z) < 0
end

-- Sphere
function GCAD.UnpackedSphere3d.ContainsSphere (x, y, z, r, sphere3d)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, sphere3d:GetPositionUnpacked ())
	return distance + sphere3d [4] < r
end

function GCAD.UnpackedSphere3d.ContainsNativeSphere (x, y, z, r, nativeSphere3d)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, nativeSphere3d:GetPositionUnpacked ())
	return distance + nativeSphere3d [4] < r
end

function GCAD.UnpackedSphere3d.ContainsUnpackedSphere (x, y, z, r, x1, y1, z1, r1)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, x1, y1, z1)
	return distance + r1 < r
end

function GCAD.UnpackedSphere3d.IntersectsSphere (x, y, z, r, sphere3d)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, sphere3d:GetPositionUnpacked ())
	local sphereRadius = sphere3d [4]
	if distance + sphereRadius < r then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < r then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

function GCAD.UnpackedSphere3d.IntersectsNativeSphere (x, y, z, r, nativeSphere3d)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, nativeSphere3d:GetPositionUnpacked ())
	local sphereRadius = nativeSphere3d [4]
	if distance + sphereRadius < r then return true, true  end -- sphere lies within this sphere
	if distance - sphereRadius < r then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

function GCAD.UnpackedSphere3d.IntersectsUnpackedSphere (x, y, z, r, x1, y1, z1, r1)
	local distance = GCAD_UnpackedVector3d_DistanceTo (x, y, z, x1, y1, z1)
	if distance + r1 < r then return true, true  end -- sphere lies within this sphere
	if distance - r1 < r then return true, false end -- centre lies outside, but surface intersects this sphere
	return false, false
end

-- Conversion
function GCAD.UnpackedSphere3d.FromNativeSphere3d (nativeSphere3d)
	local x, y, z = nativeSphere3d:GetPositionUnpacked ()
	return x, y, z, nativeSphere3d [4]
end

function GCAD.UnpackedSphere3d.ToNativeSphere3d (x, y, z, r, out)
	out = out or GCAD.NativeSphere3d ()
	
	out:SetPositionUnpacked (x, y, z)
	out [4] = r
	
	return out
end

-- Utility
function GCAD.UnpackedSphere3d.ToString (x, y, z, r)
	return "Sphere [(" .. tostring (x) .. ", " .. tostring (y) .. ", " .. tostring (z) .."), " .. tostring (r) .. "]"
end

-- Construction
function GCAD.UnpackedSphere3d.Minimum ()
	return 0, 0, 0, -math.huge
end

function GCAD.UnpackedSphere3d.Maximum ()
	return 0, 0, 0, math.huge
end
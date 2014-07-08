local math_max                                   = math.max

local Angle                                      = Angle
local Vector                                     = Vector

local Angle_Set                                  = debug.getregistry ().Angle.Set
local Entity_BoundingRadius                      = debug.getregistry ().Entity.BoundingRadius
local Entity_GetAngles                           = debug.getregistry ().Entity.GetAngles
local Entity_GetPos                              = debug.getregistry ().Entity.GetPos
local Entity_IsValid                             = debug.getregistry ().Entity.IsValid
local Entity_LocalToWorld                        = debug.getregistry ().Entity.LocalToWorld
local Entity_OBBCenter                           = debug.getregistry ().Entity.OBBCenter
local Entity_OBBMaxs                             = debug.getregistry ().Entity.OBBMaxs
local Entity_OBBMins                             = debug.getregistry ().Entity.OBBMins
local Vector_Set                                 = debug.getregistry ().Vector.Set
local Vector___index                             = debug.getregistry ().Vector.__index

local GCAD_EulerAngle_FromNativeAngle            = GCAD.EulerAngle.FromNativeAngle
local GCAD_Vector3d_FromNativeVector             = GCAD.Vector3d.FromNativeVector
local GCAD_UnpackedVector3d_FromNativeVector     = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_ToNativeVector       = GCAD.UnpackedVector3d.ToNativeVector
local GCAD_UnpackedVector3d_VectorScalarMultiply = GCAD.UnpackedVector3d.VectorScalarMultiply

function GCAD.Sphere3d.FromPACPartBoundingSphere (part, out)
	out = out or GCAD.Sphere3d ()
	
	local ent = part.Entity
	if not Entity_IsValid (ent) then return out end
	
	local pos = Entity_LocalToWorld (ent, Entity_OBBCenter (ent))
	out [1] = Vector___index (pos, 1)
	out [2] = Vector___index (pos, 2)
	out [3] = Vector___index (pos, 3)
	out [4] = Entity_BoundingRadius (ent) * math_max (GCAD_UnpackedVector3d_FromNativeVector (part.Scale)) * part.Size
	return out
end
-- GCAD.Sphere3d.FromPACPartBoundingSphere = GCAD.Profiler:Wrap (GCAD.Sphere3d.FromPACPartBoundingSphere, "Sphere3d.FromPACPartBoundingSphere")

function GCAD.NativeSphere3d.FromPACPartBoundingSphere (part, out)
	out = out or GCAD.NativeSphere3d ()
	
	local ent = part.Entity
	if not Entity_IsValid (ent) then return out end
	
	local pos = Entity_LocalToWorld (ent, Entity_OBBCenter (ent))
	Vector_Set (out.Position, pos)
	out [4] = Entity_BoundingRadius (ent) * math_max (GCAD_UnpackedVector3d_FromNativeVector (part.Scale)) * part.Size
	return out
end
-- GCAD.NativeSphere3d.FromPACPartBoundingSphere = GCAD.Profiler:Wrap (GCAD.NativeSphere3d.FromPACPartBoundingSphere, "NativeSphere3d.FromPACPartBoundingSphere")

function GCAD.OBB3d.FromPACPart (part, out)
	out = out or GCAD.OBB3d ()
	
	local ent = part.Entity
	if not Entity_IsValid (ent) then return out end
	
	out.Position = GCAD_Vector3d_FromNativeVector  (Entity_GetPos    (ent), out.Position)
	out.Min      = GCAD_Vector3d_FromNativeVector  (Entity_OBBMins   (ent), out.Min     )
	out.Max      = GCAD_Vector3d_FromNativeVector  (Entity_OBBMaxs   (ent), out.Max     )
	out.Angle    = GCAD_EulerAngle_FromNativeAngle (Entity_GetAngles (ent), out.Angle   )
	
	local kx, ky, kz = GCAD_UnpackedVector3d_FromNativeVector (part.Scale)
	kx, ky, kz = GCAD_UnpackedVector3d_VectorScalarMultiply (kx, ky, kz, part.Size)
	
	out.Min [1] = out.Min [1] * kx
	out.Min [2] = out.Min [2] * ky
	out.Min [3] = out.Min [3] * kz
	
	out.Max [1] = out.Max [1] * kx
	out.Max [2] = out.Max [2] * ky
	out.Max [3] = out.Max [3] * kz
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end
-- GCAD.OBB3d.FromPACPart = GCAD.Profiler:Wrap (GCAD.OBB3d.FromPACPart, "OBB3d.FromPACPart")

function GCAD.NativeOBB3d.FromPACPart (part, out)
	out = out or GCAD.NativeOBB3d ()
	
	local ent = part.Entity
	if not Entity_IsValid (ent) then return out end
	
	Vector_Set (out.Position, Entity_GetPos    (ent))
	Angle_Set  (out.Angle,    Entity_GetAngles (ent))
	
	local x1, y1, z1 = GCAD_UnpackedVector3d_FromNativeVector (Entity_OBBMins (ent))
	local x2, y2, z2 = GCAD_UnpackedVector3d_FromNativeVector (Entity_OBBMaxs (ent))
	
	local kx, ky, kz = GCAD_UnpackedVector3d_FromNativeVector (part.Scale)
	kx, ky, kz = GCAD_UnpackedVector3d_VectorScalarMultiply (kx, ky, kz, part.Size)
	
	x1 = x1 * kx
	y1 = y1 * ky
	z1 = z1 * kz
	
	x2 = x2 * kx
	y2 = y2 * ky
	z2 = z2 * kz
	
	out.Min = GCAD_UnpackedVector3d_ToNativeVector (x1, y1, z1, out.Min)
	out.Max = GCAD_UnpackedVector3d_ToNativeVector (x2, y2, z2, out.Max)
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end
-- GCAD.NativeOBB3d.FromPACPart = GCAD.Profiler:Wrap (GCAD.NativeOBB3d.FromPACPart, "NativeOBB3d.FromPACPart")

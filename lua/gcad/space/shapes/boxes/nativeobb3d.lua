local self = {}
GCAD.NativeOBB3d = GCAD.MakeConstructor (self)

local Angle                                       = Angle
local Vector                                      = Vector

local Angle_Set                                   = debug.getregistry ().Angle.Set
local Entity_GetAngles                            = debug.getregistry ().Entity.GetAngles
local Entity_GetPos                               = debug.getregistry ().Entity.GetPos
local Entity_IsValid                              = debug.getregistry ().Entity.IsValid
local Entity_OBBMaxs                              = debug.getregistry ().Entity.OBBMaxs
local Entity_OBBMins                              = debug.getregistry ().Entity.OBBMins
local Vector_Set                                  = debug.getregistry ().Vector.Set

local GCAD_EulerAngle_FromNativeAngle             = GCAD.EulerAngle.FromNativeAngle
local GCAD_EulerAngle_ToNativeAngle               = GCAD.EulerAngle.ToNativeAngle
local GCAD_Vector3d_FromNativeVector              = GCAD.Vector3d.FromNativeVector
local GCAD_Vector3d_ToNativeVector                = GCAD.Vector3d.ToNativeVector
local GCAD_UnpackedEulerAngle_FromNativeAngle     = GCAD.UnpackedEulerAngle.FromNativeAngle
local GCAD_UnpackedEulerAngle_ToNativeAngle       = GCAD.UnpackedEulerAngle.ToNativeAngle
local GCAD_UnpackedVector3d_FromNativeVector      = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_ToNativeVector        = GCAD.UnpackedVector3d.ToNativeVector

function GCAD.NativeOBB3d.FromEntity (ent, out)
	out = out or GCAD.NativeOBB3d ()
	
	if not Entity_IsValid (ent) then return out end
	
	Vector_Set (out.Position, Entity_GetPos    (ent))
	Vector_Set (out.Min,      Entity_OBBMins   (ent))
	Vector_Set (out.Max,      Entity_OBBMaxs   (ent))
	Angle_Set  (out.Angle,    Entity_GetAngles (ent))
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end
-- GCAD.NativeOBB3d.FromEntity = GCAD.Profiler:Wrap (GCAD.NativeOBB3d.FromEntity, "NativeOBB3d.FromEntity")

-- Copying
function GCAD.NativeOBB3d.Clone (self, out)
	out = out or GCAD.NativeOBB3d ()
	
	Vector_Set (out.Position, self.Position)
	Vector_Set (out.Min,      self.Min     )
	Vector_Set (out.Max,      self.Max     )
	Angle_Set  (out.Angle,    self.Angle   )
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end

function GCAD.NativeOBB3d.Copy (self, source)
	Vector_Set (self.Position, source.Position)
	Vector_Set (self.Min,      source.Min     )
	Vector_Set (self.Max,      source.Max     )
	Angle_Set  (self.Angle,    source.Angle   )
	
	self.CornersValid        = false
	self.RotationMatrixValid = false
	
	return self
end

-- OBB properties
function GCAD.NativeOBB3d.GetPosition         (self, out)     return GCAD_Vector3d_FromNativeVector  (self.Position, out) end
function GCAD.NativeOBB3d.GetMin              (self, out)     return GCAD_Vector3d_FromNativeVector  (self.Min,      out) end
function GCAD.NativeOBB3d.GetMax              (self, out)     return GCAD_Vector3d_FromNativeVector  (self.Max,      out) end
function GCAD.NativeOBB3d.GetAngle            (self, out)     return GCAD_EulerAngle_FromNativeAngle (self.Angle,    out) end

function GCAD.NativeOBB3d.GetPositionNative   (self, out)     out = out or Vector () Vector_Set (out, self.Position) return out end
function GCAD.NativeOBB3d.GetMinNative        (self, out)     out = out or Vector () Vector_Set (out, self.Min     ) return out end
function GCAD.NativeOBB3d.GetMaxNative        (self, out)     out = out or Vector () Vector_Set (out, self.Max     ) return out end
function GCAD.NativeOBB3d.GetAngleNative      (self, out)     out = out or Angle  () Angle_Set  (out, self.Angle   ) return out end

function GCAD.NativeOBB3d.GetPositionUnpacked (self)          return GCAD_UnpackedVector3d_FromNativeVector   (self.Position     ) end
function GCAD.NativeOBB3d.GetMinUnpacked      (self)          return GCAD_UnpackedVector3d_FromNativeVector   (self.Min          ) end
function GCAD.NativeOBB3d.GetMaxUnpacked      (self)          return GCAD_UnpackedVector3d_FromNativeVector   (self.Max          ) end
function GCAD.NativeOBB3d.GetAngleUnpacked    (self)          return GCAD_UnpackedEulerAngle_FromNativeAngle  (self.Angle        ) end

function GCAD.NativeOBB3d.SetPosition         (self, pos)     self.Position = GCAD_Vector3d_ToNativeVector   (pos,   self.Position)           self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetMin              (self, pos)     self.Min      = GCAD_Vector3d_ToNativeVector   (pos,   self.Min     )           self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetMax              (self, pos)     self.Max      = GCAD_Vector3d_ToNativeVector   (pos,   self.Max     )           self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetAngle            (self, angle)   self.Angle    = GCAD_EulerAngle_ToNativeAngle  (angle, self.Angle   )           self.CornersValid = false self.RotationMatrixValid = false return self end

function GCAD.NativeOBB3d.SetPositionNative   (self, pos)     Vector_Set (self.Position, pos  )                                               self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetMinNative        (self, pos)     Vector_Set (self.Min,      pos  )                                               self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetMaxNative        (self, pos)     Vector_Set (self.Max,      pos  )                                               self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetAngleNative      (self, angle)   Angle_Set  (self.Angle,    angle)                                               self.CornersValid = false self.RotationMatrixValid = false return self end

function GCAD.NativeOBB3d.SetPositionUnpacked (self, x, y, z) self.Position = GCAD_UnpackedVector3d_ToNativeVector   (x, y, z, self.Position) self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetMinUnpacked      (self, x, y, z) self.Min      = GCAD_UnpackedVector3d_ToNativeVector   (x, y, z, self.Min     ) self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetMaxUnpacked      (self, x, y, z) self.Max      = GCAD_UnpackedVector3d_ToNativeVector   (x, y, z, self.Max     ) self.CornersValid = false return self end
function GCAD.NativeOBB3d.SetAngleUnpacked    (self, p, y, r) self.Angle    = GCAD_UnpackedEulerAngle_ToNativeAngle  (p, y, r, self.Angle   ) self.CornersValid = false self.RotationMatrixValid = false return self end

-- OBB corner queries

-- Intersection tests
-- Point

-- Line

-- Conversion
function GCAD.OBB3d.FromOBB3d (obb3d, out)
	out = out or GCAD.NativeOBB3d ()
	
	out.Position = GCAD_Vector3d_ToNativeVector  (obb3d.Position, out.Position)
	out.Min      = GCAD_Vector3d_ToNativeVector  (obb3d.Min,      out.Min     )
	out.Max      = GCAD_Vector3d_ToNativeVector  (obb3d.Max,      out.Max     )
	out.Angle    = GCAD_EulerAngle_ToNativeAngle (obb3d.Angle,    out.Angle   )
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end

function GCAD.OBB3d.ToOBB3d (self, out)
	out = out or GCAD.OBB3d ()
	
	out.Position = GCAD_Vector3d_FromNativeVector  (self.Position, out.Position)
	out.Min      = GCAD_Vector3d_FromNativeVector  (self.Min,      out.Min     )
	out.Max      = GCAD_Vector3d_FromNativeVector  (self.Max,      out.Max     )
	out.Angle    = GCAD_EulerAngle_FromNativeAngle (self.Angle,    out.Angle   )
	
	return out
end

-- Construction
function self:ctor (position, min, max, angle)
	self.Position = Vector ()
	self.Min      = Vector ()
	self.Max      = Vector ()
	self.Angle    = Angle  ()
	
	self.Corners = {}
	self.RotationMatrix = nil
	
	if position then self:SetPositionNative (position) end
	if min      then self:SetMinNative      (min)      end
	if max      then self:SetMaxNative      (max)      end
	if angle    then self:SetAngleNative    (angle)    end
	
	self.CornersValid        = false
	self.RotationMatrixValid = false
end

-- Initialization
function self:Set (position, min, max, angle)
	self:SetPositionNative (position)
	self:SetMinNative      (min)
	self:SetMaxNative      (max)
	self:SetAngleNative    (angle)
	
	self.CornersValid        = false
	self.RotationMatrixValid = false
end

-- Copying
self.Clone                       = GCAD.NativeOBB3d.Clone
self.Copy                        = GCAD.NativeOBB3d.Copy

-- OBB properties
self.GetPosition                 = GCAD.NativeOBB3d.GetPosition
self.GetMin                      = GCAD.NativeOBB3d.GetMin
self.GetMax                      = GCAD.NativeOBB3d.GetMax
self.GetAngle                    = GCAD.NativeOBB3d.GetAngle

self.GetPositionNative           = GCAD.NativeOBB3d.GetPositionNative
self.GetMinNative                = GCAD.NativeOBB3d.GetMinNative
self.GetMaxNative                = GCAD.NativeOBB3d.GetMaxNative
self.GetAngleNative              = GCAD.NativeOBB3d.GetAngleNative

self.GetPositionUnpacked         = GCAD.NativeOBB3d.GetPositionUnpacked
self.GetMinUnpacked              = GCAD.NativeOBB3d.GetMinUnpacked
self.GetMaxUnpacked              = GCAD.NativeOBB3d.GetMaxUnpacked
self.GetAngleUnpacked            = GCAD.NativeOBB3d.GetAngleUnpacked

self.SetPosition                 = GCAD.NativeOBB3d.SetPosition
self.SetMin                      = GCAD.NativeOBB3d.SetMin
self.SetMax                      = GCAD.NativeOBB3d.SetMax
self.SetAngle                    = GCAD.NativeOBB3d.SetAngle

self.SetPositionNative           = GCAD.NativeOBB3d.SetPositionNative
self.SetMinNative                = GCAD.NativeOBB3d.SetMinNative
self.SetMaxNative                = GCAD.NativeOBB3d.SetMaxNative
self.SetAngleNative              = GCAD.NativeOBB3d.SetAngleNative

self.SetPositionUnpacked         = GCAD.NativeOBB3d.SetPositionUnpacked
self.SetMinUnpacked              = GCAD.NativeOBB3d.SetMinUnpacked
self.SetMaxUnpacked              = GCAD.NativeOBB3d.SetMaxUnpacked
self.SetAngleUnpacked            = GCAD.NativeOBB3d.SetAngleUnpacked

-- OBB corner queries
self.GetCorner                   = GCAD.NativeOBB3d.GetCorner
self.GetCornerUnpacked           = GCAD.NativeOBB3d.GetCornerUnpacked
self.GetCornerEnumerator         = GCAD.NativeOBB3d.GetCornerEnumerator
self.GetVertex                   = GCAD.NativeOBB3d.GetVertex
self.GetVertexUnpacked           = GCAD.NativeOBB3d.GetVertexUnpacked
self.GetVertexEnumerator         = GCAD.NativeOBB3d.GetVertexEnumerator
self.GetEdgeEnumerator           = GCAD.NativeOBB3d.GetEdgeEnumerator
self.GetOppositeCorner           = GCAD.NativeOBB3d.GetOppositeCorner
self.GetOppositeCornerId         = GCAD.NativeOBB3d.GetOppositeCornerId
self.GetExtremeCorner            = GCAD.NativeOBB3d.GetExtremeCorner
self.GetExtremeCornerId          = GCAD.NativeOBB3d.GetExtremeCornerId
self.GetExtremeCornerIdUnpacked  = GCAD.NativeOBB3d.GetExtremeCornerIdUnpacked
self.GetExtremeCornerIds         = GCAD.NativeOBB3d.GetExtremeCornerIds
self.GetExtremeCornerIdsUnpacked = GCAD.NativeOBB3d.GetExtremeCornerIdsUnpacked

-- Intersection tests
-- Point
self.ContainsPoint               = GCAD.NativeOBB3d.ContainsPoint
self.ContainsNativePoint         = GCAD.NativeOBB3d.ContainsNativePoint
self.ContainsUnpackedPoint       = GCAD.NativeOBB3d.ContainsUnpackedPoint

-- Line
self.IntersectsLine              = GCAD.NativeOBB3d.IntersectsLine
self.IntersectLine               = GCAD.NativeOBB3d.IntersectLine

-- Conversion
self.ToOBB3d                     = GCAD.NativeOBB3d.ToOBB3d

-- Utility

-- Internal, do not call
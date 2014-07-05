local self = {}
GCAD.OBB3d = GCAD.MakeConstructor (self)

local Entity_GetAngles                            = debug.getregistry ().Entity.GetAngles
local Entity_GetPos                               = debug.getregistry ().Entity.GetPos
local Entity_IsValid                              = debug.getregistry ().Entity.IsValid
local Entity_OBBMaxs                              = debug.getregistry ().Entity.OBBMaxs
local Entity_OBBMins                              = debug.getregistry ().Entity.OBBMins

local GCAD_AABB3d_GetExtremeCornerIdsUnpacked     = GCAD.AABB3d.GetExtremeCornerIdsUnpacked
local GCAD_EulerAngle_Clone                       = GCAD.EulerAngle.Clone
local GCAD_EulerAngle_Copy                        = GCAD.EulerAngle.Copy
local GCAD_EulerAngle_FromNativeAngle             = GCAD.EulerAngle.FromNativeAngle
local GCAD_EulerAngle_ToNativeAngle               = GCAD.EulerAngle.ToNativeAngle
local GCAD_EulerAngle_Unpack                      = GCAD.EulerAngle.Unpack
local GCAD_Matrix3x3_UnpackedVectorMatrixMultiply = GCAD.Matrix3x3.UnpackedVectorMatrixMultiply
local GCAD_Vector3d_Add                           = GCAD.Vector3d.Add
local GCAD_Vector3d_Clone                         = GCAD.Vector3d.Clone
local GCAD_Vector3d_Copy                          = GCAD.Vector3d.Copy
local GCAD_Vector3d_FromNativeVector              = GCAD.Vector3d.FromNativeVector
local GCAD_Vector3d_ToNativeVector                = GCAD.Vector3d.ToNativeVector
local GCAD_Vector3d_Unpack                        = GCAD.Vector3d.Unpack
local GCAD_UnpackedRange1d_IntersectTriple        = GCAD.UnpackedRange1d.IntersectTriple
local GCAD_UnpackedRange1d_IsEmpty                = GCAD.UnpackedRange1d.IsEmpty
local GCAD_UnpackedRange3d_ContainsUnpackedPoint  = GCAD.UnpackedRange3d.ContainsUnpackedPoint
local GCAD_UnpackedVector3d_FromNativeVector      = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_Subtract              = GCAD.UnpackedVector3d.Subtract

function GCAD.OBB3d.FromEntity (ent, out)
	out = out or GCAD.OBB3d ()
	
	if not Entity_IsValid (ent) then return out end
	
	out.Position = GCAD_Vector3d_FromNativeVector  (Entity_GetPos    (ent), out.Position)
	out.Min      = GCAD_Vector3d_FromNativeVector  (Entity_OBBMins   (ent), out.Min     )
	out.Max      = GCAD_Vector3d_FromNativeVector  (Entity_OBBMaxs   (ent), out.Max     )
	out.Angle    = GCAD_EulerAngle_FromNativeAngle (Entity_GetAngles (ent), out.Angle   )
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end
-- GCAD.OBB3d.FromEntity = GCAD.Profiler:Wrap (GCAD.OBB3d.FromEntity, "OBB3d.FromEntity")

-- Copying
function GCAD.OBB3d.Clone (self, out)
	out = out or GCAD.OBB3d ()
	
	out.Position = GCAD_Vector3d_Clone   (self.Position, out.Position)
	out.Min      = GCAD_Vector3d_Clone   (self.Min,      out.Min     )
	out.Max      = GCAD_Vector3d_Clone   (self.Max,      out.Max     )
	out.Angle    = GCAD_EulerAngle_Clone (self.Angle,    out.Angle   )
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end

function GCAD.OBB3d.Copy (self, source)
	self.Position = GCAD_Vector3d_Copy   (self.Position, out.Position)
	self.Min      = GCAD_Vector3d_Copy   (self.Min,      out.Min     )
	self.Max      = GCAD_Vector3d_Copy   (self.Max,      out.Max     )
	self.Angle    = GCAD_EulerAngle_Copy (self.Angle,    out.Angle   )
	
	self.CornersValid        = false
	self.RotationMatrixValid = false
	
	return self
end

-- OBB properties
function GCAD.OBB3d.GetPosition         (self, out)     return GCAD_Vector3d_Clone            (self.Position, out) end
function GCAD.OBB3d.GetMin              (self, out)     return GCAD_Vector3d_Clone            (self.Min,      out) end
function GCAD.OBB3d.GetMax              (self, out)     return GCAD_Vector3d_Clone            (self.Max,      out) end
function GCAD.OBB3d.GetAngle            (self, out)     return GCAD_EulerAngle_Clone          (self.Angle,    out) end

function GCAD.OBB3d.GetPositionNative   (self, out)     return GCAD_Vector3d_ToNativeVector   (self.Position, out) end
function GCAD.OBB3d.GetMinNative        (self, out)     return GCAD_Vector3d_ToNativeVector   (self.Min,      out) end
function GCAD.OBB3d.GetMaxNative        (self, out)     return GCAD_Vector3d_ToNativeVector   (self.Max,      out) end
function GCAD.OBB3d.GetAngleNative      (self, out)     return GCAD_EulerAngle_ToNativeVector (self.Angle,    out) end

function GCAD.OBB3d.GetPositionUnpacked (self)          return GCAD_Vector3d_Unpack           (self.Position     ) end
function GCAD.OBB3d.GetMinUnpacked      (self)          return GCAD_Vector3d_Unpack           (self.Min          ) end
function GCAD.OBB3d.GetMaxUnpacked      (self)          return GCAD_Vector3d_Unpack           (self.Max          ) end
function GCAD.OBB3d.GetAngleUnpacked    (self)          return GCAD_EulerAngle_Unpack         (self.Angle        ) end

function GCAD.OBB3d.SetPosition         (self, pos)     self.Position = GCAD_Vector3d_Copy   (self.Position, pos  )            self.CornersValid = false return self end
function GCAD.OBB3d.SetMin              (self, pos)     self.Min      = GCAD_Vector3d_Copy   (self.Min,      pos  )            self.CornersValid = false return self end
function GCAD.OBB3d.SetMax              (self, pos)     self.Max      = GCAD_Vector3d_Copy   (self.Max,      pos  )            self.CornersValid = false return self end
function GCAD.OBB3d.SetAngle            (self, angle)   self.Angle    = GCAD_EulerAngle_Copy (self.Angle,    angle)            self.CornersValid = false self.RotationMatrixValid = false return self end

function GCAD.OBB3d.SetPositionNative   (self, pos)     self.Position = GCAD_Vector3d_FromNativeVector  (pos,   self.Position) self.CornersValid = false return self end
function GCAD.OBB3d.SetMinNative        (self, pos)     self.Min      = GCAD_Vector3d_FromNativeVector  (pos,   self.Min     ) self.CornersValid = false return self end
function GCAD.OBB3d.SetMaxNative        (self, pos)     self.Max      = GCAD_Vector3d_FromNativeVector  (pos,   self.Max     ) self.CornersValid = false return self end
function GCAD.OBB3d.SetAngleNative      (self, angle)   self.Angle    = GCAD_EulerAngle_FromNativeAngle (angle, self.Angle   ) self.CornersValid = false self.RotationMatrixValid = false return self end

function GCAD.OBB3d.SetPositionUnpacked (self, x, y, z) self.Position:Set (x, y, z)                                            self.CornersValid = false return self end
function GCAD.OBB3d.SetMinUnpacked      (self, x, y, z) self.Min     :Set (x, y, z)                                            self.CornersValid = false return self end
function GCAD.OBB3d.SetMaxUnpacked      (self, x, y, z) self.Max     :Set (x, y, z)                                            self.CornersValid = false return self end
function GCAD.OBB3d.SetAngleUnpacked    (self, p, y, r) self.Angle   :Set (p, y, r)                                            self.CornersValid = false self.RotationMatrixValid = false return self end

-- OBB corner queries
function GCAD.OBB3d.GetCorner (self, cornerId, out)
	out = out or GCAD.Vector3d ()
	
	if not self.CornersValid then self:ComputeCorners () end
	
	out [1] = self.Corners [cornerId] [1]
	out [2] = self.Corners [cornerId] [2]
	out [3] = self.Corners [cornerId] [3]
	
	return out
end

function GCAD.OBB3d.GetCornerUnpacked (self, cornerId)
	if not self.CornersValid then self:ComputeCorners () end
	
	return self.Corners [cornerId] [1], self.Corners [cornerId] [2], self.Corners [cornerId] [3]
end

local GCAD_OBB3d_GetCorner = GCAD.OBB3d.GetCorner

function GCAD.OBB3d.GetCornerEnumerator (self, out)
	local i = 0
	return function ()
		i = i + 1
		if i > 8 then return nil end
		
		return GCAD_OBB3d_GetCorner (self, i, out)
	end
end

GCAD.OBB3d.GetVertex           = GCAD.OBB3d.GetCorner
GCAD.OBB3d.GetVertexUnpacked   = GCAD.OBB3d.GetCornerUnpacked
GCAD.OBB3d.GetVertexEnumerator = GCAD.OBB3d.GetCornerEnumerator

local edgeCornerIds1 = { 1, 2, 4, 3, 1, 2, 4, 3, 5, 6, 8, 7 }
local edgeCornerIds2 = { 2, 4, 3, 1, 5, 6, 8, 7, 6, 8, 7, 5 }
function GCAD.OBB3d.GetEdgeEnumerator (self, out1, out2)
	local i = 0
	
	return function ()
		i = i + 1
		if i > 12 then return nil, nil end
		
		return GCAD_OBB3d_GetCorner (self, edgeCornerIds1 [i], out1), GCAD_OBB3d_GetCorner (self, edgeCornerIds2 [i], out2)
	end
end

local oppositeCornerIds =
{
	[1] = 8,
	[2] = 7,
	[3] = 6,
	[4] = 5,
	[5] = 4,
	[6] = 3,
	[7] = 2,
	[8] = 1
}

function GCAD.OBB3d.GetOppositeCorner (self, cornerId, out)
	return GCAD.OBB3d.GetCorner (oppositeCornerIds [cornerId], out)
end

function GCAD.OBB3d.GetOppositeCornerId (self, cornerId)
	return oppositeCornerIds [cornerId]
end

function GCAD.OBB3d.GetExtremeCornerIdsUnpacked (self, x, y, z)
	if not self.RotationMatrixValid then
		self:ComputeRotationMatrix ()
	end
	
	return GCAD_AABB3d_GetExtremeCornerIdsUnpacked (self, GCAD_Matrix3x3_UnpackedVectorMatrixMultiply (x, y, z, self.RotationMatrix))
end

local GCAD_OBB3d_GetExtremeCornerIdsUnpacked = GCAD.OBB3d.GetExtremeCornerIdsUnpacked
function GCAD.OBB3d.GetExtremeCornerIds (self, direction)
	return GCAD_OBB3d_GetExtremeCornerIdsUnpacked (self, direction [1], direction [2], direction [3])
end

GCAD.OBB3d.GetExtremeCornerId         = GCAD.OBB3d.GetExtremeCornerIds
GCAD.OBB3d.GetExtremeCornerIdUnpacked = GCAD.OBB3d.GetExtremeCornerIdsUnpacked

local GCAD_OBB3d_GetCorner          = GCAD.OBB3d.GetCorner
local GCAD_OBB3d_GetExtremeCornerId = GCAD.OBB3d.GetExtremeCornerId

function GCAD.OBB3d.GetExtremeCorner (self, direction, out)
	return GCAD_OBB3d_GetCorner (GCAD_OBB3d_GetExtremeCornerId (self, direction), out)
end

-- Intersection tests
-- Point
function GCAD.OBB3d.ContainsUnpackedPoint (self, x, y, z)
	if not self.RotationMatrixValid then
		self:ComputeRotationMatrix ()
	end
	
	local x, y, z = GCAD_UnpackedVector3d_Subtract (x, y, z, GCAD_Vector3d_Unpack (self.Position))
	x, y, z = GCAD_Matrix3x3_UnpackedVectorMatrixMultiply (x, y, z, self.RotationMatrix)
	return GCAD_UnpackedRange3d_ContainsUnpackedPoint (self.Min [1], self.Min [2], self.Min [3], self.Max [1], self.Max [2], self.Max [3], x, y, z)
end

local GCAD_OBB3d_ContainsUnpackedPoint = GCAD.OBB3d.ContainsUnpackedPoint
function GCAD.OBB3d.ContainsPoint (self, v3d)
	return GCAD_OBB3d_ContainsUnpackedPoint (self, v3d [1], v3d [2], v3d [3])
end

function GCAD.OBB3d.ContainsNativePoint (self, v)
	return GCAD_OBB3d_ContainsUnpackedPoint (self, GCAD_UnpackedVector3d_FromNativeVector (v))
end

-- Line
function GCAD.OBB3d.IntersectLine (self, line3d)
	if not self.RotationMatrixValid then
		self:ComputeRotationMatrix ()
	end
	
	local dx, dy, dz = line3d:GetDirectionUnpacked ()
	dx, dy, dz = GCAD_Matrix3x3_UnpackedVectorMatrixMultiply (dx, dy, dz, self.RotationMatrix)
	
	local px, py, pz = line3d:GetPositionUnpacked ()
	px, py, pz = GCAD_UnpackedVector3d_Subtract (px, py, pz, GCAD_Vector3d_Unpack (self.Position))
	px, py, pz = GCAD_Matrix3x3_UnpackedVectorMatrixMultiply (px, py, pz, self.RotationMatrix)
	
	local x1, x2 = (self.Min [1] - px) / dx, (self.Max [1] - px) / dx
	local y1, y2 = (self.Min [2] - py) / dy, (self.Max [2] - py) / dy
	local z1, z2 = (self.Min [3] - pz) / dz, (self.Max [3] - pz) / dz
	
	if x1 > x2 then x1, x2 = x2, x1 end
	if y1 > y2 then y1, y2 = y2, y1 end
	if z1 > z2 then z1, z2 = z2, z1 end
	
	local t1, t2 = GCAD_UnpackedRange1d_IntersectTriple (
		x1, x2,
		y1, y2,
		z1, z2
	)
	
	if GCAD_UnpackedRange1d_IsEmpty (t1, t2) then return nil end
	return t1, t2
end
GCAD.OBB3d.IntersectLine = GCAD.Profiler:Wrap (GCAD.OBB3d.IntersectLine, "OBB3d:IntersectLine")

local GCAD_OBB3d_IntersectLine = GCAD.OBB3d.IntersectLine
function GCAD.OBB3d.IntersectsLine (self, line3d)
	return GCAD_OBB3d_IntersectLine (self, line3d) ~= nil
end

-- Conversion
function GCAD.OBB3d.FromNativeOBB3d (nativeOBB3d, out)
	out = out or GCAD.OBB3d ()
	
	out.Position = GCAD_Vector3d_FromNativeVector  (nativeOBB3d.Position, out.Position)
	out.Min      = GCAD_Vector3d_FromNativeVector  (nativeOBB3d.Min,      out.Min     )
	out.Max      = GCAD_Vector3d_FromNativeVector  (nativeOBB3d.Max,      out.Max     )
	out.Angle    = GCAD_EulerAngle_FromNativeAngle (nativeOBB3d.Angle,    out.Angle   )
	
	out.CornersValid        = false
	out.RotationMatrixValid = false
	
	return out
end

function GCAD.OBB3d.ToNativeOBB3d (self, out)
	out = out or GCAD.NativeOBB3d ()
	
	out.Position = GCAD_Vector3d_ToNativeVector  (self.Position, out.Position)
	out.Min      = GCAD_Vector3d_ToNativeVector  (self.Min,      out.Min     )
	out.Max      = GCAD_Vector3d_ToNativeVector  (self.Max,      out.Max     )
	out.Angle    = GCAD_EulerAngle_ToNativeAngle (self.Angle,    out.Angle   )
	
	return out
end

-- Construction
function self:ctor (position, min, max, angle)
	self.Position = GCAD.Vector3d ()
	self.Min      = GCAD.Vector3d ()
	self.Max      = GCAD.Vector3d ()
	self.Angle    = GCAD.EulerAngle ()
	
	self.Corners = {}
	self.RotationMatrix = nil
	
	if position then self:SetPosition (position) end
	if min      then self:SetMin      (min)      end
	if max      then self:SetMax      (max)      end
	if angle    then self:SetAngle    (angle)    end
	
	self.CornersValid        = false
	self.RotationMatrixValid = false
end

-- Initialization
function self:Set (position, min, max, angle)
	self:SetPosition (position)
	self:SetMin      (min)
	self:SetMax      (max)
	self:SetAngle    (angle)
	
	self.CornersValid        = false
	self.RotationMatrixValid = false
end

-- Copying
self.Clone                       = GCAD.OBB3d.Clone
self.Copy                        = GCAD.OBB3d.Copy

-- OBB properties
self.GetPosition                 = GCAD.OBB3d.GetPosition
self.GetMin                      = GCAD.OBB3d.GetMin
self.GetMax                      = GCAD.OBB3d.GetMax
self.GetAngle                    = GCAD.OBB3d.GetAngle

self.GetPositionNative           = GCAD.OBB3d.GetPositionNative
self.GetMinNative                = GCAD.OBB3d.GetMinNative
self.GetMaxNative                = GCAD.OBB3d.GetMaxNative
self.GetAngleNative              = GCAD.OBB3d.GetAngleNative

self.GetPositionUnpacked         = GCAD.OBB3d.GetPositionUnpacked
self.GetMinUnpacked              = GCAD.OBB3d.GetMinUnpacked
self.GetMaxUnpacked              = GCAD.OBB3d.GetMaxUnpacked
self.GetAngleUnpacked            = GCAD.OBB3d.GetAngleUnpacked

self.SetPosition                 = GCAD.OBB3d.SetPosition
self.SetMin                      = GCAD.OBB3d.SetMin
self.SetMax                      = GCAD.OBB3d.SetMax
self.SetAngle                    = GCAD.OBB3d.SetAngle

self.SetPositionNative           = GCAD.OBB3d.SetPositionNative
self.SetMinNative                = GCAD.OBB3d.SetMinNative
self.SetMaxNative                = GCAD.OBB3d.SetMaxNative
self.SetAngleNative              = GCAD.OBB3d.SetAngleNative

self.SetPositionUnpacked         = GCAD.OBB3d.SetPositionUnpacked
self.SetMinUnpacked              = GCAD.OBB3d.SetMinUnpacked
self.SetMaxUnpacked              = GCAD.OBB3d.SetMaxUnpacked
self.SetAngleUnpacked            = GCAD.OBB3d.SetAngleUnpacked

-- OBB corner queries
self.GetCorner                   = GCAD.OBB3d.GetCorner
self.GetCornerUnpacked           = GCAD.OBB3d.GetCornerUnpacked
self.GetCornerEnumerator         = GCAD.OBB3d.GetCornerEnumerator
self.GetVertex                   = GCAD.OBB3d.GetVertex
self.GetVertexUnpacked           = GCAD.OBB3d.GetVertexUnpacked
self.GetVertexEnumerator         = GCAD.OBB3d.GetVertexEnumerator
self.GetEdgeEnumerator           = GCAD.OBB3d.GetEdgeEnumerator
self.GetOppositeCorner           = GCAD.OBB3d.GetOppositeCorner
self.GetOppositeCornerId         = GCAD.OBB3d.GetOppositeCornerId
self.GetExtremeCorner            = GCAD.OBB3d.GetExtremeCorner
self.GetExtremeCornerId          = GCAD.OBB3d.GetExtremeCornerId
self.GetExtremeCornerIdUnpacked  = GCAD.OBB3d.GetExtremeCornerIdUnpacked
self.GetExtremeCornerIds         = GCAD.OBB3d.GetExtremeCornerIds
self.GetExtremeCornerIdsUnpacked = GCAD.OBB3d.GetExtremeCornerIdsUnpacked

-- Intersection tests
-- Point
self.ContainsPoint               = GCAD.OBB3d.ContainsPoint
self.ContainsNativePoint         = GCAD.OBB3d.ContainsNativePoint
self.ContainsUnpackedPoint       = GCAD.OBB3d.ContainsUnpackedPoint

-- Line
self.IntersectsLine              = GCAD.OBB3d.IntersectsLine
self.IntersectLine               = GCAD.OBB3d.IntersectLine

-- Conversion
self.ToNativeOBB3d               = GCAD.OBB3d.ToNativeOBB3d

-- Utility

-- Internal, do not call
function self:ComputeCorners ()
	if self.CornersValid then return end
	
	self.CornersValid = true
	
	for i = 1, 8 do
		self.Corners [i] = self.Corners [i] or GCAD.Vector3d ()
	end
	
	GCAD.Profiler:Begin ("OBB3d:ComputeCorners : Generate corners")
	local x1, y1, z1 = self.Min [1], self.Min [2], self.Min [3]
	local x2, y2, z2 = self.Max [1], self.Max [2], self.Max [3]
	local c
	c = self.Corners [1] c [1] = x1 c [2] = y1 c [3] = z1
	c = self.Corners [2] c [1] = x2 c [2] = y1 c [3] = z1
	c = self.Corners [3] c [1] = x1 c [2] = y2 c [3] = z1
	c = self.Corners [4] c [1] = x2 c [2] = y2 c [3] = z1
	c = self.Corners [5] c [1] = x1 c [2] = y1 c [3] = z2
	c = self.Corners [6] c [1] = x2 c [2] = y1 c [3] = z2
	c = self.Corners [7] c [1] = x1 c [2] = y2 c [3] = z2
	c = self.Corners [8] c [1] = x2 c [2] = y2 c [3] = z2
	GCAD.Profiler:End ()
	
	GCAD.Profiler:Begin ("OBB3d:ComputeCorners : Rotate corners")
	if not self.RotationMatrixValid then
		self:ComputeRotationMatrix ()
	end
	
	for i = 1, 8 do
		self.Corners [i] = GCAD_Vector3d_Add (self.RotationMatrix:VectorMultiply (self.Corners [i], self.Corners [i]), self.Position, self.Corners [i])
	end
	
	GCAD.Profiler:End ()
end
self.ComputeCorners = GCAD.Profiler:Wrap (self.ComputeCorners, "OBB3d:ComputeCorners")

function self:ComputeRotationMatrix ()
	if self.RotationMatrixValid == true then return end
	
	self.RotationMatrixValid = true
	
	self.RotationMatrix = GCAD.Matrix3x3.Rotate (self.Angle, self.RotationMatrix)
end
self.ComputeRotationMatrix = GCAD.Profiler:Wrap (self.ComputeRotationMatrix, "OBB3d:ComputeRotationMatrix")
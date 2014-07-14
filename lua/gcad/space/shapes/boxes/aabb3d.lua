local self = {}
GCAD.AABB3d = GCAD.MakeConstructor (self)

local math_huge                                   = math.huge
local math_min                                    = math.min
local math_max                                    = math.max

local Entity_IsValid                              = debug.getregistry ().Entity.IsValid
local Entity_WorldSpaceAABB                       = debug.getregistry ().Entity.WorldSpaceAABB

local GCAD_Vector3d_Clone                         = GCAD.Vector3d.Clone
local GCAD_Vector3d_ContainsNaN                   = GCAD.Vector3d.ContainsNaN
local GCAD_Vector3d_Copy                          = GCAD.Vector3d.Copy
local GCAD_Vector3d_Equals                        = GCAD.Vector3d.Equals
local GCAD_Vector3d_FromNativeVector              = GCAD.Vector3d.FromNativeVector
local GCAD_Vector3d_ToNativeVector                = GCAD.Vector3d.ToNativeVector
local GCAD_Vector3d_ToString                      = GCAD.Vector3d.ToString
local GCAD_Vector3d_Unpack                        = GCAD.Vector3d.Unpack
local GCAD_UnpackedRange1d_IntersectTriple        = GCAD.UnpackedRange1d.IntersectTriple
local GCAD_UnpackedRange1d_IsEmpty                = GCAD.UnpackedRange1d.IsEmpty
local GCAD_UnpackedRange3d_ContainsPoint3         = GCAD.UnpackedRange3d.ContainsPoint3
local GCAD_UnpackedRange3d_ContainsUnpackedPoint  = GCAD.UnpackedRange3d.ContainsUnpackedPoint
local GCAD_UnpackedRange3d_ContainsUnpackedPoint3 = GCAD.UnpackedRange3d.ContainsUnpackedPoint3
local GCAD_UnpackedVector3d_FromNativeVector      = GCAD.UnpackedVector3d.FromNativeVector

function GCAD.AABB3d.FromEntity (ent, out)
	out = out or GCAD.AABB3d ()
	
	if not Entity_IsValid (ent) then return out end
	
	local min, max = Entity_WorldSpaceAABB (ent)
	out.Min = GCAD_Vector3d_FromNativeVector (min)
	out.Max = GCAD_Vector3d_FromNativeVector (max)
	
	return out
end
-- GCAD.AABB3d.FromEntity = GCAD.Profiler:Wrap (GCAD.AABB3d.FromEntity, "AABB3d.FromEntity")

-- Copying
function GCAD.AABB3d.Clone (self, out)
	out = out or GCAD.AABB3d ()
	
	out.Min = GCAD_Vector3d_Clone (self.Min, out.Min)
	out.Max = GCAD_Vector3d_Clone (self.Max, out.Max)
	
	return out
end

function GCAD.AABB3d.Copy (self, source)
	self.Min = GCAD_Vector3d_Copy (self.Min, out.Min )
	self.Max = GCAD_Vector3d_Copy (self.Max, out.Max )
	
	return self
end

-- Equality
function GCAD.AABB3d.Equals (self, aabb3d)
	return GCAD_Vector3d_Equals (self.Min, aabb3d.Min) and
	       GCAD_Vector3d_Equals (self.Max, aabb3d.Max)
end

-- NaN
function GCAD.AABB3d.ContainsNaN (self)
	return GCAD_Vector3d_ContainsNaN (self.Min) or
	       GCAD_Vector3d_ContainsNaN (self.Max)
end

-- AABB properties
function GCAD.AABB3d.GetMin              (self, out)     return GCAD_Vector3d_Clone          (self.Min, out) end
function GCAD.AABB3d.GetMax              (self, out)     return GCAD_Vector3d_Clone          (self.Max, out) end

function GCAD.AABB3d.GetMinNative        (self, out)     return GCAD_Vector3d_ToNativeVector (self.Min, out) end
function GCAD.AABB3d.GetMaxNative        (self, out)     return GCAD_Vector3d_ToNativeVector (self.Max, out) end

function GCAD.AABB3d.GetMinUnpacked      (self)          return GCAD_Vector3d_Unpack         (self.Min     ) end
function GCAD.AABB3d.GetMaxUnpacked      (self)          return GCAD_Vector3d_Unpack         (self.Max     ) end

function GCAD.AABB3d.SetMin              (self, pos)     self.Min = GCAD_Vector3d_Copy (self.Min, pos)             return self end
function GCAD.AABB3d.SetMax              (self, pos)     self.Max = GCAD_Vector3d_Copy (self.Max, pos)             return self end

function GCAD.AABB3d.SetMinNative        (self, pos)     self.Min = GCAD_Vector3d_FromNativeVector (pos, self.Min) return self end
function GCAD.AABB3d.SetMaxNative        (self, pos)     self.Max = GCAD_Vector3d_FromNativeVector (pos, self.Max) return self end

function GCAD.AABB3d.SetMinUnpacked      (self, x, y, z) self.Min:Set (x, y, z)                                    return self end
function GCAD.AABB3d.SetMaxUnpacked      (self, x, y, z) self.Max:Set (x, y, z)                                    return self end

-- AABB size
function GCAD.AABB3d.IsEmpty (self)
	return self.Min [1] > self.Max [1] or
	       self.Min [2] > self.Max [2] or
		   self.Min [3] > self.Max [3]
end

function GCAD.AABB3d.Volume (self)
	return (self.Max [1] - self.Min [1]) * (self.Max [2] - self.Min [2]) * (self.Max [3] - self.Min [3])
end

-- AABB corner queries
function GCAD.AABB3d.GetCorner (self, cornerId, out)
	out = out or GCAD.Vector3d ()
	
	cornerId = cornerId - 1
	out [1] = cornerId % 2 < 1 and self.Min [1] or self.Max [1]
	out [2] = cornerId % 4 < 2 and self.Min [2] or self.Max [2]
	out [3] = cornerId % 8 < 4 and self.Min [3] or self.Max [3]
end

function GCAD.AABB3d.GetCornerUnpacked (self, cornerId)
	cornerId = cornerId - 1
	return cornerId % 2 < 1 and self.Min [1] or self.Max [1],
	       cornerId % 4 < 2 and self.Min [2] or self.Max [2],
	       cornerId % 8 < 4 and self.Min [3] or self.Max [3]
end

local bit_band = bit.band
function GCAD.AABB3d.GetCornerUnpacked2 (self, cornerId)
	cornerId = cornerId - 1
	return bit_band (cornerId, 1) == 0 and self.Min [1] or self.Max [1],
	       bit_band (cornerId, 2) == 0 and self.Min [2] or self.Max [2],
	       bit_band (cornerId, 4) == 0 and self.Min [3] or self.Max [3]
end

local GCAD_AABB3d_GetCorner = GCAD.AABB3d.GetCorner

function GCAD.AABB3d.GetCornerEnumerator (self, out)
	local i = 0
	return function ()
		i = i + 1
		if i > 8 then return nil end
		
		return GCAD_AABB3d_GetCorner (self, i, out)
	end
end

GCAD.AABB3d.GetVertex           = GCAD.AABB3d.GetCorner
GCAD.AABB3d.GetVertexUnpacked   = GCAD.AABB3d.GetCornerUnpacked
GCAD.AABB3d.GetVertexEnumerator = GCAD.AABB3d.GetCornerEnumerator

local edgeCornerIds1 = { 1, 2, 4, 3, 1, 2, 4, 3, 5, 6, 8, 7 }
local edgeCornerIds2 = { 2, 4, 3, 1, 5, 6, 8, 7, 6, 8, 7, 5 }
function GCAD.AABB3d.GetEdgeEnumerator (self, out1, out2)
	local i = 0
	
	return function ()
		i = i + 1
		if i > 12 then return nil, nil end
		
		return GCAD_AABB3d_GetCorner (self, edgeCornerIds1 [i], out1), GCAD_AABB3d_GetCorner (self, edgeCornerIds2 [i], out2)
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

function GCAD.AABB3d.GetOppositeCorner (self, cornerId, out)
	return GCAD.AABB3d.GetCorner (oppositeCornerIds [cornerId], out)
end

function GCAD.AABB3d.GetOppositeCornerId (self, cornerId)
	return oppositeCornerIds [cornerId]
end

function GCAD.AABB3d.GetExtremeCornerIdsUnpacked (self, x, y, z)
	if z < 0 then
		if y < 0 then
			extremeCornerId = x < 0 and 1 or 2
		else
			extremeCornerId = x < 0 and 3 or 4
		end
	else
		if y < 0 then
			extremeCornerId = x < 0 and 5 or 6
		else
			extremeCornerId = x < 0 and 7 or 8
		end
	end
	
	return extremeCornerId, oppositeCornerIds [extremeCornerId]
end

local GCAD_AABB3d_GetExtremeCornerIdsUnpacked = GCAD.AABB3d.GetExtremeCornerIdsUnpacked
function GCAD.AABB3d.GetExtremeCornerIds (self, direction)
	return GCAD_AABB3d_GetExtremeCornerIdsUnpacked (self, direction [1], direction [2], direction [3])
end

GCAD.AABB3d.GetExtremeCornerId         = GCAD.AABB3d.GetExtremeCornerIds
GCAD.AABB3d.GetExtremeCornerIdUnpacked = GCAD.AABB3d.GetExtremeCornerIdsUnpacked

local GCAD_AABB3d_GetCorner          = GCAD.AABB3d.GetCorner
local GCAD_AABB3d_GetExtremeCornerId = GCAD.AABB3d.GetExtremeCornerId

function GCAD.AABB3d.GetExtremeCorner (self, direction, out)
	return GCAD_AABB3d_GetCorner (GCAD_AABB3d_GetExtremeCornerId (self, direction), out)
end

-- AABB operations
function GCAD.AABB3d.Expand (self, v, out)
	out = out or self
	
	out.Min [1] = math_min (self.Min [1], v [1])
	out.Min [2] = math_min (self.Min [2], v [2])
	out.Min [3] = math_min (self.Min [3], v [3])
	out.Max [1] = math_max (self.Max [1], v [1])
	out.Max [2] = math_max (self.Max [2], v [2])
	out.Max [3] = math_max (self.Max [3], v [3])
	
	return out
end

function GCAD.AABB3d.ExpandUnpacked (self, x, y, z, out)
	out = out or self
	
	out.Min [1] = math_min (self.Min [1], x)
	out.Min [2] = math_min (self.Min [2], y)
	out.Min [3] = math_min (self.Min [3], z)
	out.Max [1] = math_max (self.Max [1], x)
	out.Max [2] = math_max (self.Max [2], y)
	out.Max [3] = math_max (self.Max [3], z)
	
	return out
end

function GCAD.AABB3d.Intersect (a, b, out)
	out = out or GCAD.AABB3d ()
	
	out.Min [1] = math_max (a.Min [1], b.Min [1])
	out.Min [2] = math_max (a.Min [2], b.Min [2])
	out.Min [3] = math_max (a.Min [3], b.Min [3])
	out.Max [1] = math_min (a.Max [1], b.Max [1])
	out.Max [2] = math_min (a.Max [2], b.Max [2])
	out.Max [3] = math_min (a.Max [3], b.Max [3])
	
	return out
end

function GCAD.AABB3d.Union (a, b, out)
	out = out or GCAD.AABB3d ()
	
	out.Min [1] = math_min (a.Min [1], b.Min [1])
	out.Min [2] = math_min (a.Min [2], b.Min [2])
	out.Min [3] = math_min (a.Min [3], b.Min [3])
	out.Max [1] = math_max (a.Max [1], b.Max [1])
	out.Max [2] = math_max (a.Max [2], b.Max [2])
	out.Max [3] = math_max (a.Max [3], b.Max [3])
	
	return out
end

-- Intersection tests
-- Point
function GCAD.AABB3d.ContainsUnpackedPoint (self, x, y, z)
	return GCAD_UnpackedRange3d_ContainsUnpackedPoint (self.Min [1], self.Min [2], self.Min [3], self.Max [1], self.Max [2], self.Max [3], x, y, z)
end

local GCAD_AABB3d_ContainsUnpackedPoint = GCAD.AABB3d.ContainsUnpackedPoint
function GCAD.AABB3d.ContainsPoint (self, v3d)
	return GCAD_AABB3d_ContainsUnpackedPoint (self, v3d [1], v3d [2], v3d [3])
end

function GCAD.AABB3d.ContainsNativePoint (self, v)
	return GCAD_AABB3d_ContainsUnpackedPoint (self, GCAD_UnpackedVector3d_FromNativeVector (v))
end

function GCAD.AABB3d.ContainsPoint3 (self, v3d)
	return GCAD_UnpackedRange3d_ContainsPoint3 (self.Min [1], self.Min [2], self.Min [3], self.Max [1], self.Max [2], self.Max [3], v3d)
end

function GCAD.AABB3d.ContainsNativePoint3 (self, v)
	return GCAD_UnpackedRange3d_ContainsUnpackedPoint3 (self.Min [1], self.Min [2], self.Min [3], self.Max [1], self.Max [2], self.Max [3], GCAD_UnpackedVector3d_FromNativeVector (v))
end

function GCAD.AABB3d.ContainsUnpackedPoint3 (self, x, y, z)
	return GCAD_UnpackedRange3d_ContainsUnpackedPoint3 (self.Min [1], self.Min [2], self.Min [3], self.Max [1], self.Max [2], self.Max [3], x, y, z)
end

-- Line
function GCAD.AABB3d.IntersectLine (self, line3d)
	local dx, dy, dz = line3d:GetDirectionUnpacked ()
	
	local px, py, pz = line3d:GetPositionUnpacked ()
	
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
GCAD.AABB3d.IntersectLine = GCAD.Profiler:Wrap (GCAD.AABB3d.IntersectLine, "AABB3d:IntersectLine")

local GCAD_AABB3d_IntersectLine = GCAD.AABB3d.IntersectLine
function GCAD.AABB3d.IntersectsLine (self, line3d)
	return GCAD_AABB3d_IntersectLine (self, line3d) ~= nil
end

-- AABB
function GCAD.AABB3d.ContainsAABB (self, aabb3d)
	return self.Min [1] <= aabb3d.Min [1] and aabb3d.Max [1] <= self.Max [1] and
	       self.Min [2] <= aabb3d.Min [2] and aabb3d.Max [2] <= self.Max [2] and
	       self.Min [3] <= aabb3d.Min [3] and aabb3d.Max [3] <= self.Max [3]
end

GCAD.AABB3d.IntersectAABB = GCAD.AABB3d.Intersect

function GCAD.AABB3d.IntersectsAABB (self, aabb3d)
	return math_max (self.Min [1], aabb3d.Min [1]) <= math_min (self.Max [1], aabb3d.Max [1]) and
	       math_max (self.Min [2], aabb3d.Min [2]) <= math_min (self.Max [2], aabb3d.Max [2]) and
	       math_max (self.Min [3], aabb3d.Min [3]) <= math_min (self.Max [3], aabb3d.Max [3])
end

-- Conversion
function GCAD.AABB3d.FromNativeAABB3d (nativeAABB3d, out)
	out = out or GCAD.AABB3d ()
	
	out.Min = GCAD_Vector3d_FromNativeVector (nativeAABB3d.Min, out.Min)
	out.Max = GCAD_Vector3d_FromNativeVector (nativeAABB3d.Max, out.Max)
	
	return out
end

function GCAD.AABB3d.ToNativeAABB3d (self, out)
	out = out or GCAD.NativeAABB3d ()
	
	out.Min = GCAD_Vector3d_ToNativeVector (self.Min, out.Min)
	out.Max = GCAD_Vector3d_ToNativeVector (self.Max, out.Max)
	
	return out
end

function GCAD.AABB3d.FromRange3d (range3d, out)
	out = out or GCAD.AABB3d ()
	
	range3d.Min:Set (range3d [1], range3d [3], range3d [5])
	range3d.Max:Set (range3d [2], range3d [4], range3d [6])
	
	return out
end

function GCAD.AABB3d.ToRange3d (self, out)
	out = out or GCAD.Range3d ()
	
	out [1], out [3], out [5] = GCAD_Vector3d_Unpack (self.Min)
	out [2], out [4], out [6] = GCAD_Vector3d_Unpack (self.Max)
	
	return out
end

-- Utility
function GCAD.AABB3d.Unpack (self)
	return self.Min [1], self.Min [2], self.Min [3], self.Max [1], self.Max [2], self.Max [3]
end

function GCAD.AABB3d.ToString (self)
	return "[" .. GCAD_Vector3d_ToString (self.Min) .. ", " .. GCAD_Vector3d_ToString (self.Max) .. "]"
end

-- Construction
function GCAD.AABB3d.Minimum (out)
	out = out or GCAD.AABB3d ()
	
	out.Min:Set ( math_huge,  math_huge,  math_huge)
	out.Max:Set (-math_huge, -math_huge, -math_huge)
	
	return out
end
function GCAD.AABB3d.Maximum (out)
	out = out or GCAD.AABB3d ()
	
	out.Min:Set (-math_huge, -math_huge, -math_huge)
	out.Max:Set ( math_huge,  math_huge,  math_huge)
	
	return out
end

function self:ctor (min, max)
	self.Min = GCAD.Vector3d ( math_huge,  math_huge,  math_huge)
	self.Max = GCAD.Vector3d (-math_huge, -math_huge, -math_huge)
	
	if min then self:SetMin (min) end
	if max then self:SetMax (max) end
end

-- Initialization
function self:Set (min, max)
	self:SetMin (min)
	self:SetMax (max)
end

local GCAD_AABB3d_Minimum = GCAD.AABB3d.Minimum
local GCAD_AABB3d_Maximum = GCAD.AABB3d.Maximum

function self:Minimize () return GCAD_AABB3d_Minimum (self) end
function self:Maximize () return GCAD_AABB3d_Maximum (self) end

-- Copying
self.Clone                       = GCAD.AABB3d.Clone
self.Copy                        = GCAD.AABB3d.Copy

-- Equality
self.Equals                      = GCAD.AABB3d.Equals
self.__eq                        = GCAD.AABB3d.Equals

-- NaN
self.ContainsNaN                 = GCAD.AABB3d.ContainsNaN

-- AABB properties
self.GetMin                      = GCAD.AABB3d.GetMin
self.GetMax                      = GCAD.AABB3d.GetMax

self.GetMinNative                = GCAD.AABB3d.GetMinNative
self.GetMaxNative                = GCAD.AABB3d.GetMaxNative

self.GetMinUnpacked              = GCAD.AABB3d.GetMinUnpacked
self.GetMaxUnpacked              = GCAD.AABB3d.GetMaxUnpacked

self.SetMin                      = GCAD.AABB3d.SetMin
self.SetMax                      = GCAD.AABB3d.SetMax

self.SetMinNative                = GCAD.AABB3d.SetMinNative
self.SetMaxNative                = GCAD.AABB3d.SetMaxNative

self.SetMinUnpacked              = GCAD.AABB3d.SetMinUnpacked
self.SetMaxUnpacked              = GCAD.AABB3d.SetMaxUnpacked

-- AABB size
self.IsEmpty                     = GCAD.AABB3d.IsEmpty
self.Volume                      = GCAD.AABB3d.Volume

-- AABB corner queries
self.GetCorner                   = GCAD.AABB3d.GetCorner
self.GetCornerUnpacked           = GCAD.AABB3d.GetCornerUnpacked
self.GetCornerEnumerator         = GCAD.AABB3d.GetCornerEnumerator
self.GetVertex                   = GCAD.AABB3d.GetVertex
self.GetVertexUnpacked           = GCAD.AABB3d.GetVertexUnpacked
self.GetVertexEnumerator         = GCAD.AABB3d.GetVertexEnumerator
self.GetEdgeEnumerator           = GCAD.AABB3d.GetEdgeEnumerator
self.GetOppositeCorner           = GCAD.AABB3d.GetOppositeCorner
self.GetOppositeCornerId         = GCAD.AABB3d.GetOppositeCornerId
self.GetExtremeCorner            = GCAD.AABB3d.GetExtremeCorner
self.GetExtremeCornerId          = GCAD.AABB3d.GetExtremeCornerId
self.GetExtremeCornerIdUnpacked  = GCAD.AABB3d.GetExtremeCornerIdUnpacked
self.GetExtremeCornerIds         = GCAD.AABB3d.GetExtremeCornerIds
self.GetExtremeCornerIdsUnpacked = GCAD.AABB3d.GetExtremeCornerIdsUnpacked

-- AABB operations
self.Expand                      = GCAD.AABB3d.Expand
self.ExpandUnpacked              = GCAD.AABB3d.ExpandUnpacked
self.Intersect                   = GCAD.AABB3d.Intersect
self.Union                       = GCAD.AABB3d.Union

-- Intersection tests
-- Point
self.ContainsPoint               = GCAD.AABB3d.ContainsPoint
self.ContainsNativePoint         = GCAD.AABB3d.ContainsNativePoint
self.ContainsUnpackedPoint       = GCAD.AABB3d.ContainsUnpackedPoint
self.ContainsPoint3              = GCAD.AABB3d.ContainsPoint3
self.ContainsNativePoint3        = GCAD.AABB3d.ContainsNativePoint3
self.ContainsUnpackedPoint3      = GCAD.AABB3d.ContainsUnpackedPoint3

-- Line
self.IntersectsLine              = GCAD.AABB3d.IntersectsLine
self.IntersectLine               = GCAD.AABB3d.IntersectLine

-- AABB
self.ContainsAABB                = GCAD.AABB3d.ContainsAABB
self.IntersectAABB               = GCAD.AABB3d.IntersectAABB
self.IntersectsAABB              = GCAD.AABB3d.IntersectsAABB

-- Conversion
self.ToNativeAABB3d              = GCAD.AABB3d.ToNativeAABB3d
self.ToRange3d                   = GCAD.AABB3d.ToRange3d

-- Utility
self.Unpack                      = GCAD.AABB3d.Unpack
self.ToString                    = GCAD.AABB3d.ToString
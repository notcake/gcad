local self = {}
GCAD.Plane2d = GCAD.MakeConstructor (self)

local GCAD_Vector2d_Clone       = GCAD.Vector2d.Clone
local GCAD_Vector2d_Dot         = GCAD.Vector2d.Dot
local GCAD_Vector2d_Length      = GCAD.Vector2d.Length
local GCAD_UnpackedVector2d_Dot = GCAD.UnpackedVector2d.Dot

function GCAD.Plane2d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.Plane2d ()
	
	-- ax + by + c = 0
	-- d = -normal . position
	out [1] = normal [1]
	out [2] = normal [2]
	out [3] = -GCAD_Vector2d_Dot (position, normal)
	
	return out
end

-- Copying
function GCAD.Plane2d.Clone (self, out)
	out = out or GCAD.Plane2d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function GCAD.Plane2d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	
	return self
end

-- Plane properties
function GCAD.Plane2d.GetNormal (self, out)
	return GCAD_Vector2d_Clone (self, out)
end

function GCAD.Plane2d.GetNormalUnpacked (self)
	return self [1], self [2]
end

function GCAD.Plane2d.GetNormalLength (self)
	return GCAD_Vector2d_Length (self)
end

function GCAD.Plane2d.SetNormal (self, normal)
	self [1] = normal [1]
	self [2] = normal [2]
	
	return self
end

function GCAD.Plane2d.SetNormalUnpacked (self, x, y)
	self [1] = x
	self [2] = y
	
	return self
end

-- Plane operations
local GCAD_Plane2d_GetNormalLength = GCAD.Plane2d.GetNormalLength

function GCAD.Plane2d.Flip (self, out)
	out [1] = -self [1]
	out [2] = -self [2]
	out [3] = -self [3]
	
	return out
end

function GCAD.Plane2d.Normalize (self, out)
	out = out or GCAD.Plane2d ()
	
	local length = GCAD_Plane2d_GetNormalLength (self)
	out [1] = self [1] / length
	out [2] = self [2] / length
	out [3] = self [3] / length
	
	return out
end

-- Plane queries
local GCAD_Plane2d_GetNormalLength = GCAD.Plane2d.GetNormalLength

function GCAD.Plane2d.DistanceToPoint (self, v2d)
	return (GCAD_Vector2d_Dot (self, v2d) + self [3]) / GCAD_Plane2d_GetNormalLength (self)
end

function GCAD.Plane2d.DistanceToUnpackedPoint (self, x, y)
	return (GCAD_UnpackedVector2d_Dot (self [1], self [2], x, y) + self [3]) / GCAD_Plane2d_GetNormalLength (self)
end

function GCAD.Plane2d.ScaledDistanceToPoint (self, v2d)
	return GCAD_Vector2d_Dot (self, v2d) + self [3]
end

function GCAD.Plane2d.ScaledDistanceToUnpackedPoint (self, x, y)
	return GCAD_UnpackedVector2d_Dot (self [1], self [2], x, y) + self [3]
end

-- Intersection tests
local GCAD_Plane2d_DistanceToPoint               = GCAD.Plane2d.DistanceToPoint
local GCAD_Plane2d_DistanceToUnpackedPoint       = GCAD.Plane2d.DistanceToUnpackedPoint
local GCAD_Plane2d_ScaledDistanceToPoint         = GCAD.Plane2d.ScaledDistanceToPoint
local GCAD_Plane2d_ScaledDistanceToUnpackedPoint = GCAD.Plane2d.ScaledDistanceToUnpackedPoint

function GCAD.Plane2d.ContainsPoint (self, v2d)
	return GCAD_Plane2d_ScaledDistanceToPoint (self, v2d) < 0
end

function GCAD.Plane2d.ContainsUnpackedPoint (self, x, y)
	return GCAD_Plane2d_ScaledDistanceToUnpackedPoint (self, x, y) < 0
end

function GCAD.Plane2d.ContainsCircle (self, circle2d)
	local distance = GCAD_Plane2d_DistanceToPoint (self, circle2d)
	return distance + circle2d [3] < 0
end

function GCAD.Plane2d.ContainsUnpackedCircle (self, x, y, r)
	local distance = GCAD_Plane2d_DistanceToUnpackedPoint (self, x, y)
	return distance + r < 0
end

function GCAD.Plane2d.IntersectsCircle (self, circle2d)
	local distance = GCAD_Plane2d_DistanceToPoint (self, circle2d)
	local circleRadius = circle2d [3]
	if distance + circleRadius < 0 then return true, true  end -- circle lies within this plane
	if distance - circleRadius < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.Plane2d.IntersectsUnpackedCircle (self, x, y, r)
	local distance = GCAD_Plane2d_DistanceToUnpackedPoint (self, x, y)
	if distance + r < 0 then return true, true  end -- circle lies within this plane
	if distance - r < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

local GCAD_Plane2d_ContainsUnpackedPoint = GCAD.Plane2d.ContainsUnpackedPoint

function GCAD.Plane2d.ContainsAABB (self, aabb2d)
	local farCornerId, nearCornerId = aabb2d:GetExtremeCornerIds (self)
	
	return GCAD_Plane2d_ContainsUnpackedPoint (self, aabb2d:GetCornerUnpacked (farCornerId))
end

function GCAD.Plane2d.IntersectsAABB (self, aabb2d)
	local farCornerId, nearCornerId = aabb2d:GetExtremeCornerIds (self)
	
	return GCAD_Plane2d_ContainsUnpackedPoint (self, aabb2d:GetCornerUnpacked (nearCornerId))
end

GCAD.Plane2d.ContainsOBB   = GCAD.Plane2d.ContainsAABB
GCAD.Plane2d.IntersectsOBB = GCAD.Plane2d.IntersectsAABB

-- Conversion
function GCAD.Plane2d.FromLine2d (line, out)
	out = out or GCAD.Plane2d ()
	
	local a, b = line:GetDirectionUnpacked ()
	a, b = -b, a
	
	out [1] = a
	out [2] = b
	out [3] = -GCAD_UnpackedVector2d_Dot (a, b, line:GetPositionUnpacked ())
	
	return out
end

function GCAD.Plane2d.ToLine2d (self, out)
	out = out or GCAD.Line2d ()
	
	out:SetDirectionUnpacked (-self [2], self [1])
	out:SetPositionUnpacked (-self [3] * self [1], -self [3] * self [2])
	
	return out
end

-- Utility
function GCAD.Plane2d.Unpack (self)
	return self [1], self [2], self [3]
end

function GCAD.Plane2d.ToString (self)
	return "Plane [(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. "), " .. tostring (self [3]) .. "]"
end

-- Construction
function GCAD.Plane2d.Minimum (out)
	out = out or GCAD.Plane2d (1, 0)
	
	out [3] = math.huge
	
	return out
end

function GCAD.Plane2d.Maximum (out)
	out = out or GCAD.Plane2d (1, 0)
	
	out [3] = -math.huge
	
	return out
end

function self:ctor (a, b, c)
	self [1] = a or 0
	self [2] = b or 0
	self [3] = c or 0
end

-- Initialization
function self:Set (a, b, c)
	self [1] = a
	self [2] = b
	self [3] = c
	
	return self
end

local GCAD_Plane2d_Minimum = GCAD.Plane2d.Minimum
local GCAD_Plane2d_Maximum = GCAD.Plane2d.Maximum

function self:Minimize () return GCAD_Plane2d_Minimum (self) end
function self:Maximize () return GCAD_Plane2d_Maximum (self) end

-- Copying
self.Clone                         = GCAD.Plane2d.Clone
self.Copy                          = GCAD.Plane2d.Copy

-- Plane properties
self.GetNormal                     = GCAD.Plane2d.GetNormal
self.GetNormalUnpacked             = GCAD.Plane2d.GetNormalUnpacked
self.GetNormalLength               = GCAD.Plane2d.GetNormalLength
self.SetNormal                     = GCAD.Plane2d.SetNormal
self.SetNormalUnpacked             = GCAD.Plane2d.SetNormalUnpacked

-- Plane operations
self.Flip                          = GCAD.Plane2d.Flip
self.Normalize                     = GCAD.Plane2d.Normalize

-- Plane queries
self.DistanceToPoint               = GCAD.Plane2d.DistanceToPoint
self.DistanceToUnpackedPoint       = GCAD.Plane2d.DistanceToUnpackedPoint
self.ScaledDistanceToPoint         = GCAD.Plane2d.ScaledDistanceToPoint
self.ScaledDistanceToUnpackedPoint = GCAD.Plane2d.ScaledDistanceToUnpackedPoint

-- Intersection tests
self.ContainsPoint                 = GCAD.Plane2d.ContainsPoint
self.ContainsUnpackedPoint         = GCAD.Plane2d.ContainsUnpackedPoint
self.ContainsCircle                = GCAD.Plane2d.ContainsCircle
self.ContainsUnpackedCircle        = GCAD.Plane2d.ContainsUnpackedCircle
self.IntersectsCircle              = GCAD.Plane2d.IntersectsCircle
self.IntersectsUnpackedCircle      = GCAD.Plane2d.IntersectsUnpackedCircle
self.ContainsAABB                  = GCAD.Plane2d.ContainsAABB
self.IntersectsAABB                = GCAD.Plane2d.IntersectsAABB
self.ContainsOBB                   = GCAD.Plane2d.ContainsOBB
self.IntersectsOBB                 = GCAD.Plane2d.IntersectsOBB

-- Conversion
self.ToLine2d                      = GCAD.Plane2d.ToLine2d

-- Utility
self.Unpack                        = GCAD.Plane2d.Unpack
self.ToString                      = GCAD.Plane2d.ToString
self.__tostring                    = GCAD.Plane2d.ToString
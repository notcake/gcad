local self = {}
GCAD.Circle2d = GCAD.MakeConstructor (self)

local GCAD_Vector2d_Clone              = GCAD.Vector2d.Clone
local GCAD_Vector2d_DistanceTo         = GCAD.Vector2d.DistanceTo
local GCAD_UnpackedVector2d_DistanceTo = GCAD.UnpackedVector2d.DistanceTo

function GCAD.Circle2d.FromPositionAndRadius (position, radius, out)
	out = out or GCAD.Circle2d ()
	
	out [1] = position [1]
	out [2] = position [2]
	out [3] = radius
	
	return out
end

-- Copying
function GCAD.Circle2d.Clone (self, out)
	out = out or GCAD.Circle2d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function GCAD.Circle2d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	
	return self
end

-- Circle properties
function GCAD.Circle2d.GetPosition (self, out)
	return GCAD_Vector2d_Clone (self, out)
end

function GCAD.Circle2d.GetPositionUnpacked (self)
	return self [1], self [2]
end

function GCAD.Circle2d.GetRadius (self)
	return self [3]
end

function GCAD.Circle2d.SetPosition (self, pos)
	self [1] = pos [1]
	self [2] = pos [2]
	
	return self
end

function GCAD.Circle2d.SetPositionUnpacked (self, x, y)
	self [1] = x
	self [2] = y
	
	return self
end

function GCAD.Circle2d.SetRadius (self, r)
	self [3] = r
	
	return self
end

-- Circle queries
function GCAD.Circle2d.DistanceToPoint (self, v2d)
	return GCAD_Vector2d_DistanceTo (self, v2d) - self [3]
end

function GCAD.Circle2d.DistanceToUnpackedPoint (self, x, y)
	return GCAD_UnpackedVector2d_DistanceTo (self [1], self [2], x, y) - self [3]
end

-- Intersection tests
-- Point
local GCAD_Circle2d_DistanceToPoint         = GCAD.Circle2d.DistanceToPoint
local GCAD_Circle2d_DistanceToUnpackedPoint = GCAD.Circle2d.DistanceToUnpackedPoint

function GCAD.Circle2d.ContainsPoint (self, v2d)
	return GCAD_Circle2d_DistanceToPoint (self, v2d) < 0
end

function GCAD.Circle2d.ContainsUnpackedPoint (self, x, y)
	return GCAD_Circle2d_DistanceToUnpackedPoint (self, x, y) < 0
end

-- Circle
function GCAD.Circle2d.ContainsCircle (self, circle2d)
	local distance = GCAD_Vector2d_DistanceTo (self, circle2d)
	return distance + circle2d [3] < self [3]
end

function GCAD.Circle2d.ContainsUnpackedCircle (self, x, y, r)
	local distance = GCAD_UnpackedVector2d_DistanceTo (self [1], self [2], x, y)
	return distance + r < self [3]
end

function GCAD.Circle2d.IntersectsCircle (self, circle2d)
	local distance = GCAD_Vector2d_DistanceTo (self, circle2d)
	local thisRadius   = self [3]
	local circleRadius = circle2d [3]
	if distance + circleRadius < thisRadius then return true, true  end -- circle lies within this circle
	if distance - circleRadius < thisRadius then return true, false end -- centre lies outside, but edge intersects this circle
	return false, false
end

function GCAD.Circle2d.IntersectsUnpackedCircle (self, x, y, r)
	local distance = GCAD_UnpackedVector2d_DistanceTo (self [1], self [2], x, y)
	local thisRadius = self [3]
	if distance + r < thisRadius then return true, true  end -- circle lies within this circle
	if distance - r < thisRadius then return true, false end -- centre lies outside, but edge intersects this circle
	return false, false
end

-- Utility
function GCAD.Circle2d.Unpack (self)
	return self [1], self [2], self [3]
end

function GCAD.Circle2d.ToString (self)
	return "Circle [(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. "), " .. tostring (self [3]) .. "]"
end

-- Construction
function GCAD.Circle2d.Minimum (out)
	out = out or GCAD.Circle2d ()
	
	out [3] = -math.huge
	
	return out
end

function GCAD.Circle2d.Maximum (out)
	out = out or GCAD.Circle2d ()
	
	out [3] = math.huge
	
	return out
end

function self:ctor (x, y, r)
	self [1] = x or 0
	self [2] = y or 0
	self [3] = r or 0
end

-- Initialization
function self:Set (x, y, r)
	self [1] = x
	self [2] = y
	self [3] = r
	
	return self
end

local GCAD_Circle2d_Minimum = GCAD.Circle2d.Minimum
local GCAD_Circle2d_Maximum = GCAD.Circle2d.Maximum

function self:Minimize () return GCAD_Circle2d_Minimum (self) end
function self:Maximize () return GCAD_Circle2d_Maximum (self) end

-- Copying
self.Clone                    = GCAD.Circle2d.Clone
self.Copy                     = GCAD.Circle2d.Copy

-- Circle properties
self.GetPosition              = GCAD.Circle2d.GetPosition
self.GetPositionUnpacked      = GCAD.Circle2d.GetPositionUnpacked
self.GetRadius                = GCAD.Circle2d.GetRadius
self.SetPosition              = GCAD.Circle2d.SetPosition
self.SetPositionUnpacked      = GCAD.Circle2d.SetPositionUnpacked
self.SetRadius                = GCAD.Circle2d.SetRadius

-- Circle queries
self.DistanceToPoint          = GCAD.Circle2d.DistanceToPoint
self.DistanceToUnpackedPoint  = GCAD.Circle2d.DistanceToUnpackedPoint

-- Intersection tests
-- Point
self.ContainsPoint            = GCAD.Circle2d.ContainsPoint
self.ContainsUnpackedPoint    = GCAD.Circle2d.ContainsUnpackedPoint

-- Circle
self.ContainsCircle           = GCAD.Circle2d.ContainsCircle
self.ContainsUnpackedCircle   = GCAD.Circle2d.ContainsUnpackedCircle
self.IntersectsCircle         = GCAD.Circle2d.IntersectsCircle
self.IntersectsUnpackedCircle = GCAD.Circle2d.IntersectsUnpackedCircle

-- Utility
self.Unpack                   = GCAD.Circle2d.Unpack
self.ToString                 = GCAD.Circle2d.ToString
self.__tostring               = GCAD.Circle2d.ToString
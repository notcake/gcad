local self = {}
GCAD.NormalizedPlane2d = GCAD.MakeConstructor (self)

local GCAD_Vector2d_Dot               = GCAD.Vector2d.Dot
local GCAD_Vector2d_Length            = GCAD.Vector2d.Length
local GCAD_UnpackedVector2d_Length    = GCAD.UnpackedVector2d.Length
local GCAD_UnpackedVector2d_Normalize = GCAD.UnpackedVector2d.Normalize

function GCAD.NormalizedPlane2d.FromPositionAndNormal (position, normal, out)
	out = out or GCAD.NormalizedPlane2d ()
	
	-- ax + by + c = 0
	-- c = -normal . position
	local length = GCAD_Vector2d_Length (normal)
	out [1] = normal [1] / length
	out [2] = normal [2] / length
	out [3] = -GCAD_Vector2d_Dot (position, normal) / length
	
	return out
end

-- Copying
GCAD.NormalizedPlane2d.Clone                         = GCAD.Plane2d.Clone
GCAD.NormalizedPlane2d.Copy                          = GCAD.Plane2d.Copy

-- Plane properties
GCAD.NormalizedPlane2d.GetNormal                     = GCAD.Plane2d.GetNormal
GCAD.NormalizedPlane2d.GetNormalUnpacked             = GCAD.Plane2d.GetNormalUnpacked
GCAD.NormalizedPlane2d.GetNormalLength               = GCAD.Plane2d.GetNormalLength

function GCAD.NormalizedPlane2d.SetNormal (self, normal)
	local length = GCAD_Vector2d_Length (normal)
	self [1] = normal [1] / length
	self [2] = normal [2] / length
	
	return self
end

function GCAD.NormalizedPlane2d.SetNormalUnpacked (self, x, y)
	local length = GCAD_UnpackedVector2d_Length (x, y)
	self [1] = x / length
	self [2] = y / length
	
	return self
end

-- Plane operations
GCAD.NormalizedPlane2d.Flip                          = GCAD.Plane2d.Flip
GCAD.NormalizedPlane2d.Normalize                     = GCAD.Plane2d.Normalize

-- Plane queries
GCAD.NormalizedPlane2d.DistanceToPoint               = GCAD.Plane2d.ScaledDistanceToPoint
GCAD.NormalizedPlane2d.DistanceToUnpackedPoint       = GCAD.Plane2d.ScaledDistanceToUnpackedPoint
GCAD.NormalizedPlane2d.ScaledDistanceToPoint         = GCAD.Plane2d.ScaledDistanceToPoint
GCAD.NormalizedPlane2d.ScaledDistanceToUnpackedPoint = GCAD.Plane2d.ScaledDistanceToUnpackedPoint

-- Intersection tests
local GCAD_NormalizedPlane2d_DistanceToPoint         = GCAD.NormalizedPlane2d.DistanceToPoint
local GCAD_NormalizedPlane2d_DistanceToUnpackedPoint = GCAD.NormalizedPlane2d.DistanceToUnpackedPoint

GCAD.NormalizedPlane2d.ContainsPoint                 = GCAD.Plane2d.ContainsPoint
GCAD.NormalizedPlane2d.ContainsUnpackedPoint         = GCAD.Plane2d.ContainsUnpackedPoint

function GCAD.NormalizedPlane2d.ContainsCircle (self, circle2d)
	local distance = GCAD_NormalizedPlane2d_DistanceToPoint (self, circle2d)
	return distance + circle2d [3] < 0
end

function GCAD.NormalizedPlane2d.ContainsUnpackedCircle (self, x, y, r)
	local distance = GCAD_NormalizedPlane2d_DistanceToUnpackedPoint (self, x, y)
	return distance + r < 0
end

function GCAD.NormalizedPlane2d.IntersectsCircle (self, circle2d)
	local distance = GCAD_NormalizedPlane2d_DistanceToPoint (self, circle2d)
	local circleRadius = circle2d [3]
	if distance + circleRadius < 0 then return true, true  end -- circle lies within this plane
	if distance - circleRadius < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

function GCAD.NormalizedPlane2d.IntersectsUnpackedCircle (self, x, y, r)
	local distance = GCAD_NormalizedPlane2d_DistanceToUnpackedPoint (self, x, y)
	if distance + r < 0 then return true, true  end -- circle lies within this plane
	if distance - r < 0 then return true, false end -- circle centre lies outside, but surface intersects this plane
	return false, false
end

-- Conversion
function GCAD.NormalizedPlane2d.FromLine2d (line, out)
	out = out or GCAD.NormalizedPlane2d ()
	
	local a, b = line:GetDirectionUnpacked ()
	a, b = GCAD_UnpackedVector2d_Normalize (-b, a)
	
	out [1] = a
	out [2] = b
	out [3] = -GCAD_UnpackedVector2d_Dot (a, b, line:GetPositionUnpacked ())
	
	return out
end

GCAD.NormalizedPlane2d.ToLine2d                      = GCAD.Plane2d.ToLine2d

-- Utility
GCAD.NormalizedPlane2d.Unpack                        = GCAD.Plane2d.Unpack
GCAD.NormalizedPlane2d.ToString                      = GCAD.Plane2d.ToString

-- Construction
GCAD.NormalizedPlane2d.Minimum                       = GCAD.Plane2d.Minimum
GCAD.NormalizedPlane2d.Maximum                       = GCAD.Plane2d.Maximum

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

local GCAD_NormalizedPlane2d_Minimum = GCAD.NormalizedPlane2d.Minimum
local GCAD_NormalizedPlane2d_Maximum = GCAD.NormalizedPlane2d.Maximum

function self:Minimize () return GCAD_NormalizedPlane2d_Minimum (self) end
function self:Maximize () return GCAD_NormalizedPlane2d_Maximum (self) end

-- Copying
self.Clone                         = GCAD.NormalizedPlane2d.Clone
self.Copy                          = GCAD.NormalizedPlane2d.Copy

-- Plane properties
self.GetNormal                     = GCAD.NormalizedPlane2d.GetNormal
self.GetNormalUnpacked             = GCAD.NormalizedPlane2d.GetNormalUnpacked
self.GetNormalLength               = GCAD.NormalizedPlane2d.GetNormalLength
self.SetNormal                     = GCAD.NormalizedPlane2d.SetNormal
self.SetNormalUnpacked             = GCAD.NormalizedPlane2d.SetNormalUnpacked

-- Plane operations
self.Flip                          = GCAD.NormalizedPlane2d.Flip
self.Normalize                     = GCAD.NormalizedPlane2d.Normalize

-- Plane queries
self.DistanceToPoint               = GCAD.NormalizedPlane2d.DistanceToPoint
self.DistanceToUnpackedPoint       = GCAD.NormalizedPlane2d.DistanceToUnpackedPoint
self.ScaledDistanceToPoint         = GCAD.NormalizedPlane2d.ScaledDistanceToPoint
self.ScaledDistanceToUnpackedPoint = GCAD.NormalizedPlane2d.ScaledDistanceToUnpackedPoint

-- Intersection tests
self.ContainsPoint                 = GCAD.NormalizedPlane2d.ContainsPoint
self.ContainsUnpackedPoint         = GCAD.NormalizedPlane2d.ContainsUnpackedPoint
self.ContainsCircle                = GCAD.NormalizedPlane2d.ContainsCircle
self.ContainsUnpackedCircle        = GCAD.NormalizedPlane2d.ContainsUnpackedCircle
self.IntersectsCircle              = GCAD.NormalizedPlane2d.IntersectsCircle
self.IntersectsUnpackedCircle      = GCAD.NormalizedPlane2d.IntersectsUnpackedCircle

-- Conversion
self.ToLine2d                      = GCAD.NormalizedPlane2d.ToLine2d

-- Utility
self.Unpack                        = GCAD.NormalizedPlane2d.Unpack
self.ToString                      = GCAD.NormalizedPlane2d.ToString
self.__tostring                    = GCAD.NormalizedPlane2d.ToString
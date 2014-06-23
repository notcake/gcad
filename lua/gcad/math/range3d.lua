local self = {}
GCAD.Range3d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_huge = math.huge
local math_min  = math.min
local math_max  = math.max

-- Copying
function GCAD.Range3d.Clone (self, out)
	out = out or GCAD.Range3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	out [5] = self [5]
	out [6] = self [6]
	
	return out
end

function GCAD.Range3d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	self [5] = source [5]
	self [6] = source [6]
	
	return self
end

-- Range size
function GCAD.Range3d.IsEmpty (self)
	return self [1] > self [2] or
	       self [3] > self [4] or
		   self [5] > self [6]
end

function GCAD.Range3d.Volume (self)
	return (self [2] - self [1]) * (self [4] - self [3]) * (self [6] - self [5])
end

-- Range operations
function GCAD.Range3d.Expand (self, v, out)
	out = out or self
	
	out [1] = math_min (self [1], v [1])
	out [2] = math_max (self [2], v [1])
	out [3] = math_min (self [3], v [2])
	out [4] = math_max (self [4], v [2])
	out [5] = math_min (self [5], v [3])
	out [6] = math_max (self [6], v [3])
	
	return out
end

function GCAD.Range3d.ExpandUnpacked (self, x, y, z, out)
	out = out or self
	
	out [1] = math_min (self [1], x)
	out [2] = math_max (self [2], x)
	out [3] = math_min (self [3], y)
	out [4] = math_max (self [4], y)
	out [5] = math_min (self [5], z)
	out [6] = math_max (self [6], z)
	
	return out
end

function GCAD.Range3d.Intersect (a, b, out)
	out = out or GCAD.Range3d ()
	
	out [1] = math_max (a [1], b [1])
	out [2] = math_min (a [2], b [2])
	out [3] = math_max (a [3], b [3])
	out [4] = math_min (a [4], b [4])
	out [5] = math_max (a [5], b [5])
	out [6] = math_min (a [6], b [6])
	
	return out
end

function GCAD.Range3d.Union (a, b, out)
	out = out or GCAD.Range3d ()
	
	out [1] = math_min (a [1], b [1])
	out [2] = math_max (a [2], b [2])
	out [3] = math_min (a [3], b [3])
	out [4] = math_max (a [4], b [4])
	out [5] = math_min (a [5], b [5])
	out [6] = math_max (a [6], b [6])
	
	return out
end

-- Range tests
function GCAD.Range3d.ContainsPoint (self, v)
	return self [1] <= v [1] and v [1] <= self [2] and
	       self [3] <= v [2] and v [2] <= self [4] and
	       self [5] <= v [3] and v [3] <= self [6]
end

function GCAD.Range3d.ContainsUnpackedPoint (self, x, y, z)
	return self [1] <= x and x <= self [2] and
	       self [3] <= y and y <= self [4] and
	       self [5] <= y and y <= self [6]
end

function GCAD.Range3d.ContainsRange (a, b)
	return a [1] <= b [1] and b [2] <= a [2] and
	       a [3] <= b [3] and b [4] <= a [4] and
	       a [5] <= b [5] and b [6] <= a [6]
end

local GCAD_Range3d_ContainsPoint         = GCAD.Range3d.ContainsPoint
local GCAD_Range3d_ContainsUnpackedPoint = GCAD.Range3d.ContainsUnpackedPoint
local GCAD_Range3d_ContainsRange         = GCAD.Range3d.ContainsRange

function GCAD.Range3d.Contains (self, b, ...)
	if isnumber (b) then
		return GCAD_Range3d_ContainsUnpackedPoint (self, b, ...)
	elseif #b == 3 then
		return GCAD_Range3d_ContainsPoint (self, b)
	elseif #b == 6 then
		return GCAD_Range3d_ContainsRange (self, b)
	end
end

function GCAD.Range3d.IntersectsRange (a, b)
	return math_max (a [1], b [1]) <= math_min (a [2], b [2]) and
	       math_max (a [3], b [3]) <= math_min (a [4], b [4]) and
	       math_max (a [5], b [5]) <= math_min (a [6], b [6])
end

-- Utility
function GCAD.Range3d.Unpack (self)
	return self [1], self [3], self [5], self [2], self [4], self [6]
end

function GCAD.Range3d.ToString (self)
	return "[(" .. tostring (self [1]) .. ", " .. tostring (self [3]) .. ", " .. tostring (self [5]) .. "), (" .. tostring (self [2]) .. ", " .. tostring (self [4]) .. ", " .. tostring (self [6]) .. ")]"
end

-- Construction
function GCAD.Range3d.Minimum (out)
	out = out or GCAD.Range3d ()
	
	out [1] =  math.huge
	out [2] = -math.huge
	out [3] =  math.huge
	out [4] = -math.huge
	out [5] =  math.huge
	out [6] = -math.huge
	
	return out
end

function GCAD.Range3d.Maximum (out)
	out = out or GCAD.Range3d ()
	
	out [1] = -math.huge
	out [2] =  math.huge
	out [3] = -math.huge
	out [4] =  math.huge
	out [5] = -math.huge
	out [6] =  math.huge
	
	return out
end

function self:ctor (x1, y1, z1, x2, y2, z2)
	self [1] = x1 or  math_huge
	self [2] = x2 or -math_huge
	self [3] = y1 or  math_huge
	self [4] = y2 or -math_huge
	self [5] = z1 or  math_huge
	self [6] = z2 or -math_huge
end

-- Initialization
function self:Set (x1, y1, z1, x2, y2, z3)
	self [1] = x1
	self [2] = x2
	self [3] = y1
	self [4] = y2
	self [5] = z1
	self [6] = z2
	
	return self
end

local GCAD_Range3d_Minimum = GCAD.Range3d.Minimum
local GCAD_Range3d_Maximum = GCAD.Range3d.Maximum

function self:Minimize () return GCAD_Range3d_Minimum (self) end
function self:Maximize () return GCAD_Range3d_Maximum (self) end

-- Copying
self.Clone                 = GCAD.Range3d.Clone
self.Copy                  = GCAD.Range3d.Copy

-- Range size
self.IsEmpty               = GCAD.Range3d.IsEmpty
self.Length                = GCAD.Range3d.Length

-- Range operations
self.Expand                = GCAD.Range3d.Expand
self.ExpandUnpacked        = GCAD.Range3d.ExpandUnpacked
self.Intersect             = GCAD.Range3d.Intersect
self.Union                 = GCAD.Range3d.Union

-- Range tests
self.ContainsPoint         = GCAD.Range3d.ContainsPoint
self.ContainsUnpackedPoint = GCAD.Range3d.ContainsUnpackedPoint
self.ContainsRange         = GCAD.Range3d.ContainsRange
self.Contains              = GCAD.Range3d.Contains
self.IntersectsRange       = GCAD.Range3d.IntersectsRange

-- Utility
self.Unpack                = GCAD.Range3d.Unpack
self.ToString              = GCAD.Range3d.ToString
self.__tostring            = GCAD.Range3d.ToString
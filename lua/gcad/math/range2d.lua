local self = {}
GCAD.Range2d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_huge = math.huge
local math_min  = math.min
local math_max  = math.max

-- Copying
function GCAD.Range2d.Clone (self, out)
	out = out or GCAD.Range2d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	
	return out
end

function GCAD.Range2d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	
	return self
end

-- Range size
function GCAD.Range2d.IsEmpty (self)
	return self [1] > self [2] or
	       self [3] > self [4]
end

function GCAD.Range2d.Area (self)
	return (self [2] - self [1]) * (self [4] - self [3])
end

-- Range operations
function GCAD.Range2d.Expand (self, v, out)
	out = out or self
	
	out [1] = math_min (self [1], v [1])
	out [2] = math_max (self [2], v [1])
	out [3] = math_min (self [3], v [2])
	out [4] = math_max (self [4], v [2])
	
	return out
end

function GCAD.Range2d.ExpandUnpacked (self, x, y, out)
	out = out or self
	
	out [1] = math_min (self [1], x)
	out [2] = math_max (self [2], x)
	out [3] = math_min (self [3], y)
	out [4] = math_max (self [4], y)
	
	return out
end

function GCAD.Range2d.Intersect (a, b, out)
	out = out or GCAD.Range2d ()
	
	out [1] = math_max (a [1], b [1])
	out [2] = math_min (a [2], b [2])
	out [3] = math_max (a [3], b [3])
	out [4] = math_min (a [4], b [4])
	
	return out
end

function GCAD.Range2d.Union (a, b, out)
	out = out or GCAD.Range2d ()
	
	out [1] = math_min (a [1], b [1])
	out [2] = math_max (a [2], b [2])
	out [3] = math_min (a [3], b [3])
	out [4] = math_max (a [4], b [4])
	
	return out
end

-- Range tests
function GCAD.Range2d.ContainsPoint (self, v)
	return self [1] <= v [1] and v [1] <= self [2] and
	       self [3] <= v [2] and v [2] <= self [4]
end

function GCAD.Range2d.ContainsUnpackedPoint (self, x, y)
	return self [1] <= x and x <= self [2] and
	       self [3] <= y and y <= self [4]
end

function GCAD.Range2d.ContainsRange (a, b)
	return a [1] <= b [1] and b [2] <= a [2] and
	       a [3] <= b [3] and b [4] <= a [4]
end

local GCAD_Range2d_ContainsPoint         = GCAD.Range2d.ContainsPoint
local GCAD_Range2d_ContainsUnpackedPoint = GCAD.Range2d.ContainsUnpackedPoint
local GCAD_Range2d_ContainsRange         = GCAD.Range2d.ContainsRange

function GCAD.Range2d.Contains (self, b, ...)
	if isnumber (b) then
		return GCAD_Range2d_ContainsUnpackedPoint (self, b, ...)
	elseif #b == 2 then
		return GCAD_Range2d_ContainsPoint (self, b)
	elseif #b == 4 then
		return GCAD_Range2d_ContainsRange (self, b)
	end
end

function GCAD.Range2d.IntersectsRange (a, b)
	return math_max (a [1], b [1]) <= math_min (a [2], b [2]) and
	       math_max (a [3], b [3]) <= math_min (a [4], b [4])
end

-- Utility
function GCAD.Range2d.Unpack (self)
	return self [1], self [3], self [2], self [4]
end

function GCAD.Range2d.ToString (self)
	return "[(" .. tostring (self [1]) .. ", " .. tostring (self [3]) .. "), (" .. tostring (self [2]) .. ", " .. tostring (self [4]) .. ")]"
end

-- Construction
function GCAD.Range2d.Minimum (out)
	out = out or GCAD.Range2d ()
	
	out [1] =  math.huge
	out [2] = -math.huge
	out [3] =  math.huge
	out [4] = -math.huge
	
	return out
end

function GCAD.Range2d.Maximum (out)
	out = out or GCAD.Range2d ()
	
	out [1] = -math.huge
	out [2] =  math.huge
	out [3] = -math.huge
	out [4] =  math.huge
	
	return out
end

function self:ctor (x1, y1, x2, y2)
	self [1] = x1 or  math_huge
	self [2] = x2 or -math_huge
	self [3] = y1 or  math_huge
	self [4] = y2 or -math_huge
end

-- Initialization
function self:Set (x1, y1, x2, y2)
	self [1] = x1
	self [2] = x2
	self [3] = y1
	self [4] = y2
	
	return self
end

local GCAD_Range2d_Minimum = GCAD.Range2d.Minimum
local GCAD_Range2d_Maximum = GCAD.Range2d.Maximum

function self:Minimize () return GCAD_Range2d_Minimum (self) end
function self:Maximize () return GCAD_Range2d_Maximum (self) end

-- Copying
self.Clone                 = GCAD.Range2d.Clone
self.Copy                  = GCAD.Range2d.Copy

-- Range size
self.IsEmpty               = GCAD.Range2d.IsEmpty
self.Length                = GCAD.Range2d.Length

-- Range operations
self.Expand                = GCAD.Range2d.Expand
self.ExpandUnpacked        = GCAD.Range2d.ExpandUnpacked
self.Intersect             = GCAD.Range2d.Intersect
self.Union                 = GCAD.Range2d.Union

-- Range tests
self.ContainsPoint         = GCAD.Range2d.ContainsPoint
self.ContainsUnpackedPoint = GCAD.Range2d.ContainsUnpackedPoint
self.ContainsRange         = GCAD.Range2d.ContainsRange
self.Contains              = GCAD.Range2d.Contains
self.IntersectsRange       = GCAD.Range2d.IntersectsRange

-- Utility
self.Unpack                = GCAD.Range2d.Unpack
self.ToString              = GCAD.Range2d.ToString
self.__tostring            = GCAD.Range2d.ToString
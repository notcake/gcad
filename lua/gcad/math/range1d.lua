local self = {}
GCAD.Range1d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_huge = math.huge
local math_min  = math.min
local math_max  = math.max

-- Copying
function GCAD.Range1d.Clone (self, out)
	out = out or GCAD.Range1d ()
	
	out [1] = self [1]
	out [2] = self [2]
	
	return out
end

function GCAD.Range1d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	
	return self
end

-- Range size
function GCAD.Range1d.IsEmpty (self)
	return self [1] >= self [2]
end

function GCAD.Range1d.Length (self)
	return self [2] - self [1]
end

-- Range operations
function GCAD.Range1d.Expand (self, v, out)
	out = out or self
	
	out [1] = math_min (self [1], v)
	out [2] = math_max (self [2], v)
	
	return out
end

function GCAD.Range1d.ExpandUnpacked (self, x, out)
	out = out or self
	
	out [1] = math_min (self [1], x)
	out [2] = math_max (self [2], x)
	
	return out
end

function GCAD.Range1d.Intersect (a, b, out)
	out = out or GCAD.Range1d ()
	
	out [1] = math_max (a [1], b [1])
	out [2] = math_min (a [2], b [2])
	
	return out
end

function GCAD.Range1d.IntersectTriple (a, b, c, out)
	out = out or GCAD.Range1d ()
	
	out [1] = math_max (a [1], b [1], c [1])
	out [2] = math_min (a [2], b [2], c [2])
	
	return out
end

function GCAD.Range1d.Union (a, b, out)
	out = out or GCAD.Range1d ()
	
	out [1] = math_min (a [1], b [1])
	out [2] = math_max (a [2], b [2])
	
	return out
end

-- Range tests
function GCAD.Range1d.ContainsPoint (self, v)
	return self [1] <= v and v <= self [2]
end

function GCAD.Range1d.ContainsUnpackedPoint (self, x)
	return self [1] <= x and x <= self [2]
end

function GCAD.Range1d.ContainsRange (a, b)
	return a [1] <= b [1] and b [2] <= a [2]
end

local GCAD_Range1d_ContainsPoint         = GCAD.Range1d.ContainsPoint
local GCAD_Range1d_ContainsUnpackedPoint = GCAD.Range1d.ContainsUnpackedPoint
local GCAD_Range1d_ContainsRange         = GCAD.Range1d.ContainsRange

function GCAD.Range1d.Contains (self, b, ...)
	if isnumber (b) then
		return GCAD_Range1d_ContainsUnpackedPoint (self, b, ...)
	elseif #b == 1 then
		return GCAD_Range1d_ContainsPoint (self, b)
	elseif #b == 2 then
		return GCAD_Range1d_ContainsRange (self, b)
	end
end

function GCAD.Range1d.IntersectsRange (a, b)
	return math_max (a [1], b [1]) <= math_min (a [2], b [2])
end

function GCAD.Range1d.IntersectsRangeTriple (a, b, c)
	return math_max (a [1], b [1], c [1]) <= math_min (a [2], b [2], c [2])
end

-- Utility
function GCAD.Range1d.Unpack (self)
	return self [1], self [2]
end

function GCAD.Range1d.ToString (self)
	return "[" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. "]"
end

-- Construction
function GCAD.Range1d.Minimum (out)
	out = out or GCAD.Range1d ()
	
	out [1] =  math.huge
	out [2] = -math.huge
	
	return out
end

function GCAD.Range1d.Maximum (out)
	out = out or GCAD.Range1d ()
	
	out [1] = -math.huge
	out [2] =  math.huge
	
	return out
end

function self:ctor (x1, x2)
	self [1] = x1 or  math_huge
	self [2] = x2 or -math_huge
end

-- Initialization
function self:Set (x1, x2)
	self [1] = x1
	self [2] = x2
	
	return self
end

local GCAD_Range1d_Minimum = GCAD.Range1d.Minimum
local GCAD_Range1d_Maximum = GCAD.Range1d.Maximum

function self:Minimize () return GCAD_Range1d_Minimum (self) end
function self:Maximize () return GCAD_Range1d_Maximum (self) end

-- Copying
self.Clone                 = GCAD.Range1d.Clone
self.Copy                  = GCAD.Range1d.Copy

-- Range size
self.IsEmpty               = GCAD.Range1d.IsEmpty
self.Length                = GCAD.Range1d.Length

-- Range operations
self.Expand                = GCAD.Range1d.Expand
self.ExpandUnpacked        = GCAD.Range1d.ExpandUnpacked
self.Intersect             = GCAD.Range1d.Intersect
self.IntersectTriple       = GCAD.Range1d.IntersectTriple
self.Union                 = GCAD.Range1d.Union

-- Range tests
self.ContainsPoint         = GCAD.Range1d.ContainsPoint
self.ContainsUnpackedPoint = GCAD.Range1d.ContainsUnpackedPoint
self.ContainsRange         = GCAD.Range1d.ContainsRange
self.Contains              = GCAD.Range1d.Contains
self.IntersectsRange       = GCAD.Range1d.IntersectsRange
self.IntersectsRangeTriple = GCAD.Range1d.IntersectsRangeTriple

-- Utility
self.Unpack                = GCAD.Range1d.Unpack
self.ToString              = GCAD.Range1d.ToString
self.__tostring            = GCAD.Range1d.ToString
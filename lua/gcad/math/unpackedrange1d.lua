GCAD.UnpackedRange1d = {}

local math      = math

local isnumber  = isnumber
local math_huge = math.huge
local math_min  = math.min
local math_max  = math.max

-- Range size
function GCAD.UnpackedRange1d.IsEmpty (x1, x2)
	return x1 >= x2
end

function GCAD.UnpackedRange1d.Length (x1, x2)
	return x2 - x1
end

-- Range operations
function GCAD.UnpackedRange1d.Expand (x1, x2, v)
	return math_min (x1, v), math_max (x2, v)
end

function GCAD.UnpackedRange1d.ExpandUnpacked (x1, x2, x)
	return math_min (x1, x), math_max (x2, x)
end

function GCAD.UnpackedRange1d.Intersect (ax1, ax2, bx1, bx2)
	return math_max (ax1, bx1), math_min (ax2, bx2)
end

function GCAD.UnpackedRange1d.Union (ax1, ax2, bx1, bx2)
	return math_min (ax1, bx1), math_max (ax2, bx2)
end

-- Range tests
function GCAD.UnpackedRange1d.ContainsPoint (x1, x2, v)
	return x1 <= v and v <= x2
end

function GCAD.UnpackedRange1d.ContainsUnpackedPoint (x1, x2, x)
	return x1 <= x and x <= x2
end

function GCAD.UnpackedRange1d.ContainsRange (ax1, ax2, bx1, bx2)
	return ax1 <= bx1 and bx2 <= ax2
end

function GCAD.UnpackedRange1d.IntersectsRange (ax1, ax2, bx1, bx2)
	return math_max (ax1, bx1) <= math_min (ax2, bx2)
end
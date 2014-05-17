GCAD.UnpackedRange2d = {}

local math      = math

local isnumber  = isnumber
local math_huge = math.huge
local math_min  = math.min
local math_max  = math.max

-- Range size
function GCAD.UnpackedRange2d.IsEmpty (x1, y1, x2, y2)
	return x1 >= x2 or
	       y1 >= y2
end

function GCAD.UnpackedRange2d.Length (x1, y1, x2, y2)
	return (x2 - x1) * (y2 - y1)
end

-- Range operations
function GCAD.UnpackedRange2d.Expand (x1, y1, x2, y2, v)
	return math_min (x1, v [1]), math_min (y1, v [2]),
	       math_max (x2, v [1]), math_max (y2, v [2])
end

function GCAD.UnpackedRange2d.ExpandUnpacked (x1, y1, x2, y2, x, y)
	return math_min (x1, x), math_min (y1, y),
	       math_max (x2, x), math_max (y2, y)
end

function GCAD.UnpackedRange2d.Intersect (ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
	return math_max (ax1, bx1), math_max (ay1, by1),
	       math_min (ax2, bx2), math_min (ay2, by2)
end

function GCAD.UnpackedRange2d.Union (ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
	return math_min (ax1, bx1), math_min (ay1, by1),
	       math_max (ax2, bx2), math_max (ay2, by2)
end

-- Range tests
function GCAD.UnpackedRange2d.ContainsPoint (x1, y1, x2, y2, v)
	return x1 <= v [1] and v [1] <= x2 and
	       y1 <= v [2] and v [2] <= y2
end

function GCAD.UnpackedRange2d.ContainsUnpackedPoint (x1, y1, x2, y2, x, y)
	return x1 <= x and x <= x2 and
	       y1 <= y and y <= y2
end

function GCAD.UnpackedRange2d.ContainsRange (ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
	return ax1 <= bx1 and bx2 <= ax2 and
	       ay1 <= by1 and ay2 <= by2
end

function GCAD.UnpackedRange2d.IntersectsRange (ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
	return math_max (ax1, bx1) <= math_min (ax2, bx2) and
	       math_max (ay1, by1) <= math_min (ay2, by2)
end

-- Utility
function GCAD.UnpackedRange2d.ToString (x1, y1, x2, y2)
	return "[(" .. tostring (x1) .. ", " .. tostring (y1) .. "), (" .. tostring (x2) .. ", " .. tostring (y2) .. ")]"
end

-- Construction
function GCAD.UnpackedRange2d.Minimum ()
	return math.huge, math.huge, -math.huge, -math.huge
end

function GCAD.UnpackedRange2d.Maximum ()
	return -math.huge, -math.huge, math.huge, math.huge
end
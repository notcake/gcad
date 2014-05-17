GCAD.UnpackedRange3d = {}

local math      = math

local isnumber  = isnumber
local math_huge = math.huge
local math_min  = math.min
local math_max  = math.max

-- Range size
function GCAD.UnpackedRange3d.IsEmpty (x1, y1, z1, x2, y2, z2)
	return x1 >= x2 or
	       y1 >= y2 or
		   z1 >= z2
end

function GCAD.UnpackedRange3d.Length (x1, y1, z1, x2, y2, z2)
	return (x2 - x1) * (y2 - y1) * (z2 - z1)
end

-- Range operations
function GCAD.UnpackedRange3d.Expand (x1, y1, z1, x2, y2, z2, v)
	return math_min (x1, v [1]), math_min (y1, v [2]), math_min (z1, v [3]),
	       math_max (x2, v [1]), math_max (y2, v [2]), math_max (z2, v [3])
end

function GCAD.UnpackedRange3d.ExpandUnpacked (x1, y1, z1, x2, y2, z3, x, y, z)
	return math_min (x1, x), math_min (y1, y), math_min (z1, z),
	       math_max (x2, x), math_max (y2, y), math_max (z2, z)
end

function GCAD.UnpackedRange3d.Intersect (ax1, ay1, az1, ax2, ay2, az2, bx1, by1, bz1, bx2, by2, bz2)
	return math_max (ax1, bx1), math_max (ay1, by1), math_max (az1, bz1),
	       math_min (ax2, bx2), math_min (ay2, by2), math_min (az2, bz2)
end

function GCAD.UnpackedRange3d.Union (ax1, ay1, az1, ax2, ay2, az2, bx1, by1, bz1, bx2, by2, bz2)
	return math_min (ax1, bx1), math_min (ay1, by1), math_min (az1, bz1),
	       math_max (ax2, bx2), math_max (ay2, by2), math_max (az2, bz2)
end

-- Range tests
function GCAD.UnpackedRange3d.ContainsPoint (x1, y1, z1, x2, y2, z2, v)
	return x1 <= v [1] and v [1] <= x2 and
	       y1 <= v [2] and v [2] <= y2 and
		   z1 <= v [3] and v [3] <= z2
end

function GCAD.UnpackedRange3d.ContainsUnpackedPoint (x1, y1, z1, x2, y2, z3, x, y, z)
	return x1 <= x and x <= x2 and
	       y1 <= y and y <= y2 and
		   z1 <= z and z <= z2
end

function GCAD.UnpackedRange3d.ContainsRange (ax1, ay1, az1, ax2, ay2, az2, bx1, by1, bz1, bx2, by2, bz2)
	return ax1 <= bx1 and bx2 <= ax2 and
	       ay1 <= by1 and ay2 <= by2 and
		   az1 <= bz1 and az2 <= bz2
end

function GCAD.UnpackedRange3d.IntersectsRange (ax1, ay1, az1, ax2, ay2, az2, bx1, by1, bz1, bx2, by2, bz2)
	return math_max (ax1, bx1) <= math_min (ax2, bx2) and
	       math_max (ay1, by1) <= math_min (ay2, by2) and
		   math_max (az1, bz1) <= math_min (az2, bz2)
end

-- Utility
function GCAD.UnpackedRange3d.ToString (x1, y1, z1, x2, y2, z2)
	return "[(" .. tostring (x1) .. ", " .. tostring (y1) .. ", " .. tostring (z1) .. "), (" .. tostring (x2) .. ", " .. tostring (y2) .. ", " .. tostring (z2) .. ")]"
end

-- Construction
function GCAD.UnpackedRange3d.Minimum ()
	return math.huge, math.huge, math.huge, -math.huge, -math.huge, -math.huge
end

function GCAD.UnpackedRange3d.Maximum ()
	return -math.huge, -math.huge, -math.huge, math.huge, math.huge, math.huge
end
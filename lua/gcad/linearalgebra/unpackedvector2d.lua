GCAD.UnpackedVector2d = {}

local math      = math

local math_abs  = math.abs
local math_sqrt = math.sqrt

-- Equality
function GCAD.UnpackedVector2d.Equals (x1, y1, x2, y2)
	return x1 == x2 and
	       y1 == y2
end

-- NaN
function GCAD.UnpackedVector2d.ContainsNaN (x, y)
	return x ~= x or
	       y ~= y
end

-- Vector products
function GCAD.UnpackedVector2d.Cross (x1, y1, x2, y2)
	return x1 * y2 - y1 * x2
end

function GCAD.UnpackedVector2d.Dot (x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

GCAD.UnpackedVector2d.InnerProduct = GCAD.UnpackedVector2d.Dot

function GCAD.UnpackedVector2d.OuterProduct (x1, y1, x2, y2, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = x1 * x2, x1 * y2
	out [3], out [4] = y1 * x2, y1 * y2
	
	return out
end

-- Vector norms
function GCAD.UnpackedVector2d.L1Norm (x, y)
	return math_abs (x) + math_abs (y)
end

function GCAD.UnpackedVector2d.L2Norm (x, y)
	return math_sqrt (x * x + y * y)
end

function GCAD.UnpackedVector2d.L2NormSquared (x, y)
	return x * x + y * y
end

GCAD.UnpackedVector2d.Length        = GCAD.UnpackedVector2d.L2Norm
GCAD.UnpackedVector2d.LengthSquared = GCAD.UnpackedVector2d.L2NormSquared

-- Vector operations
local GCAD_UnpackedVector2d_Length = GCAD.UnpackedVector2d.Length

function GCAD.UnpackedVector2d.Normalize (x, y)
	local length = GCAD_UnpackedVector2d_Length (x, y)
	return x / length, y / length
end

-- Vector queries
function GCAD.UnpackedVector2d.DistanceTo (x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math_sqrt (dx * dx + dy * dy)
end

function GCAD.UnpackedVector2d.DistanceToSquared (x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return dx * dx + dy * dy
end

-- Vector arithmetic
function GCAD.UnpackedVector2d.Add (x1, y1, x2, y2)
	return x1 + x2, y1 + y2
end

function GCAD.UnpackedVector2d.Subtract (x1, y1, x2, y2)
	return x1 - x2, y1 - y2
end

function GCAD.UnpackedVector2d.ScalarVectorMultiply (k, x, y)
	return k * x, k * y
end

function GCAD.UnpackedVector2d.VectorScalarMultiply (x, y, k)
	return x * k, y * k
end

function GCAD.UnpackedVector2d.ScalarDivide (x, y, k)
	return x / k, y / k
end

function GCAD.UnpackedVector2d.Negate (x, y)
	return -x, -y
end

-- Utility
function GCAD.UnpackedVector2d.ToString (x, y)
	return "(" .. tostring (x) .. ", " .. tostring (y) .. ")"
end

function GCAD.UnpackedVector2d.Origin () return 0, 0 end
function GCAD.UnpackedVector2d.Zero   () return 0, 0 end
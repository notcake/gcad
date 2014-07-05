local self = {}
GCAD.UnpackedVector4d = GCAD.MakeConstructor (self)

local math      = math

local math_abs  = math.abs
local math_sqrt = math.sqrt

local Vector            = Vector

local Vector___index    = debug.getregistry ().Vector.__index
local Vector___newindex = debug.getregistry ().Vector.__newindex

-- Equality
function GCAD.UnpackedVector4d.Equals (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 == x2 and
	       y1 == y2 and
	       z1 == z2 and
	       w1 == w2
end

-- Vector products
function GCAD.UnpackedVector4d.Dot (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2
end

GCAD.UnpackedVector4d.InnerProduct = GCAD.UnpackedVector4d.Dot

function GCAD.UnpackedVector4d.OuterProduct (x1, y1, z1, w1, x2, y2, z2, w2, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = x1 * x2, x1 * y2, x1 * z2, x1 * w2
	out [ 5], out [ 6], out [ 7], out [ 8] = y1 * x2, y1 * y2, y1 * z2, y1 * w2
	out [ 9], out [10], out [11], out [12] = z1 * x2, z1 * y2, z1 * z2, z1 * w2
	out [13], out [14], out [15], out [16] = w1 * x2, w1 * y2, w1 * z2, w1 * w2
	
	return out
end

-- Vector norms
function GCAD.UnpackedVector4d.L1Norm (x, y, z, w)
	return math_abs (x) + math_abs (y) + math_abs (z) + math_abs (w)
end

function GCAD.UnpackedVector4d.L2Norm (x, y, z, w)
	return math_sqrt (x * x + y * y + z * z + w * w)
end

function GCAD.UnpackedVector4d.L2NormSquared (x, y, z, w)
	return x * x + y * y + z * z + w * w
end

GCAD.UnpackedVector4d.Length        = GCAD.UnpackedVector4d.L2Norm
GCAD.UnpackedVector4d.LengthSquared = GCAD.UnpackedVector4d.L2NormSquared

-- Vector operations
local GCAD_UnpackedVector4d_Length = GCAD.UnpackedVector4d.Length

function GCAD.UnpackedVector4d.Normalize (x, y, z, w)
	local length = GCAD_UnpackedVector4d_Length (x, y, z, w)
	return x / length, y / length, z / length, w / length
end

-- Vector queries
function GCAD.UnpackedVector4d.DistanceTo (x1, y1, z1, w1, x2, y2, z2, w2)
	local dx = x1 - x2
	local dy = y1 - y2
	local dz = z1 - z2
	local dw = w1 - w2
	return math_sqrt (dx * dx + dy * dy + dz * dz + dw * dw)
end

function GCAD.UnpackedVector4d.DistanceToSquared (x1, y1, z1, w1, x2, y2, z2, w2)
	local dx = x1 - x2
	local dy = y1 - y2
	local dw = w1 - w2
	return dx * dx + dy * dy + dz * dz + dw * dw
end

-- Vector arithmetic
function GCAD.UnpackedVector4d.Add (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 + x2, y1 + y2, z1 + z2, w1 + w2
end

function GCAD.UnpackedVector4d.Subtract (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 - x2, y1 - y2, z1 - z2, w1 - w2
end

function GCAD.UnpackedVector4d.ScalarVectorMultiply (k, x, y, z, w)
	return k * x, k * y, k * z, k * z
end

function GCAD.UnpackedVector4d.VectorScalarMultiply (x, y, z, w, k)
	return x * k, y * k, z * k, w * k
end

function GCAD.UnpackedVector4d.ScalarDivide (x, y, z, w, k)
	return x / k, y / k, z / k, w / k
end

function GCAD.UnpackedVector4d.Negate (x, y, z, w)
	return -x, -y, -z, -w
end

-- Conversion
function GCAD.UnpackedVector4d.FromNativeVector (v, w)
	w = w or 0
	return Vector___index (v, "x"), Vector___index (v, "y"), Vector___index (v, "z")
end

function GCAD.UnpackedVector4d.ToNativeVector (x, y, z, w, out)
	out = out or Vector ()
	
	Vector___newindex (out, "x", x)
	Vector___newindex (out, "y", y)
	Vector___newindex (out, "z", z)
	
	return out, w
end

-- Utility
function GCAD.UnpackedVector4d.ToString (x, y, z, w)
	return "(" .. tostring (x) .. ", " .. tostring (y) .. ", " .. tostring (z) .. ", " .. tostring (w) .. ")"
end

function GCAD.UnpackedVector4d.Origin () return 0, 0, 0, 0 end
function GCAD.UnpackedVector4d.Zero   () return 0, 0, 0, 0 end
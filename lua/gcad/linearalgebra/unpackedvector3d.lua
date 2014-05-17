local self = {}
GCAD.UnpackedVector3d = GCAD.MakeConstructor (self)

local math      = math

local math_abs  = math.abs
local math_sqrt = math.sqrt

local Vector            = Vector

local Vector___index    = debug.getregistry ().Vector.__index
local Vector___newindex = debug.getregistry ().Vector.__newindex

-- Vector products
function GCAD.UnpackedVector3d.Cross (x1, y1, z1, x2, y2, z2)
	return y1 * z2 - z1 * y2,
	       z1 * x2 - x1 * z2,
	       x1 * y2 - y1 * x2
end

function GCAD.UnpackedVector3d.Dot (x1, y1, z1, x2, y2, z2)
	return x1 * x2 + y1 * y2 + z1 * z2
end

GCAD.UnpackedVector3d.InnerProduct = GCAD.UnpackedVector3d.Dot

function GCAD.UnpackedVector3d.OuterProduct (x1, y1, z1, x2, y2, z2, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = x1 * x2
	out [2] = x1 * y2
	out [3] = x1 * z2
	out [4] = y1 * x2
	out [5] = y1 * y2
	out [6] = y1 * z2
	out [7] = z1 * x2
	out [8] = z1 * y2
	out [9] = z1 * z2
	
	return out
end

-- Vector norms
function GCAD.UnpackedVector3d.L1Norm (x, y, z)
	return math_abs (x) + math_abs (y) + math_abs (z)
end

function GCAD.UnpackedVector3d.L2Norm (x, y, z)
	return math_sqrt (x * x + y * y + z * z)
end

function GCAD.UnpackedVector3d.L2NormSquared (x, y, z)
	return x * x + y * y + z * z
end

GCAD.UnpackedVector3d.Length        = GCAD.UnpackedVector3d.L2Norm
GCAD.UnpackedVector3d.LengthSquared = GCAD.UnpackedVector3d.L2NormSquared

-- Vector operations
local GCAD_UnpackedVector3d_Length = GCAD.UnpackedVector3d.Length

function GCAD.UnpackedVector3d.Normalize (x, y, z)
	local length = GCAD_UnpackedVector3d_Length (x, y, z)
	return x / length, y / length, z / length
end

-- Vector arithmetic
function GCAD.UnpackedVector3d.Add (x1, y1, z1, x2, y2, z2)
	return x1 + x2, y1 + y2, z1 + z2
end

function GCAD.UnpackedVector3d.Subtract (x1, y1, z1, x2, y2, z2)
	return x1 - x2, y1 - y2, z1 - z2
end

function GCAD.UnpackedVector3d.ScalarVectorMultiply (k, x, y, z)
	return k * x, k * y, k * z
end

function GCAD.UnpackedVector3d.VectorScalarMultiply (x, y, z, k)
	return x * k, y * k, z * k
end

function GCAD.UnpackedVector3d.ScalarDivide (x, y, z, k)
	return x / k, y / k, z / k
end

function GCAD.UnpackedVector3d.Negate (x, y, z)
	return -x, -y, -z
end

-- Conversion
function GCAD.UnpackedVector3d.FromNativeVector (v)
	return Vector___index (v, "x"), Vector___index (v, "y"), Vector___index (v, "z")
end

function GCAD.UnpackedVector3d.ToNativeVector (x, y, z, out)
	out = out or Vector ()
	
	Vector___newindex (out, "x", x)
	Vector___newindex (out, "y", y)
	Vector___newindex (out, "z", z)
	
	return out
end

-- Utility
function GCAD.UnpackedVector3d.ToString (x, y, z)
	return "(" .. tostring (x) .. ", " .. tostring (y) .. ", " .. tostring (z) .. ")"
end

function GCAD.UnpackedVector3d.Origin () return 0, 0, 0 end
function GCAD.UnpackedVector3d.Zero   () return 0, 0, 0 end
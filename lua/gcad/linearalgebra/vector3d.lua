local self = {}
GCAD.Vector3d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_abs  = math.abs
local math_sqrt = math.sqrt

-- Vector products
function GCAD.Vector3d.Cross (a, b, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a [2] * b [3] - a [3] * b [2]
	out [2] = a [3] * b [1] - a [1] * b [3]
	out [3] = a [1] * b [2] - a [2] * b [1]
	
	return out
end

function GCAD.Vector3d.Dot (a, b)
	return a [1] * b [1] + a [2] * b [2] + a [3] * b [3]
end

GCAD.Vector3d.InnerProduct = GCAD.Vector3d.Dot

function GCAD.Vector3d.OuterProduct (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = a [1] * b [1]
	out [2] = a [1] * b [2]
	out [3] = a [1] * b [3]
	out [4] = a [2] * b [1]
	out [5] = a [2] * b [2]
	out [6] = a [2] * b [3]
	out [7] = a [3] * b [1]
	out [8] = a [3] * b [2]
	out [9] = a [3] * b [3]
	
	return out
end

-- Vector norms
function GCAD.Vector3d.L1Norm (a)
	return math_abs (a [1]) + math_abs (a [2]) + math_abs (a [3])
end

function GCAD.Vector3d.L2Norm (a)
	return math_sqrt (a [1] * a [1] + a [2] * a [2] + a [3] * a [3])
end

function GCAD.Vector3d.L2NormSquared (a)
	return a [1] * a [1] + a [2] * a [2] + a [3] * a [3]
end

GCAD.Vector3d.Length        = GCAD.Vector3d.L2Norm
GCAD.Vector3d.LengthSquared = GCAD.Vector3d.L2NormSquared

-- Vector arithmetic
function GCAD.Vector3d.Add (a, b, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a [1] + b [1]
	out [2] = a [2] + b [2]
	out [3] = a [3] + b [3]
	
	return out
end

function GCAD.Vector3d.Subtract (a, b, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a [1] - b [1]
	out [2] = a [2] - b [2]
	out [3] = a [3] - b [3]
	
	return out
end

function GCAD.Vector3d.ScalarVectorMultiply (a, b, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a * b [1]
	out [2] = a * b [2]
	out [3] = a * b [3]
	
	return out
end

function GCAD.Vector3d.VectorScalarMultiply (a, b, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a [1] * b
	out [2] = a [2] * b
	out [3] = a [3] * b
	
	return out
end

local GCAD_Vector3d_ScalarVectorMultiply = GCAD.Vector3d.ScalarVectorMultiply
local GCAD_Vector3d_VectorScalarMultiply = GCAD.Vector3d.VectorScalarMultiply

function GCAD.Vector3d.Multiply (a, b, out)
	if isnumber (a) then
		return GCAD_Vector3d_ScalarVectorMultiply (a, b, out)
	elseif isnumber (b) then
		return GCAD_Vector3d_VectorScalarMultiply (a, b, out)
	end
	
	GCAD.Error ("Vector3d.Multiply : Neither of the arguments is a scalar!")
	
	return out
end

function GCAD.Vector3d.ScalarDivide (a, b, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = a [1] / b
	out [2] = a [2] / b
	out [3] = a [3] / b
	
	return out
end

function GCAD.Vector3d.Negate (a, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = -a [1]
	out [2] = -a [2]
	out [3] = -a [3]
	
	return out
end

-- Utility
function GCAD.Vector3d.Unpack (a)
	return a [1], a [2], a[3]
end

function GCAD.Vector3d.ToString (a)
	return "(" .. tostring (a [1]) .. ", " .. tostring (a [2]) .. ", " .. tostring (a [3]) .. ")"
end

-- Constructor
function self:ctor (x, y, z)
	self [1] = x or 0
	self [2] = y or 0
	self [3] = z or 0
end

function self:Set (x, y, z)
	self [1] = x
	self [2] = y
	self [3] = z
end

-- Vector products
self.Cross          = GCAD.Vector3d.Cross
self.Dot            = GCAD.Vector3d.Dot
self.InnerProduct   = GCAD.Vector3d.InnerProduct
self.OuterProduct   = GCAD.Vector3d.OuterProduct

-- Vector norms
self.L1Norm         = GCAD.Vector3d.L1Norm
self.L2Norm         = GCAD.Vector3d.L2Norm
self.L2NormSquared  = GCAD.Vector3d.L2NormSquared
self.Length         = GCAD.Vector3d.Length
self.LengthSquared  = GCAD.Vector3d.LengthSquared

-- Vector arithmetic
self.Add            = GCAD.Vector3d.Add
self.Subtract       = GCAD.Vector3d.Subtract
self.Multiply       = GCAD.Vector3d.Multiply
self.ScalarMultiply = GCAD.Vector3d.VectorScalarMultiply
self.ScalarDivide   = GCAD.Vector3d.ScalarDivide
self.Negate         = GCAD.Vector3d.Negate

self.__add          = GCAD.Vector3d.Add
self.__sub          = GCAD.Vector3d.Subtract
self.__mul          = GCAD.Vector3d.Multiply
self.__div          = GCAD.Vector3d.ScalarDivide
self.__unm          = GCAD.Vector3d.Negate

-- Utility
self.Unpack         = GCAD.Vector3d.Unpack
self.ToString       = GCAD.Vector3d.ToString
self.__tostring     = GCAD.Vector3d.ToString

GCAD.Vector3d.Origin = GCAD.Vector3d (0, 0, 0)
GCAD.Vector3d.Zero   = GCAD.Vector3d (0, 0, 0)
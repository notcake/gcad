local self = {}
GCAD.Vector2d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_abs  = math.abs
local math_sqrt = math.sqrt

-- Copying
function GCAD.Vector2d.Clone (self, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = self [1]
	out [2] = self [2]
	
	return out
end

function GCAD.Vector2d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	
	return self
end

-- Vector products
function GCAD.Vector2d.Cross (a, b)
	return a [1] * b [2] - a [2] * b [1]
end

function GCAD.Vector2d.Dot (a, b)
	return a [1] * b [1] + a [2] * b [2]
end

GCAD.Vector2d.InnerProduct = GCAD.Vector2d.Dot

function GCAD.Vector2d.OuterProduct (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1] * b [1]
	out [2] = a [1] * b [2]
	out [3] = a [2] * b [1]
	out [4] = a [2] * b [2]
	
	return out
end

-- Vector norms
function GCAD.Vector2d.L1Norm (self)
	return math_abs (self [1]) + math_abs (self [2])
end

function GCAD.Vector2d.L2Norm (self)
	return math_sqrt (self [1] * self [1] + self [2] * self [2])
end

function GCAD.Vector2d.L2NormSquared (self)
	return self [1] * self [1] + self [2] * self [2]
end

GCAD.Vector2d.Length        = GCAD.Vector2d.L2Norm
GCAD.Vector2d.LengthSquared = GCAD.Vector2d.L2NormSquared

-- Vector operations
local GCAD_Vector2d_Length = GCAD.Vector2d.Length

function GCAD.Vector2d.Normalize (self, out)
	out = out or GCAD.Vector2d ()
	
	local length = GCAD_Vector2d_Length (self)
	out [1] = self [1] / length
	out [2] = self [2] / length
	
	return out
end

-- Vector arithmetic
function GCAD.Vector2d.Add (a, b, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [1] + b [1]
	out [2] = a [2] + b [2]
	
	return out
end

function GCAD.Vector2d.Subtract (a, b, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [1] - b [1]
	out [2] = a [2] - b [2]
	
	return out
end

function GCAD.Vector2d.ScalarVectorMultiply (a, b, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a * b [1]
	out [2] = a * b [2]
	
	return out
end

function GCAD.Vector2d.VectorScalarMultiply (a, b, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [1] * b
	out [2] = a [2] * b
	
	return out
end

local GCAD_Vector2d_ScalarVectorMultiply = GCAD.Vector2d.ScalarVectorMultiply
local GCAD_Vector2d_VectorScalarMultiply = GCAD.Vector2d.VectorScalarMultiply

function GCAD.Vector2d.Multiply (a, b, out)
	if isnumber (a) then
		return GCAD_Vector2d_ScalarVectorMultiply (a, b, out)
	elseif isnumber (b) then
		return GCAD_Vector2d_VectorScalarMultiply (a, b, out)
	end
	
	GCAD.Error ("Vector2d.Multiply : Neither of the arguments is a scalar!")
	
	return out
end

function GCAD.Vector2d.ScalarDivide (a, b, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [1] / b
	out [2] = a [2] / b
	
	return out
end

function GCAD.Vector2d.Negate (self, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = -self [1]
	out [2] = -self [2]
	
	return out
end

-- Conversion
function GCAD.Vector2d.FromVector3d (v3d, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = v3d [1]
	out [2] = v3d [2]
	
	return out, v3d [3]
end

function GCAD.Vector2d.ToVector3d (self, z, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = z or 0
	
	return out
end

-- Utility
function GCAD.Vector2d.Unpack (self)
	return self [1], self [2]
end

function GCAD.Vector2d.ToString (self)
	return "(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ")"
end

-- Constructor
function self:ctor (x, y)
	self [1] = x or 0
	self [2] = y or 0
end

-- Initialization
function self:Set (x, y)
	self [1] = x
	self [2] = y
end

function self:Zero ()
	self [1] = 0
	self [2] = 0
	
	return self
end

-- Copying
self.Clone          = GCAD.Vector2d.Clone
self.Copy           = GCAD.Vector2d.Copy

-- Vector products
self.Cross          = GCAD.Vector2d.Cross
self.Dot            = GCAD.Vector2d.Dot
self.InnerProduct   = GCAD.Vector2d.InnerProduct
self.OuterProduct   = GCAD.Vector2d.OuterProduct

-- Vector norms
self.L1Norm         = GCAD.Vector2d.L1Norm
self.L2Norm         = GCAD.Vector2d.L2Norm
self.L2NormSquared  = GCAD.Vector2d.L2NormSquared
self.Length         = GCAD.Vector2d.Length
self.LengthSquared  = GCAD.Vector2d.LengthSquared

-- Vector operations
self.Normalize      = GCAD.Vector2d.Normalize

-- Vector arithmetic
self.Add            = GCAD.Vector2d.Add
self.Subtract       = GCAD.Vector2d.Subtract
self.Multiply       = GCAD.Vector2d.Multiply
self.ScalarMultiply = GCAD.Vector2d.VectorScalarMultiply
self.ScalarDivide   = GCAD.Vector2d.ScalarDivide
self.Negate         = GCAD.Vector2d.Negate

self.__add          = GCAD.Vector2d.Add
self.__sub          = GCAD.Vector2d.Subtract
self.__mul          = GCAD.Vector2d.Multiply
self.__div          = GCAD.Vector2d.ScalarDivide
self.__unm          = GCAD.Vector2d.Negate

-- Conversion
self.ToVector3d     = GCAD.Vector2d.ToVector3d

-- Utility
self.Unpack         = GCAD.Vector2d.Unpack
self.ToString       = GCAD.Vector2d.ToString
self.__tostring     = GCAD.Vector2d.ToString

GCAD.Vector2d.Origin = GCAD.Vector2d (0, 0)
GCAD.Vector2d.Zero   = GCAD.Vector2d (0, 0)
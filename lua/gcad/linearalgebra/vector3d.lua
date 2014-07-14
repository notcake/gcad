local self = {}
GCAD.Vector3d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_abs  = math.abs
local math_sqrt = math.sqrt

local Vector            = Vector

local Vector___index    = debug.getregistry ().Vector.__index
local Vector___newindex = debug.getregistry ().Vector.__newindex

-- Copying
function GCAD.Vector3d.Clone (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out
end

function GCAD.Vector3d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	
	return self
end

-- Equality
function GCAD.Vector3d.Equals (a, b)
	return a [1] == b [1] and
	       a [2] == b [2] and
	       a [3] == b [3]
end

-- NaN
function GCAD.Vector3d.ContainsNaN (self)
	return self [1] ~= self [1] or
	       self [2] ~= self [2] or
	       self [3] ~= self [3]
end

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
	
	out [1], out [2], out [3] = a [1] * b [1], a [1] * b [2], a [1] * b [3]
	out [4], out [5], out [6] = a [2] * b [1], a [2] * b [2], a [2] * b [3]
	out [7], out [8], out [9] = a [3] * b [1], a [3] * b [2], a [3] * b [3]
	
	return out
end

-- Vector norms
function GCAD.Vector3d.L1Norm (self)
	return math_abs (self [1]) + math_abs (self [2]) + math_abs (self [3])
end

function GCAD.Vector3d.L2Norm (self)
	return math_sqrt (self [1] * self [1] + self [2] * self [2] + self [3] * self [3])
end

function GCAD.Vector3d.L2NormSquared (self)
	return self [1] * self [1] + self [2] * self [2] + self [3] * self [3]
end

GCAD.Vector3d.Length        = GCAD.Vector3d.L2Norm
GCAD.Vector3d.LengthSquared = GCAD.Vector3d.L2NormSquared

-- Vector operations
local GCAD_Vector3d_Length = GCAD.Vector3d.Length

function GCAD.Vector3d.Normalize (self, out)
	out = out or GCAD.Vector3d ()
	
	local length = GCAD_Vector3d_Length (self)
	out [1] = self [1] / length
	out [2] = self [2] / length
	out [3] = self [3] / length
	
	return out
end

-- Vector queries
function GCAD.Vector3d.DistanceTo (a, b)
	local dx = a [1] - b [1]
	local dy = a [2] - b [2]
	local dz = a [3] - b [3]
	return math_sqrt (dx * dx + dy * dy + dz * dz)
end

function GCAD.Vector3d.DistanceToSquared (a, b)
	local dx = a [1] - b [1]
	local dy = a [2] - b [2]
	local dz = a [3] - b [3]
	return dx * dx + dy * dy + dz * dz
end

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

function GCAD.Vector3d.Negate (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = -self [1]
	out [2] = -self [2]
	out [3] = -self [3]
	
	return out
end

-- Conversion
function GCAD.Vector3d.FromVector2d (v2d, z, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = v2d [1]
	out [2] = v2d [2]
	out [3] = z or 0
	
	return out
end

function GCAD.Vector3d.ToVector2d (self, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = self [1]
	out [2] = self [2]
	
	return out, self [3]
end

function GCAD.Vector3d.FromNativeVector (v, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = Vector___index (v, 1)
	out [2] = Vector___index (v, 2)
	out [3] = Vector___index (v, 3)
	
	return out
end

function GCAD.Vector3d.ToNativeVector (self, out)
	out = out or Vector ()
	
	Vector___newindex (out, 1, self [1])
	Vector___newindex (out, 2, self [2])
	Vector___newindex (out, 3, self [3])
	
	return out
end

-- Utility
function GCAD.Vector3d.Unpack (self)
	return self [1], self [2], self [3]
end

function GCAD.Vector3d.ToString (self)
	return "(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .. ")"
end

-- Constructor
function self:ctor (x, y, z)
	self [1] = x or 0
	self [2] = y or 0
	self [3] = z or 0
end

-- Initialization
function self:Set (x, y, z)
	self [1] = x
	self [2] = y
	self [3] = z
	
	return self
end

function self:Zero ()
	self [1] = 0
	self [2] = 0
	self [3] = 0
	
	return self
end

-- Copying
self.Clone             = GCAD.Vector3d.Clone
self.Copy              = GCAD.Vector3d.Copy

-- Equality
self.Equals            = GCAD.Vector3d.Equals
self.__eq              = GCAD.Vector3d.Equals

-- NaN
self.ContainsNaN       = GCAD.Vector3d.ContainsNaN

-- Vector products
self.Cross             = GCAD.Vector3d.Cross
self.Dot               = GCAD.Vector3d.Dot
self.InnerProduct      = GCAD.Vector3d.InnerProduct
self.OuterProduct      = GCAD.Vector3d.OuterProduct

-- Vector norms
self.L1Norm            = GCAD.Vector3d.L1Norm
self.L2Norm            = GCAD.Vector3d.L2Norm
self.L2NormSquared     = GCAD.Vector3d.L2NormSquared
self.Length            = GCAD.Vector3d.Length
self.LengthSquared     = GCAD.Vector3d.LengthSquared

-- Vector operations
self.Normalize         = GCAD.Vector3d.Normalize

-- Vector queries
self.DistanceTo        = GCAD.Vector3d.DistanceTo
self.DistanceToSquared = GCAD.Vector3d.DistanceToSquared

-- Vector arithmetic
self.Add               = GCAD.Vector3d.Add
self.Subtract          = GCAD.Vector3d.Subtract
self.Multiply          = GCAD.Vector3d.Multiply
self.ScalarMultiply    = GCAD.Vector3d.VectorScalarMultiply
self.ScalarDivide      = GCAD.Vector3d.ScalarDivide
self.Negate            = GCAD.Vector3d.Negate

self.__add             = GCAD.Vector3d.Add
self.__sub             = GCAD.Vector3d.Subtract
self.__mul             = GCAD.Vector3d.Multiply
self.__div             = GCAD.Vector3d.ScalarDivide
self.__unm             = GCAD.Vector3d.Negate

-- Conversion
self.ToVector2d        = GCAD.Vector3d.ToVector2d
self.ToNativeVector    = GCAD.Vector3d.ToNativeVector

-- Utility
self.Unpack            = GCAD.Vector3d.Unpack
self.ToString          = GCAD.Vector3d.ToString
self.__tostring        = GCAD.Vector3d.ToString

GCAD.Vector3d.Origin   = GCAD.Vector3d (0, 0, 0)
GCAD.Vector3d.Zero     = GCAD.Vector3d (0, 0, 0)
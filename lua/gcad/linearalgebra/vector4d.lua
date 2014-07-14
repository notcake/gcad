local self = {}
GCAD.Vector4d = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber
local math_abs  = math.abs
local math_sqrt = math.sqrt

local Vector            = Vector

local Vector___index    = debug.getregistry ().Vector.__index
local Vector___newindex = debug.getregistry ().Vector.__newindex

-- Copying
function GCAD.Vector4d.Clone (self, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	
	return out
end

function GCAD.Vector4d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	
	return self
end

-- Equality
function GCAD.Vector4d.Equals (a, b)
	return a [1] == b [1] and
	       a [2] == b [2] and
	       a [3] == b [3] and
	       a [4] == b [4]
end

-- NaN
function GCAD.Vector4d.ContainsNaN (self)
	return self [1] ~= self [1] or
	       self [2] ~= self [2] or
	       self [3] ~= self [3] or
	       self [4] ~= self [4]
end

-- Vector products
function GCAD.Vector4d.Dot (a, b)
	return a [1] * b [1] + a [2] * b [2] + a [3] * b [3] + a [4] * b [4]
end

GCAD.Vector4d.InnerProduct = GCAD.Vector4d.Dot

function GCAD.Vector4d.OuterProduct (a, b, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = a [1] * b [1], a [1] * b [2], a [1] * b [3], a [1] * b [4]
	out [ 5], out [ 6], out [ 7], out [ 8] = a [2] * b [1], a [2] * b [2], a [2] * b [3], a [2] * b [4]
	out [ 9], out [10], out [11], out [12] = a [3] * b [1], a [3] * b [2], a [3] * b [3], a [3] * b [4]
	out [13], out [14], out [15], out [16] = a [4] * b [1], a [4] * b [2], a [4] * b [3], a [4] * b [4]
	
	return out
end

-- Vector norms
function GCAD.Vector4d.L1Norm (self)
	return math_abs (self [1]) + math_abs (self [2]) + math_abs (self [3]) + math_abs (self [4])
end

function GCAD.Vector4d.L2Norm (self)
	return math_sqrt (self [1] * self [1] + self [2] * self [2] + self [3] * self [3] + self [4] * self [4])
end

function GCAD.Vector4d.L2NormSquared (self)
	return self [1] * self [1] + self [2] * self [2] + self [3] * self [3] + self [4] * self [4]
end

GCAD.Vector4d.Length        = GCAD.Vector4d.L2Norm
GCAD.Vector4d.LengthSquared = GCAD.Vector4d.L2NormSquared

-- Vector operations
local GCAD_Vector4d_Length = GCAD.Vector4d.Length

function GCAD.Vector4d.Normalize (self, out)
	out = out or GCAD.Vector4d ()
	
	local length = GCAD_Vector4d_Length (self)
	out [1] = self [1] / length
	out [2] = self [2] / length
	out [3] = self [3] / length
	out [4] = self [4] / length
	
	return out
end

-- Vector queries
function GCAD.Vector2d.DistanceTo (a, b)
	local dx = a [1] - b [1]
	local dy = a [2] - b [2]
	local dz = a [3] - b [3]
	local dw = a [4] - b [4]
	return math_sqrt (dx * dx + dy * dy + dz * dz + dw * dw)
end

function GCAD.Vector2d.DistanceToSquared (a, b)
	local dx = a [1] - b [1]
	local dy = a [2] - b [2]
	local dz = a [3] - b [3]
	local dw = a [4] - b [4]
	return dx * dx + dy * dy + dz * dz + dw * dw
end

-- Vector arithmetic
function GCAD.Vector4d.Add (a, b, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = a [1] + b [1]
	out [2] = a [2] + b [2]
	out [3] = a [3] + b [3]
	out [4] = a [4] + b [4]
	
	return out
end

function GCAD.Vector4d.Subtract (a, b, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = a [1] - b [1]
	out [2] = a [2] - b [2]
	out [3] = a [3] - b [3]
	out [4] = a [4] - b [4]
	
	return out
end

function GCAD.Vector4d.ScalarVectorMultiply (a, b, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = a * b [1]
	out [2] = a * b [2]
	out [3] = a * b [3]
	out [4] = a * b [4]
	
	return out
end

function GCAD.Vector4d.VectorScalarMultiply (a, b, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = a [1] * b
	out [2] = a [2] * b
	out [3] = a [3] * b
	out [4] = a [4] * b
	
	return out
end

local GCAD_Vector4d_ScalarVectorMultiply = GCAD.Vector4d.ScalarVectorMultiply
local GCAD_Vector4d_VectorScalarMultiply = GCAD.Vector4d.VectorScalarMultiply

function GCAD.Vector4d.Multiply (a, b, out)
	if isnumber (a) then
		return GCAD_Vector4d_ScalarVectorMultiply (a, b, out)
	elseif isnumber (b) then
		return GCAD_Vector4d_VectorScalarMultiply (a, b, out)
	end
	
	GCAD.Error ("Vector4d.Multiply : Neither of the arguments is a scalar!")
	
	return out
end

function GCAD.Vector4d.ScalarDivide (a, b, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = a [1] / b
	out [2] = a [2] / b
	out [3] = a [3] / b
	out [4] = a [4] / b
	
	return out
end

function GCAD.Vector4d.Negate (self, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = -self [1]
	out [2] = -self [2]
	out [3] = -self [3]
	out [4] = -self [4]
	
	return out
end

-- Conversion
function GCAD.Vector4d.FromVector3d (v3d, w, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = v3d [1]
	out [2] = v3d [2]
	out [3] = v3d [3]
	out [4] = w or 0
	
	return out
end

function GCAD.Vector4d.ToVector3d (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	
	return out, self [4]
end

function GCAD.Vector4d.FromNativeVector (v, w, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = Vector___index (v, 1)
	out [2] = Vector___index (v, 2)
	out [3] = Vector___index (v, 3)
	out [4] = w
	
	return out
end

function GCAD.Vector4d.ToNativeVector (self, out)
	out = out or Vector ()
	
	Vector___newindex (out, 1, self [1])
	Vector___newindex (out, 2, self [2])
	Vector___newindex (out, 3, self [3])
	
	return out, self [4]
end

-- Utility
function GCAD.Vector4d.Unpack (self)
	return self [1], self [2], self [3], self [4]
end

function GCAD.Vector4d.ToString (self)
	return "(" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .. ", " .. tostring (self [4]) .. ")"
end

-- Constructor
function self:ctor (x, y, z, w)
	self [1] = x or 0
	self [2] = y or 0
	self [3] = z or 0
	self [4] = w or 0
end

-- Initialization
function self:Set (x, y, z, w)
	self [1] = x
	self [2] = y
	self [3] = z
	self [4] = w
	
	return self
end

function self:Zero ()
	self [1] = 0
	self [2] = 0
	self [3] = 0
	self [4] = 0
	
	return self
end

-- Copying
self.Clone             = GCAD.Vector4d.Clone
self.Copy              = GCAD.Vector4d.Copy

-- Equality
self.Equals            = GCAD.Vector4d.Equals
self.__eq              = GCAD.Vector4d.Equals

-- NaN
self.ContainsNaN       = GCAD.Vector4d.ContainsNaN

-- Vector products
self.Dot               = GCAD.Vector4d.Dot
self.InnerProduct      = GCAD.Vector4d.InnerProduct
self.OuterProduct      = GCAD.Vector4d.OuterProduct

-- Vector norms
self.L1Norm            = GCAD.Vector4d.L1Norm
self.L2Norm            = GCAD.Vector4d.L2Norm
self.L2NormSquared     = GCAD.Vector4d.L2NormSquared
self.Length            = GCAD.Vector4d.Length
self.LengthSquared     = GCAD.Vector4d.LengthSquared

-- Vector operations
self.Normalize         = GCAD.Vector4d.Normalize

-- Vector queries
self.DistanceTo        = GCAD.Vector4d.DistanceTo
self.DistanceToSquared = GCAD.Vector4d.DistanceToSquared

-- Vector arithmetic
self.Add               = GCAD.Vector4d.Add
self.Subtract          = GCAD.Vector4d.Subtract
self.Multiply          = GCAD.Vector4d.Multiply
self.ScalarMultiply    = GCAD.Vector4d.VectorScalarMultiply
self.ScalarDivide      = GCAD.Vector4d.ScalarDivide
self.Negate            = GCAD.Vector4d.Negate

self.__add             = GCAD.Vector4d.Add
self.__sub             = GCAD.Vector4d.Subtract
self.__mul             = GCAD.Vector4d.Multiply
self.__div             = GCAD.Vector4d.ScalarDivide
self.__unm             = GCAD.Vector4d.Negate

-- Conversion
self.ToVector3d        = GCAD.Vector4d.ToVector3d
self.ToNativeVector    = GCAD.Vector4d.ToNativeVector

-- Utility
self.Unpack            = GCAD.Vector4d.Unpack
self.ToString          = GCAD.Vector4d.ToString
self.__tostring        = GCAD.Vector4d.ToString

GCAD.Vector4d.Origin   = GCAD.Vector4d (0, 0, 0, 0)
GCAD.Vector4d.Zero     = GCAD.Vector4d (0, 0, 0, 0)
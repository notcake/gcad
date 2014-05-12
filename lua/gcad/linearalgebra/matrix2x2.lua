local self = {}
GCAD.Matrix2x2 = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber

-- Matrix reading
function GCAD.Matrix2x2.GetColumn (a, column, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [column + 0]
	out [2] = a [column + 2]
	
	return out
end

function GCAD.Matrix2x2.GetDiagonal (a, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [1]
	out [2] = a [3]
	
	return out
end

function GCAD.Matrix2x2.GetRow (a, row, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = a [row * 2 - 2 + 1]
	out [2] = a [row * 2 - 2 + 2]
	
	return out
end

-- Matrix operations
function GCAD.Matrix2x2.Determinant (a)
	return a [1] * a [4] - a [3] * a [2]
end

local GCAD_Matrix2x2_Determinant = GCAD.Matrix2x2.Determinant
function GCAD.Matrix2x2.Invert (a, out)
	out = out or GCAD.Matrix2x2 ()
	
	local determinant = GCAD_Matrix2x2_Determinant (a)
	out [1], out [4] = a [4] / determinant, a [1] / determinant
	out [2] = -a [2] / determinant
	out [3] = -a [3] / determinant
	
	return out
end

function GCAD.Matrix2x2.Transpose (a, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1]
	out [4] = a [4]
	out [2], out [3] = a [3], a [2]
	
	return out
end

-- Matrix arithmetic
function GCAD.Matrix2x2.Add (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1] + b [1]
	out [2] = a [2] + b [2]
	out [3] = a [3] + b [3]
	out [4] = a [4] + b [4]
	
	return out
end

function GCAD.Matrix2x2.Subtract (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1] - b [1]
	out [2] = a [2] - b [2]
	out [3] = a [3] - b [3]
	out [4] = a [4] - b [4]
	
	return out
end

function GCAD.Matrix2x2.MatrixScalarMultiply (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1] * b
	out [2] = a [2] * b
	out [3] = a [3] * b
	out [4] = a [4] * b
	
	return out
end

local GCAD_Matrix2x2_MatrixScalarMultiply = GCAD.Matrix2x2.MatrixScalarMultiply
function GCAD.Matrix2x2.ScalarMatrixMultiply (a, b, out)
	return GCAD_Matrix2x2_MatrixScalarMultiply (b, a, out)
end

function GCAD.Matrix2x2.MatrixVectorMultiply (a, b, out)
	out = out or GCAD.Vector2d ()
	
	local x, y = b [1], b [2]
	out [1] = a [1] * x + a [2] * y
	out [2] = a [3] * x + a [4] * y
	
	return out
end

function GCAD.Matrix2x2.VectorMatrixMultiply (a, b, out)
	out = out or GCAD.Vector2d ()
	
	local x, y = a [1], a [2]
	out [1] = x * b [1] + y * b [3]
	out [2] = x * b [2] + y * b [4]
	
	return out
end

function GCAD.Matrix2x2.MatrixMatrixMultiply (a, b, out)
	if out == a or out == b then out = nil end
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1] * b [1] + a [2] * b [3]
	out [2] = a [1] * b [2] + a [2] * b [4]
	
	out [3] = a [3] * b [1] + a [4] * b [3]
	out [4] = a [3] * b [2] + a [4] * b [4]
	
	return out
end

local GCAD_Matrix2x2_ScalarMatrixMultiply = GCAD.Matrix2x2.ScalarMatrixMultiply
local GCAD_Matrix2x2_MatrixMatrixMultiply = GCAD.Matrix2x2.MatrixMatrixMultiply
local GCAD_Matrix2x2_VectorMatrixMultiply = GCAD.Matrix2x2.VectorMatrixMultiply
local GCAD_Matrix2x2_MatrixVectorMultiply = GCAD.Matrix2x2.MatrixVectorMultiply

function GCAD.Matrix2x2.Multiply (a, b, out)
	if isnumber (a) then
		return GCAD_Matrix2x2_ScalarMatrixMultiply (a, b, out)
	elseif isnumber (b) then
		return GCAD_Matrix2x2_MatrixScalarMultiply (a, b, out)
	elseif #a == 4 and #b == 4 then
		return GCAD_Matrix2x2_MatrixMatrixMultiply (a, b, out)
	elseif #a == 2 then
		return GCAD_Matrix2x2_VectorMatrixMultiply (a, b, out)
	elseif #b == 2 then
		return GCAD_Matrix2x2_MatrixVectorMultiply (a, b, out)
	end
	
	GCAD.Error ("Matrix2x2.Multiply : Invalid argument types!")
	
	return out
end

function GCAD.Matrix2x2.ScalarDivide (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = a [1] / b
	out [2] = a [2] / b
	out [3] = a [3] / b
	out [4] = a [4] / b
	
	return out
end

function GCAD.Matrix2x2.Negate (a, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = -a [1]
	out [2] = -a [2]
	out [3] = -a [3]
	out [4] = -a [4]
	
	return out
end

-- Utility
function GCAD.Matrix2x2.Unpack (a)
	return a [1], a [2], a [3], a [4]
end

function GCAD.Matrix2x2.ToString (a)
	return "[" .. tostring (a [1]) .. ", " .. tostring (a [2]) .. "]\n[" .. tostring (a [3]) .. ", " .. tostring (a [4]) .. "]"
end

-- Construction
function GCAD.Matrix2x2.Identity (out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = 1
	out [2] = 0
	out [3] = 0
	out [4] = 1
	
	return out
end

function GCAD.Matrix2x2.Rotate (radians, out)
	out = out or GCAD.Matrix2x2 ()
	
	local sin = math_sin (radians)
	local cos = math_cos (radians)
	out [1] = cos
	out [3] = sin
	out [2] = -sin
	out [4] = cos
	
	return out
end

function GCAD.Matrix2x2.Scale (x, y, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = x
	out [2] = 0
	out [3] = 0
	out [4] = y
	
	return out
end

function GCAD.Matrix2x2.Zero (out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = 0
	out [2] = 0
	out [3] = 0
	out [4] = 0
	
	return out
end

-- Constructor
function self:ctor (m11, m12, m21, m22)
	self [1] = m11 or 0
	self [2] = m12 or 0
	self [3] = m21 or 0
	self [4] = m22 or 0
end

function self:Set (m11, m12, m21, m22)
	self [1] = m11
	self [2] = m12
	self [3] = m21
	self [4] = m22
end

-- Matrix reading
self.GetColumn      = GCAD.Matrix2x2.GetColumn
self.GetDiagonal    = GCAD.Matrix2x2.GetDiagonal
self.GetRow         = GCAD.Matrix2x2.GetRow

-- Matrix operations
self.Determinant    = GCAD.Matrix2x2.Determinant
self.Invert         = GCAD.Matrix2x2.Invert
self.Transpose      = GCAD.Matrix2x2.Transpose

-- Matrix arithmetic
self.Add            = GCAD.Matrix2x2.Add
self.Subtract       = GCAD.Matrix2x2.Subtract
self.Multiply       = GCAD.Matrix2x2.Multiply
self.ScalarMultiply = GCAD.Matrix2x2.MatrixScalarMultiply
self.ScalarDivide   = GCAD.Matrix2x2.ScalarDivide
self.MatrixMultiply = GCAD.Matrix2x2.MatrixMatrixMultiply
self.VectorMultiply = GCAD.Matrix2x2.MatrixVectorMultiply
self.Negate         = GCAD.Matrix2x2.Negate

self.__add          = GCAD.Matrix2x2.Add
self.__sub          = GCAD.Matrix2x2.Subtract
self.__mul          = GCAD.Matrix2x2.Multiply
self.__div          = GCAD.Matrix2x2.ScalarDivide
self.__unm          = GCAD.Matrix2x2.Negate

-- Utility
self.Unpack         = GCAD.Matrix2x2.Unpack
self.ToString       = GCAD.Matrix2x2.ToString
self.__tostring     = GCAD.Matrix2x2.ToString
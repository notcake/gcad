local self = {}
GCAD.Matrix2x2 = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber

-- Copying
function GCAD.Matrix2x2.Clone (self, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = self [1], self [2]
	out [3], out [4] = self [3], self [4]
	
	return self
end

function GCAD.Matrix2x2.Copy (self, source)
	self [1], self [2] = source [1], source [2]
	self [3], self [4] = source [3], source [4]
	
	return self
end

-- Matrix reading
function GCAD.Matrix2x2.GetColumn (self, column, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = self [column + 0]
	out [2] = self [column + 2]
	
	return out
end

function GCAD.Matrix2x2.GetColumnUnpacked (self, column)	
	return self [column + 0], self [column + 2]
end

function GCAD.Matrix2x2.GetDiagonal (self, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = self [1]
	out [2] = self [3]
	
	return out
end

function GCAD.Matrix2x2.GetDiagonalUnpacked (self)
	return self [1], self [3]
end

function GCAD.Matrix2x2.GetRow (self, row, out)
	out = out or GCAD.Vector2d ()
	
	out [1] = self [row * 2 - 2 + 1]
	out [2] = self [row * 2 - 2 + 2]
	
	return out
end

function GCAD.Matrix2x2.GetRowUnpacked (self, row)
	return self [row * 2 - 2 + 1], self [row * 2 - 2 + 2]
end

function GCAD.Matrix2x2.SetColumn (self, column, v2d)
	self [column + 0] = v2d [1]
	self [column + 2] = v2d [2]
	
	return self
end

function GCAD.Matrix2x2.SetColumnUnpacked (self, column, x, y)
	self [column + 0] = x
	self [column + 2] = y
	
	return self
end

function GCAD.Matrix2x2.SetDiagonal (self, v2d)
	self [1] = v2d [1]
	self [3] = v2d [2]
	
	return self
end

function GCAD.Matrix2x2.SetDiagonalUnpacked (self, x, y)
	self [1] = x
	self [3] = y
	
	return self
end

function GCAD.Matrix2x2.SetRow (self, row, v2d)
	self [row * 2 - 2 + 1] = v2d [1]
	self [row * 2 - 2 + 2] = v2d [2]
	
	return self
end

function GCAD.Matrix2x2.SetRowUnpacked (self, row, x, y)
	self [row * 2 - 2 + 1] = x
	self [row * 2 - 2 + 2] = y
	
	return self
end

-- Matrix operations
function GCAD.Matrix2x2.Determinant (self)
	return self [1] * self [4] - self [3] * self [2]
end

local GCAD_Matrix2x2_Determinant = GCAD.Matrix2x2.Determinant
function GCAD.Matrix2x2.Invert (self, out)
	out = out or GCAD.Matrix2x2 ()
	
	local determinant = GCAD_Matrix2x2_Determinant (self)
	out [1], out [4] = self [4] / determinant, self [1] / determinant
	out [2] = -self [2] / determinant
	out [3] = -self [3] / determinant
	
	return out
end

function GCAD.Matrix2x2.Transpose (self, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1] = self [1]
	out [4] = self [4]
	out [2], out [3] = self [3], self [2]
	
	return out
end

-- Matrix arithmetic
function GCAD.Matrix2x2.Add (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = a [1] + b [1], a [2] + b [2]
	out [3], out [4] = a [3] + b [3], a [4] + b [4]
	
	return out
end

function GCAD.Matrix2x2.Subtract (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = a [1] - b [1], a [2] - b [2]
	out [3], out [4] = a [3] - b [3], a [4] - b [4]
	
	return out
end

function GCAD.Matrix2x2.MatrixScalarMultiply (a, b, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = a [1] * b, a [2] * b
	out [3], out [4] = a [3] * b, a [4] * b
	
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

function GCAD.Matrix2x2.MatrixUnpackedVectorMultiply (a, x, y)
	return a [1] * x + a [2] * y,
	       a [3] * x + a [4] * y
end

function GCAD.Matrix2x2.VectorMatrixMultiply (a, b, out)
	out = out or GCAD.Vector2d ()
	
	local x, y = a [1], a [2]
	out [1] = x * b [1] + y * b [3]
	out [2] = x * b [2] + y * b [4]
	
	return out
end

function GCAD.Matrix2x2.UnpackedVectorMatrixMultiply (x, y, b)
	return x * b [1] + y * b [3],
	       x * b [2] + y * b [4]
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
	
	out [1], out [2] = a [1] / b, a [2] / b
	out [3], out [4] = a [3] / b, a [4] / b
	
	return out
end

function GCAD.Matrix2x2.Negate (self, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = -self [1], -self [2]
	out [3], out [4] = -self [3], -self [4]
	
	return out
end

-- Utility
function GCAD.Matrix2x2.Unpack (self)
	return self [1], self [2],
	       self [3], self [4]
end

function GCAD.Matrix2x2.ToString (self)
	return "[" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. "]\n" ..
	       "[" .. tostring (self [3]) .. ", " .. tostring (self [4]) .. "]"
end

-- Construction
function GCAD.Matrix2x2.Identity (out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = 1, 0
	out [3], out [4] = 0, 1
	
	return out
end

function GCAD.Matrix2x2.Rotate (radians, out)
	out = out or GCAD.Matrix2x2 ()
	
	local sin = math_sin (radians)
	local cos = math_cos (radians)
	out [1], out [2] = cos, -sin
	out [3], out [4] = sin,  cos
	
	return out
end

function GCAD.Matrix2x2.Scale (v2d, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = v2d [1],       0
	out [3], out [4] =       0, v2d [2]
	
	return out
end

function GCAD.Matrix2x2.ScaleUnpacked (x, y, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = x, 0
	out [3], out [4] = 0, y
	
	return out
end

function GCAD.Matrix2x2.Zero (out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = 0, 0
	out [3], out [4] = 0, 0
	
	return out
end

-- Constructor
function self:ctor (m11, m12,
                    m21, m22)
	
	self [1], self [2] = m11 or 0, m12 or 0
	self [3], self [4] = m21 or 0, m22 or 0
end

-- Initialization
function self:Set (m11, m12,
                   m21, m22)
	
	self [1], self [2] = m11, m12
	self [3], self [4] = m21, m22
	
	return self
end

local GCAD_Matrix2x2_Identity = GCAD.Matrix2x2.Identity
local GCAD_Matrix2x2_Zero     = GCAD.Matrix2x2.Zero

function self:Identity () return GCAD_Matrix2x2_Identity (self) end
function self:Zero     () return GCAD_Matrix2x2_Zero     (self) end

-- Copying
self.Clone                  = GCAD.Matrix2x2.Clone
self.Copy                   = GCAD.Matrix2x2.Copy

-- Matrix reading
self.GetColumn              = GCAD.Matrix2x2.GetColumn
self.GetColumnUnpacked      = GCAD.Matrix2x2.GetColumnUnpacked
self.GetDiagonal            = GCAD.Matrix2x2.GetDiagonal
self.GetDiagonalUnpacked    = GCAD.Matrix2x2.GetDiagonalUnpacked
self.GetRow                 = GCAD.Matrix2x2.GetRow
self.GetRowUnpacked         = GCAD.Matrix2x2.GetRowUnpacked
self.SetColumn              = GCAD.Matrix2x2.SetColumn
self.SetColumnUnpacked      = GCAD.Matrix2x2.SetColumnUnpacked
self.SetDiagonal            = GCAD.Matrix2x2.SetDiagonal
self.SetDiagonalUnpacked    = GCAD.Matrix2x2.SetDiagonalUnpacked
self.SetRow                 = GCAD.Matrix2x2.SetRow
self.SetRowUnpacked         = GCAD.Matrix2x2.SetRowUnpacked

-- Matrix operations
self.Determinant            = GCAD.Matrix2x2.Determinant
self.Invert                 = GCAD.Matrix2x2.Invert
self.Transpose              = GCAD.Matrix2x2.Transpose

-- Matrix arithmetic
self.Add                    = GCAD.Matrix2x2.Add
self.Subtract               = GCAD.Matrix2x2.Subtract
self.Multiply               = GCAD.Matrix2x2.Multiply
self.ScalarMultiply         = GCAD.Matrix2x2.MatrixScalarMultiply
self.ScalarDivide           = GCAD.Matrix2x2.ScalarDivide
self.MatrixMultiply         = GCAD.Matrix2x2.MatrixMatrixMultiply
self.VectorMultiply         = GCAD.Matrix2x2.MatrixVectorMultiply
self.UnpackedVectorMultiply = GCAD.Matrix2x2.MatrixUnpackedVectorMultiply
self.Negate                 = GCAD.Matrix2x2.Negate

self.__add                  = GCAD.Matrix2x2.Add
self.__sub                  = GCAD.Matrix2x2.Subtract
self.__mul                  = GCAD.Matrix2x2.Multiply
self.__div                  = GCAD.Matrix2x2.ScalarDivide
self.__unm                  = GCAD.Matrix2x2.Negate

-- Utility
self.Unpack                 = GCAD.Matrix2x2.Unpack
self.ToString               = GCAD.Matrix2x2.ToString
self.__tostring             = GCAD.Matrix2x2.ToString
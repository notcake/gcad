local self = {}
GCAD.Matrix3x3 = GCAD.MakeConstructor (self)

local math      = math

local isnumber  = isnumber

-- Copying
function GCAD.Matrix3x3.Clone (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	out [5] = self [5]
	out [6] = self [6]
	out [7] = self [7]
	out [8] = self [8]
	out [9] = self [9]
	
	return out
end

function GCAD.Matrix3x3.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	self [5] = source [5]
	self [6] = source [6]
	self [7] = source [7]
	self [8] = source [8]
	self [9] = source [9]
	
	return self
end

-- Matrix reading
function GCAD.Matrix3x3.GetColumn (self, column, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [column + 0]
	out [2] = self [column + 3]
	out [3] = self [column + 6]
	
	return out
end

function GCAD.Matrix3x3.Vector3d (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [1]
	out [2] = self [5]
	out [3] = self [9]
	
	return out
end

function GCAD.Matrix3x3.GetRow (self, row, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [row * 3 - 3 + 1]
	out [2] = self [row * 3 - 3 + 2]
	out [3] = self [row * 3 - 3 + 3]
	
	return out
end

-- Matrix operations
function GCAD.Matrix3x3.Determinant (self)
	return   self [1] * (self [5] * self [9] - self [8] * self [6])
	       - self [2] * (self [4] * self [9] - self [7] * self [6])
		   + self [3] * (self [4] * self [8] - self [7] * self [5])
end

local GCAD_Matrix3x3_Determinant = GCAD.Matrix3x3.Determinant
function GCAD.Matrix3x3.Invert (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	GCAD.Error ("Matrix3x3.Invert : Not implemented.")
	
	return out
end

function GCAD.Matrix3x3.Transpose (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = self [1]
	out [5] = self [5]
	out [9] = self [9]
	out [2], out [4] = self [4], self [2]
	out [3], out [7] = self [7], self [3]
	out [6], out [8] = self [8], self [6]
	
	return out
end

-- Matrix arithmetic
function GCAD.Matrix3x3.Add (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = a [1] + b [1]
	out [2] = a [2] + b [2]
	out [3] = a [3] + b [3]
	out [4] = a [4] + b [4]
	out [5] = a [5] + b [5]
	out [6] = a [6] + b [6]
	out [7] = a [7] + b [7]
	out [8] = a [8] + b [8]
	out [9] = a [9] + b [9]
	
	return out
end

function GCAD.Matrix3x3.Subtract (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = a [1] - b [1]
	out [2] = a [2] - b [2]
	out [3] = a [3] - b [3]
	out [4] = a [4] - b [4]
	out [5] = a [5] - b [5]
	out [6] = a [6] - b [6]
	out [7] = a [7] - b [7]
	out [8] = a [8] - b [8]
	out [9] = a [9] - b [9]
	
	return out
end

function GCAD.Matrix3x3.MatrixScalarMultiply (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = a [1] * b
	out [2] = a [2] * b
	out [3] = a [3] * b
	out [4] = a [4] * b
	out [5] = a [5] * b
	out [6] = a [6] * b
	out [7] = a [7] * b
	out [8] = a [8] * b
	out [9] = a [9] * b
	
	return out
end

local GCAD_Matrix3x3_MatrixScalarMultiply = GCAD.Matrix3x3.MatrixScalarMultiply
function GCAD.Matrix3x3.ScalarMatrixMultiply (a, b, out)
	return GCAD_Matrix3x3_MatrixScalarMultiply (b, a, out)
end

function GCAD.Matrix3x3.MatrixVectorMultiply (a, b, out)
	out = out or GCAD.Vector3d ()
	
	local x, y, z = b [1], b [2], b [3]
	out [1] = a [1] * x + a [2] * y + a [3] * z
	out [2] = a [4] * x + a [5] * y + a [6] * z
	out [3] = a [7] * x + a [8] * y + a [9] * z
	
	return out
end

function GCAD.Matrix3x3.VectorMatrixMultiply (a, b, out)
	out = out or GCAD.Vector3d ()
	
	local x, y, z = a [1], a [2], a [3]
	out [1] = x * b [1] + y * b [4] + z * b [7]
	out [2] = x * b [2] + y * b [5] + z * b [8]
	out [3] = x * b [3] + y * b [6] + z * b [9]
	
	return out
end

function GCAD.Matrix3x3.MatrixMatrixMultiply (a, b, out)
	if out == a or out == b then out = nil end
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = a [1] * b [1] + a [2] * b [4] + a [3] * b [7]
	out [2] = a [1] * b [2] + a [2] * b [5] + a [3] * b [8]
	out [3] = a [1] * b [3] + a [2] * b [6] + a [3] * b [9]
	
	out [4] = a [4] * b [1] + a [5] * b [4] + a [6] * b [7]
	out [5] = a [4] * b [2] + a [5] * b [5] + a [6] * b [8]
	out [6] = a [4] * b [3] + a [5] * b [6] + a [6] * b [9]
	
	out [7] = a [7] * b [1] + a [8] * b [4] + a [9] * b [7]
	out [8] = a [7] * b [2] + a [8] * b [5] + a [9] * b [8]
	out [9] = a [7] * b [3] + a [8] * b [6] + a [9] * b [9]
	
	return out
end

-- This multiplication method is slower than the previous one.
local vmatrix1 = Matrix ()
local vmatrix2 = Matrix ()
local VMatrix_GetField = debug.getregistry ().VMatrix.GetField
local VMatrix_Identity = debug.getregistry ().VMatrix.Identity
local VMatrix_SetField = debug.getregistry ().VMatrix.SetField
function GCAD.Matrix3x3.MatrixMatrixMultiply2 (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	VMatrix_Identity (vmatrix1)
	VMatrix_SetField (vmatrix1, 1, 1, a [1]) VMatrix_SetField (vmatrix1, 1, 2, a [2]) VMatrix_SetField (vmatrix1, 1, 3, a [3])
	VMatrix_SetField (vmatrix1, 2, 1, a [4]) VMatrix_SetField (vmatrix1, 2, 2, a [5]) VMatrix_SetField (vmatrix1, 2, 3, a [6])
	VMatrix_SetField (vmatrix1, 3, 1, a [7]) VMatrix_SetField (vmatrix1, 3, 2, a [8]) VMatrix_SetField (vmatrix1, 3, 3, a [9])
	
	VMatrix_Identity (vmatrix2)
	VMatrix_SetField (vmatrix2, 1, 1, b [1]) VMatrix_SetField (vmatrix2, 1, 2, b [2]) VMatrix_SetField (vmatrix2, 1, 3, b [3])
	VMatrix_SetField (vmatrix2, 2, 1, b [4]) VMatrix_SetField (vmatrix2, 2, 2, b [5]) VMatrix_SetField (vmatrix2, 2, 3, b [6])
	VMatrix_SetField (vmatrix2, 3, 1, b [7]) VMatrix_SetField (vmatrix2, 3, 2, b [8]) VMatrix_SetField (vmatrix2, 3, 3, b [9])
	
	local c = vmatrix1 * vmatrix2
	out [1] = VMatrix_GetField (c, 1, 1) out [2] = VMatrix_GetField (c, 1, 2) out [3] = VMatrix_GetField (c, 1, 3)
	out [4] = VMatrix_GetField (c, 2, 1) out [5] = VMatrix_GetField (c, 2, 2) out [6] = VMatrix_GetField (c, 2, 3)
	out [7] = VMatrix_GetField (c, 3, 1) out [8] = VMatrix_GetField (c, 3, 2) out [9] = VMatrix_GetField (c, 3, 3)
	
	return out
end

local GCAD_Matrix3x3_ScalarMatrixMultiply = GCAD.Matrix3x3.ScalarMatrixMultiply
local GCAD_Matrix3x3_MatrixMatrixMultiply = GCAD.Matrix3x3.MatrixMatrixMultiply
local GCAD_Matrix3x3_VectorMatrixMultiply = GCAD.Matrix3x3.VectorMatrixMultiply
local GCAD_Matrix3x3_MatrixVectorMultiply = GCAD.Matrix3x3.MatrixVectorMultiply

function GCAD.Matrix3x3.Multiply (a, b, out)
	if isnumber (a) then
		return GCAD_Matrix3x3_ScalarMatrixMultiply (a, b, out)
	elseif isnumber (b) then
		return GCAD_Matrix3x3_MatrixScalarMultiply (a, b, out)
	elseif #a == 9 and #b == 9 then
		return GCAD_Matrix3x3_MatrixMatrixMultiply (a, b, out)
	elseif #a == 3 then
		return GCAD_Matrix3x3_VectorMatrixMultiply (a, b, out)
	elseif #b == 3 then
		return GCAD_Matrix3x3_MatrixVectorMultiply (a, b, out)
	end
	
	GCAD.Error ("Matrix3x3.Multiply : Invalid argument types!")
	
	return out
end

function GCAD.Matrix3x3.ScalarDivide (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = a [1] / b
	out [2] = a [2] / b
	out [3] = a [3] / b
	out [4] = a [4] / b
	out [5] = a [5] / b
	out [6] = a [6] / b
	out [7] = a [7] / b
	out [8] = a [8] / b
	out [9] = a [9] / b
	
	return out
end

function GCAD.Matrix3x3.Negate (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = -self [1]
	out [2] = -self [2]
	out [3] = -self [3]
	out [4] = -self [4]
	out [5] = -self [5]
	out [6] = -self [6]
	out [7] = -self [7]
	out [8] = -self [8]
	out [9] = -self [9]
	
	return out
end

-- Utility
function GCAD.Matrix3x3.Unpack (self)
	return self [1], self [2], self [3], self [4], self [5], self [6], self [7], self [8], self [9]
end

function GCAD.Matrix3x3.ToString (self)
	return "[" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .. "]\n[" .. tostring (self [4]) .. ", " .. tostring (self [5]) .. ", " .. tostring (self [6]) .. "]\n[" .. tostring (self [7]) .. ", " .. tostring (self [8]) .. ", " .. tostring (self [9]) .. "]"
end

-- Construction
function GCAD.Matrix3x3.Identity (out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = 1
	out [2] = 0
	out [3] = 0
	out [4] = 0
	out [5] = 1
	out [6] = 0
	out [7] = 0
	out [8] = 0
	out [9] = 1
	
	return out
end

function GCAD.Matrix3x3.Rotate (angle, out)
	return GCAD.EulerAngle.ToMatrix3x3 (angle, out)
end

function GCAD.Matrix3x3.RotateUnpacked (p, y, r, out)
	return GCAD.UnpackedEulerAngle.ToMatrix3x3 (p, y, r, out)
end

function GCAD.Matrix3x3.Scale (v3d, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = v3d [1],       0,       0
	out [4], out [5], out [6] =       0, v3d [2],       0
	out [7], out [8], out [9] =       0,       0, v3d [3]
	
	return out
end

function GCAD.Matrix3x3.ScaleUnpacked (x, y, z, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = x, 0, 0
	out [4], out [5], out [6] = 0, y, 0
	out [7], out [8], out [9] = 0, 0, z
	
	return out
end

function GCAD.Matrix3x3.Zero (out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1] = 0
	out [2] = 0
	out [3] = 0
	out [4] = 0
	out [5] = 0
	out [6] = 0
	out [7] = 0
	out [8] = 0
	out [9] = 0
	
	return out
end

-- Constructor
function self:ctor (m11, m12, m13, m21, m22, m23, m31, m32, m33)
	self [1] = m11 or 0
	self [2] = m12 or 0
	self [3] = m13 or 0
	self [4] = m21 or 0
	self [5] = m22 or 0
	self [6] = m23 or 0
	self [7] = m31 or 0
	self [8] = m32 or 0
	self [9] = m33 or 0
end

-- Initialization
function self:Set (m11, m12, m21, m22, m23, m31, m32, m33)
	self [1] = m11
	self [2] = m12
	self [3] = m13
	self [4] = m21
	self [5] = m22
	self [6] = m23
	self [7] = m31
	self [8] = m32
	self [9] = m33
	
	return self
end

local GCAD_Matrix3x3_Identity = GCAD.Matrix3x3.Identity
local GCAD_Matrix3x3_Zero     = GCAD.Matrix3x3.Zero

function self:Identity () return GCAD_Matrix3x3_Identity (self) end
function self:Zero     () return GCAD_Matrix3x3_Zero     (self) end

-- Copying
self.Clone          = GCAD.Matrix3x3.Clone
self.Copy           = GCAD.Matrix3x3.Copy

-- Matrix reading
self.GetColumn      = GCAD.Matrix3x3.GetColumn
self.GetDiagonal    = GCAD.Matrix3x3.GetDiagonal
self.GetRow         = GCAD.Matrix3x3.GetRow

-- Matrix operations
self.Determinant    = GCAD.Matrix3x3.Determinant
self.Invert         = GCAD.Matrix3x3.Invert
self.Transpose      = GCAD.Matrix3x3.Transpose

-- Matrix arithmetic
self.Add            = GCAD.Matrix3x3.Add
self.Subtract       = GCAD.Matrix3x3.Subtract
self.Multiply       = GCAD.Matrix3x3.Multiply
self.ScalarMultiply = GCAD.Matrix3x3.MatrixScalarMultiply
self.ScalarDivide   = GCAD.Matrix3x3.ScalarDivide
self.MatrixMultiply = GCAD.Matrix3x3.MatrixMatrixMultiply
self.VectorMultiply = GCAD.Matrix3x3.MatrixVectorMultiply
self.Negate         = GCAD.Matrix3x3.Negate

self.__add          = GCAD.Matrix3x3.Add
self.__sub          = GCAD.Matrix3x3.Subtract
self.__mul          = GCAD.Matrix3x3.Multiply
self.__div          = GCAD.Matrix3x3.ScalarDivide
self.__unm          = GCAD.Matrix3x3.Negate

-- Utility
self.Unpack         = GCAD.Matrix3x3.Unpack
self.ToString       = GCAD.Matrix3x3.ToString
self.__tostring     = GCAD.Matrix3x3.ToString
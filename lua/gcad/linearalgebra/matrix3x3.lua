local self = {}
GCAD.Matrix3x3 = GCAD.MakeConstructor (self)

local isnumber          = isnumber

local math              = math

local Matrix            = Matrix

local Vector            = Vector
local Vector___index    = debug.getregistry ().Vector.__index
local Vector___newindex = debug.getregistry ().Vector.__newindex
local VMatrix_GetField  = debug.getregistry ().VMatrix.GetField
local VMatrix_Identity  = debug.getregistry ().VMatrix.Identity
local VMatrix_SetField  = debug.getregistry ().VMatrix.SetField

-- Copying
function GCAD.Matrix3x3.Clone (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = self [1], self [2], self [3]
	out [4], out [5], out [6] = self [4], self [5], self [6]
	out [7], out [8], out [9] = self [7], self [8], self [9]
	
	return out
end

function GCAD.Matrix3x3.Copy (self, source)
	self [1], self [2], self [3] = source [1], source [2], source [3]
	self [4], self [5], self [6] = source [4], source [5], source [6]
	self [7], self [8], self [9] = source [7], source [8], source [9]
	
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

function GCAD.Matrix3x3.GetColumnNative (self, column, out)
	out = out or Vector ()
	
	Vector___newindex (out, "x", self [column + 0])
	Vector___newindex (out, "y", self [column + 3])
	Vector___newindex (out, "z", self [column + 6])
	
	return out
end

function GCAD.Matrix3x3.GetColumnUnpacked (self, column)
	return self [column + 0], self [column + 3], self [column + 6]
end

function GCAD.Matrix3x3.GetDiagonal (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [1]
	out [2] = self [5]
	out [3] = self [9]
	
	return out
end

function GCAD.Matrix3x3.GetDiagonalNative (self, out)
	out = out or Vector ()
	
	Vector___newindex (out, "x", self [1])
	Vector___newindex (out, "y", self [5])
	Vector___newindex (out, "z", self [9])
	
	return out
end

function GCAD.Matrix3x3.GetDiagonalUnpacked (self)
	return self [1], self [5], self [9]
end

function GCAD.Matrix3x3.GetRow (self, row, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [row * 3 - 3 + 1]
	out [2] = self [row * 3 - 3 + 2]
	out [3] = self [row * 3 - 3 + 3]
	
	return out
end

function GCAD.Matrix3x3.GetRowNative (self, row, out)
	out = out or Vector ()
	
	Vector___newindex (out, "x", self [row * 3 - 3 + 1])
	Vector___newindex (out, "y", self [row * 3 - 3 + 2])
	Vector___newindex (out, "z", self [row * 3 - 3 + 3])
	
	return out
end

function GCAD.Matrix3x3.GetRowUnpacked (self, row)
	return self [row * 3 - 3 + 1], self [row * 3 - 3 + 2], self [row * 3 - 3 + 3]
end

function GCAD.Matrix3x3.SetColumn (self, column, v3d)
	self [column + 0] = v3d [1]
	self [column + 3] = v3d [2]
	self [column + 6] = v3d [3]
	
	return self
end

function GCAD.Matrix3x3.SetColumnNative (self, column, v)
	self [column + 0] = Vector___index (v, "x")
	self [column + 3] = Vector___index (v, "y")
	self [column + 6] = Vector___index (v, "z")
	
	return self
end

function GCAD.Matrix3x3.SetColumnUnpacked (self, column, x, y, z)
	self [column + 0] = x
	self [column + 3] = y
	self [column + 6] = z
	
	return self
end

function GCAD.Matrix3x3.SetDiagonal (self, v3d)
	self [1] = v3d [1]
	self [5] = v3d [2]
	self [9] = v3d [3]
	
	return self
end

function GCAD.Matrix3x3.SetDiagonalNative (self, v)
	self [1] = Vector___index (v, "x")
	self [5] = Vector___index (v, "y")
	self [9] = Vector___index (v, "z")
	
	return self
end

function GCAD.Matrix3x3.SetDiagonalUnpacked (self, x, y, z)
	self [1] = x
	self [5] = y
	self [9] = z
	
	return self
end

function GCAD.Matrix3x3.SetRow (self, row, v3d)
	self [row * 3 - 3 + 1] = v3d [1]
	self [row * 3 - 3 + 2] = v3d [2]
	self [row * 3 - 3 + 3] = v3d [3]
	
	return self
end

function GCAD.Matrix3x3.SetRowNative (self, row, v)
	self [row * 3 - 3 + 1] = Vector___index (v, "x")
	self [row * 3 - 3 + 2] = Vector___index (v, "y")
	self [row * 3 - 3 + 3] = Vector___index (v, "z")
	
	return self
end

function GCAD.Matrix3x3.SetRowUnpacked (self, row, x, y, z)
	self [row * 3 - 3 + 1] = x
	self [row * 3 - 3 + 2] = y
	self [row * 3 - 3 + 3] = z
	
	return self
end

-- Matrix operations
function GCAD.Matrix3x3.Determinant (self)
	return   self [1] * (self [5] * self [9] - self [8] * self [6])
	       - self [2] * (self [4] * self [9] - self [7] * self [6])
	       + self [3] * (self [4] * self [8] - self [7] * self [5])
end

function GCAD.Matrix3x3.Determinant2x2 (self)
	return  self [1] * self [5] - self [4] * self [2]
end

local GCAD_Matrix3x3_Determinant = GCAD.Matrix3x3.Determinant
function GCAD.Matrix3x3.Invert (self, out)
	if out == self then out = nil end
	out = out or GCAD.Matrix3x3 ()
	
	local inverseDeterminant = 1 / GCAD_Matrix3x3_Determinant (self)
	local m11, m12, m13 = self [1], self [2], self [3]
	local m21, m22, m23 = self [4], self [5], self [6]
	local m31, m32, m33 = self [7], self [8], self [9]
	out [1] =  (m22 * m33 - m32 * m23) * inverseDeterminant
	out [2] = -(m12 * m33 - m32 * m13) * inverseDeterminant
	out [3] =  (m12 * m23 - m22 * m13) * inverseDeterminant
	
	out [4] = -(m21 * m33 - m31 * m23) * inverseDeterminant
	out [5] =  (m11 * m33 - m31 * m13) * inverseDeterminant
	out [6] = -(m11 * m23 - m21 * m13) * inverseDeterminant
	
	out [7] =  (m21 * m32 - m31 * m22) * inverseDeterminant
	out [8] = -(m11 * m32 - m31 * m12) * inverseDeterminant
	out [9] =  (m11 * m22 - m21 * m12) * inverseDeterminant
	
	return out
end

local GCAD_Matrix3x3_Determinant2x2 = GCAD.Matrix3x3.Determinant2x2
function GCAD.Matrix3x3.InvertAffine (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	-- A = T M
	-- I =    InvA      A    =   A       InvA
	--   =    InvA     T M   =  T M      InvA
	--   = InvM InvT   T M   =  T M   InvM InvT
	
	-- InvT = [ I -T ]
	--      = [ 0  1 ]
	
	-- InvM = [ InvM 0 ]
	--      = [    0 1 ]
	
	-- InvA = [ InvM (InvM * -T) ]
	--      = [    0           1 ]
	
	-- Inline expansion of Matrix2x2:Invert ()
	local inverseDeterminant = 1 / GCAD_Matrix3x3_Determinant2x2 (self)
	out [1], out [5] = self [5] * inverseDeterminant, self [1] * inverseDeterminant
	out [2] = -self [2] * inverseDeterminant
	out [4] = -self [4] * inverseDeterminant
	
	-- Inline expansion of Matrix2x2:MatrixUnpackedVectorMultiply ()
	local tx, ty = -self [3], -self [6]
	out [3] = tx * out [1] + ty * out [2]
	out [6] = tx * out [4] + ty * out [5]
	
	-- Set the last row
	out [7], out [8], out [9] = 0, 0, 1
	
	return out
end

function GCAD.Matrix3x3.InvertAffineOrthonormal (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	-- Inline expansion of Matrix2x2:Transpose ()
	out [1] = self [1]
	out [5] = self [5]
	out [2], out [4] = self [4], self [2]
	
	-- Inline expansion of Matrix2x2:MatrixUnpackedVectorMultiply ()
	local tx, ty = -self [3], -self [6]
	out [3] = tx * out [1] + ty * out [2]
	out [6] = tx * out [4] + ty * out [5]
	
	-- Set the last row
	out [7], out [8], out [9] = 0, 0, 1
	
	return out
end

local math_abs                   = math.abs
local math_huge                  = math.huge
local GCAD_Matrix3x3_Clone       = GCAD.Matrix3x3.Clone
local GCAD_Matrix3x3_Determinant = GCAD.Matrix3x3.Determinant
local left
function GCAD.Matrix3x3.InvertGaussian (self, out)
	if out == self then out = nil end
	out = out or GCAD.Matrix3x3 ()
	
	-- [ M I ]
	left = GCAD_Matrix3x3_Clone (self, left)
	local right = GCAD.Matrix3x3.Identity (out)
	
	-- We want to turn this into [ I M ^ -1 ]
	
	for x = 0, 2 do
		-- Find the biggest row
		local largestElement  = -math_huge
		local largestElementY = 0
		for y = x, 2 do
			if math_abs (left [1 + y * 3 + x]) >= largestElement then
				largestElement  = math_abs (left [1 + y * 3 + x])
				largestElementY = y
			end
		end
		
		-- Get the row elements
		local i = 1 + largestElementY * 3
		local l1, r1 = left [i + 0], right [i + 0]
		local l2, r2 = left [i + 1], right [i + 1]
		local l3, r3 = left [i + 2], right [i + 2]
		largestElement = left [i + x]
		
		-- Swap rows
		local i1 = 1 + largestElementY * 3
		local i2 = 1 + x * 3
		left  [i1 + 0], left  [i2 + 0] = left  [i2 + 0], l1
		left  [i1 + 1], left  [i2 + 1] = left  [i2 + 1], l2
		left  [i1 + 2], left  [i2 + 2] = left  [i2 + 2], l3
		right [i1 + 0], right [i2 + 0] = right [i2 + 0], r1
		right [i1 + 1], right [i2 + 1] = right [i2 + 1], r2
		right [i1 + 2], right [i2 + 2] = right [i2 + 2], r3
		
		-- Now mess around
		for y = 0, 2 do
			local i = 1 + y * 3
			local k = y == x and ((left [i + x] - 1) / largestElement) or (left [i + x] / largestElement)
			left  [i + 0] = left  [i + 0] - k * l1
			left  [i + 1] = left  [i + 1] - k * l2
			left  [i + 2] = left  [i + 2] - k * l3
			right [i + 0] = right [i + 0] - k * r1
			right [i + 1] = right [i + 1] - k * r2
			right [i + 2] = right [i + 2] - k * r3
		end
	end
	
	return out
end

function GCAD.Matrix3x3.InvertOrthonormal (self, out)
	return GCAD.Matrix3x3.Transpose (self, out)
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
	
	out [1], out [2], out [3] = a [1] + b [1], a [2] + b [2], a [3] + b [3]
	out [4], out [5], out [6] = a [4] + b [4], a [5] + b [5], a [6] + b [6]
	out [7], out [8], out [9] = a [7] + b [7], a [8] + b [8], a [9] + b [9]
	
	return out
end

function GCAD.Matrix3x3.Subtract (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = a [1] - b [1], a [2] - b [2], a [3] - b [3]
	out [4], out [5], out [6] = a [4] - b [4], a [5] - b [5], a [6] - b [6]
	out [7], out [8], out [9] = a [7] - b [7], a [8] - b [8], a [9] - b [9]
	
	return out
end

function GCAD.Matrix3x3.MatrixScalarMultiply (a, b, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = a [1] * b, a [2] * b, a [3] * b
	out [4], out [5], out [6] = a [4] * b, a [5] * b, a [6] * b
	out [7], out [8], out [9] = a [7] * b, a [8] * b, a [9] * b
	
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

function GCAD.Matrix3x3.MatrixUnpackedVectorMultiply (a, x, y, z)
	return a [1] * x + a [2] * y + a [3] * z,
	       a [4] * x + a [5] * y + a [6] * z,
	       a [7] * x + a [8] * y + a [9] * z
end

function GCAD.Matrix3x3.VectorMatrixMultiply (a, b, out)
	out = out or GCAD.Vector3d ()
	
	local x, y, z = a [1], a [2], a [3]
	out [1] = x * b [1] + y * b [4] + z * b [7]
	out [2] = x * b [2] + y * b [5] + z * b [8]
	out [3] = x * b [3] + y * b [6] + z * b [9]
	
	return out
end

function GCAD.Matrix3x3.UnpackedVectorMatrixMultiply (x, y, z, b)
	return x * b [1] + y * b [4] + z * b [7],
	       x * b [2] + y * b [5] + z * b [8],
	       x * b [3] + y * b [6] + z * b [9]
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
function GCAD.Matrix3x3.MatrixMatrixMultiply2 (a, b, out)
	GCAD.Matrix3x3.ToNativeMatrix (a, vmatrix1)
	GCAD.Matrix3x3.ToNativeMatrix (b, vmatrix2)
	return GCAD.Matrix3x3.FromNativeMatrix (vmatrix * vmatrix2, out)
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
	
	b = 1 / b
	out [1], out [2], out [3] = a [1] * b, a [2] * b, a [3] * b
	out [4], out [5], out [6] = a [4] * b, a [5] * b, a [6] * b
	out [7], out [8], out [9] = a [7] * b, a [8] * b, a [9] * b
	
	return out
end

function GCAD.Matrix3x3.Negate (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = -self [1], -self [2], -self [3]
	out [4], out [5], out [6] = -self [4], -self [5], -self [6]
	out [7], out [8], out [9] = -self [7], -self [8], -self [9]
	
	return out
end

-- Conversion
function GCAD.Matrix3x3.FromMatrix2x2 (matrix, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = matrix [1], matrix [2], 0
	out [4], out [5], out [6] = matrix [3], matrix [4], 0
	out [7], out [8], out [9] =          0,          0, 1
	
	return out
end

function GCAD.Matrix3x3.ToMatrix2x2 (self, out)
	out = out or GCAD.Matrix2x2 ()
	
	out [1], out [2] = self [1], self [2]
	out [3], out [4] = self [4], self [5]
	
	return out
end

function GCAD.Matrix3x3.FromMatrix4x4 (matrix, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = matrix [ 1], matrix [ 2], matrix [ 3]
	out [4], out [5], out [6] = matrix [ 5], matrix [ 6], matrix [ 7]
	out [7], out [8], out [9] = matrix [ 9], matrix [10], matrix [11]
	
	return out
end

function GCAD.Matrix3x3.ToMatrix4x4 (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = self [1], self [2], self [3], 0
	out [ 5], out [ 6], out [ 7], out [ 8] = self [4], self [5], self [6], 0
	out [ 9], out [10], out [11], out [12] = self [7], self [8], self [9], 0
	out [13], out [14], out [15], out [16] =        0,        0,        0, 1
	
	return out
end

function GCAD.Matrix3x3.FromNativeMatrix (matrix, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = VMatrix_GetField (matrix, 1, 1), VMatrix_GetField (matrix, 1, 2), VMatrix_GetField (matrix, 1, 3)
	out [4], out [5], out [6] = VMatrix_GetField (matrix, 2, 1), VMatrix_GetField (matrix, 2, 2), VMatrix_GetField (matrix, 2, 3)
	out [7], out [8], out [9] = VMatrix_GetField (matrix, 3, 1), VMatrix_GetField (matrix, 3, 2), VMatrix_GetField (matrix, 3, 3)
	
	return out
end

function GCAD.Matrix3x3.ToNativeMatrix (self, out)
	out = out or Matrix ()
	
	VMatrix_Identity (out)
	VMatrix_SetField (out, 1, 1, self [1]) VMatrix_SetField (out, 1, 2, self [2]) VMatrix_SetField (out, 1, 3, self [3])
	VMatrix_SetField (out, 2, 1, self [4]) VMatrix_SetField (out, 2, 2, self [5]) VMatrix_SetField (out, 2, 3, self [6])
	VMatrix_SetField (out, 3, 1, self [7]) VMatrix_SetField (out, 3, 2, self [8]) VMatrix_SetField (out, 3, 3, self [9])
	
	return out
end

-- Utility
function GCAD.Matrix3x3.Unpack (self)
	return self [1], self [2], self [3],
	       self [4], self [5], self [6],
	       self [7], self [8], self [9]
end

function GCAD.Matrix3x3.ToString (self)
	return "[" .. tostring (self [1]) .. ", " .. tostring (self [2]) .. ", " .. tostring (self [3]) .. "]\n" ..
	       "[" .. tostring (self [4]) .. ", " .. tostring (self [5]) .. ", " .. tostring (self [6]) .. "]\n" ..
	       "[" .. tostring (self [7]) .. ", " .. tostring (self [8]) .. ", " .. tostring (self [9]) .. "]"
end

-- Construction
function GCAD.Matrix3x3.Identity (out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = 1, 0, 0
	out [4], out [5], out [6] = 0, 1, 0
	out [7], out [8], out [9] = 0, 0, 1
	
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
	
	out [1], out [2], out [3] = 0, 0, 0
	out [4], out [5], out [6] = 0, 0, 0
	out [7], out [8], out [9] = 0, 0, 0
	
	return out
end

-- Constructor
function self:ctor (m11, m12, m13,
                    m21, m22, m23,
                    m31, m32, m33)
	
	self [1], self [2], self [3] = m11 or 0, m12 or 0, m13 or 0
	self [4], self [5], self [6] = m21 or 0, m22 or 0, m23 or 0
	self [7], self [8], self [9] = m31 or 0, m32 or 0, m33 or 0
end

-- Initialization
function self:Set (m11, m12, m13,
                   m21, m22, m23,
                   m31, m32, m33)
	
	self [1], self [2], self [3] = m11, m12, m13
	self [4], self [5], self [6] = m21, m22, m23
	self [7], self [8], self [9] = m31, m32, m33
	
	return self
end

local GCAD_Matrix3x3_Identity = GCAD.Matrix3x3.Identity
local GCAD_Matrix3x3_Zero     = GCAD.Matrix3x3.Zero

function self:Identity () return GCAD_Matrix3x3_Identity (self) end
function self:Zero     () return GCAD_Matrix3x3_Zero     (self) end

-- Copying
self.Clone                   = GCAD.Matrix3x3.Clone
self.Copy                    = GCAD.Matrix3x3.Copy

-- Matrix reading
self.GetColumn               = GCAD.Matrix3x3.GetColumn
self.GetColumnNative         = GCAD.Matrix3x3.GetColumnNative
self.GetColumnUnpacked       = GCAD.Matrix3x3.GetColumnUnpacked
self.GetDiagonal             = GCAD.Matrix3x3.GetDiagonal
self.GetDiagonalNative       = GCAD.Matrix3x3.GetDiagonalNative
self.GetDiagonalUnpacked     = GCAD.Matrix3x3.GetDiagonalUnpacked
self.GetRow                  = GCAD.Matrix3x3.GetRow
self.GetRowNative            = GCAD.Matrix3x3.GetRowNative
self.GetRowUnpacked          = GCAD.Matrix3x3.GetRowUnpacked
self.SetColumn               = GCAD.Matrix3x3.SetColumn
self.SetColumnNative         = GCAD.Matrix3x3.SetColumnNative
self.SetColumnUnpacked       = GCAD.Matrix3x3.SetColumnUnpacked
self.SetDiagonal             = GCAD.Matrix3x3.SetDiagonal
self.SetDiagonalNative       = GCAD.Matrix3x3.SetDiagonalNative
self.SetDiagonalUnpacked     = GCAD.Matrix3x3.SetDiagonalUnpacked
self.SetRow                  = GCAD.Matrix3x3.SetRow
self.SetRowNative            = GCAD.Matrix3x3.SetRowNative
self.SetRowUnpacked          = GCAD.Matrix3x3.SetRowUnpacked

-- Matrix operations
self.Determinant             = GCAD.Matrix3x3.Determinant
self.Invert                  = GCAD.Matrix3x3.Invert
self.InvertAffine            = GCAD.Matrix3x3.InvertAffine
self.InvertAffineOrthonormal = GCAD.Matrix3x3.InvertAffineOrthonormal
self.InvertOrthonormal       = GCAD.Matrix3x3.InvertOrthonormal
self.Transpose               = GCAD.Matrix3x3.Transpose

-- Matrix arithmetic
self.Add                     = GCAD.Matrix3x3.Add
self.Subtract                = GCAD.Matrix3x3.Subtract
self.Multiply                = GCAD.Matrix3x3.Multiply
self.ScalarMultiply          = GCAD.Matrix3x3.MatrixScalarMultiply
self.ScalarDivide            = GCAD.Matrix3x3.ScalarDivide
self.MatrixMultiply          = GCAD.Matrix3x3.MatrixMatrixMultiply
self.VectorMultiply          = GCAD.Matrix3x3.MatrixVectorMultiply
self.UnpackedVectorMultiply  = GCAD.Matrix3x3.MatrixUnpackedVectorMultiply
self.Negate                  = GCAD.Matrix3x3.Negate

self.__add                   = GCAD.Matrix3x3.Add
self.__sub                   = GCAD.Matrix3x3.Subtract
self.__mul                   = GCAD.Matrix3x3.Multiply
self.__div                   = GCAD.Matrix3x3.ScalarDivide
self.__unm                   = GCAD.Matrix3x3.Negate

-- Conversion
self.ToMatrix2x2             = GCAD.Matrix3x3.ToMatrix2x2
self.ToMatrix4x4             = GCAD.Matrix3x3.ToMatrix4x4
self.ToNativeMatrix          = GCAD.Matrix3x3.ToNativeMatrix

-- Utility
self.Unpack                  = GCAD.Matrix3x3.Unpack
self.ToString                = GCAD.Matrix3x3.ToString
self.__tostring              = GCAD.Matrix3x3.ToString
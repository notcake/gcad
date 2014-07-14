local self = {}
GCAD.Matrix4x4 = GCAD.MakeConstructor (self)

local isnumber                      = isnumber

local Matrix                        = Matrix

local Vector                        = Vector
local Vector___index                = debug.getregistry ().Vector.__index
local Vector___newindex             = debug.getregistry ().Vector.__newindex
local VMatrix_GetField              = debug.getregistry ().VMatrix.GetField
local VMatrix_Identity              = debug.getregistry ().VMatrix.Identity
local VMatrix_SetField              = debug.getregistry ().VMatrix.SetField

local GCAD_Matrix3x3_Eigenvalues    = GCAD.Matrix3x3.Eigenvalues
local GCAD_Matrix3x3_SingularValues = GCAD.Matrix3x3.SingularValues

-- Copying
function GCAD.Matrix4x4.Clone (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = self [ 1], self [ 2], self [ 3], self [ 4]
	out [ 5], out [ 6], out [ 7], out [ 8] = self [ 5], self [ 6], self [ 7], self [ 8]
	out [ 9], out [10], out [11], out [12] = self [ 9], self [10], self [11], self [12]
	out [13], out [14], out [15], out [16] = self [13], self [14], self [15], self [16]
	
	return out
end

function GCAD.Matrix4x4.Copy (self, source)
	self [ 1], self [ 2], self [ 3], self [ 4] = source [ 1], source [ 2], source [ 3], source [ 4]
	self [ 5], self [ 6], self [ 7], self [ 8] = source [ 5], source [ 6], source [ 7], source [ 8]
	self [ 9], self [10], self [11], self [12] = source [ 9], source [10], source [11], source [12]
	self [13], self [14], self [15], self [16] = source [13], source [14], source [15], source [16]
	
	return self
end

-- Matrix reading
function GCAD.Matrix4x4.GetColumn (self, column, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = self [column +  0]
	out [2] = self [column +  4]
	out [3] = self [column +  8]
	out [4] = self [column + 12]
	
	return out
end

function GCAD.Matrix4x4.GetColumnNative (self, column, out)
	out = out or Vector ()
	
	Vector___newindex (out, 1, self [column +  0])
	Vector___newindex (out, 2, self [column +  4])
	Vector___newindex (out, 3, self [column +  8])
	
	return out, self [column + 12]
end

function GCAD.Matrix4x4.GetColumnUnpacked (self, column)
	return self [column + 0], self [column + 4], self [column + 8], self [column + 12]
end

function GCAD.Matrix4x4.GetDiagonal (self, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = self [ 1]
	out [2] = self [ 6]
	out [3] = self [11]
	out [4] = self [16]
	
	return out
end

function GCAD.Matrix4x4.GetDiagonalNative (self, out)
	out = out or Vector ()
	
	Vector___newindex (out, 1, self [ 1])
	Vector___newindex (out, 2, self [ 6])
	Vector___newindex (out, 3, self [11])
	
	return out, self [16]
end

function GCAD.Matrix4x4.GetDiagonalUnpacked (self)
	return self [1], self [6], self [11], self [16]
end

function GCAD.Matrix4x4.GetRow (self, row, out)
	out = out or GCAD.Vector4d ()
	
	out [1] = self [row * 4 - 4 + 1]
	out [2] = self [row * 4 - 4 + 2]
	out [3] = self [row * 4 - 4 + 3]
	out [4] = self [row * 4 - 4 + 4]
	
	return out
end

function GCAD.Matrix4x4.GetRowNative (self, row, out)
	out = out or Vector ()
	
	Vector___newindex (out, 1, self [row * 4 - 4 + 1])
	Vector___newindex (out, 2, self [row * 4 - 4 + 2])
	Vector___newindex (out, 3, self [row * 4 - 4 + 3])
	
	return out, self [row * 4 - 4 + 4]
end

function GCAD.Matrix4x4.GetRowUnpacked (self, row)
	return self [row * 4 - 4 + 1], self [row * 4 - 4 + 2], self [row * 4 - 4 + 3], self [row * 4 - 4 + 4]
end

function GCAD.Matrix4x4.SetColumn (self, column, v4d)
	self [column +  0] = v4d [1]
	self [column +  4] = v4d [2]
	self [column +  8] = v4d [3]
	self [column + 12] = v4d [4] or self [column + 12]
	
	return self
end

function GCAD.Matrix4x4.SetColumnNative (self, column, v, w)
	self [column +  0] = Vector___index (v, 1)
	self [column +  4] = Vector___index (v, 2)
	self [column +  8] = Vector___index (v, 3)
	self [column + 12] = w or self [column + 12]
	
	return self
end

function GCAD.Matrix4x4.SetColumnUnpacked (self, column, x, y, z, w)
	self [column +  0] = x
	self [column +  4] = y
	self [column +  8] = z
	self [column + 12] = w or self [column + 12]
	
	return self
end

function GCAD.Matrix4x4.SetDiagonal (self, v4d)
	self [ 1] = v4d [1]
	self [ 6] = v4d [2]
	self [11] = v4d [3]
	self [16] = v4d [4] or self [16]
	
	return self
end

function GCAD.Matrix4x4.SetDiagonalNative (self, v, w)
	self [ 1] = Vector___index (v, 1)
	self [ 6] = Vector___index (v, 2)
	self [11] = Vector___index (v, 3)
	self [16] = w or self [16]
	
	return self
end

function GCAD.Matrix4x4.SetDiagonalUnpacked (self, x, y, z, w)
	self [ 1] = x
	self [ 6] = y
	self [11] = z
	self [16] = w or self [16]
	
	return self
end

function GCAD.Matrix4x4.SetRow (self, row, v4d)
	self [row * 4 - 4 + 1] = v4d [1]
	self [row * 4 - 4 + 2] = v4d [2]
	self [row * 4 - 4 + 3] = v4d [3]
	self [row * 4 - 4 + 4] = v4d [4] or self [row * 4 - 4 + 4]
	
	return self
end

function GCAD.Matrix4x4.SetRowNative (self, row, v, w)
	self [row * 4 - 4 + 1] = Vector___index (v, 1)
	self [row * 4 - 4 + 2] = Vector___index (v, 2)
	self [row * 4 - 4 + 3] = Vector___index (v, 3)
	self [row * 4 - 4 + 4] = w or self [row * 4 - 4 + 4]
	
	return self
end

function GCAD.Matrix4x4.SetRowUnpacked (self, row, x, y, z, w)
	self [row * 4 - 4 + 1] = x
	self [row * 4 - 4 + 2] = y
	self [row * 4 - 4 + 3] = z
	self [row * 4 - 4 + 4] = w or self [row * 4 - 4 + 4]
	
	return self
end

-- Matrix properties
function GCAD.Matrix4x4.Determinant (self)
	return   self [1] * (  self [ 6] * (self [11] * self [16] - self [15] * self [12])
	                     - self [ 7] * (self [10] * self [16] - self [14] * self [12])
	                     + self [ 8] * (self [10] * self [15] - self [14] * self [11]))
	       - self [2] * (  self [ 5] * (self [11] * self [16] - self [15] * self [12])
	                     - self [ 7] * (self [ 9] * self [16] - self [13] * self [12])
	                     + self [ 8] * (self [ 9] * self [15] - self [13] * self [11]))
	       + self [3] * (  self [ 5] * (self [10] * self [16] - self [14] * self [12])
	                     - self [ 6] * (self [ 9] * self [16] - self [13] * self [12])
	                     + self [ 8] * (self [ 9] * self [14] - self [13] * self [10]))
	       - self [4] * (  self [ 5] * (self [10] * self [15] - self [14] * self [11])
	                     - self [ 6] * (self [ 9] * self [15] - self [13] * self [11])
	                     + self [ 7] * (self [ 9] * self [14] - self [13] * self [10]))
end

function GCAD.Matrix4x4.Determinant3x3 (self)
	return   self [1] * (self [ 6] * self [11] - self [10] * self [ 7])
	       - self [2] * (self [ 5] * self [11] - self [ 9] * self [ 7])
	       + self [3] * (self [ 5] * self [10] - self [ 9] * self [ 6])
end

function GCAD.Matrix4x4.Trace (self)
	return self [1] + self [6] + self [11] + self [16]
end

function GCAD.Matrix4x4.Trace3x3 (self)
	return self [1] + self [6] + self [11]
end

local matrix3x3 = nil
function GCAD.Matrix4x4.Eigenvalues3x3 (self)
	matrix3x3 = GCAD.Matrix4x4.ToMatrix3x3 (self, matrix3x3)
	return GCAD_Matrix3x3_Eigenvalues (matrix3x3)
end

function GCAD.Matrix4x4.SingularValues3x3 (self)
	matrix3x3 = GCAD.Matrix4x4.ToMatrix3x3 (self, matrix3x3)
	return GCAD_Matrix3x3_SingularValues (matrix3x3)
end

-- Matrix operations
local GCAD_Matrix4x4_Determinant = GCAD.Matrix4x4.Determinant
function GCAD.Matrix4x4.Invert (self, out)
	if out == self then out = nil end
	out = out or GCAD.Matrix4x4 ()
	
	local inverseDeterminant = 1 / GCAD_Matrix4x4_Determinant (self)
	local m11, m12, m13, m14 = self [ 1], self [ 2], self [ 3], self [ 4]
	local m21, m22, m23, m24 = self [ 5], self [ 6], self [ 7], self [ 8]
	local m31, m32, m33, m34 = self [ 9], self [10], self [11], self [12]
	local m41, m42, m43, m44 = self [13], self [14], self [15], self [16]
	
	-- Elements are calculated in this order
	-- because it's faster (believe it or not)
	local m33m44m43m34 = m33 * m44 - m43 * m34
	local m32m44m42m34 = m32 * m44 - m42 * m34
	local m32m43m42m33 = m32 * m43 - m42 * m33
	local m31m44m41m34 = m31 * m44 - m41 * m34
	local m31m43m41m33 = m31 * m43 - m41 * m33
	local m31m42m41m32 = m31 * m42 - m41 * m32
	out [ 1] =  (  m22 * (m33m44m43m34)
	             - m23 * (m32m44m42m34)
	             + m24 * (m32m43m42m33)) * inverseDeterminant
	out [ 2] = -(  m12 * (m33m44m43m34)
	             - m13 * (m32m44m42m34)
	             + m14 * (m32m43m42m33)) * inverseDeterminant
	out [ 5] = -(  m21 * (m33m44m43m34)
	             - m23 * (m31m44m41m34)
	             + m24 * (m31m43m41m33)) * inverseDeterminant
	out [ 6] =  (  m11 * (m33m44m43m34)
	             - m13 * (m31m44m41m34)
	             + m14 * (m31m43m41m33)) * inverseDeterminant
	out [ 9] =  (  m21 * (m32m44m42m34)
	             - m22 * (m31m44m41m34)
	             + m24 * (m31m42m41m32)) * inverseDeterminant
	out [10] = -(  m11 * (m32m44m42m34)
	             - m12 * (m31m44m41m34)
	             + m14 * (m31m42m41m32)) * inverseDeterminant
	out [13] = -(  m21 * (m32m43m42m33)
	             - m22 * (m31m43m41m33)
	             + m23 * (m31m42m41m32)) * inverseDeterminant
	out [14] =  (  m11 * (m32m43m42m33)
	             - m12 * (m31m43m41m33)
	             + m13 * (m31m42m41m32)) * inverseDeterminant
	
	local m23m44m43m24 = m23 * m44 - m43 * m24
	local m22m44m42m24 = m22 * m44 - m42 * m24
	local m22m43m42m23 = m22 * m43 - m42 * m23
	local m21m44m41m24 = m21 * m44 - m41 * m24
	local m21m43m41m23 = m21 * m43 - m41 * m23
	local m21m42m41m22 = m21 * m42 - m41 * m22
	out [ 3] =  (  m12 * (m23m44m43m24)
	             - m13 * (m22m44m42m24)
	             + m14 * (m22m43m42m23)) * inverseDeterminant
	out [ 7] = -(  m11 * (m23m44m43m24)
	             - m13 * (m21m44m41m24)
	             + m14 * (m21m43m41m23)) * inverseDeterminant
	out [11] =  (  m11 * (m22m44m42m24)
	             - m12 * (m21m44m41m24)
	             + m14 * (m21m42m41m22)) * inverseDeterminant
	out [15] = -(  m11 * (m22m43m42m23)
	             - m12 * (m21m43m41m23)
	             + m13 * (m21m42m41m22)) * inverseDeterminant
	
	local m23m34m33m24 = m23 * m34 - m33 * m24
	local m22m34m32m24 = m22 * m34 - m32 * m24
	local m22m33m32m23 = m22 * m33 - m32 * m23
	local m21m34m31m24 = m21 * m34 - m31 * m24
	local m21m33m31m23 = m21 * m33 - m31 * m23
	local m21m32m31m22 = m21 * m32 - m31 * m22
	out [ 4] = -(  m12 * (m23m34m33m24)
	             - m13 * (m22m34m32m24)
	             + m14 * (m22m33m32m23)) * inverseDeterminant
	out [ 8] =  (  m11 * (m23m34m33m24)
	             - m13 * (m21m34m31m24)
	             + m14 * (m21m33m31m23)) * inverseDeterminant
	out [12] = -(  m11 * (m22m34m32m24)
	             - m12 * (m21m34m31m24)
	             + m14 * (m21m32m31m22)) * inverseDeterminant
	out [16] =  (  m11 * (m22m33m32m23)
	             - m12 * (m21m33m31m23)
	             + m13 * (m21m32m31m22)) * inverseDeterminant
	
	return out
end

local GCAD_Matrix4x4_Determinant3x3 = GCAD.Matrix4x4.Determinant3x3
function GCAD.Matrix4x4.InvertAffine (self, out)
	if out == self then out = nil end
	out = out or GCAD.Matrix4x4 ()
	
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
	
	-- Inline expansion of Matrix3x3:Invert ()
	local inverseDeterminant = 1 / GCAD_Matrix4x4_Determinant3x3 (self)
	local m11, m12, m13 = self [ 1], self [ 2], self [ 3]
	local m21, m22, m23 = self [ 5], self [ 6], self [ 7]
	local m31, m32, m33 = self [ 9], self [10], self [11]
	out [ 1] =  (m22 * m33 - m32 * m23) * inverseDeterminant
	out [ 2] = -(m12 * m33 - m32 * m13) * inverseDeterminant
	out [ 3] =  (m12 * m23 - m22 * m13) * inverseDeterminant
	
	out [ 5] = -(m21 * m33 - m31 * m23) * inverseDeterminant
	out [ 6] =  (m11 * m33 - m31 * m13) * inverseDeterminant
	out [ 7] = -(m11 * m23 - m21 * m13) * inverseDeterminant
	
	out [ 9] =  (m21 * m32 - m31 * m22) * inverseDeterminant
	out [10] = -(m11 * m32 - m31 * m12) * inverseDeterminant
	out [11] =  (m11 * m22 - m21 * m12) * inverseDeterminant
	
	-- Inline expansion of Matrix3x3:MatrixUnpackedVectorMultiply ()
	local tx, ty, tz = -self [4], -self [8], -self [12]
	out [ 4] = tx * out [ 1] + ty * out [ 2] + tz * out [ 3]
	out [ 8] = tx * out [ 5] + ty * out [ 6] + tz * out [ 7]
	out [12] = tx * out [ 9] + ty * out [10] + tz * out [11]
	
	-- Set the last row
	out [13], out [14], out [15], out [16] = 0, 0, 0, 1
	
	return out
end

function GCAD.Matrix4x4.InvertAffineOrthonormal (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	-- Inline expansion of Matrix3x3:Transpose ()
	out [ 1] = self [ 1]
	out [ 6] = self [ 6]
	out [11] = self [11]
	out [ 2], out [ 5] = self [ 5], self [ 2]
	out [ 3], out [ 9] = self [ 9], self [ 3]
	out [ 7], out [10] = self [10], self [ 7]
	
	-- Inline expansion of Matrix3x3:MatrixUnpackedVectorMultiply ()
	local tx, ty, tz = -self [4], -self [8], -self [12]
	out [ 4] = tx * out [ 1] + ty * out [ 2] + tz * out [ 3]
	out [ 8] = tx * out [ 5] + ty * out [ 6] + tz * out [ 7]
	out [12] = tx * out [ 9] + ty * out [10] + tz * out [11]
	
	-- Set the last row
	out [13], out [14], out [15], out [16] = 0, 0, 0, 1
	
	return out
end

local math_abs                   = math.abs
local math_huge                  = math.huge
local GCAD_Matrix4x4_Clone       = GCAD.Matrix4x4.Clone
local GCAD_Matrix4x4_Determinant = GCAD.Matrix4x4.Determinant
local left
function GCAD.Matrix4x4.InvertGaussian (self, out)
	if out == self then out = nil end
	out = out or GCAD.Matrix4x4 ()
	
	-- [ M I ]
	left = GCAD_Matrix4x4_Clone (self, left)
	local right = GCAD.Matrix4x4.Identity (out)
	
	-- We want to turn this into [ I M ^ -1 ]
	
	for x = 0, 3 do
		-- Find the biggest row
		local largestElement  = -math_huge
		local largestElementY = 0
		for y = x, 3 do
			if math_abs (left [1 + y * 4 + x]) >= largestElement then
				largestElement  = math_abs (left [1 + y * 4 + x])
				largestElementY = y
			end
		end
		
		-- Get the row elements
		local i = 1 + largestElementY * 4
		local l1, r1 = left [i + 0], right [i + 0]
		local l2, r2 = left [i + 1], right [i + 1]
		local l3, r3 = left [i + 2], right [i + 2]
		local l4, r4 = left [i + 3], right [i + 3]
		largestElement = left [i + x]
		
		-- Swap rows
		local i1 = 1 + largestElementY * 4
		local i2 = 1 + x * 4
		left  [i1 + 0], left  [i2 + 0] = left  [i2 + 0], l1
		left  [i1 + 1], left  [i2 + 1] = left  [i2 + 1], l2
		left  [i1 + 2], left  [i2 + 2] = left  [i2 + 2], l3
		left  [i1 + 3], left  [i2 + 3] = left  [i2 + 3], l4
		right [i1 + 0], right [i2 + 0] = right [i2 + 0], r1
		right [i1 + 1], right [i2 + 1] = right [i2 + 1], r2
		right [i1 + 2], right [i2 + 2] = right [i2 + 2], r3
		right [i1 + 3], right [i2 + 3] = right [i2 + 3], r4
		
		-- Now mess around
		for y = 0, 3 do
			local i = 1 + y * 4
			local k = y == x and ((left [i + x] - 1) / largestElement) or (left [i + x] / largestElement)
			left  [i + 0] = left  [i + 0] - k * l1
			left  [i + 1] = left  [i + 1] - k * l2
			left  [i + 2] = left  [i + 2] - k * l3
			left  [i + 3] = left  [i + 3] - k * l4
			right [i + 0] = right [i + 0] - k * r1
			right [i + 1] = right [i + 1] - k * r2
			right [i + 2] = right [i + 2] - k * r3
			right [i + 3] = right [i + 3] - k * r4
		end
	end
	
	return out
end

function GCAD.Matrix4x4.InvertOrthonormal (self, out)
	return GCAD.Matrix4x4.Transpose (self, out)
end

local VMatrix_Invert = debug.getregistry ().VMatrix.Invert
local matrix = Matrix ()
function GCAD.Matrix4x4.InvertToVMatrixAndBack (self, out)
	GCAD.Matrix4x4.ToNativeMatrix (self, matrix)
	VMatrix_Invert (matrix)
	return GCAD.Matrix4x4.FromNativeMatrix (matrix, out)
end

function GCAD.Matrix4x4.Transpose (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1] = self [ 1]
	out [ 6] = self [ 6]
	out [11] = self [11]
	out [16] = self [16]
	out [ 2], out [ 5] = self [ 5], self [ 2]
	out [ 3], out [ 9] = self [ 9], self [ 3]
	out [ 4], out [13] = self [13], self [ 4]
	out [ 7], out [10] = self [10], self [ 7]
	out [ 8], out [14] = self [14], self [ 8]
	out [12], out [15] = self [15], self [12]
	
	return out
end

-- Matrix arithmetic
function GCAD.Matrix4x4.Add (a, b, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = a [ 1] + b [ 1], a [ 2] + b [ 2], a [ 3] + b [ 3], a [ 4] + b [ 4]
	out [ 5], out [ 6], out [ 7], out [ 8] = a [ 5] + b [ 5], a [ 6] + b [ 6], a [ 7] + b [ 7], a [ 8] + b [ 8]
	out [ 9], out [10], out [11], out [12] = a [ 9] + b [ 9], a [10] + b [10], a [11] + b [11], a [12] + b [12]
	out [13], out [14], out [15], out [16] = a [13] + b [13], a [14] + b [14], a [15] + b [15], a [16] + b [16]
	
	return out
end

function GCAD.Matrix4x4.Subtract (a, b, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = a [ 1] - b [ 1], a [ 2] - b [ 2], a [ 3] - b [ 3], a [ 4] - b [ 4]
	out [ 5], out [ 6], out [ 7], out [ 8] = a [ 5] - b [ 5], a [ 6] - b [ 6], a [ 7] - b [ 7], a [ 8] - b [ 8]
	out [ 9], out [10], out [11], out [12] = a [ 9] - b [ 9], a [10] - b [10], a [11] - b [11], a [12] - b [12]
	out [13], out [14], out [15], out [16] = a [13] - b [13], a [14] - b [14], a [15] - b [15], a [16] - b [16]
	
	return out
end

function GCAD.Matrix4x4.MatrixScalarMultiply (a, b, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = a [ 1] * b, a [ 2] * b, a [ 3] * b, a [ 4] * b
	out [ 5], out [ 6], out [ 7], out [ 8] = a [ 5] * b, a [ 6] * b, a [ 7] * b, a [ 8] * b
	out [ 9], out [10], out [11], out [12] = a [ 9] * b, a [10] * b, a [11] * b, a [12] * b
	out [13], out [14], out [15], out [16] = a [13] * b, a [14] * b, a [15] * b, a [16] * b
	
	return out
end

local GCAD_Matrix4x4_MatrixScalarMultiply = GCAD.Matrix4x4.MatrixScalarMultiply
function GCAD.Matrix4x4.ScalarMatrixMultiply (a, b, out)
	return GCAD_Matrix4x4_MatrixScalarMultiply (b, a, out)
end

function GCAD.Matrix4x4.MatrixVectorMultiply (a, b, out)
	out = out or GCAD.Vector4d ()
	
	local x, y, z, w = b [1], b [2], b [3], b [4]
	out [1] = a [ 1] * x + a [ 2] * y + a [ 3] * z + a [ 4] * w
	out [2] = a [ 5] * x + a [ 6] * y + a [ 7] * z + a [ 8] * w
	out [3] = a [ 9] * x + a [10] * y + a [11] * z + a [12] * w
	out [4] = a [13] * x + a [14] * y + a [15] * z + a [16] * w
	
	return out
end

function GCAD.Matrix4x4.MatrixUnpackedVectorMultiply (a, x, y, z, w)
	return a [ 1] * x + a [ 2] * y + a [ 3] * z + a [ 4] * w,
	       a [ 5] * x + a [ 6] * y + a [ 7] * z + a [ 8] * w,
	       a [ 9] * x + a [10] * y + a [11] * z + a [12] * w,
	       a [13] * x + a [14] * y + a [15] * z + a [16] * w
end

function GCAD.Matrix4x4.VectorMatrixMultiply (a, b, out)
	out = out or GCAD.Vector4d ()
	
	local x, y, z, w = a [1], a [2], a [3], a [4]
	out [1] = x * b [1] + y * b [5] + z * b [ 9] + w * b [13]
	out [2] = x * b [2] + y * b [6] + z * b [10] + w * b [14]
	out [3] = x * b [3] + y * b [7] + z * b [11] + w * b [15]
	out [4] = x * b [4] + y * b [8] + z * b [12] + w * b [16]
	
	return out
end

function GCAD.Matrix4x4.UnpackedVectorMatrixMultiply (x, y, z, w, b)
	return x * b [1] + y * b [5] + z * b [ 9] + w * b [13],
	       x * b [2] + y * b [6] + z * b [10] + w * b [14],
	       x * b [3] + y * b [7] + z * b [11] + w * b [15],
	       x * b [4] + y * b [8] + z * b [12] + w * b [16]
end

function GCAD.Matrix4x4.MatrixMatrixMultiply (a, b, out)
	if out == a or out == b then out = nil end
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1] = a [ 1] * b [1] + a [ 2] * b [5] + a [ 3] * b [ 9] + a [ 4] * b [13]
	out [ 2] = a [ 1] * b [2] + a [ 2] * b [6] + a [ 3] * b [10] + a [ 4] * b [14]
	out [ 3] = a [ 1] * b [3] + a [ 2] * b [7] + a [ 3] * b [11] + a [ 4] * b [15]
	out [ 4] = a [ 1] * b [4] + a [ 2] * b [8] + a [ 3] * b [12] + a [ 4] * b [16]
	
	out [ 5] = a [ 5] * b [1] + a [ 6] * b [5] + a [ 7] * b [ 9] + a [ 8] * b [13]
	out [ 6] = a [ 5] * b [2] + a [ 6] * b [6] + a [ 7] * b [10] + a [ 8] * b [14]
	out [ 7] = a [ 5] * b [3] + a [ 6] * b [7] + a [ 7] * b [11] + a [ 8] * b [15]
	out [ 8] = a [ 5] * b [4] + a [ 6] * b [8] + a [ 7] * b [12] + a [ 8] * b [16]
	
	out [ 9] = a [ 9] * b [1] + a [10] * b [5] + a [11] * b [ 9] + a [12] * b [13]
	out [10] = a [ 9] * b [2] + a [10] * b [6] + a [11] * b [10] + a [12] * b [14]
	out [11] = a [ 9] * b [3] + a [10] * b [7] + a [11] * b [11] + a [12] * b [15]
	out [12] = a [ 9] * b [4] + a [10] * b [8] + a [11] * b [12] + a [12] * b [16]
	
	out [13] = a [13] * b [1] + a [14] * b [5] + a [15] * b [ 9] + a [16] * b [13]
	out [14] = a [13] * b [2] + a [14] * b [6] + a [15] * b [10] + a [16] * b [14]
	out [15] = a [13] * b [3] + a [14] * b [7] + a [15] * b [11] + a [16] * b [15]
	out [16] = a [13] * b [4] + a [14] * b [8] + a [15] * b [12] + a [16] * b [16]
	
	return out
end

-- This multiplication method is slower than the previous one.
local vmatrix1 = Matrix ()
local vmatrix2 = Matrix ()
function GCAD.Matrix4x4.MatrixMatrixMultiply2 (a, b, out)
	GCAD.Matrix4x4.ToNativeMatrix (a, vmatrix1)
	GCAD.Matrix4x4.ToNativeMatrix (b, vmatrix2)
	return GCAD.Matrix4x4.FromNativeMatrix (vmatrix * vmatrix2, out)
end

local GCAD_Matrix4x4_ScalarMatrixMultiply = GCAD.Matrix4x4.ScalarMatrixMultiply
local GCAD_Matrix4x4_MatrixMatrixMultiply = GCAD.Matrix4x4.MatrixMatrixMultiply
local GCAD_Matrix4x4_VectorMatrixMultiply = GCAD.Matrix4x4.VectorMatrixMultiply
local GCAD_Matrix4x4_MatrixVectorMultiply = GCAD.Matrix4x4.MatrixVectorMultiply

function GCAD.Matrix4x4.Multiply (a, b, out)
	if isnumber (a) then
		return GCAD_Matrix4x4_ScalarMatrixMultiply (a, b, out)
	elseif isnumber (b) then
		return GCAD_Matrix4x4_MatrixScalarMultiply (a, b, out)
	elseif #a == 16 and #b == 16 then
		return GCAD_Matrix4x4_MatrixMatrixMultiply (a, b, out)
	elseif #a == 4 then
		return GCAD_Matrix4x4_VectorMatrixMultiply (a, b, out)
	elseif #b == 4 then
		return GCAD_Matrix4x4_MatrixVectorMultiply (a, b, out)
	end
	
	GCAD.Error ("Matrix4x4.Multiply : Invalid argument types!")
	
	return out
end

function GCAD.Matrix4x4.ScalarDivide (a, b, out)
	out = out or GCAD.Matrix4x4 ()
	
	b = 1 / b
	out [ 1], out [ 2], out [ 3], out [ 4] = a [ 1] * b, a [ 2] * b, a [ 3] * b, a [ 4] * b
	out [ 5], out [ 6], out [ 7], out [ 8] = a [ 5] * b, a [ 6] * b, a [ 7] * b, a [ 8] * b
	out [ 9], out [10], out [11], out [12] = a [ 9] * b, a [10] * b, a [11] * b, a [12] * b
	out [13], out [14], out [15], out [16] = a [13] * b, a [14] * b, a [15] * b, a [16] * b
	
	return out
end

function GCAD.Matrix4x4.Negate (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = -self [ 1], -self [ 2], -self [ 3], -self [ 4]
	out [ 5], out [ 6], out [ 7], out [ 8] = -self [ 5], -self [ 6], -self [ 7], -self [ 8]
	out [ 9], out [10], out [11], out [12] = -self [ 9], -self [10], -self [11], -self [12]
	out [13], out [14], out [15], out [16] = -self [13], -self [14], -self [15], -self [16]
	
	return out
end

-- Conversion
function GCAD.Matrix4x4.FromMatrix3x3 (matrix, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = matrix [1], matrix [2], matrix [3], 0
	out [ 5], out [ 6], out [ 7], out [ 8] = matrix [4], matrix [5], matrix [6], 0
	out [ 9], out [10], out [11], out [12] = matrix [7], matrix [8], matrix [9], 0
	out [13], out [14], out [15], out [16] =          0,          0,          0, 1
	
	return out
end

function GCAD.Matrix4x4.ToMatrix3x3 (self, out)
	out = out or GCAD.Matrix3x3 ()
	
	out [1], out [2], out [3] = self [ 1], self [ 2], self [ 3]
	out [4], out [5], out [6] = self [ 5], self [ 6], self [ 7]
	out [7], out [8], out [9] = self [ 9], self [10], self [11]
	
	return out
end

function GCAD.Matrix4x4.FromNativeMatrix (matrix, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = VMatrix_GetField (matrix, 1, 1), VMatrix_GetField (matrix, 1, 2), VMatrix_GetField (matrix, 1, 3), VMatrix_GetField (matrix, 1, 4)
	out [ 5], out [ 6], out [ 7], out [ 8] = VMatrix_GetField (matrix, 2, 1), VMatrix_GetField (matrix, 2, 2), VMatrix_GetField (matrix, 2, 3), VMatrix_GetField (matrix, 2, 4)
	out [ 9], out [10], out [11], out [12] = VMatrix_GetField (matrix, 3, 1), VMatrix_GetField (matrix, 3, 2), VMatrix_GetField (matrix, 3, 3), VMatrix_GetField (matrix, 3, 4)
	out [13], out [14], out [15], out [16] = VMatrix_GetField (matrix, 4, 1), VMatrix_GetField (matrix, 4, 2), VMatrix_GetField (matrix, 4, 3), VMatrix_GetField (matrix, 4, 4)
	
	return out
end

function GCAD.Matrix4x4.ToNativeMatrix (self, out)
	out = out or Matrix ()
	
	VMatrix_SetField (out, 1, 1, self [ 1]) VMatrix_SetField (out, 1, 2, self [ 2]) VMatrix_SetField (out, 1, 3, self [ 3]) VMatrix_SetField (out, 1, 4, self [ 4])
	VMatrix_SetField (out, 2, 1, self [ 5]) VMatrix_SetField (out, 2, 2, self [ 6]) VMatrix_SetField (out, 2, 3, self [ 7]) VMatrix_SetField (out, 2, 4, self [ 8])
	VMatrix_SetField (out, 3, 1, self [ 9]) VMatrix_SetField (out, 3, 2, self [10]) VMatrix_SetField (out, 3, 3, self [11]) VMatrix_SetField (out, 3, 4, self [12])
	VMatrix_SetField (out, 4, 1, self [13]) VMatrix_SetField (out, 4, 2, self [14]) VMatrix_SetField (out, 4, 3, self [15]) VMatrix_SetField (out, 4, 4, self [16])
	
	return out
end

-- Utility
function GCAD.Matrix4x4.Unpack (self)
	return self [ 1], self [ 2], self [ 3], self [ 4],
	       self [ 5], self [ 6], self [ 7], self [ 8],
	       self [ 9], self [10], self [11], self [12],
	       self [13], self [14], self [15], self [16]
end

function GCAD.Matrix4x4.ToString (self)
	return "[" .. tostring (self [ 1]) .. ", " .. tostring (self [ 2]) .. ", " .. tostring (self [ 3]) .. ", " .. tostring (self [ 4]) .. "]\n" ..
	       "[" .. tostring (self [ 5]) .. ", " .. tostring (self [ 6]) .. ", " .. tostring (self [ 7]) .. ", " .. tostring (self [ 8]) .. "]\n" ..
	       "[" .. tostring (self [ 9]) .. ", " .. tostring (self [10]) .. ", " .. tostring (self [11]) .. ", " .. tostring (self [12]) .. "]\n" ..
	       "[" .. tostring (self [13]) .. ", " .. tostring (self [14]) .. ", " .. tostring (self [15]) .. ", " .. tostring (self [16]) .. "]"
end

-- Construction
function GCAD.Matrix4x4.Identity (out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = 1, 0, 0, 0
	out [ 5], out [ 6], out [ 7], out [ 8] = 0, 1, 0, 0
	out [ 9], out [10], out [11], out [12] = 0, 0, 1, 0
	out [13], out [14], out [15], out [16] = 0, 0, 0, 1
	
	return out
end

function GCAD.Matrix4x4.Rotate (angle, out)
	return GCAD.EulerAngle.ToMatrix4x4 (angle, out)
end

function GCAD.Matrix4x4.RotateUnpacked (p, y, r, out)
	return GCAD.UnpackedEulerAngle.ToMatrix4x4 (p, y, r, out)
end

function GCAD.Matrix4x4.Scale (v4d, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = v4d [1],       0,       0,       0
	out [ 5], out [ 6], out [ 7], out [ 8] =       0, v4d [2],       0,       0
	out [ 9], out [10], out [11], out [12] =       0,       0, v4d [3],       0
	out [13], out [14], out [15], out [16] =       0,       0,       0, v4d [4]
	
	return out
end

function GCAD.Matrix4x4.ScaleUnpacked (x, y, z, w, out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = x, 0, 0, 0
	out [ 5], out [ 6], out [ 7], out [ 8] = 0, y, 0, 0
	out [ 9], out [10], out [11], out [12] = 0, 0, z, 0
	out [13], out [14], out [15], out [16] = 0, 0, 0, w
	
	return out
end

function GCAD.Matrix4x4.Zero (out)
	out = out or GCAD.Matrix4x4 ()
	
	out [ 1], out [ 2], out [ 3], out [ 4] = 0, 0, 0, 0
	out [ 5], out [ 6], out [ 7], out [ 8] = 0, 0, 0, 0
	out [ 9], out [10], out [11], out [12] = 0, 0, 0, 0
	out [13], out [14], out [15], out [16] = 0, 0, 0, 0
	
	return out
end

-- Constructor
function self:ctor (m11, m12, m13, m14,
                    m21, m22, m23, m24,
                    m31, m32, m33, m34,
                    m41, m42, m43, m44)
	
	self [ 1], self [ 2], self [ 3], self [ 4] = m11 or 0, m12 or 0, m13 or 0, m14 or 0
	self [ 5], self [ 6], self [ 7], self [ 8] = m21 or 0, m22 or 0, m23 or 0, m24 or 0
	self [ 9], self [10], self [11], self [12] = m31 or 0, m32 or 0, m33 or 0, m34 or 0
	self [13], self [14], self [15], self [16] = m41 or 0, m42 or 0, m43 or 0, m44 or 0
end

-- Initialization
function self:Set (m11, m12, m13, m14,
                   m21, m22, m23, m24,
                   m31, m32, m33, m34,
                   m41, m42, m43, m44)
	
	self [ 1], self [ 2], self [ 3], self [ 4] = m11, m12, m13, m14
	self [ 5], self [ 6], self [ 7], self [ 8] = m21, m22, m23, m24
	self [ 9], self [10], self [11], self [12] = m31, m32, m33, m34
	self [13], self [14], self [15], self [16] = m41, m42, m43, m44
	
	return self
end

local GCAD_Matrix4x4_Identity = GCAD.Matrix4x4.Identity
local GCAD_Matrix4x4_Zero     = GCAD.Matrix4x4.Zero

function self:Identity () return GCAD_Matrix4x4_Identity (self) end
function self:Zero     () return GCAD_Matrix4x4_Zero     (self) end

-- Copying
self.Clone                   = GCAD.Matrix4x4.Clone
self.Copy                    = GCAD.Matrix4x4.Copy

-- Matrix reading
self.GetColumn               = GCAD.Matrix4x4.GetColumn
self.GetColumnNative         = GCAD.Matrix4x4.GetColumnNative
self.GetColumnUnpacked       = GCAD.Matrix4x4.GetColumnUnpacked
self.GetDiagonal             = GCAD.Matrix4x4.GetDiagonal
self.GetDiagonalNative       = GCAD.Matrix4x4.GetDiagonalNative
self.GetDiagonalUnpacked     = GCAD.Matrix4x4.GetDiagonalUnpacked
self.GetRow                  = GCAD.Matrix4x4.GetRow
self.GetRowNative            = GCAD.Matrix4x4.GetRowNative
self.GetRowUnpacked          = GCAD.Matrix4x4.GetRowUnpacked
self.SetColumn               = GCAD.Matrix4x4.SetColumn
self.SetColumnNative         = GCAD.Matrix4x4.SetColumnNative
self.SetColumnUnpacked       = GCAD.Matrix4x4.SetColumnUnpacked
self.SetDiagonal             = GCAD.Matrix4x4.SetDiagonal
self.SetDiagonalNative       = GCAD.Matrix4x4.SetDiagonalNative
self.SetDiagonalUnpacked     = GCAD.Matrix4x4.SetDiagonalUnpacked
self.SetRow                  = GCAD.Matrix4x4.SetRow
self.SetRowNative            = GCAD.Matrix4x4.SetRowNative
self.SetRowUnpacked          = GCAD.Matrix4x4.SetRowUnpacked

-- Matrix properties
self.Determinant             = GCAD.Matrix4x4.Determinant
self.Determinant3x3          = GCAD.Matrix4x4.Determinant3x3
self.Trace                   = GCAD.Matrix4x4.Trace
self.Trace3x3                = GCAD.Matrix4x4.Trace3x3
self.Eigenvalues3x3          = GCAD.Matrix4x4.Eigenvalues3x3
self.SingularValues3x3       = GCAD.Matrix4x4.SingularValues3x3

-- Matrix operations
self.Invert                  = GCAD.Matrix4x4.Invert
self.InvertAffine            = GCAD.Matrix4x4.InvertAffine
self.InvertAffineOrthonormal = GCAD.Matrix4x4.InvertAffineOrthonormal
self.InvertOrthonormal       = GCAD.Matrix4x4.InvertOrthonormal
self.Transpose               = GCAD.Matrix4x4.Transpose

-- Matrix arithmetic
self.Add                     = GCAD.Matrix4x4.Add
self.Subtract                = GCAD.Matrix4x4.Subtract
self.Multiply                = GCAD.Matrix4x4.Multiply
self.ScalarMultiply          = GCAD.Matrix4x4.MatrixScalarMultiply
self.ScalarDivide            = GCAD.Matrix4x4.ScalarDivide
self.MatrixMultiply          = GCAD.Matrix4x4.MatrixMatrixMultiply
self.VectorMultiply          = GCAD.Matrix4x4.MatrixVectorMultiply
self.UnpackedVectorMultiply  = GCAD.Matrix4x4.MatrixUnpackedVectorMultiply
self.Negate                  = GCAD.Matrix4x4.Negate

self.__add                   = GCAD.Matrix4x4.Add
self.__sub                   = GCAD.Matrix4x4.Subtract
self.__mul                   = GCAD.Matrix4x4.Multiply
self.__div                   = GCAD.Matrix4x4.ScalarDivide
self.__unm                   = GCAD.Matrix4x4.Negate

-- Conversion
self.ToMatrix3x3             = GCAD.Matrix4x4.ToMatrix3x3
self.ToNativeMatrix          = GCAD.Matrix4x4.ToNativeMatrix

-- Utility
self.Unpack                  = GCAD.Matrix4x4.Unpack
self.ToString                = GCAD.Matrix4x4.ToString
self.__tostring              = GCAD.Matrix4x4.ToString
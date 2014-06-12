local self = {}
GCAD.Matrix4x4 = GCAD.MakeConstructor (self)

local math              = math

local isnumber          = isnumber

local Vector            = Vector
local Vector___index    = debug.getregistry ().Vector.__index
local Vector___newindex = debug.getregistry ().Vector.__newindex

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
	
	Vector___newindex (out, "x", self [column +  0])
	Vector___newindex (out, "y", self [column +  4])
	Vector___newindex (out, "z", self [column +  8])
	
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
	
	Vector___newindex (out, "x", self [ 1])
	Vector___newindex (out, "y", self [ 6])
	Vector___newindex (out, "z", self [11])
	
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
	
	Vector___newindex (out, "x", self [row * 4 - 4 + 1])
	Vector___newindex (out, "y", self [row * 4 - 4 + 2])
	Vector___newindex (out, "z", self [row * 4 - 4 + 3])
	
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
	self [column +  0] = Vector___index (v, "x")
	self [column +  4] = Vector___index (v, "y")
	self [column +  8] = Vector___index (v, "z")
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
	self [ 1] = Vector___index (v, "x")
	self [ 6] = Vector___index (v, "y")
	self [11] = Vector___index (v, "z")
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
	self [row * 4 - 4 + 1] = Vector___index (v, "x")
	self [row * 4 - 4 + 2] = Vector___index (v, "y")
	self [row * 4 - 4 + 3] = Vector___index (v, "z")
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

-- Matrix operations
function GCAD.Matrix4x4.Determinant (self)
	GCAD.Error ("Matrix4x4.Determinant : Not implemented.")
	return 0
end

local GCAD_Matrix4x4_Determinant = GCAD.Matrix4x4.Determinant
function GCAD.Matrix4x4.Invert (self, out)
	out = out or GCAD.Matrix4x4 ()
	
	GCAD.Error ("Matrix4x4.Invert : Not implemented.")
	
	return out
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

local vmatrix1 = Matrix ()
local vmatrix2 = Matrix ()
local VMatrix_GetField = debug.getregistry ().VMatrix.GetField
local VMatrix_Identity = debug.getregistry ().VMatrix.Identity
local VMatrix_SetField = debug.getregistry ().VMatrix.SetField
function GCAD.Matrix4x4.MatrixMatrixMultiply2 (a, b, out)
	out = out or GCAD.Matrix4x4 ()
	
	VMatrix_Identity (vmatrix1)
	VMatrix_SetField (vmatrix1, 1, 1, a [ 1]) VMatrix_SetField (vmatrix1, 1, 2, a [ 2]) VMatrix_SetField (vmatrix1, 1, 3, a [ 3]) VMatrix_SetField (vmatrix1, 1, 4, a [ 4])
	VMatrix_SetField (vmatrix1, 2, 1, a [ 5]) VMatrix_SetField (vmatrix1, 2, 2, a [ 6]) VMatrix_SetField (vmatrix1, 2, 3, a [ 7]) VMatrix_SetField (vmatrix1, 2, 4, a [ 8])
	VMatrix_SetField (vmatrix1, 3, 1, a [ 9]) VMatrix_SetField (vmatrix1, 3, 2, a [10]) VMatrix_SetField (vmatrix1, 3, 3, a [11]) VMatrix_SetField (vmatrix1, 3, 4, a [12])
	VMatrix_SetField (vmatrix1, 4, 1, a [13]) VMatrix_SetField (vmatrix1, 4, 2, a [14]) VMatrix_SetField (vmatrix1, 4, 3, a [15]) VMatrix_SetField (vmatrix1, 4, 4, a [16])
	
	VMatrix_Identity (vmatrix2)
	VMatrix_SetField (vmatrix2, 1, 1, b [ 1]) VMatrix_SetField (vmatrix2, 1, 2, b [ 2]) VMatrix_SetField (vmatrix2, 1, 3, b [ 3]) VMatrix_SetField (vmatrix2, 1, 4, b [ 4])
	VMatrix_SetField (vmatrix2, 2, 1, b [ 5]) VMatrix_SetField (vmatrix2, 2, 2, b [ 6]) VMatrix_SetField (vmatrix2, 2, 3, b [ 7]) VMatrix_SetField (vmatrix2, 2, 4, b [ 8])
	VMatrix_SetField (vmatrix2, 3, 1, b [ 9]) VMatrix_SetField (vmatrix2, 3, 2, b [10]) VMatrix_SetField (vmatrix2, 3, 3, b [11]) VMatrix_SetField (vmatrix2, 3, 4, b [12])
	VMatrix_SetField (vmatrix2, 4, 1, b [13]) VMatrix_SetField (vmatrix2, 4, 2, b [14]) VMatrix_SetField (vmatrix2, 4, 3, b [15]) VMatrix_SetField (vmatrix2, 4, 4, b [16])
	
	local c = vmatrix1 * vmatrix2
	out [ 1], out [ 2], out [ 3], out [ 4] = VMatrix_GetField (c, 1, 1), VMatrix_GetField (c, 1, 2), VMatrix_GetField (c, 1, 3), VMatrix_GetField (c, 1, 4)
	out [ 5], out [ 6], out [ 7], out [ 8] = VMatrix_GetField (c, 2, 1), VMatrix_GetField (c, 2, 2), VMatrix_GetField (c, 2, 3), VMatrix_GetField (c, 2, 4)
	out [ 9], out [10], out [11], out [12] = VMatrix_GetField (c, 3, 1), VMatrix_GetField (c, 3, 2), VMatrix_GetField (c, 3, 3), VMatrix_GetField (c, 3, 4)
	out [13], out [14], out [15], out [16] = VMatrix_GetField (c, 4, 1), VMatrix_GetField (c, 4, 2), VMatrix_GetField (c, 4, 3), VMatrix_GetField (c, 4, 4)
	
	return out
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
	
	out [ 1], out [ 2], out [ 3], out [ 4] = a [ 1] / b, a [ 2] / b, a [ 3] / b, a [ 4] / b
	out [ 5], out [ 6], out [ 7], out [ 8] = a [ 5] / b, a [ 6] / b, a [ 7] / b, a [ 8] / b
	out [ 9], out [10], out [11], out [12] = a [ 9] / b, a [10] / b, a [11] / b, a [12] / b
	out [13], out [14], out [15], out [16] = a [13] / b, a [14] / b, a [15] / b, a [16] / b
	
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
self.Clone                  = GCAD.Matrix4x4.Clone
self.Copy                   = GCAD.Matrix4x4.Copy

-- Matrix reading
self.GetColumn              = GCAD.Matrix4x4.GetColumn
self.GetColumnNative        = GCAD.Matrix4x4.GetColumnNative
self.GetColumnUnpacked      = GCAD.Matrix4x4.GetColumnUnpacked
self.GetDiagonal            = GCAD.Matrix4x4.GetDiagonal
self.GetDiagonalNative      = GCAD.Matrix4x4.GetDiagonalNative
self.GetDiagonalUnpacked    = GCAD.Matrix4x4.GetDiagonalUnpacked
self.GetRow                 = GCAD.Matrix4x4.GetRow
self.GetRowNative           = GCAD.Matrix4x4.GetRowNative
self.GetRowUnpacked         = GCAD.Matrix4x4.GetRowUnpacked
self.SetColumn              = GCAD.Matrix4x4.SetColumn
self.SetColumnNative        = GCAD.Matrix4x4.SetColumnNative
self.SetColumnUnpacked      = GCAD.Matrix4x4.SetColumnUnpacked
self.SetDiagonal            = GCAD.Matrix4x4.SetDiagonal
self.SetDiagonalNative      = GCAD.Matrix4x4.SetDiagonalNative
self.SetDiagonalUnpacked    = GCAD.Matrix4x4.SetDiagonalUnpacked
self.SetRow                 = GCAD.Matrix4x4.SetRow
self.SetRowNative           = GCAD.Matrix4x4.SetRowNative
self.SetRowUnpacked         = GCAD.Matrix4x4.SetRowUnpacked

-- Matrix operations
self.Determinant            = GCAD.Matrix4x4.Determinant
self.Invert                 = GCAD.Matrix4x4.Invert
self.Transpose              = GCAD.Matrix4x4.Transpose

-- Matrix arithmetic
self.Add                    = GCAD.Matrix4x4.Add
self.Subtract               = GCAD.Matrix4x4.Subtract
self.Multiply               = GCAD.Matrix4x4.Multiply
self.ScalarMultiply         = GCAD.Matrix4x4.MatrixScalarMultiply
self.ScalarDivide           = GCAD.Matrix4x4.ScalarDivide
self.MatrixMultiply         = GCAD.Matrix4x4.MatrixMatrixMultiply
self.VectorMultiply         = GCAD.Matrix4x4.MatrixVectorMultiply
self.UnpackedVectorMultiply = GCAD.Matrix4x4.MatrixUnpackedVectorMultiply
self.Negate                 = GCAD.Matrix4x4.Negate

self.__add                  = GCAD.Matrix4x4.Add
self.__sub                  = GCAD.Matrix4x4.Subtract
self.__mul                  = GCAD.Matrix4x4.Multiply
self.__div                  = GCAD.Matrix4x4.ScalarDivide
self.__unm                  = GCAD.Matrix4x4.Negate

-- Utility
self.Unpack                 = GCAD.Matrix4x4.Unpack
self.ToString               = GCAD.Matrix4x4.ToString
self.__tostring             = GCAD.Matrix4x4.ToString
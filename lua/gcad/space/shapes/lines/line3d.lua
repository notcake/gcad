local self = {}
GCAD.Line3d = GCAD.MakeConstructor (self)

local math_sqrt                                  = math.sqrt

local Vector                                     = Vector

local Vector___index                             = debug.getregistry ().Vector.__index

local GCAD_Vector3d_Clone                        = GCAD.Vector3d.Clone
local GCAD_Vector3d_ToNativeVector               = GCAD.Vector3d.ToNativeVector
local GCAD_Vector3d_Unpack                       = GCAD.Vector3d.Unpack
local GCAD_UnpackedVector3d_Add                  = GCAD.UnpackedVector3d.Add
local GCAD_UnpackedVector3d_Dot                  = GCAD.UnpackedVector3d.Dot
local GCAD_UnpackedVector3d_FromNativeVector     = GCAD.UnpackedVector3d.FromNativeVector
local GCAD_UnpackedVector3d_Length               = GCAD.UnpackedVector3d.Length
local GCAD_UnpackedVector3d_LengthSquared        = GCAD.UnpackedVector3d.LengthSquared
local GCAD_UnpackedVector3d_ScalarVectorMultiply = GCAD.UnpackedVector3d.ScalarVectorMultiply
local GCAD_UnpackedVector3d_Subtract             = GCAD.UnpackedVector3d.Subtract
local GCAD_UnpackedVector3d_ToNativeVector       = GCAD.UnpackedVector3d.ToNativeVector

function GCAD.Line3d.FromPositionAndDirection (position, direction, out)
	out = out or GCAD.Line3d ()
	
	out:SetPosition (position)
	out:SetDirection (direction)
	
	return out
end

-- Copying
function GCAD.Line3d.Clone (self, out)
	out = out or GCAD.Line3d ()
	
	out [1] = self [1]
	out [2] = self [2]
	out [3] = self [3]
	out [4] = self [4]
	out [5] = self [5]
	out [6] = self [6]
	
	return out
end

function GCAD.Line3d.Copy (self, source)
	self [1] = source [1]
	self [2] = source [2]
	self [3] = source [3]
	self [4] = source [4]
	self [5] = source [5]
	self [6] = source [6]
	
	return self
end

-- Line properties
function GCAD.Line3d.GetPosition (self, out)
	return GCAD_Vector3d_Clone (self, out)
end

function GCAD.Line3d.GetPositionNative (self, out)
	return GCAD_Vector3d_ToNativeVector (self, out)
end

function GCAD.Line3d.GetPositionUnpacked (self)
	return self [1], self [2], self [3]
end

function GCAD.Line3d.GetDirection (self, out)
	out = out or GCAD.Vector3d ()
	
	out [1] = self [4]
	out [2] = self [5]
	out [3] = self [6]
	
	return out
end

function GCAD.Line3d.GetDirectionNative (self, out)
	return GCAD_UnpackedVector3d_ToNativeVector (self [4], self [5], self [6], out)
end

function GCAD.Line3d.GetDirectionUnpacked (self)
	return self [4], self [5], self [6]
end

function GCAD.Line3d.GetDirectionLength (self)
	return GCAD_UnpackedVector3d_Length (self [4], self [5], self [6])
end

function GCAD.Line3d.GetDirectionLengthSquared (self)
	return GCAD_UnpackedVector3d_LengthSquared (self [4], self [5], self [6])
end

function GCAD.Line3d.SetPosition (self, pos)
	self [1] = pos [1]
	self [2] = pos [2]
	self [3] = pos [3]
	
	return self
end

function GCAD.Line3d.SetPositionNative (self, pos)
	self [1] = Vector___index (pos, "x")
	self [2] = Vector___index (pos, "y")
	self [3] = Vector___index (pos, "z")
	
	return self
end

function GCAD.Line3d.SetPositionUnpacked (self, x, y, z)
	self [1] = x
	self [2] = y
	self [3] = z
	
	return self
end

function GCAD.Line3d.SetDirection (self, direction)
	self [4] = direction [1]
	self [5] = direction [2]
	self [6] = direction [3]
	
	return self
end

function GCAD.Line3d.SetPositionNative (self, direction)
	self [4] = Vector___index (direction, "x")
	self [5] = Vector___index (direction, "y")
	self [6] = Vector___index (direction, "z")
	
	return self
end

function GCAD.Line3d.SetDirectionUnpacked (self, x, y, z)
	self [4] = x
	self [5] = y
	self [6] = z
	
	return self
end

-- Line queries
local GCAD_Line3d_GetDirectionLengthSquared = GCAD.Line3d.GetDirectionLengthSquared

function GCAD.Line3d.DistanceToUnpackedPoint (self, x, y, z)
	x, y, z = GCAD_UnpackedVector3d_Subtract (x, y, z, self [1], self [2], self [3])
	local scaledT = GCAD_UnpackedVector3d_Dot (x, y, z, self [4], self [5], self [6])
	
	return math_sqrt (GCAD_UnpackedVector3d_LengthSquared (x, y, z) - scaledT * scaledT / GCAD_Line3d_GetDirectionLengthSquared (self))
end

local GCAD_Line3d_DistanceToUnpackedPoint = GCAD.Line3d.DistanceToUnpackedPoint
function GCAD.Line3d.DistanceToPoint (self, v3d)
	return GCAD_Line3d_DistanceToUnpackedPoint (self, GCAD_Vector3d_Unpack (v3d))
end

function GCAD.Line3d.DistanceToNativePoint (self, v)
	return GCAD_Line3d_DistanceToUnpackedPoint (self, GCAD_UnpackedVector3d_FromNativeVector (v))
end

function GCAD.Line3d.GetNearestPointParameterToUnpackedPoint (self, x, y, z)
	x, y, z = GCAD_UnpackedVector3d_Subtract (x, y, z, self [1], self [2], self [3])
	return GCAD_UnpackedVector3d_Dot (x, y, z, self [4], self [5], self [6]) / GCAD_Line3d_GetDirectionLengthSquared (self)
end

local GCAD_Line3d_GetNearestPointParameterToUnpackedPoint = GCAD.Line3d.GetNearestPointParameterToUnpackedPoint
function GCAD.Line3d.GetNearestPointParameterToPoint (self, v3d)
	return GCAD_Line3d_GetNearestPointParameterToUnpackedPoint (self, GCAD_Vector3d_Unpack (v3d))
end

function GCAD.Line3d.GetNearestPointParameterToNativePoint (self, v)
	return GCAD_Line3d_GetNearestPointParameterToUnpackedPoint (self, GCAD_UnpackedVector3d_FromNativeVector (v))
end

function GCAD.Line3d.EvaluateUnpacked (self, t)
	local x, y, z = GCAD_UnpackedVector3d_ScalarVectorMultiply (t, self [4], self [5], self [6])
	return GCAD_UnpackedVector3d_Add (self [1], self [2], self [3], x, y, z)
end

local GCAD_Line3d_EvaluateUnpacked = GCAD.Line3d.EvaluateUnpacked
function GCAD.Line3d.Evaluate (self, t, out)
	out = out or GCAD.Vector3d ()
	
	local x, y, z = GCAD_Line3d_EvaluateUnpacked (self, t)
	
	out [1] = x
	out [2] = y
	out [3] = z
	
	return out
end

function GCAD.Line3d.EvaluateNative (self, t, out)
	local x, y, z = GCAD_Line3d_EvaluateUnpacked (self, t)
	return GCAD_UnpackedVector3d_ToNativeVector (x, y, z, out)
end

-- Utility
function GCAD.Line3d.Unpack ()
	return self [1], self [2], self [3], self [4], self [5], self [6]
end

function GCAD.Line3d.ToString (self)
	return "Line [" .. GCAD_Vector3d_ToString (self) .. " + t * " .. GCAD_UnpackedVector3d_ToString (self [4], self [5], self [6]) .. "]"
end

-- Constructor
function self:ctor (px, py, pz, dx, dy, dz)
	self [1] = px or 0
	self [2] = py or 0
	self [3] = pz or 0
	self [4] = dx or 0
	self [5] = dy or 0
	self [6] = dz or 0
end

-- Initialization
function self:Set (px, py, pz, dx, dy, dz)
	self [1] = px
	self [2] = py
	self [3] = pz
	self [4] = dx
	self [5] = dy
	self [6] = dz
end

-- Copying
self.Clone                                   = GCAD.Line3d.Clone
self.Copy                                    = GCAD.Line3d.Copy

-- Line properties
self.GetPosition                             = GCAD.Line3d.GetPosition
self.GetPositionNative                       = GCAD.Line3d.GetPositionNative
self.GetPositionUnpacked                     = GCAD.Line3d.GetPositionUnpacked
self.GetDirection                            = GCAD.Line3d.GetDirection
self.GetDirectionNative                      = GCAD.Line3d.GetDirectionNative
self.GetDirectionUnpacked                    = GCAD.Line3d.GetDirectionUnpacked
self.GetDirectionLength                      = GCAD.Line3d.GetDirectionLength
self.GetDirectionLengthSquared               = GCAD.Line3d.GetDirectionLengthSquared
self.SetPosition                             = GCAD.Line3d.SetPosition
self.SetPositionNative                       = GCAD.Line3d.SetPositionNative
self.SetPositionUnpacked                     = GCAD.Line3d.SetPositionUnpacked
self.SetDirection                            = GCAD.Line3d.SetDirection
self.SetDirectionNative                      = GCAD.Line3d.SetDirectionNative
self.SetDirectionUnpacked                    = GCAD.Line3d.SetDirectionUnpacked

-- Line queries
self.DistanceToPoint                         = GCAD.Line3d.DistanceToPoint
self.DistanceToNativePoint                   = GCAD.Line3d.DistanceToNativePoint
self.DistanceToUnpackedPoint                 = GCAD.Line3d.DistanceToUnpackedPoint
self.GetNearestPointParameterToPoint         = GCAD.Line3d.GetNearestPointParameterToPoint
self.GetNearestPointParameterToNativePoint   = GCAD.Line3d.GetNearestPointParameterToNativePoint
self.GetNearestPointParameterToUnpackedPoint = GCAD.Line3d.GetNearestPointParameterToUnpackedPoint
self.Evaluate                                = GCAD.Line3d.Evaluate
self.EvaluateNative                          = GCAD.Line3d.EvaluateNative
self.EvaluateUnpacked                        = GCAD.Line3d.EvaluateUnpacked

-- Utility
self.Unpack                                  = GCAD.Line3d.Unpack
self.ToString                                = GCAD.Line3d.ToString
self.__tostring                              = GCAD.Line3d.ToString
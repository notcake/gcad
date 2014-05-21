local self = {}
GCAD.OBB3d = GCAD.MakeConstructor (self)

local Angle_Forward  = debug.getregistry ().Angle.Forward
local Angle_Set      = debug.getregistry ().Angle.Set
local Angle_Right    = debug.getregistry ().Angle.Right
local Angle_Up       = debug.getregistry ().Angle.Up
local Vector___index = debug.getregistry ().Vector.__index

local GCAD_Vector3d_FromNativeVector = GCAD.Vector3d.FromNativeVector

function GCAD.OBB3d.FromEntity (ent, out)
	GCAD.Profiler:Begin ("OBB3d.FromEntity")
	
	out = out or GCAD.OBB3d ()
	
	out.Center = GCAD_Vector3d_FromNativeVector (ent:GetPos  (), out.Center)
	out.Min    = GCAD_Vector3d_FromNativeVector (ent:OBBMins (), out.Min   )
	out.Max    = GCAD_Vector3d_FromNativeVector (ent:OBBMaxs (), out.Max   )
	
	out:SetAngle (ent:GetAngles ())
	
	GCAD.Profiler:End ()
	return out
end

function self:ctor (center, min, max, angle)
	self.Center = GCAD.Vector3d ()
	self.Min    = GCAD.Vector3d ()
	self.Max    = GCAD.Vector3d ()
	self.Angle  = Angle ()
	
	self.Corners = {}
	self.CornersValid = false
	
	if center then self:SetCenter (center) end
	if min then self:SetMin (min) end
	if max then self:SetMax (min) end
	if angle then self:SetAngle (angle) end
end

function self:GetCorner (n, out)
	out = out or GCAD.Vector3d ()
	
	if not self.CornersValid then
		self:ComputeCorners ()
	end
	
	out [1] = self.Corners [n] [1]
	out [2] = self.Corners [n] [2]
	out [3] = self.Corners [n] [3]
	
	return out
end

function self:GetEdgeEnumerator (out1, out2)
	local i = 0
	
	return function ()
		i = i + 1
		if i > 12 then return nil, nil end
		
		if     i ==  1 then return self:GetCorner (1, out1), self:GetCorner (2, out2)
		elseif i ==  2 then return self:GetCorner (2, out1), self:GetCorner (3, out2)
		elseif i ==  3 then return self:GetCorner (3, out1), self:GetCorner (4, out2)
		elseif i ==  4 then return self:GetCorner (4, out1), self:GetCorner (1, out2)
		elseif i ==  5 then return self:GetCorner (1, out1), self:GetCorner (5, out2)
		elseif i ==  6 then return self:GetCorner (2, out1), self:GetCorner (6, out2)
		elseif i ==  7 then return self:GetCorner (3, out1), self:GetCorner (7, out2)
		elseif i ==  8 then return self:GetCorner (4, out1), self:GetCorner (8, out2)
		elseif i ==  9 then return self:GetCorner (5, out1), self:GetCorner (6, out2)
		elseif i == 10 then return self:GetCorner (6, out1), self:GetCorner (7, out2)
		elseif i == 11 then return self:GetCorner (7, out1), self:GetCorner (8, out2)
		elseif i == 12 then return self:GetCorner (8, out1), self:GetCorner (5, out2)
		end
	end
end

function self:GetVertexEnumerator (out)
	local i = 0
	return function ()
		i = i + 1
		if i > 8 then return nil end
		
		return self:GetCorner (i, out)
	end
end

function self:GetCenter (out)
	if out then return self.Center:Clone (out) end
	return self.Center
end

function self:GetMin (out)
	if out then return self.Min:Clone (out) end
	return self.Min
end

function self:GetMax (out)
	if out then return self.Max:Clone (out) end
	return self.Max
end

function self:GetAngle (out)
	out = out or Angle ()
	
	Angle_Set (out, self.Angle)
	
	return self
end

function self:SetCenter (center)
	self.Center [1] = center [1]
	self.Center [2] = center [2]
	self.Center [3] = center [3]
	self.CornersValid = false
	return self
end

function self:SetMin (min)
	self.Min [1] = min [1]
	self.Min [2] = min [2]
	self.Min [3] = min [3]
	self.CornersValid = false
	return self
end

function self:SetMax (max)
	self.Max [1] = max [1]
	self.Max [2] = max [2]
	self.Max [3] = max [3]
	self.CornersValid = false
	return self
end

function self:SetAngle (angle)
	Angle_Set (self.Angle, angle)
	self.CornersValid = false
	return self
end

-- Internal, do not call
function self:ComputeCorners ()
	self.CornersValid = true
	
	for i = 1, 8 do
		self.Corners [i] = self.Corners [i] or GCAD.Vector3d ()
	end
	
	GCAD.Profiler:Begin ("OBB3d:ComputeCorners : Generate corners")
	local x1, y1, z1 = self.Min [1], self.Min [2], self.Min [3]
	local x2, y2, z2 = self.Max [1], self.Max [2], self.Max [3]
	local c
	c = self.Corners [1] c [1] = x1 c [2] = y1 c [3] = z1
	c = self.Corners [2] c [1] = x2 c [2] = y1 c [3] = z1
	c = self.Corners [3] c [1] = x2 c [2] = y2 c [3] = z1
	c = self.Corners [4] c [1] = x1 c [2] = y2 c [3] = z1
	c = self.Corners [5] c [1] = x1 c [2] = y1 c [3] = z2
	c = self.Corners [6] c [1] = x2 c [2] = y1 c [3] = z2
	c = self.Corners [7] c [1] = x2 c [2] = y2 c [3] = z2
	c = self.Corners [8] c [1] = x1 c [2] = y2 c [3] = z2
	GCAD.Profiler:End ()
	
	GCAD.Profiler:Begin ("OBB3d:ComputeCorners : Rotate corners")
	local x      = Angle_Forward (self.Angle)
	local minusY = Angle_Right   (self.Angle)
	local z      = Angle_Up      (self.Angle)
	
	local x1, x2, x3 =  Vector___index (     x, "x"),  Vector___index (     x, "y"),  Vector___index (     x, "z")
	local y1, y2, y3 = -Vector___index (minusY, "x"), -Vector___index (minusY, "y"), -Vector___index (minusY, "z")
	local z1, z2, z3 =  Vector___index (     z, "x"),  Vector___index (     z, "y"),  Vector___index (     z, "z")
	
	local cx, cy, cz = self.Center [1], self.Center [2], self.Center [3]
	
	for i = 1, 8 do
		local c = self.Corners [i]
		local x, y, z = c [1], c [2], c [3]
		self.Corners [i] [1] = cx + x * x1 + y * y1 + z * z1
		self.Corners [i] [2] = cy + x * x2 + y * y2 + z * z2
		self.Corners [i] [3] = cz + x * x3 + y * y3 + z * z3
	end
	GCAD.Profiler:End ()
end
self.ComputeCorners = GCAD.Profiler:Wrap (self.ComputeCorners, "OBB3d:ComputeCorners")
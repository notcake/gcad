local self = {}
GCAD.OBB3d = GCAD.MakeConstructor (self)

local Angle_Set      = debug.getregistry ().Angle.Set
local Vector___index = debug.getregistry ().Vector.__index

function GCAD.OBB3d.FromEntity (ent, out)
	out = out or GCAD.OBB3d ()
	
	local v
	v = ent:GetPos  () out.Center [1] = Vector___index (v, "x") out.Center [2] = Vector___index (v, "y") out.Center [3] = Vector___index (v, "z")
	v = ent:OBBMins () out.Min    [1] = Vector___index (v, "x") out.Min    [2] = Vector___index (v, "y") out.Min    [3] = Vector___index (v, "z")
	v = ent:OBBMaxs () out.Max    [1] = Vector___index (v, "x") out.Max    [2] = Vector___index (v, "y") out.Max    [3] = Vector___index (v, "z")
	
	out:SetAngle (ent:GetAngles ())
	
	return out
end

function self:ctor (center, min, max, angle)
	self.Center = GLib.ColumnVector (3)
	self.Min    = GLib.ColumnVector (3)
	self.Max    = GLib.ColumnVector (3)
	self.Angle  = Angle ()
	
	self.Corners = {}
	self.CornersValid = false
	
	if center then self:SetCenter (center) end
	if min then self:SetMin (min) end
	if max then self:SetMax (min) end
	if angle then self:SetAngle (angle) end
end

function self:GetCorner (n, out)
	out = out or GLib.ColumnVector (3)
	
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
	
	local x      = self.Angle:Forward ()
	local minusY = self.Angle:Right ()
	local z      = self.Angle:Up ()
	
	for i = 1, 8 do
		self.Corners [i] = self.Corners [i] or GLib.ColumnVector (3)
	end
	
	self.Corners [1] [1] = self.Min [1] self.Corners [1] [2] = self.Min [2] self.Corners [1] [3] = self.Min [3]
	self.Corners [2] [1] = self.Max [1] self.Corners [2] [2] = self.Min [2] self.Corners [2] [3] = self.Min [3]
	self.Corners [3] [1] = self.Max [1] self.Corners [3] [2] = self.Max [2] self.Corners [3] [3] = self.Min [3]
	self.Corners [4] [1] = self.Min [1] self.Corners [4] [2] = self.Max [2] self.Corners [4] [3] = self.Min [3]
	self.Corners [5] [1] = self.Min [1] self.Corners [5] [2] = self.Min [2] self.Corners [5] [3] = self.Max [3]
	self.Corners [6] [1] = self.Max [1] self.Corners [6] [2] = self.Min [2] self.Corners [6] [3] = self.Max [3]
	self.Corners [7] [1] = self.Max [1] self.Corners [7] [2] = self.Max [2] self.Corners [7] [3] = self.Max [3]
	self.Corners [8] [1] = self.Min [1] self.Corners [8] [2] = self.Max [2] self.Corners [8] [3] = self.Max [3]
	
	for i = 1, 8 do
		local cx, cy, cz = self.Corners [i] [1], self.Corners [i] [2], self.Corners [i] [3]
		self.Corners [i] [1] = self.Center [1] + cx * x [1] - cy * minusY [1] + cz * z [1]
		self.Corners [i] [2] = self.Center [2] + cx * x [2] - cy * minusY [2] + cz * z [2]
		self.Corners [i] [3] = self.Center [3] + cx * x [3] - cy * minusY [3] + cz * z [3]
	end
end
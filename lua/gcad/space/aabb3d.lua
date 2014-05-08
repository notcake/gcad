local self = {}
GCAD.AABB3d = GCAD.MakeConstructor (self)

function GCAD.AABB3d.FromEntity (ent, out)
	out = out or GCAD.AABB3d ()
	
	local min, max = ent:WorldSpaceAABB ()
	out:SetMin (min)
	out:SetMax (max)
	
	return out
end

function self:ctor (min, max)
	self.Min = GLib.ColumnVector (3)
	self.Max = GLib.ColumnVector (3)
	
	self:Clear ()
	
	if min then self:SetMin (min) end
	if max then self:SetMax (min) end
end

function self:Clear ()
	self.Min [1] =  math.huge
	self.Min [2] =  math.huge
	self.Min [3] =  math.huge
	self.Max [1] = -math.huge
	self.Max [2] = -math.huge
	self.Max [3] = -math.huge
end

function self:Expand (pos)
	self.Min [1] = math.min (self.Min [1], pos [1])
	self.Min [2] = math.min (self.Min [2], pos [2])
	self.Min [3] = math.min (self.Min [3], pos [3])
	self.Max [1] = math.max (self.Max [1], pos [1])
	self.Max [2] = math.max (self.Max [2], pos [2])
	self.Max [3] = math.max (self.Max [3], pos [3])
end

function self:GetCorner (n, out)
	out = out or GLib.ColumnVector (3)
	
	if     n == 1 then out [1] = self.Min [1] out [2] = self.Min [2] out [3] = self.Min [3]
	elseif n == 2 then out [1] = self.Max [1] out [2] = self.Min [2] out [3] = self.Min [3]
	elseif n == 3 then out [1] = self.Max [1] out [2] = self.Max [2] out [3] = self.Min [3]
	elseif n == 4 then out [1] = self.Min [1] out [2] = self.Max [2] out [3] = self.Min [3]
	elseif n == 5 then out [1] = self.Min [1] out [2] = self.Min [2] out [3] = self.Max [3]
	elseif n == 6 then out [1] = self.Max [1] out [2] = self.Min [2] out [3] = self.Max [3]
	elseif n == 7 then out [1] = self.Max [1] out [2] = self.Max [2] out [3] = self.Max [3]
	elseif n == 8 then out [1] = self.Min [1] out [2] = self.Max [2] out [3] = self.Max [3]
	end
	
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

function self:GetMin (out)
	if out then return self.Min:Clone (out) end
	return self.Min
end

function self:GetMax (out)
	if out then return self.Max:Clone (out) end
	return self.Max
end

function self:SetMin (min)
	self.Min [1] = min [1]
	self.Min [2] = min [2]
	self.Min [3] = min [3]
	return self
end

function self:SetMax (max)
	self.Max [1] = max [1]
	self.Max [2] = max [2]
	self.Max [3] = max [3]
	return self
end
local self = {}
GCAD.OctreeItemNode = GCAD.MakeConstructor (self, GCAD.ISpatialPartitionItemNode3d)

local GCAD_AABB3d_Clone = GCAD.AABB3d.Clone

function self:ctor (item)
	self.Parent = nil
	self.Item   = item
	
	self.AABB3d = GCAD.AABB3d ()
	self.Point  = false
	
	self:Update ()
end

-- ISpatialNode3d
function self:GetAABB (out)
	if not out then return self.AABB3d end
	return GCAD_AABB3d_Clone (self.AABB3d, out)
end

function self:GetBoundingSphere (out)
	return self.Item:GetBoundingSphere (out)
end

function self:GetOBB (out)
	return self.Item:GetOBB (out)
end

function self:GetNativeOBB (out)
	return self.Item:GetNativeOBB (out)
end

-- ISpatialPartitionItemNode3d
function self:GetItem ()
	return self.Item
end

function self:GetParent ()
	return self.Parent
end

function self:Remove ()
	self.Parent:Remove (self)
end

function self:Update ()
	self.AABB3d = self.Item:GetAABB (self.AABB3d)
	self.Point = self.AABB3d.Min [1] == self.AABB3d.Max [1] and
	             self.AABB3d.Min [2] == self.AABB3d.Max [2] and
				 self.AABB3d.Min [3] == self.AABB3d.Max [3]
	
	if self.Parent then
		self.Parent:Update (self, self:GetAABB ())
	end
end

-- OctreeItemNode
function self:IsPoint ()
	return self.Point
end
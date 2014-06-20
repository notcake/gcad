local self = {}
GCAD.SpatialNode2d = GCAD.MakeConstructor (self, GCAD.ISpatialNode2d)

function self:ctor ()
	self.AABB           = GCAD.AABB2d ()
	self.BoundingCircle = GCAD.Circle2d ()
	self.OBB            = GCAD.OBB2d ()
	
	self.AABBValid           = false
	self.BoundingCircleValid = false
	self.OBBValid            = false
end

-- ISpatialNode3d
function self:GetAABB (out)
	if not self.AABBValid then
		self:ComputeAABB ()
	end
	
	if not out then return self.AABB end
	return GCAD.AABB2d.Clone (self.AABB, out)
end

function self:GetBoundingCircle (out)
	if not self.BoundingCircleValid then
		self:ComputeBoundingCircle ()
	end
	
	if not out then return self.BoundingCircle end
	return GCAD.Circle2d.Clone (self.BoundingCircle, out)
end

function self:GetOBB (out)
	if not self.OBBValid then
		self:ComputeOBB ()
	end
	
	if not out then return self.OBB end
	return GCAD.OBB2d.Clone (self.OBB, out)
end

function self:InvalidateBoundingVolumes ()
	self.AABBValid           = false
	self.BoundingCircleValid = false
	self.OBBValid            = false
end

function self:ComputeAABB ()
	GCAD.Error ("SpatialNode2d:ComputeAABB : Not implemented.")
end

function self:ComputeBoundingCircle ()
	GCAD.Error ("SpatialNode2d:ComputeBoundingCircle : Not implemented.")
end

function self:ComputeOBB ()
	GCAD.Error ("SpatialNode2d:ComputeOBB : Not implemented.")
end
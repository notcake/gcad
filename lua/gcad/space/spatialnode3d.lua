local self = {}
GCAD.SpatialNode3d = GCAD.MakeConstructor (self, GCAD.ISpatialNode3d)

function self:ctor ()
	self.AABB           = GCAD.AABB3d ()
	self.BoundingSphere = GCAD.Sphere3d ()
	self.OBB            = GCAD.OBB3d ()
	self.NativeOBB      = GCAD.NativeOBB3d ()
	
	self.AABBValid           = false
	self.BoundingSphereValid = false
	self.OBBValid            = false
	self.NativeOBBValid      = false
end

-- ISpatialNode3d
function self:GetAABB (out)
	if not self.AABBValid then
		self:ComputeAABB ()
	end
	
	if not out then return self.AABB end
	return GCAD.AABB3d.Clone (self.AABB, out)
end

function self:GetBoundingSphere (out)
	if not self.BoundingSphereValid then
		self:ComputeBoundingSphere ()
	end
	
	if not out then return self.BoundingSphere end
	return GCAD.Sphere3d.Clone (self.BoundingSphere, out)
end

function self:GetOBB (out)
	if not self.OBBValid then
		self:ComputeOBB ()
	end
	
	if not out then return self.OBB end
	return GCAD.OBB3d.Clone (self.OBB, out)
end

function self:GetNativeOBB (out)
	if not self.NativeOBBValid then
		self:ComputeNativeOBB ()
	end
	
	if not out then return self.NativeOBB end
	return GCAD.NativeOBB3d.Clone (self.NativeOBB, out)
end

function self:InvalidateBoundingVolumes ()
	self.AABBValid           = false
	self.BoundingSphereValid = false
	self.OBBValid            = false
	self.NativeOBBValid      = false
end

function self:ComputeAABB ()
	GCAD.Error ("SpatialNode3d:ComputeAABB : Not implemented.")
end

function self:ComputeBoundingSphere ()
	GCAD.Error ("SpatialNode3d:ComputeBoundingSphere : Not implemented.")
end

function self:ComputeOBB ()
	GCAD.Error ("SpatialNode3d:ComputeOBB : Not implemented.")
end

function self:ComputeNativeOBB ()
	self.NativeOBBValid = true
	self.NativeOBB = GCAD.OBB3d.ToNativeOBB3d (self.OBB, self.NativeOBB)
end
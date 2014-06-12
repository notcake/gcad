local self = {}
GCAD.VEntities.Point3dComponent = GCAD.MakeConstructor (self,
	GCAD.VEntities.VEntity,
	GCAD.ISpatialNode3d
)

function self:ctor ()
	-- ISpatialNode3d
	self:SetSpatialNode3d (self)
	
	self.Position       = GCAD.Vector3d ()
	self.BoundingSphere = GCAD.Sphere3d ()
	self.OBB            = GCAD.OBB3d ()
	
	self.BoundingSphere:SetRadius (0)
	self.OBB:SetMinUnpacked (0, 0, 0)
	self.OBB:SetMaxUnpacked (0, 0, 0)
end

-- ISpatialNode3d
function self:GetBoundingSphere (out)
	return out and self.BoundingSphere:Clone (out) or self.BoundingSphere
end

function self:GetOBB (out)
	return out and self.OBB:Clone (out) or self.OBB
end

-- Point3dComponent
function self:GetPosition (out)
	return out and self.Position:Clone (out) or self.Position
end

function self:GetPositionNative (out)
	return self.Position:ToNativeVector (out)
end

function self:SetPosition (pos)
	self.Position:Copy (pos)
	self.BoundingSphere:SetPosition (pos)
	self.OBB:SetPosition (pos)
	
	return self
end
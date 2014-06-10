local self = {}
GCAD.ISpatialNode3d = GCAD.MakeConstructor (self, GCAD.ISpatialNode3dHost)

function self:ctor ()
end

-- ISpatialNode3dHost
function self:GetSpatialNode3d ()
	return self
end

-- ISpatialNode3d
function self:GetAABB (out)
	GCAD.Error ("ISpatialNode3d:GetAABB : Not implemented.")
end

function self:GetBoundingSphere (out)
	GCAD.Error ("ISpatialNode3d:GetBoundingSphere : Not implemented.")
end

function self:GetOBB (out)
	GCAD.Error ("ISpatialNode3d:GetOBB : Not implemented.")
end
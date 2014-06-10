local self = {}
GCAD.ISpatialNode3d = GCAD.MakeConstructor (self, GCAD.ISpatialNode3dHost)

function self:ctor ()
end

-- ISpatialNode3dHost
function self:GetSpatialNode3d ()
	return self
end

-- ISpatialNode3d
-- If out is not specified, an immutable reference should be returned
function self:GetAABB (out)
	GCAD.Error ("ISpatialNode3d:GetAABB : Not implemented.")
end

-- If out is not specified, an immutable reference should be returned
function self:GetBoundingSphere (out)
	GCAD.Error ("ISpatialNode3d:GetBoundingSphere : Not implemented.")
end

-- If out is not specified, an immutable reference should be returned
function self:GetOBB (out)
	GCAD.Error ("ISpatialNode3d:GetOBB : Not implemented.")
end

-- If out is not specified, an immutable reference should be returned
function self:GetNativeOBB (out)
	GCAD.Error ("ISpatialNode3d:GetNativeOBB : Not implemented.")
end
local self = {}
GCAD.ISpatialNode2d = GCAD.MakeConstructor (self, GCAD.ISpatialNode2dHost)

function self:ctor ()
end

-- ISpatialNode2dHost
function self:GetSpatialNode2d ()
	return self
end

-- ISpatialNode2d
-- If out is not specified, an immutable reference should be returned
function self:GetAABB (out)
	GCAD.Error ("ISpatialNode2d:GetAABB : Not implemented.")
end

-- If out is not specified, an immutable reference should be returned
function self:GetBoundingCircle (out)
	GCAD.Error ("ISpatialNode2d:GetBoundingCircle : Not implemented.")
end

-- If out is not specified, an immutable reference should be returned
function self:GetOBB (out)
	GCAD.Error ("ISpatialNode2d:GetOBB : Not implemented.")
end
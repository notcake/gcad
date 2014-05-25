local self = {}
GCAD.ISpatialQueryable3d = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:FindInAABB (aabb3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindInAABB : Not implemented.")
end

function self:FindIntersectingAABB (aabb3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindIntersectingAABB : Not implemented.")
end

function self:FindInSphere (sphere3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindInSphere : Not implemented.")
end

function self:FindIntersectingSphere (sphere3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindIntersectingSphere : Not implemented.")
end

function self:FindInPlane (plane3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindInPlane : Not implemented.")
end

function self:FindIntersectingPlane (plane3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindIntersectingPlane : Not implemented.")
end

function self:FindInFrustum (frustum3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindInFrustum : Not implemented.")
end

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable3d:FindIntersectingFrustum : Not implemented.")
end
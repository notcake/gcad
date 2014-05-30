local self = {}
GCAD.ISpatialQueryable2d = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:FindInAABB (aabb2d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable2d:FindInAABB : Not implemented.")
end

function self:FindIntersectingAABB (aabb2d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable2d:FindIntersectingAABB : Not implemented.")
end

function self:FindInCircle (circle2d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable2d:FindInCircle : Not implemented.")
end

function self:FindIntersectingCircle (circle2d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable2d:FindIntersectingCircle : Not implemented.")
end

function self:FindInPlane (plane2d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable2d:FindInPlane : Not implemented.")
end

function self:FindIntersectingPlane (plane2d, spatialQueryResult)
	GCAD.Error ("ISpatialQueryable2d:FindIntersectingPlane : Not implemented.")
end

function self:TraceLine (line2d, lineTraceResult)
	GCAD.Error ("ISpatialQueryable2d:TraceLine : Not implemented.")
end
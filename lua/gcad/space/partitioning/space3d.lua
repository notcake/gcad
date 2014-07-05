local self = {}
GCAD.Space3d = GCAD.MakeConstructor (self, GCAD.ISpace3d)

function self:ctor ()
end

-- ISpatialQueryable3d
function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	return self:FindIntersectingFrustum2 (self:GetRootSpatialPartitionNode (), frustum3d, spatialQueryResult)
end

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	return self:TraceLine2 (self:GetRootSpatialPartitionNode (), line3d, lineTraceResult)
end

-- Space3d
function self:FindIntersectingFrustum2 (spatialPartitionNode, frustum3d, spatialQueryResult)
	if spatialPartitionNode:GetExclusiveItemCount () > 0 then
		for spatialPartitionItemNode in spatialPartitionNode:GetExclusiveItemNodeEnumerator () do
			local intersects, contains = frustum3d:IntersectsSphere (spatialPartitionItemNode:GetBoundingSphere ())
			if contains then
				spatialQueryResult:Add (spatialPartitionItemNode:GetItem (), true)
			elseif intersects then
				if frustum3d:IntersectsOBB (spatialPartitionItemNode:GetOBB ()) then
					spatialQueryResult:Add (spatialPartitionItemNode:GetItem ())
				end
			end
		end
	end
	
	for childSpatialPartitionNode in spatialPartitionNode:GetChildNodeEnumerator () do
		if childSpatialPartitionNode:GetInclusiveItemCount () > 0 then
			local intersects, contains = frustum3d:IntersectsSphere (childSpatialPartitionNode:GetBoundingSphere ())
			if contains then
				self:FindInSpatialPartitionNode (childSpatialPartitionNode, spatialQueryResult)
			elseif intersects then
				self:FindIntersectingFrustum2 (childSpatialPartitionNode, frustum3d, spatialQueryResult)
			end
		end
	end
	
	return spatialQueryResult
end

-- Internal, do not call
function self:FindInSpatialPartitionNode (spatialPartitionNode, spatialQueryResult)
	if spatialPartitionNode:GetInclusiveItemCount () == 0 then return end
	
	if spatialPartitionNode:GetExclusiveItemCount () > 0 then
		for spatialPartitionItemNode in spatialPartitionNode:GetExclusiveItemNodeEnumerator () do
			spatialQueryResult:Add (spatialPartitionItemNode:GetItem (), true)
		end
	end
	
	for childSpatialPartitionNode in spatialPartitionNode:GetChildNodeEnumerator () do
		self:FindInSpatialPartitionNode (childSpatialPartitionNode, spatialQueryResult)
	end
	
	return spatialPartitionNode
end
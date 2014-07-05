local self = {}
GCAD.ISpatialPartitionNode3d = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetBoundingSphere (out)
	GCAD.Error ("ISpatialPartitionNode3d:GetBoundingSphere : Not implemented.")
end

function self:GetParent ()
	GCAD.Error ("ISpatialPartitionNode3d:GetParent : Not implemented.")
end

function self:GetChildNodeEnumerator ()
	GCAD.Error ("ISpatialPartitionNode3d:GetChildNodeEnumerator : Not implemented.")
end

function self:GetExclusiveItemCount ()
	GCAD.Error ("ISpatialPartitionNode3d:GetExclusiveItemCount : Not implemented.")
end

function self:GetExclusiveItemNodeEnumerator ()
	GCAD.Error ("ISpatialPartitionNode3d:GetExclusiveItemNodeEnumerator : Not implemented.")
end

function self:GetInclusiveItemCount ()
	GCAD.Error ("ISpatialPartitionNode3d:GetInclusiveItemCount : Not implemented.")
end
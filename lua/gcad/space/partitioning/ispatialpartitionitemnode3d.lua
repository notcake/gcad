local self = {}
GCAD.ISpatialPartitionItemNode3d = GCAD.MakeConstructor (self, GCAD.ISpatialNode3d)

function self:ctor ()
end

function self:GetItem ()
	GCAD.Error ("ISpatialPartitionItemNode3d:GetItem : Not implemented.")
end

function self:GetParent ()
	GCAD.Error ("ISpatialPartitionItemNode3d:GetParent : Not implemented.")
end

function self:Remove ()
	GCAD.Error ("ISpatialPartitionItemNode3d:Remove : Not implemented.")
end

function self:Update ()
	GCAD.Error ("ISpatialPartitionItemNode3d:GetItem : Not implemented.")
end
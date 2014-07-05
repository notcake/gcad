local self = {}
GCAD.ISpace3d = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d, GLib.Containers.ICollection)

function self:ctor ()
end

function self:GetRootSpatialPartitionNode ()
	GCAD.Error ("ISpace3d:GetRootSpatialPartitionNode : Not implemented.")
end
local self = {}
GCAD.ISpatialNode3dHost = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetSpatialNode3d ()
	GCAD.Error ("ISpatialNode3dHost:GetSpatialNode3d : Not implemented.")
end
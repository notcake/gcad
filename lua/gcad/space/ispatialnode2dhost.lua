local self = {}
GCAD.ISpatialNode2dHost = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetSpatialNode2d ()
	GCAD.Error ("ISpatialNode2dHost:GetSpatialNode2d : Not implemented.")
end
local self = {}
GCAD.Components.IComponentHost = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetComponent (componentName)
	GCAD.Error ("IComponentHost:GetComponent : Not implemented.")
end

function self:GetSpatialNode2d ()
	GCAD.Error ("IComponentHost:GetSpatialNode2d : Not implemented.")
end

function self:GetSpatialNode3d ()
	GCAD.Error ("IComponentHost:GetSpatialNode3d : Not implemented.")
end

function self:GetSpatialNode3d ()
	GCAD.Error ("IComponentHost:GetSpatialNode3d : Not implemented.")
end

function self:GetRenderNode ()
	GCAD.Error ("IComponentHost:GetRenderNode : Not implemented.")
end

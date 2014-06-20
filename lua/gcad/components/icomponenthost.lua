local self = {}
GCAD.Components.IComponentHost = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetComponent (componentName)
	GCAD.Error ("IComponentHost:GetComponent : Not implemented.")
end

function self:GetRenderComponent ()
	GCAD.Error ("IComponentHost:GetRenderComponent : Not implemented.")
end

function self:GetSceneGraphNode ()
	GCAD.Error ("IComponentHost:GetSceneGraphNode : Not implemented.")
end

function self:GetSpatialNode2d ()
	GCAD.Error ("IComponentHost:GetSpatialNode2d : Not implemented.")
end

function self:GetSpatialNode3d ()
	GCAD.Error ("IComponentHost:GetSpatialNode3d : Not implemented.")
end
local self = {}
GCAD.Components.ComponentHost = GCAD.MakeConstructor (self, GCAD.Components.IComponentHost)

function self:ctor ()
	self.RenderComponent = nil
	self.SceneGraphNode  = nil
	self.SpatialNode2d   = nil
	self.SpatialNode3d   = nil
end

-- IComponentHost
function self:GetComponent (componentName)
	return self [componentName]
end

function self:GetRenderComponent ()
	return self.RenderComponent
end

function self:GetSceneGraphNode ()
	return self.SceneGraphNode
end

function self:GetSpatialNode2d ()
	return self.SpatialNode2d
end

function self:GetSpatialNode3d ()
	return self.SpatialNode3d
end

-- ComponentHost
function self:SetComponent (componentName, component)
	self [componentName] = component
	return self
end

function self:SetRenderComponent (renderComponent)
	self.RenderComponent = renderComponent
end

function self:SetSceneGraphNode (sceneGraphNode)
	self.SceneGraphNode = sceneGraphNode
end

function self:SetSpatialNode2d (spatialNode2d)
	self.SpatialNode2d = spatialNode2d
	return self
end

function self:SetSpatialNode3d (spatialNode3d)
	self.SpatialNode3d = spatialNode3d
	return self
end
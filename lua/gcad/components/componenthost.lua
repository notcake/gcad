local self = {}
GCAD.Components.ComponentHost = GCAD.MakeConstructor (self, GCAD.Components.IComponentHost)

function self:ctor ()
	self.SpatialNode2d = nil
	self.SpatialNode3d = nil
	self.RenderNode    = nil
end

-- IComponentHost
function self:GetComponent (componentName)
	return self [componentName]
end

function self:GetSpatialNode2d ()
	return self.SpatialNode2d
end

function self:GetSpatialNode3d ()
	return self.SpatialNode3d
end

function self:GetRenderNode ()
	return self.RenderNode
end

-- ComponentHost
function self:SetComponent (componentName, component)
	self [componentName] = component
	return self
end

function self:SetSpatialNode2d (spatialNode2d)
	self.SpatialNode2d = spatialNode2d
	return self
end

function self:SetSpatialNode3d (spatialNode3d)
	self.SpatialNode3d = spatialNode3d
	return self
end

function self:SetRenderNode (renderNode)
	self.RenderNode = renderNode
end
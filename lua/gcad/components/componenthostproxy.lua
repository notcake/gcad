local self = {}
GCAD.Components.ComponentHostProxy = GCAD.MakeConstructor (self, GCAD.Components.IComponent)

function self:ctor ()
	self.ComponentHost = nil
end

-- IComponentHost
function self:GetComponent (componentName)
	if not self.ComponentHost then return nil end
	return self.ComponentHost:GetComponent (componentName)
end

function self:GetRenderComponent ()
	if not self.ComponentHost then return nil end
	return self.ComponentHost:GetRenderComponent ()
end

function self:GetSceneGraphNode ()
	if not self.ComponentHost then return nil end
	return self.ComponentHost:GetSceneGraphNode ()
end

function self:GetSpatialNode2d ()
	if not self.ComponentHost then return nil end
	return self.ComponentHost:GetSpatialNode2d ()
end

function self:GetSpatialNode3d ()
	if not self.ComponentHost then return nil end
	return self.ComponentHost:GetSpatialNode3d ()
end

-- IComponent
function self:GetComponentHost ()
	return self.ComponentHost
end

-- ComponentHostProxy
function self:SetComponentHost (componentHost)
	self.ComponentHost = componentHost
	return self
end
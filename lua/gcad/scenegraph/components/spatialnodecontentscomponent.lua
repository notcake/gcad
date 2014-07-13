local self = {}
GCAD.SceneGraph.Components.SpatialNodeContentsComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.NonContainerComponent)
local base = self.__base

function self:ctor (sceneGraphNode)
end

-- IContentsComponent
function self:Initialize ()
	base.Initialize (self)
	
	self.SpatialNode = nil
end

-- Bounding volumes
function self:GetLocalSpaceAABB ()
	return self.SpatialNode:GetAABB ()
end

function self:GetLocalSpaceBoundingSphere ()
	return self.SpatialNode:GetBoundingSphere ()
end

function self:GetLocalSpaceOBB ()
	return self.SpatialNode:GetOBB ()
end

-- SpatialNodeContentsComponent
function self:GetSpatialNode ()
	return self.SpatialNode
end

function self:SetSpatialNode (spatialNode)
	if self.SpatialNode == spatialNode then return self end
	
	self.SpatialNode = spatialNode
	self:InvalidateLocalSpaceBoundingVolumes ()
	
	return self
end

GCAD.SceneGraph.Components.SpatialNodeContentsComponent.Instance = GCAD.SceneGraph.Components.SpatialNodeContentsComponent ()
local self = {}
GCAD.SceneGraph.GroupNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.SceneGraphNode)

function self:ctor ()
	self:SetTransformationComponent (GCAD.SceneGraph.Components.NonTransformationComponent.Instance)
	self:SetContentsComponent (GCAD.SceneGraph.Components.NodeContainerComponent.Instance)
end
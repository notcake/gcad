local self = {}
GCAD.SceneGraph.MatrixTransformationNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.SceneGraphNode)

function self:ctor ()
	self:SetTransformationComponent (GCAD.SceneGraph.Components.TransformationComponent.Instance)
	self:SetContentsComponent (GCAD.SceneGraph.Components.NodeContainerComponent.Instance)
end
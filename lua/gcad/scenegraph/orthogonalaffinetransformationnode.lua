local self = {}
GCAD.SceneGraph.OrthogonalAffineTransformationNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.SceneGraphNode)

function self:ctor ()
	self:SetTransformationComponent (GCAD.SceneGraph.Components.OrthogonalAffineTransformationComponent.Instance)
	self:SetContentsComponent (GCAD.SceneGraph.Components.NodeContainerComponent.Instance)
end
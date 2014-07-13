local self = {}
GCAD.SceneGraph.ModelNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.SceneGraphNode)

function self:ctor ()
	self:SetTransformationComponent (GCAD.SceneGraph.Components.OrthogonalAffineTransformationComponent.Instance)
	self:SetContentsComponent (GCAD.SceneGraph.Components.NonContainerComponent.Instance)
end
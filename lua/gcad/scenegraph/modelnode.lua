local self = {}
GCAD.SceneGraph.ModelNode = GCAD.MakeConstructor (self,
	GCAD.SceneGraph.SceneGraphNode,
	GCAD.SceneGraph.Components.OrthogonalAffineTransformationNode
)

function self:ctor ()
end
local self = {}
GCAD.SceneGraph.OrthogonalAffineTransformationNode = GCAD.MakeConstructor (self,
	GCAD.SceneGraph.SceneGraphNode,
	GCAD.SceneGraph.Components.GroupNode,
	GCAD.SceneGraph.Components.OrthogonalAffineTransformationNode
)

function self:ctor ()
end
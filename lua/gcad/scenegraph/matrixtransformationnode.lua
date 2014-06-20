local self = {}
GCAD.SceneGraph.MatrixTransformationNode = GCAD.MakeConstructor (self,
	GCAD.SceneGraph.SceneGraphNode,
	GCAD.SceneGraph.Components.GroupNode,
	GCAD.SceneGraph.Components.TransformationNode
)

function self:ctor ()
end
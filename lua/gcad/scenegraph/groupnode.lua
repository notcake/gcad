local self = {}
GCAD.SceneGraph.GroupNode = GCAD.MakeConstructor (self,
	GCAD.SceneGraph.SceneGraphNode,
	GCAD.SceneGraph.Components.NonTransformationNode,
	GCAD.SceneGraph.Components.GroupNode
)

function self:ctor ()
end
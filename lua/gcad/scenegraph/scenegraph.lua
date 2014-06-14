local self = {}
GCAD.SceneGraph.SceneGraph = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraph)

function self:ctor ()
	self.RootNode = GCAD.SceneGraph.SceneGraphNode ()
end

-- ISceneGraph
function self:GetRootNode ()
	return self.RootNode
end
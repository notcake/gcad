local self = {}
GCAD.SceneGraph.SceneGraph = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraph)

function self:ctor ()
	self.RootNode = GCAD.SceneGraph.GroupNode ()
end

-- ISceneGraph
function self:GetRootNode ()
	return self.RootNode
end

function self:CreateGroupNode ()
	return GCAD.SceneGraph.GroupNode ()
end

function self:CreateModelNode ()
	return GCAD.SceneGraph.ModelNode ()
end

function self:CreateTransformationNode ()
	return GCAD.SceneGraph.TransformationNode ()
end
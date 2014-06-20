local self = {}
GCAD.SceneGraph.ISceneGraph = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetRootNode ()
	GCAD.Error ("ISceneGraph:GetRootNode : Not implemented.")
end

function self:CreateGroupNode ()
	GCAD.Error ("ISceneGraph:CreateGroupNode : Not implemented.")
end

function self:CreateModelNode ()
	GCAD.Error ("ISceneGraph:CreateModelNode : Not implemented.")
end

function self:CreateTransformationNode ()
	GCAD.Error ("ISceneGraph:CreateTransformationNode : Not implemented.")
end
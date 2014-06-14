local self = {}
GCAD.SceneGraph.ISceneGraph = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetRootNode ()
	GCAD.Error ("ISceneGraph:GetRootNode : Not implemented.")
end
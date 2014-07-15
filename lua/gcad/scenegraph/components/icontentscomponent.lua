local self = {}
GCAD.SceneGraph.Components.IContentsComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraphNode)

function self:ctor ()
end

function self:Initialize ()
	GCAD.Error ("IContentsComponent:Initialize : Not implemented.")
end

function self:Uninitialize ()
	GCAD.Error ("IContentsComponent:Uninitialize : Not implemented.")
end

-- Scene graph node
function self:GetSceneGraphNode ()
	GCAD.Error ("IContentsComponent:GetSceneGraphNode : Not implemented.")
end

-- Tree
function self:AddChild (sceneGraphNode)
	GCAD.Error ("IContentsComponent:AddChild : Not implemented.")
end

function self:ContainsNode (sceneGraphNode)
	GCAD.Error ("IContentsComponent:ContainsNode : Not implemented.")
end

function self:HasChildren ()
	GCAD.Error ("IContentsComponent:HasChildren : Not implemented.")
end

function self:GetChildCount ()
	GCAD.Error ("IContentsComponent:GetChildCount : Not implemented.")
end

function self:GetChildEnumerator ()
	GCAD.Error ("IContentsComponent:GetChildEnumerator : Not implemented.")
end

function self:GetRecursiveChildEnumerator ()
	GCAD.Error ("IContentsComponent:GetRecursiveChildEnumerator : Not implemented.")
end

function self:GetRecursiveEnumerator ()
	GCAD.Error ("IContentsComponent:GetRecursiveEnumerator : Not implemented.")
end

function self:RemoveChild (sceneGraphNode)
	GCAD.Error ("IContentsComponent:RemoveChild : Not implemented.")
end

function self:OnChildWorldSpaceBoundingVolumesInvalidated (sceneGraphNode)
	GCAD.Error ("IContentsComponent:OnChildWorldSpaceBoundingVolumesInvalidated : Not implemented.")
end

-- Bounding volumes
function self:GetLocalSpaceAABB ()
	GCAD.Error ("IContentsComponent:GetLocalSpaceAABB : Not implemented.")
end

function self:GetLocalSpaceBoundingSphere ()
	GCAD.Error ("IContentsComponent:GetLocalSpaceBoundingSphere : Not implemented.")
end

function self:GetLocalSpaceOBB ()
	GCAD.Error ("IContentsComponent:GetLocalSpaceOBB : Not implemented.")
end
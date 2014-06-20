local self = {}
GCAD.SceneGraph.ISceneGraphNode = GCAD.MakeConstructor (self)

function self:ctor ()
end

-- Scene graph
function self:GetSceneGraph ()
	GCAD.Error ("ISceneGraphNode:GetSceneGraph : Not implemented.")
end

-- Tree
function self:AddChild (sceneGraphNode)
	GCAD.Error ("ISceneGraphNode:AddChild : Not implemented.")
end

function self:ContainsNode (sceneGraphNode)
	GCAD.Error ("ISceneGraphNode:ContainsNode : Not implemented.")
end

function self:HasChildren ()
	GCAD.Error ("ISceneGraphNode:HasChildren : Not implemented.")
end

function self:GetChildCount ()
	GCAD.Error ("ISceneGraphNode:GetChildCount : Not implemented.")
end

function self:GetChildEnumerator ()
	GCAD.Error ("ISceneGraphNode:GetChildEnumerator : Not implemented.")
end

function self:GetParent ()
	GCAD.Error ("ISceneGraphNode:GetParent : Not implemented.")
end

function self:GetRecursiveChildEnumerator ()
	GCAD.Error ("ISceneGraphNode:GetRecursiveChildEnumerator : Not implemented.")
end

function self:GetRecursiveEnumerator ()
	GCAD.Error ("ISceneGraphNode:GetRecursiveEnumerator : Not implemented.")
end

function self:SetParent (parent)
	GCAD.Error ("ISceneGraphNode:SetParent : Not implemented.")
end

function self:RemoveChild (sceneGraphNode)
	GCAD.Error ("ISceneGraphNode:RemoveChild : Not implemented.")
end

-- Scene graph
function self:Remove ()
	GCAD.Error ("ISceneGraphNode:Remove : Not implemented.")
end

-- Bounding volumes
function self:GetLocalSpaceAABB ()
	GCAD.Error ("ISceneGraphNode:GetLocalSpaceAABB : Not implemented.")
end

function self:GetLocalSpaceBoundingSphere ()
	GCAD.Error ("ISceneGraphNode:GetLocalSpaceBoundingSphere : Not implemented.")
end

function self:GetLocalSpaceOBB ()
	GCAD.Error ("ISceneGraphNode:GetLocalSpaceOBB : Not implemented.")
end

function self:GetParentSpaceAABB ()
	GCAD.Error ("ISceneGraphNode:GetParentSpaceAABB : Not implemented.")
end

function self:GetParentSpaceBoundingSphere ()
	GCAD.Error ("ISceneGraphNode:GetParentSpaceBoundingSphere : Not implemented.")
end

function self:GetParentSpaceOBB ()
	GCAD.Error ("ISceneGraphNode:GetParentSpaceOBB : Not implemented.")
end

function self:GetWorldSpaceAABB ()
	GCAD.Error ("ISceneGraphNode:GetWorldSpaceAABB : Not implemented.")
end

function self:GetWorldSpaceBoundingSphere ()
	GCAD.Error ("ISceneGraphNode:GetWorldSpaceBoundingSphere : Not implemented.")
end

function self:GetWorldSpaceOBB ()
	GCAD.Error ("ISceneGraphNode:GetWorldSpaceOBB : Not implemented.")
end

-- Transformations
function self:GetLocalToParentMatrix ()
	GCAD.Error ("ISceneGraphNode:GetLocalToParentMatrix : Not implemented.")
end

function self:GetLocalToParentMatrixNative ()
	GCAD.Error ("ISceneGraphNode:GetLocalToParentMatrixNative : Not implemented.")
end

function self:GetParentToLocalMatrix ()
	GCAD.Error ("ISceneGraphNode:GetParentToLocalMatrix : Not implemented.")
end

function self:GetParentToLocalMatrixNative ()
	GCAD.Error ("ISceneGraphNode:GetParentToLocalMatrixNative : Not implemented.")
end

function self:GetLocalToWorldMatrix ()
	GCAD.Error ("ISceneGraphNode:GetLocalToWorldMatrix : Not implemented.")
end

function self:GetLocalToWorldMatrixNative ()
	GCAD.Error ("ISceneGraphNode:GetLocalToWorldMatrixNative : Not implemented.")
end

function self:GetWorldToLocalMatrix ()
	GCAD.Error ("ISceneGraphNode:GetWorldToLocalMatrix : Not implemented.")
end

function self:GetWorldToLocalMatrixNative ()
	GCAD.Error ("ISceneGraphNode:GetWorldToLocalMatrixNative : Not implemented.")
end

-- Rendering
function self:GetRenderComponent ()
	GCAD.Error ("ISceneGraphNode:GetRenderComponent : Not implemented.")
end

function self:GetRenderModifierComponent ()
	GCAD.Error ("ISceneGraphNode:GetRenderModifierComponent : Not implemented.")
end
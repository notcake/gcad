local self = {}
GCAD.SceneGraph.Components.BaseTransformationComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.ITransformationComponent)

function self:ctor (sceneGraphNode)
	self.SceneGraphNode = sceneGraphNode
	
	self:Initialize ()
end

function self:dtor ()
	self:Uninitialize ()
end

-- ITransformationComponent
function self:Initialize ()
	-- Transformations
	self.LocalToWorldMatrixValid        = false
	self.WorldToLocalMatrixValid        = false
	
	self.LocalToWorldMatrixNativeValid  = false
	self.WorldToLocalMatrixNativeValid  = false
end

function self:Uninitialize ()
end

-- Scene graph node
function self:GetSceneGraphNode ()
	return self.SceneGraphNode
end

-- Invalidation
function self:InvalidateWorldMatrices ()
	-- When these are recomputed, the invalidation
	-- flags will be propagated down the tree.
	self.LocalToWorldMatrixValid        = false
	self.WorldToLocalMatrixValid        = false
	self.LocalToWorldMatrixNativeValid  = false
	self.WorldToLocalMatrixNativeValid  = false
	
	-- Invalidate world space bounding volumes too
	self:InvalidateWorldSpaceBoundingVolumes ()
end

function self:InvalidateLocalToWorldMatrix ()
	self.LocalToWorldMatrixValid        = false
	self.LocalToWorldMatrixNativeValid  = false
	
	-- Invalidate world space bounding volumes too
	self:InvalidateWorldSpaceBoundingVolumes ()
end

function self:InvalidateWorldToLocalMatrix ()
	self.WorldToLocalMatrixValid        = false
	self.WorldToLocalMatrixNativeValid  = false
end

function self:InvalidateChildLocalToWorldMatrices ()
	for childSceneGraphNode in self:GetChildEnumerator () do
		childSceneGraphNode:InvalidateLocalToWorldMatrix ()
	end
end

function self:InvalidateChildWorldToLocalMatrices ()
	for childSceneGraphNode in self:GetChildEnumerator () do
		childSceneGraphNode:InvalidateWorldToLocalMatrix ()
	end
end
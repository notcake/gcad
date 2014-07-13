local self = {}
GCAD.SceneGraph.Components.NonTransformationComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.BaseTransformationComponent)
local base = self.__base

function self:ctor (sceneGraphNode)
end

-- ITransformationComponent
function self:Initialize ()
	base.Initialize (self)
	
	-- Transformations
	self.LocalToParentMatrixValid       = false
	self.ParentToLocalMatrixValid       = false
	
	self.LocalToParentMatrixNativeValid = false
	self.ParentToLocalMatrixNativeValid = false
end

-- Bounding volumes
function self:GetParentSpaceAABB ()
	return self:GetLocalSpaceAABB ()
end

function self:GetParentSpaceBoundingSphere ()
	return self:GetLocalSpaceBoundingSphere ()
end

function self:GetParentSpaceOBB ()
	return self:GetLocalSpaceOBB ()
end

-- Transformations
local identityMatrix       = GCAD.Matrix4x4.Identity ()
local identityMatrixNative = Matrix ()

function self:GetLocalToParentMatrix ()
	return identityMatrix
end

function self:GetLocalToParentMatrixNative ()
	return identityMatrixNative
end

function self:GetParentToLocalMatrix ()
	return identityMatrix
end

function self:GetParentToLocalMatrixNative ()
	return identityMatrixNative
end

function self:GetLocalToWorldMatrix ()
	-- Need to propagate invalidation downwards
	if not self.LocalToWorldMatrixValid then
		self.LocalToWorldMatrixValid = true
		self:InvalidateChildLocalToWorldMatrices ()
	end
	
	return self.Parent and self.Parent:GetLocalToWorldMatrix () or identityMatrix
end

function self:GetLocalToWorldMatrixNative ()
	return self.Parent and self.Parent:GetLocalToWorldMatrixNative () or identityMatrixNative
end

function self:GetWorldToLocalMatrix ()
	-- Need to propagate invalidation downwards
	if not self.WorldToLocalMatrixValid then
		self.WorldToLocalMatrixValid = true
		self:InvalidateChildWorldToLocalMatrices ()
	end
	
	return self.Parent and self.Parent:GetWorldToLocalMatrix () or identityMatrix
end

function self:GetWorldToLocalMatrixNative ()
	return self.Parent and self.Parent:GetWorldToLocalMatrixNative () or identityMatrixNative
end

-- Invalidation
function self:InvalidateTransformation ()
	-- Nothing to do here
end

function self:InvalidateParentSpaceBoundingVolumes ()
	-- Nothing to do here
end

GCAD.SceneGraph.Components.NonTransformationComponent.Instance = GCAD.SceneGraph.Components.NonTransformationComponent ()
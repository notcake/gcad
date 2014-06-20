local self = {}
GCAD.SceneGraph.Components.NonTransformationNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.SceneGraphNode)

function self:ctor ()
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
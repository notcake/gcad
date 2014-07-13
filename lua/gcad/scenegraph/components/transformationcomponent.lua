local self = {}
GCAD.SceneGraph.Components.TransformationComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.BaseTransformationComponent)
local base = self.__base

function self:ctor (sceneGraphNode)
end

-- ITransformationComponent
function self:Initialize ()
	base.Initialize (self)
	
	-- Bounding volumes
	self.ParentSpaceAABB3d              = nil
	self.ParentSpaceBoundingSphere      = nil
	self.ParentSpaceOBB3d               = nil
	
	self.ParentSpaceAABB3dValid         = false
	self.ParentSpaceBoundingSphereValid = false
	self.ParentSpaceOBB3dValid          = false
	
	-- Transformations
	self.LocalToParentMatrix            = GCAD.Matrix4x4.Identity ()
	self.ParentToLocalMatrix            = nil
	
	self.LocalToParentMatrixNative      = nil
	self.ParentToLocalMatrixNative      = nil
	
	self.LocalToParentMatrixValid       = false
	self.ParentToLocalMatrixValid       = false
	
	self.LocalToParentMatrixNativeValid = false
	self.ParentToLocalMatrixNativeValid = false
end

-- Bounding volumes
function self:GetParentSpaceAABB ()
	if not self.ParentSpaceAABB3dValid then
		self:ComputeParentSpaceAABB3d ()
	end
	return self.ParentSpaceAABB3d
end

function self:GetParentSpaceBoundingSphere ()
	if not self.ParentSpaceBoundingSphereValid then
		self:ComputeParentSpaceBoundingSphere ()
	end
	return self.ParentSpaceBoundingSphere
end

function self:GetParentSpaceOBB ()
	if not self.ParentSpaceOBB3dValid then
		self:ComputeParentSpaceOBB3d ()
	end
	return self.ParentSpaceOBB3d
end

-- Transformations
function self:GetLocalToParentMatrix ()
	if not self.LocalToParentMatrixValid then
		self:ComputeLocalToParentMatrix ()
	end
	
	return self.LocalToParentMatrix
end

function self:GetLocalToParentMatrixNative ()
	if not self.LocalToParentMatrixNativeValid then
		self.LocalToParentMatrixNativeValid = true
		self.LocalToParentMatrixNative = GCAD.Matrix4x4.ToNativeMatrix (self:GetLocalToParentMatrix (), self.LocalToParentMatrixNative)
	end
	
	return self.LocalToParentMatrixNative
end

function self:GetParentToLocalMatrix ()
	if not self.ParentToLocalMatrixValid then
		self:ComputeParentToLocalMatrix ()
	end
	
	return self.ParentToLocalMatrix
end

function self:GetParentToLocalMatrixNative ()
	if not self.ParentToLocalMatrixNativeValid then
		self.ParentToLocalMatrixNativeValid = true
		self.ParentToLocalMatrixNative = GCAD.Matrix4x4.ToNativeMatrix (self:GetParentToLocalMatrix (), self.ParentToLocalMatrixNative)
	end
	
	return self.ParentToLocalMatrixNative
end

-- ComputeLocalToWorldMatrix should propagate invalidation downwards
function self:GetLocalToWorldMatrix ()
	if not self.LocalToWorldMatrixValid then
		self:ComputeLocalToWorldMatrix ()
	end
	return self.LocalToWorldMatrix
end

function self:GetLocalToWorldMatrixNative ()
	if not self.LocalToWorldMatrixNativeValid then
		self.LocalToWorldMatrixNativeValid = true
		self.LocalToWorldMatrixNative = GCAD.Matrix4x4.ToNativeMatrix (self:GetLocalToWorldMatrix (), self.LocalToWorldMatrixNative)
	end
	
	return self.LocalToWorldMatrixNative
end

-- ComputeWorldToLocalMatrix should propagate invalidation downwards
function self:GetWorldToLocalMatrix ()
	if not self.WorldToLocalMatrixValid then
		self:ComputeWorldToLocalMatrix ()
	end
	return self.WorldToLocalMatrix
end

function self:GetWorldToLocalMatrixNative ()
	if not self.WorldToLocalMatrixNativeValid then
		self.WorldToLocalMatrixNativeValid = true
		self.WorldToLocalMatrixNative = GCAD.Matrix4x4.ToNativeMatrix (self:GetWorldToLocalMatrix (), self.WorldToLocalMatrixNative)
	end
	
	return self.WorldToLocalMatrixNative
end

-- Invalidation
function self:InvalidateTransformation ()
	self.LocalToParentMatrixValid       = false
	self.ParentToLocalMatrixValid       = false
	self.LocalToParentMatrixValidNative = false
	self.ParentToLocalMatrixValidNative = false
	
	-- Invalidate local to world and world to local matrices
	self:InvalidateWorldMatrices ()
	
	-- Invalidate parent space bounding volumes
	self:InvalidateParentSpaceBoundingVolumes ()
	self:InvalidateWorldSpaceBoundingVolumes ()
	
	-- Propagate bounding volume invalidation upwards
	if not self.Parent then return end
	self.Parent:InvalidateLocalSpaceBoundingVolumes ()
end

function self:InvalidateParentSpaceBoundingVolumes ()
	-- No propagation is performed here.
	-- Propagation of invalidation should be performed by InvalidateLocalSpaceBoundingVolumes ().
	self.ParentSpaceAABB3dValid         = false
	self.ParentSpaceBoundingSphereValid = false
	self.ParentSpaceOBB3dValid          = false
end

-- TransformationComponent
function self:SetLocalToParentMatrix (matrix)
	self:InvalidateTransformation ()
	
	self.LocalToParentMatrix = GCAD.Matrix4x4.Clone (matrix, self.LocalToParentMatrix)
	self.LocalToParentMatrixValid = true
end

-- Internal, do not call
function self:ComputeLocalToParentMatrix ()
	self.LocalToParentMatrixValid = true
end

function self:ComputeParentToLocalMatrix ()
	self.ParentToLocalMatrixValid = true
	
	self.ParentToLocalMatrix = GCAD.Matrix4x4.Invert (self.LocalToParentMatrix, self.ParentToLocalMatrix)
end

-- ComputeLocalToWorldMatrix should propagate invalidation downwards
function self:ComputeLocalToWorldMatrix ()
	self.LocalToWorldMatrixValid = true
	self:InvalidateChildLocalToWorldMatrices ()

	if self.Parent then
		self.LocalToWorldMatrix = GCAD.Matrix4x4.MatrixMatrixMultiply (self.Parent:GetLocalToWorldMatrix (), self:GetLocalToParentMatrix (), self.LocalToWorldMatrix)
	else
		self.LocalToWorldMatrix = GCAD.Matrix4x4.Clone (self:GetLocalToParentMatrix (), self.LocalToWorldMatrix)
	end
end

-- ComputeWorldToLocalMatrix should propagate invalidation downwards
function self:ComputeWorldToLocalMatrix ()
	self.WorldToLocalMatrixValid = true
	self:InvalidateChildWorldToLocalMatrices ()

	if self.Parent then
		self.WorldToLocalMatrix = GCAD.Matrix4x4.MatrixMatrixMultiply (self:GetParentToLocalMatrix (), self.Parent:GetWorldToLocalMatrix (), self.WorldToLocalMatrix)
	else
		self.WorldToLocalMatrix = GCAD.Matrix4x4.Clone (self:GetParentToLocalMatrix (), self.WorldToLocalMatrix)
	end
end

GCAD.SceneGraph.Components.TransformationComponent.Instance = GCAD.SceneGraph.Components.TransformationComponent ()
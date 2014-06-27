local self = {}
GCAD.SceneGraph.SceneGraphNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraphNode)

function self:ctor ()
	-- Scene graph
	self.SceneGraph                     = nil
	
	-- Tree
	self.Parent                         = nil
	
	-- Bounding volumes
	self.LocalSpaceAABB3d               = nil
	self.LocalSpaceBoundingSphere       = nil
	self.LocalSpaceOBB3d                = nil
	
	self.WorldSpaceAABB3d               = nil
	self.WorldSpaceBoundingSphere       = nil
	self.WorldSpaceOBB3d                = nil
	
	self.LocalSpaceAABB3dValid          = false
	self.LocalSpaceBoundingSphereValid  = false
	self.LocalSpaceOBB3dValid           = false
	
	self.WorldSpaceAABB3dValid          = false
	self.WorldSpaceBoundingSphereValid  = false
	self.WorldSpaceOBB3dValid           = false
	
	-- Transformations
	self.LocalToWorldMatrixValid        = false
	self.WorldToLocalMatrixValid        = false
	
	self.LocalToWorldMatrixNativeValid  = false
	self.WorldToLocalMatrixNativeValid  = false
	
	-- Rendering
	self.Visible                        = true
	self.RenderModifierComponent        = GCAD.Rendering.NullRenderModifierComponent ()
	self.RenderComponent                = GCAD.Rendering.NullRenderComponent ()
end

-- Scene graph
function self:GetSceneGraph ()
	return self.SceneGraph
end

function self:SetSceneGraph (sceneGraph)
	self.SceneGraph = sceneGraph
end

-- Tree
function self:GetChildEnumerator ()
	return GLib.NullEnumerator ()
end

function self:GetParent ()
	return self.Parent
end

function self:GetRecursiveChildEnumerator ()
	return GLib.NullEnumerator ()
end

function self:GetRecursiveEnumerator ()
	return GLib.SingleValueEnumerator (self)
end

function self:GetRecursiveEnumerator ()
	local childEnumerator          = nil
	local childRecursiveEnumerator = nil
	return function ()
		if childRecursiveEnumerator then
			local ret = childRecursiveEnumerator ()
			if ret then return ret end
		elseif not childEnumerator then
			childEnumerator = self:GetChildEnumerator ()
			return self
		end
		
		local child = childEnumerator ()
		if not child then return nil end
		
		childRecursiveEnumerator = child:GetRecursiveEnumerator ()
		return childRecursiveEnumerator ()
	end
end

function self:SetParent (parent)
	if self.Parent == parent then return self end
	
	if self.Parent then
		self.Parent.Children [self] = nil
		self.Parent.ChildCount = self.Parent.ChildCount - 1
		
		-- Invalidate parent local bounding volumes (we don't have to really)
		self.Parent:InvalidateLocalSpaceBoundingVolumes ()
	end
	self.Parent = parent
	if self.Parent then
		self.Parent.Children [self] = true
		self.Parent.ChildCount = self.Parent.ChildCount + 1
		
		-- Invalidate parent local bounding volumes
		self.Parent:InvalidateLocalSpaceBoundingVolumes ()
	end
	
	-- Invalidate our world matrices (and world space bounding volumes)
	self:InvalidateWorldMatrices ()
	
	return self
end

-- Scene graph
function self:Remove ()
	self:SetParent (nil)
end

-- Bounding volumes
function self:GetLocalSpaceAABB ()
	if not self.LocalSpaceAABB3dValid then
		self:ComputeLocalSpaceAABB3d ()
	end
	return self.LocalSpaceAABB3d
end

function self:GetLocalSpaceBoundingSphere ()
	if not self.LocalSpaceBoundingSphereValid then
		self:ComputeLocalSpaceBoundingSphere ()
	end
	return self.LocalSpaceBoundingSphere
end

function self:GetLocalSpaceOBB ()
	if not self.LocalSpaceOBB3dValid then
		self:ComputeLocalSpaceOBB3d ()
	end
	return self.LocalSpaceOBB3d
end

function self:GetWorldSpaceAABB ()
	if not self.WorldSpaceAABB3dValid then
		self:ComputeWorldSpaceAABB3d ()
	end
	return self.WorldSpaceAABB3d
end

function self:GetWorldSpaceBoundingSphere ()
	if not self.WorldSpaceBoundingSphereValid then
		self:ComputeWorldSpaceBoundingSphere ()
	end
	return self.WorldSpaceBoundingSphere
end

function self:GetWorldSpaceOBB ()
	if not self.WorldSpaceOBB3dValid then
		self:ComputeWorldSpaceOBB3d ()
	end
	return self.WorldSpaceOBB3d
end

-- Transformations

-- GetLocalToWorldMatrix should propagate invalidation downwards
function self:GetLocalToWorldMatrix ()
	GCAD.Error ("SceneGraphNode:GetLocalToWorldMatrix : Not implemented.")
end

-- ComputeWorldToLocalMatrix should propagate invalidation downwards
function self:GetWorldToLocalMatrix ()
	GCAD.Error ("SceneGraphNode:GetWorldToLocalMatrix : Not implemented.")
end

-- Rendering
function self:IsVisible ()
	return self.Visible
end

function self:SetVisible (visible)
	if self.Visible == visible then return self end
	
	self.Visible = visible
	
	return self
end

function self:GetRenderComponent ()
	return self.RenderComponent
end

function self:GetRenderModifierComponent ()
	return self.RenderModifierComponent
end

function self:SetRenderComponent (renderComponent)
	if self.RenderComponent == renderComponent then return self end
	
	self.RenderComponent = renderComponent
	
	return self
end

function self:SetRenderModifierComponent (renderModifierComponent)
	if self.RenderModifierComponent == renderModifierComponent then return self end
	
	self.RenderModifierComponent = renderModifierComponent
	
	return self
end

-- Internal, do not call
function self:ComputeLocalSpaceAABB3d ()
	GCAD.Error ("SceneGraphNode:ComputeLocalSpaceAABB3d : Not implemented.")
end

function self:ComputeLocalSpaceBoundingSphere ()
	GCAD.Error ("SceneGraphNode:ComputeLocalSpaceBoundingSphere : Not implemented.")
end

function self:ComputeLocalSpaceOBB3d ()
	GCAD.Error ("SceneGraphNode:ComputeLocalSpaceOBB3d : Not implemented.")
end

function self:ComputeWorldSpaceAABB3d ()
	GCAD.Error ("SceneGraphNode:ComputeWorldSpaceAABB3d : Not implemented.")
end

function self:ComputeWorldSpaceBoundingSphere ()
	GCAD.Error ("SceneGraphNode:ComputeWorldSpaceBoundingSphere : Not implemented.")
end

function self:ComputeWorldSpaceOBB3d ()
	GCAD.Error ("SceneGraphNode:ComputeWorldSpaceOBB3d : Not implemented.")
end

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

function self:InvalidateChildLocalToWorldNativeMatrices ()
	for childSceneGraphNode in self:GetChildEnumerator () do
		childSceneGraphNode:InvalidateLocalToWorldMatrixNative ()
	end
end

function self:InvalidateChildWorldToLocalMatrices ()
	for childSceneGraphNode in self:GetChildEnumerator () do
		childSceneGraphNode:InvalidateWorldToLocalMatrix ()
	end
end

function self:InvalidateLocalSpaceBoundingVolumes ()
	-- If our local space bounding volumes are invalid,
	-- it implies that our ancestors' local space bounding volumes are also invalid,
	-- so we don't need to waste time propagating the invalidation upwards
	if not self.LocalSpaceAABB3dValid and
	   not self.LocalSpaceBoundingSphereValid and
	   not self.LocalSpaceOBB3dValid then
		return
	end
	
	self.LocalSpaceAABB3dValid          = false
	self.LocalSpaceBoundingSphereValid  = false
	self.LocalSpaceOBB3dValid           = false
	
	-- Invalidate world space bounding volumes too
	self:InvalidateWorldSpaceBoundingVolumes ()
	
	-- Propagate bounding volume invalidation upwards
	if not self.Parent then return end
	self.Parent:InvalidateLocalSpaceBoundingVolumes ()
end

function self:InvalidateWorldSpaceBoundingVolumes ()
	self.WorldSpaceAABB3dValid         = false
	self.WorldSpaceBoundingSphereValid = false
	self.WorldSpaceOBB3dValid          = false
end
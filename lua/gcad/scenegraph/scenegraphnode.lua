local self = {}
GCAD.SceneGraph.SceneGraphNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraphNode)

function self:ctor ()
	-- Tree
	self.Parent                         = nil
	self.Children                       = nil
	self.ChildCount                     = 0
	
	-- Bounding volumes
	self.WorldAABB3d                    = nil
	self.WorldBoundingSphere            = nil
	self.WorldOBB3d                     = nil
	
	self.WorldAABB3dValid               = false
	self.WorldBoundingSphereValid       = false
	self.WorldOBB3dValid                = false
	
	self.LocalAABB3d                    = nil
	self.LocalBoundingSphere            = nil
	self.LocalOBB3d                     = nil
	
	self.LocalAABB3dValid               = false
	self.LocalBoundingSphereValid       = false
	self.LocalOBB3dValid                = false
	
	-- Transformations
	self.LocalToParentMatrix            = nil
	self.LocalToWorldMatrix             = nil
	self.ParentToLocalMatrix            = nil
	self.WorldToLocalMatrix             = nil
	
	self.LocalToParentMatrixNative      = nil
	self.LocalToWorldMatrixNative       = nil
	self.ParentToLocalMatrixNative      = nil
	self.WorldToLocalMatrixNative       = nil
	
	self.LocalToParentMatrixValid       = false
	self.LocalToWorldMatrixValid        = false
	self.ParentToLocalMatrixValid       = false
	self.WorldToLocalMatrixValid        = false
	
	self.LocalToParentMatrixNativeValid = false
	self.LocalToWorldMatrixNativeValid  = false
	self.ParentToLocalMatrixNativeValid = false
	self.WorldToLocalMatrixNativeValid  = false
end

-- Tree
function self:AddChild (sceneGraphNode)
	if not self.Children then self.Children = {} end
	if self.Children [sceneGraphNode] then return end
	
	-- Remove from existing parent
	if sceneGraphNode.Parent then
		sceneGraphNode.Parent.Children [sceneGraphNode] = nil
		sceneGraphNode.Parent.ChildCount = sceneGraphNode.Parent.ChildCount - 1
	end
	
	-- Add to ourself
	self.Children [sceneGraphNode] = sceneGraphNode
	self.ChildCount = self.ChildCount + 1
	sceneGraphNode.Parent = self
end

function self:ContainsNode (sceneGraphNode)
	if not self.Children then return false end
	return self.Children [sceneGraphNode] ~= nil
end

function self:HasChildren ()
	return self.ChildCount > 0
end

function self:GetChildCount ()
	return self.ChildCount
end

function self:GetChildEnumerator ()
	if not self.Children then return GLib.NullEnumerator () end
	return GLib.KeyEnumerator (self.Children)
end

function self:GetParent ()
	return self.Parent
end

function self:GetRecursiveChildEnumerator ()
	local childEnumerator               = self:GetChildEnumerator ()
	local childRecursiveChildEnumerator = nil
	return function ()
		if childRecursiveChildEnumerator then
			local ret = childRecursiveChildEnumerator ()
			if ret then return ret end
		end
			
		local child = childEnumerator ()
		if not child then return nil end
		
		childRecursiveChildEnumerator = child:GetRecursiveChildEnumerator ()
		return child
	end
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
	end
	self.Parent = parent
	if self.Parent then
		self.Parent.Children [self] = true
		self.Parent.ChildCount = self.Parent.ChildCount + 1
	end
	
	return self
end

function self:RemoveChild (sceneGraphNode)
	if not self.Children then return end
	if not self.Children [sceneGraphNode] then return end
	
	-- Remove from ourself
	self.Children [sceneGraphNode] = nil
	self.ChildCount = self.ChildCount - 1
	sceneGraphNode.Parent = nil
end

-- Scene graph
function self:Remove ()
	self:SetParent (nil)
end

-- World space bounding volumes
function self:GetWorldAABB ()
	if not self.WorldAABB3dValid then
		self:ComputeWorldAABB3d ()
	end
	return self.WorldAABB3d
end

function self:GetWorldBoundingSphere ()
	if not self.WorldBoundingSphereValid then
		self:ComputeWorldBoundingSphere ()
	end
	return self.WorldBoundingSphere
end

function self:GetWorldOBB ()
	if not self.WorldOBB3dValid then
		self:ComputeWorldOBB3d ()
	end
	return self.WorldOBB3d
end

-- Transformations
function self:GetLocalToParentMatrix ()
	GCAD.Error ("SceneGraphNode:GetLocalToParentMatrix : Not implemented.")
end

function self:GetLocalToParentMatrixNative ()
	GCAD.Error ("SceneGraphNode:GetLocalToParentMatrixNative : Not implemented.")
end

function self:GetLocalToWorldMatrix ()
	GCAD.Error ("SceneGraphNode:GetLocalToWorldMatrix : Not implemented.")
end

function self:GetLocalToWorldMatrixNative ()
	GCAD.Error ("SceneGraphNode:GetLocalToWorldMatrixNative : Not implemented.")
end

function self:GetParentToLocalMatrix ()
	GCAD.Error ("SceneGraphNode:GetParentToLocalMatrix : Not implemented.")
end

function self:GetParentToLocalMatrixNative ()
	GCAD.Error ("SceneGraphNode:GetParentToLocalMatrixNative : Not implemented.")
end

function self:GetWorldToLocalMatrix ()
	GCAD.Error ("SceneGraphNode:GetWorldToLocalMatrix : Not implemented.")
end

function self:GetWorldToLocalMatrixNative ()
	GCAD.Error ("SceneGraphNode:GetWorldToLocalMatrixNative : Not implemented.")
end

-- Internal, do not call
function self:ComputeWorldAABB3d ()
	GCAD.Error ("SceneGraphNode:ComputeWorldAABB3d : Not implemented.")
end

function self:ComputeWorldBoundingSphere ()
	GCAD.Error ("SceneGraphNode:ComputeWorldBoundingSphere : Not implemented.")
end

function self:ComputeWorldOBB3d ()
	GCAD.Error ("SceneGraphNode:ComputeWorldOBB3d : Not implemented.")
end
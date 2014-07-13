local self = {}
GCAD.SceneGraph.Components.NodeContainerComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.IContentsComponent)

function self:ctor (sceneGraphNode)
	self.SceneGraphNode = sceneGraphNode
	
	self:Initialize ()
end

function self:dtor ()
	self:Uninitialize ()
end

-- IContentsComponent
function self:Initialize ()
	-- Tree
	self.Children   = nil
	self.ChildCount = 0
	
	self.Space3d    = nil
	
	-- Bounding volumes
	self.LocalSpaceAABB3d               = nil
	self.LocalSpaceBoundingSphere       = nil
	self.LocalSpaceOBB3d                = nil
	
	self.LocalSpaceAABB3dValid          = false
	self.LocalSpaceBoundingSphereValid  = false
	self.LocalSpaceOBB3dValid           = false
end

function self:Uninitialize ()
end

-- Scene graph node
function self:GetSceneGraphNode ()
	return self.SceneGraphNode
end

-- Tree
function self:AddChild (sceneGraphNode)
	if self:ContainsNode (sceneGraphNode) then return end
	
	-- Remove from existing parent
	if sceneGraphNode.Parent then
		local parentContentsComponent = sceneGraphNode.Parent:GetContentsComponent ()
		parentContentsComponent.Children [sceneGraphNode] = nil
		parentContentsComponent.ChildCount = parentContentsComponent.ChildCount - 1
	end
	
	-- Add to ourself
	self.Children = self.Children or {}
	self.Children [sceneGraphNode] = sceneGraphNode
	self.ChildCount = self.ChildCount + 1
	sceneGraphNode.Parent = self
	
	-- Convert to octree if it's too much
	-- if not self.Space3d and self.ChildCount > 5 then
	-- 	self.Space3d = GCAD.Octree ()
	-- 	
	-- 	for childSceneGraphNode in self:GetChildEnumerator () do
	-- 		self.Space3d:Add (childSceneGraphNode)
	-- 	end
	-- elseif self.Space3d then
	-- 	self.Space3d:Add (sceneGraphNode)
	-- end
	
	-- Invalidate the child's world matrices (and world space bounding volumes)
	sceneGraphNode:InvalidateWorldMatrices ()
	
	-- Invalidate our local bounding volumes (we don't have to really)
	self:InvalidateLocalSpaceBoundingVolumes ()
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

function self:RemoveChild (sceneGraphNode)
	if not self:ContainsNode (sceneGraphNode) then return end
	
	-- Remove from ourself
	self.Children [sceneGraphNode] = nil
	self.ChildCount = self.ChildCount - 1
	sceneGraphNode.Parent = nil
	
	if self.Space3d then
		self.Space3d:Remove (sceneGraphNode)
	end
	
	-- Invalidate the child's world matrices (and world space bounding volumes)
	sceneGraphNode:InvalidateWorldMatrices ()
	
	-- Invalidate our local bounding volumes (we don't have to really)
	self:InvalidateLocalSpaceBoundingVolumes ()
end

function self:OnChildLocalSpaceBoundingVolumesInvalidated (sceneGraphNode)
	if not self.Space3d then return end
	
	self.Space3d:UpdateItem (sceneGraphNode)
end

-- Bounding volumes
function self:GetLocalSpaceAABB ()
	if not self.LocalSpaceAABBValid then
		self:ComputeLocalSpaceAABB ()
	end
	
	return self.LocalSpaceAABB
end

function self:GetLocalSpaceBoundingSphere ()
	if not self.LocalSpaceBoundingSphereValid then
		self:ComputeLocalSpaceBoundingSphere ()
	end
	
	return self.LocalSpaceBoundingSphere
end

function self:GetLocalSpaceOBB ()
	if not self.LocalSpaceOBBValid then
		self:ComputeLocalOBBSphere ()
	end
	
	return self.LocalSpaceOBB
end

function self:ComputeLocalSpaceAABB ()
	self.LocalSpaceAABBValid = true
	
	self.LocalSpaceAABB = self.LocalSpaceAABB or GCAD.AABB3d ()
end

function self:ComputeLocalSpaceBoundingSphere ()
	self.LocalSpaceBoundingSphereValid = true
	
	self.LocalSpaceBoundingSphere = self.LocalSpaceBoundingSphere or GCAD.Sphere3d ()
end

function self:ComputeLocalOBBSphere ()
	self.LocalSpaceOBBValid = true
	
	self.LocalSpaceOBB = self.LocalSpaceOBB or GCAD.OBB3d ()
end

GCAD.SceneGraph.Components.NodeContainerComponent.Instance = GCAD.SceneGraph.Components.NodeContainerComponent ()
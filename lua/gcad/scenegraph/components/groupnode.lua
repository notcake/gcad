local self = {}
GCAD.SceneGraph.Components.GroupNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.SceneGraphNode)

function self:ctor ()
	-- Tree
	self.Children                       = nil
	self.ChildCount                     = 0
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
	if not self.Children then return end
	if not self.Children [sceneGraphNode] then return end
	
	-- Remove from ourself
	self.Children [sceneGraphNode] = nil
	self.ChildCount = self.ChildCount - 1
	sceneGraphNode.Parent = nil
	
	-- Invalidate the child's world matrices (and world space bounding volumes)
	sceneGraphNode:InvalidateWorldMatrices ()
	
	-- Invalidate our local bounding volumes (we don't have to really)
	self:InvalidateLocalSpaceBoundingVolumes ()
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

-- Internal, do not call
function self:ComputeLocalSpaceAABB3d ()
end

function self:ComputeLocalSpaceBoundingSphere ()
end

function self:ComputeLocalSpaceOBB3d ()
end
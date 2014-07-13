local self = {}
GCAD.SceneGraph.Components.NonContainerComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.IContentsComponent)

function self:ctor (sceneGraphNode)
	self.SceneGraphNode = sceneGraphNode
	
	self:Initialize ()
end

function self:dtor ()
	self:Uninitialize ()
end

-- IContentsComponent
function self:Initialize ()
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
function self:ContainsNode (sceneGraphNode)
	return false
end

function self:HasChildren ()
	return false
end

function self:GetChildCount ()
	return 0
end

function self:GetChildEnumerator ()
	return GLib.NullEnumerator ()
end

function self:GetRecursiveChildEnumerator ()
	return GLib.NullEnumerator ()
end

function self:GetRecursiveEnumerator ()
	return GLib.SingleValueEnumerator (self)
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

function self:SetLocalSpaceAABB (aabb3d)
	self:InvalidateLocalSpaceBoundingVolumes ()
	
	self.LocalSpaceAABB = GCAD.AABB3d.Clone (aabb3d, self.LocalSpaceAABB)
	self.LocalSpaceAABBValid = true
end

function self:SetLocalSpaceBoundingSphere (sphere3d)
	self:InvalidateLocalSpaceBoundingVolumes ()
	
	self.LocalSpaceBoundingSphere = GCAD.Sphere3d.Clone (sphere3d, self.LocalSpaceBoundingSphere)
	self.LocalSpaceBoundingSphereValid = true
end

function self:SetLocalSpaceOBB (obb3d)
	self:InvalidateLocalSpaceBoundingVolumes ()
	
	self.LocalSpaceOBB = GCAD.OBB3d.Clone (obb3d, self.LocalSpaceOBB)
	self.LocalSpaceOBBValid = true
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

GCAD.SceneGraph.Components.NonContainerComponent.Instance = GCAD.SceneGraph.Components.NonContainerComponent ()
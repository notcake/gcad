local self = {}
GCAD.SceneGraph.SceneGraphNode = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraphNode)

local math_min = math.min
local math_max = math.max

function self:ctor ()
	-- Scene graph
	self.SceneGraph                    = nil
	
	-- Tree
	self.Parent                        = nil
	
	-- Bounding volumes
	self.WorldSpaceAABB                = nil
	self.WorldSpaceBoundingSphere      = nil
	self.WorldSpaceOBB                 = nil
	
	self.WorldSpaceAABBValid           = false
	self.WorldSpaceBoundingSphereValid = false
	self.WorldSpaceOBBValid            = false
	
	-- Rendering
	self.Visible                       = true
	self.RenderModifierComponent       = GCAD.Rendering.NullRenderModifierComponent ()
	self.RenderComponent               = GCAD.Rendering.NullRenderComponent ()
	
	-- Components
	self.TransformationComponent       = nil
	self.ContentsComponent             = nil
end

-- ISpatialNode3d
function self:GetAABB (out)
	if not out then return self:GetWorldSpaceAABB () end
	return GCAD.AABB3d.Clone (self:GetWorldSpaceAABB (), out)
end

function self:GetBoundingSphere (out)
	if not out then return self:GetWorldSpaceBoundingSphere () end
	return GCAD.Sphere3d.Clone (self:GetWorldSpaceBoundingSphere (), out)
end

function self:GetOBB (out)
	if not out then return self:GetWorldSpaceOBB () end
	return GCAD.OBB3d.Clone (self:GetWorldSpaceOBB (), out)
end

function self:GetNativeOBB (out)
	return self:GetWorldSpaceOBB ():ToNativeOBB ()
end

-- ISceneGraphNode
-- Scene graph
function self:GetSceneGraph ()
	return self.SceneGraph
end

-- Tree
function self:AddChild (sceneGraphNode)
	self.ContentsComponent.AddChild (self, sceneGraphNode)
end

function self:ContainsNode (sceneGraphNode)
	return self.ContentsComponent.ContainsNode (self, sceneGraphNode)
end

function self:HasChildren ()
	return self.ContentsComponent.HasChildren (self)
end

function self:GetChildCount ()
	return self.ContentsComponent.GetChildCount (self)
end

function self:GetChildEnumerator ()
	return self.ContentsComponent.GetChildEnumerator (self)
end

function self:GetParent ()
	return self.ContentsComponent.GetParent (self)
end

function self:GetRecursiveChildEnumerator ()
	return self.ContentsComponent.GetRecursiveChildEnumerator (self)
end

function self:GetRecursiveEnumerator ()
	return self.ContentsComponent.GetRecursiveEnumerator (self)
end

function self:SetParent (parent)
	if self.Parent == parent then return self end
	
	if self.Parent then
		local oldParent = self.Parent
		self.Parent = nil
		oldParent:RemoveChild (self)
	end
	self.Parent = parent
	if self.Parent then
		self.Parnet:AddChild (self)
	end
	
	-- Invalidate our world matrices (and world space bounding volumes)
	self:InvalidateWorldMatrices ()
	
	return self
end

function self:Remove ()
	self:SetParent (nil)
end

function self:RemoveChild (sceneGraphNode)
	self.ContentsComponent.RemoveChild (self, sceneGraphNode)
end

function self:OnChildWorldSpaceBoundingVolumesInvalidated (sceneGraphNode)
	self.ContentsComponent.OnChildWorldSpaceBoundingVolumesInvalidated (self, sceneGraphNode)
end

-- Bounding volumes
function self:GetLocalSpaceAABB ()
	return self.ContentsComponent.GetLocalSpaceAABB (self)
end

function self:GetLocalSpaceBoundingSphere ()
	return self.ContentsComponent.GetLocalSpaceBoundingSphere (self)
end

function self:GetLocalSpaceOBB ()
	return self.ContentsComponent.GetLocalSpaceOBB (self)
end

function self:GetParentSpaceAABB ()
	return self.TransformationComponent.GetParentSpaceAABB (self)
end

function self:GetParentSpaceBoundingSphere ()
	return self.TransformationComponent.GetParentSpaceBoundingSphere (self)
end

function self:GetParentSpaceOBB ()
	return self.TransformationComponent.GetParentSpaceOBB (self)
end

function self:GetWorldSpaceAABB ()
	if not self.WorldSpaceAABBValid then
		self:ComputeWorldSpaceAABB ()
	end
	
	return self.WorldSpaceAABB
end

function self:GetWorldSpaceBoundingSphere ()
	if not self.WorldSpaceBoundingSphereValid then
		self:ComputeWorldSpaceBoundingSphere ()
	end
	
	return self.WorldSpaceBoundingSphere
end

function self:GetWorldSpaceOBB ()
	if not self.WorldSpaceOBBValid then
		self:ComputeWorldSpaceOBB ()
	end
	
	return self.WorldSpaceOBB
end

-- Transformations
function self:GetLocalToParentMatrix ()
	return self.TransformationComponent.GetLocalToParentMatrix (self)
end

function self:GetLocalToParentMatrixNative ()
	return self.TransformationComponent.GetLocalToParentMatrixNative (self)
end

function self:GetParentToLocalMatrix ()
	return self.TransformationComponent.GetParentToLocalMatrix (self)
end

function self:GetParentToLocalMatrixNative ()
	return self.TransformationComponent.GetParentToLocalMatrixNative (self)
end

function self:GetLocalToWorldMatrix ()
	return self.TransformationComponent.GetLocalToWorldMatrix (self)
end

function self:GetLocalToWorldMatrixNative ()
	return self.TransformationComponent.GetLocalToWorldMatrixNative (self)
end

function self:GetWorldToLocalMatrix ()
	return self.TransformationComponent.GetWorldToLocalMatrix (self)
end

function self:GetWorldToLocalMatrixNative ()
	return self.TransformationComponent.GetWorldToLocalMatrixNative (self)
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

-- Invalidation
function self:InvalidateTransformation ()
	self.TransformationComponent.InvalidateTransformation (self)
end

function self:InvalidateWorldMatrices ()
	self.TransformationComponent.InvalidateWorldMatrices (self)
end

function self:InvalidateLocalToWorldMatrix ()
	self.TransformationComponent.InvalidateLocalToWorldMatrix (self)
end

function self:InvalidateWorldToLocalMatrix ()
	self.TransformationComponent.InvalidateWorldToLocalMatrix (self)
end

function self:InvalidateChildLocalToWorldMatrices ()
	self.TransformationComponent.InvalidateChildLocalToWorldMatrices (self)
end

function self:InvalidateChildWorldToLocalMatrices ()
	self.TransformationComponent.InvalidateChildWorldToLocalMatrices (self)
end

function self:InvalidateLocalSpaceBoundingVolumes ()
	-- If our local space bounding volumes are invalid,
	-- it implies that our ancestors' local space bounding volumes are also invalid,
	-- so we don't need to waste time propagating the invalidation upwards
	if not self.LocalSpaceAABBValid and
	   not self.LocalSpaceBoundingSphereValid and
	   not self.LocalSpaceOBBValid then
		return
	end
	
	self.LocalSpaceAABBValid           = false
	self.LocalSpaceBoundingSphereValid = false
	self.LocalSpaceOBBValid            = false
	
	-- Invalidate parent and world space bounding volumes too
	self:InvalidateParentSpaceBoundingVolumes ()
	self:InvalidateWorldSpaceBoundingVolumes ()
	
	-- Propagate bounding volume invalidation upwards
	if not self.Parent then return end
	self.Parent:InvalidateLocalSpaceBoundingVolumes ()
end

function self:InvalidateParentSpaceBoundingVolumes ()
	self.TransformationComponent.InvalidateParentSpaceBoundingVolumes (self)
end

function self:InvalidateWorldSpaceBoundingVolumes ()
	self.WorldSpaceAABBValid           = false
	self.WorldSpaceBoundingSphereValid = false
	self.WorldSpaceOBBValid            = false
	
	if not self.Parent then return end
	self.Parent:OnChildWorldSpaceBoundingVolumesInvalidated (self)
end

-- TransformationComponent
function self:ComputeLocalToParentMatrix ()
	self.TransformationComponent.ComputeLocalToParentMatrix (self)
end

function self:ComputeParentToLocalMatrix ()
	self.TransformationComponent.ComputeParentToLocalMatrix (self)
end

function self:ComputeLocalToWorldMatrix ()
	self.TransformationComponent.ComputeLocalToWorldMatrix (self)
end

function self:ComputeWorldToLocalMatrix ()
	self.TransformationComponent.ComputeWorldToLocalMatrix (self)
end

function self:ComputeParentSpaceAABB ()
	self.TransformationComponent.ComputeParentSpaceAABB (self)
end

function self:ComputeParentSpaceBoundingSphere ()
	self.TransformationComponent.ComputeParentSpaceBoundingSphere (self)
end

function self:ComputeParentSpaceOBB ()
	self.TransformationComponent.ComputeParentSpaceOBB (self)
end

-- OrthogonalAffineTransformationComponent
function self:GetAngle ()
	return self.TransformationComponent.GetAngle (self)
end

function self:GetScale ()
	return self.TransformationComponent.GetScale (self)
end

function self:GetPosition ()
	return self.TransformationComponent.GetPosition (self)
end

function self:GetTranslation ()
	return self.TransformationComponent.GetTranslation (self)
end

function self:SetAngle (angle)
	return self.TransformationComponent.SetAngle (self, angle)
end

function self:SetScale (scale)
	return self.TransformationComponent.SetScale (self, scale)
end

function self:SetPosition (pos)
	return self.TransformationComponent.SetPosition (self, pos)
end

function self:SetTranslation (translation)
	return self.TransformationComponent.SetTranslation (self, translation)
end

-- IContentsComponent
function self:ComputeLocalSpaceAABB ()
	return self.ContentsComponent.ComputeLocalSpaceAABB (self)
end

function self:ComputeLocalSpaceBoundingSphere ()
	return self.ContentsComponent.ComputeLocalSpaceBoundingSphere (self)
end

function self:ComputeLocalSpaceOBB ()
	return self.ContentsComponent.ComputeLocalSpaceOBB (self)
end

-- NonContainerComponent
function self:SetLocalSpaceAABB (aabb3d)
	self.ContentsComponent.SetLocalSpaceAABB (self, aabb3d)
end

function self:SetLocalSpaceBoundingSphere (sphere3d)
	self.ContentsComponent.SetLocalSpaceBoundingSphere (self, sphere3d)
end

function self:SetLocalSpaceOBB (obb3d)
	self.ContentsComponent.SetLocalSpaceOBB (self, obb3d)
end

-- SceneGraphNode
function self:SetSceneGraph (sceneGraph)
	self.SceneGraph = sceneGraph
end

function self:GetContentsComponent ()
	return self
end

function self:GetTransformationComponent ()
	return self
end

function self:SetContentsComponent (contentsComponent)
	if self.ContentsComponent == contentsComponent then return self end
	
	if self.ContentsComponent then
		self.ContentsComponent.Uninitialize (self)
	end
	self.ContentsComponent = contentsComponent
	if self.ContentsComponent then
		self.ContentsComponent.Initialize (self)
	end
	self:InvalidateLocalSpaceBoundingVolumes ()
	
	return self
end

function self:SetTransformationComponent (transformationComponent)
	if self.TransformationComponent == transformationComponent then return self end
	
	if self.TransformationComponent then
		self.TransformationComponent.Uninitialize (self)
	end
	self.TransformationComponent = transformationComponent
	if self.TransformationComponent then
		self.TransformationComponent.Initialize (self)
	end
	self:InvalidateTransformation ()
	
	return self
end

-- Internal, do not call
function self:ComputeWorldSpaceAABB ()
	self.WorldSpaceAABBValid = true
	
	self.WorldSpaceAABB = self.WorldSpaceAABB or GCAD.AABB3d ()
	
	local localToWorldMatrix = self:GetLocalToWorldMatrix ()
	local localSpaceAABB = self:GetLocalSpaceAABB ()
	
	local x, y, z = localSpaceAABB:GetMinUnpacked ()
	local dx, dy, dz = localSpaceAABB:GetMaxUnpacked ()
	dx, dy, dz = GCAD.UnpackedVector3d.Subtract (dx, dy, dz, x, y, z)
	
	x, y, z = GCAD.Matrix4x4.MatrixUnpackedVectorMultiply (localToWorldMatrix, x, y, z, 1)
	
	self.WorldSpaceAABB:SetMinUnpacked (x + math_min (0, dx * localToWorldMatrix [ 1]) + math_min (0, dy * localToWorldMatrix [ 2]) + math_min (0, dz * localToWorldMatrix [ 3]),
	                                    y + math_min (0, dx * localToWorldMatrix [ 5]) + math_min (0, dy * localToWorldMatrix [ 6]) + math_min (0, dz * localToWorldMatrix [ 7]),
	                                    z + math_min (0, dx * localToWorldMatrix [ 9]) + math_min (0, dy * localToWorldMatrix [10]) + math_min (0, dz * localToWorldMatrix [11]))
	self.WorldSpaceAABB:SetMaxUnpacked (x + math_max (0, dx * localToWorldMatrix [ 1]) + math_max (0, dy * localToWorldMatrix [ 2]) + math_max (0, dz * localToWorldMatrix [ 3]),
	                                    y + math_max (0, dx * localToWorldMatrix [ 5]) + math_max (0, dy * localToWorldMatrix [ 6]) + math_max (0, dz * localToWorldMatrix [ 7]),
	                                    z + math_max (0, dx * localToWorldMatrix [ 9]) + math_max (0, dy * localToWorldMatrix [10]) + math_max (0, dz * localToWorldMatrix [11]))
end

function self:ComputeWorldSpaceBoundingSphere ()
	self.WorldSpaceBoundingSphereValid = true
	
	self.WorldSpaceBoundingSphere = self.WorldSpaceBoundingSphere or GCAD.Sphere3d ()
	
	local localToWorldMatrix = self:GetLocalToWorldMatrix ()
	local localSpaceBoundingSphere = self:GetLocalSpaceBoundingSphere ()
	local x, y, z = GCAD.Sphere3d.GetPositionUnpacked (localSpaceBoundingSphere)
	x, y, z = GCAD.Matrix4x4.MatrixUnpackedVectorMultiply (localToWorldMatrix, x, y, z, 1)
	
	local largestSingularValue = math_max (GCAD.Matrix4x4.SingularValues3x3 (localToWorldMatrix))
	
	self.WorldSpaceBoundingSphere:SetPositionUnpacked (x, y, z)
	self.WorldSpaceBoundingSphere:SetRadius (localSpaceBoundingSphere:GetRadius () * largestSingularValue)
end

function self:ComputeWorldSpaceOBB ()
	self.WorldSpaceOBBValid = true
	
	self.WorldSpaceOBB = self.WorldSpaceOBB or GCAD.OBB3d ()
	self.WorldSpaceOBB = GCAD.AABB3d.ToOBB3d (self:GetWorldSpaceAABB (), self.WorldSpaceOBB)
end
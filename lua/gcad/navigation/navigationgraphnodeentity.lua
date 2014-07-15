local self = {}
GCAD.Navigation.NavigationGraphNodeEntity = GCAD.MakeConstructor (self,
	GCAD.VEntities.VEntity,
	GCAD.SpatialNode3d,
	GCAD.Rendering.IRenderComponent
)

local render_SetMaterial      = CLIENT and render.SetMaterial

local IMaterial_SetFloat      = CLIENT and debug.getregistry ().IMaterial.SetFloat
local IMaterial_SetVector     = CLIENT and debug.getregistry ().IMaterial.SetVector
local IMesh_Draw              = CLIENT and debug.getregistry ().IMesh.Draw

if CLIENT then
	self.OutlineColor = GLib.Colors.White
	self.Color        = GLib.Color.FromColor (self.OutlineColor, 64)
	
	self.ColorMaterial          = GCAD.Materials.CreateColorMaterial ("GCAD.NavigationGraphNodeEntity.ColorMaterial"         )-- self.Color       )
	self.WireframeColorMaterial = GCAD.Materials.CreateColorMaterial ("GCAD.NavigationGraphNodeEntity.WireframeColorMaterial")-- self.OutlineColor)
end

-- Box mesh
self.BoxSize          = 16
self.HalfBoxSize      = self.BoxSize / 2
self.BoxMin           = GCAD.Vector3d (-self.HalfBoxSize, -self.HalfBoxSize, -self.HalfBoxSize)
self.BoxMax           = GCAD.Vector3d ( self.HalfBoxSize,  self.HalfBoxSize,  self.HalfBoxSize)
self.BoxMinNative     = Vector        (-self.HalfBoxSize, -self.HalfBoxSize, -self.HalfBoxSize)
self.BoxMaxNative     = Vector        ( self.HalfBoxSize,  self.HalfBoxSize,  self.HalfBoxSize)

if CLIENT then
	self.BoxMesh          = GCAD.Meshes.CreateAxisAlignedCube          (-self.HalfBoxSize, self.HalfBoxSize)
	self.WireframeBoxMesh = GCAD.Meshes.CreateAxisAlignedWireframeCube (-self.HalfBoxSize, self.HalfBoxSize)
end

-- Local space bounding volumes
self.LocalSpaceAABB = GCAD.AABB3d ()
self.LocalSpaceAABB:SetMinUnpacked (-self.HalfBoxSize, -self.HalfBoxSize, -self.HalfBoxSize)
self.LocalSpaceAABB:SetMaxUnpacked ( self.HalfBoxSize,  self.HalfBoxSize,  self.HalfBoxSize)
self.LocalSpaceBoundingSphere = GCAD.Sphere3d ()
self.LocalSpaceBoundingSphere:SetPositionUnpacked (0, 0, 0)
self.LocalSpaceBoundingSphere:SetRadius (math.sqrt (3 * self.HalfBoxSize * self.HalfBoxSize))
self.LocalSpaceOBB = GCAD.OBB3d ()
self.LocalSpaceOBB:SetPositionUnpacked (0, 0, 0)
self.LocalSpaceOBB:SetAngleUnpacked (0, 0, 0)
self.LocalSpaceOBB:SetMinUnpacked (-self.HalfBoxSize, -self.HalfBoxSize, -self.HalfBoxSize)
self.LocalSpaceOBB:SetMaxUnpacked ( self.HalfBoxSize,  self.HalfBoxSize,  self.HalfBoxSize)

function self:ctor (navigationGraphNode)
	self.NavigationGraphNode = navigationGraphNode
	
	-- IComponentHost
	self:SetRenderComponent (self)
	self:SetSpatialNode3d (self)
	
	self:InitializeSpatialNode3d ()
	self:HookNavigationGraphNode (self.NavigationGraphNode)
	
	-- Initialize materials
	if CLIENT then
		local v, alpha = GLib.Color.ToVector (self.Color)
		self.ColorMaterial:SetVector ("$color", v)
		self.ColorMaterial:SetFloat  ("$alpha", alpha)
		
		v, alpha = GLib.Color.ToVector (self.OutlineColor, v)
		self.WireframeColorMaterial:SetVector ("$color", v)
		self.WireframeColorMaterial:SetFloat  ("$alpha", alpha)
	end
end

function self:dtor ()
	self:UnhookNavigationGraphNode (self.NavigationGraphNode)
end

-- IRenderComponent
function self:HasOpaqueRendering ()
	return true
end

function self:HasTranslucentRendering ()
	return true
end

function self:RenderOpaque (renderContext)
	render_SetMaterial (self.WireframeColorMaterial)
	IMesh_Draw (self.WireframeBoxMesh)
end

function self:RenderTranslucent (renderContext)
	render_SetMaterial (self.ColorMaterial)
	IMesh_Draw (self.BoxMesh)
end

-- SpatialNode3d
function self:ComputeAABB ()
	self.AABBValid = true
	
	local position = self.NavigationGraphNode:GetPosition ()
	self.AABB:SetMinUnpacked (position - self.HalfBoxSize, position - self.HalfBoxSize, position - self.HalfBoxSize)
	self.AABB:SetMaxUnpacked (position + self.HalfBoxSize, position + self.HalfBoxSize, position + self.HalfBoxSize)
end

function self:ComputeBoundingSphere ()
	self.BoundingSphereValid = true
	
	self.BoundingSphere:SetPosition (self.NavigationGraphNode:GetPosition ())
end

function self:ComputeOBB ()
	self.OBBValid = true
	
	self.OBB:SetPosition (self.NavigationGraphNode:GetPosition ())
end

function self:ComputeNativeOBB ()
	self.NativeOBBValid = true
	
	self.NativeOBB:SetPosition (self.NavigationGraphNode:GetPositionNative ())
end

function self:GetLocalSpaceAABB ()
	return self.LocalSpaceAABB
end

function self:GetLocalSpaceBoundingSphere ()
	return self.LocalSpaceBoundingSphere
end

function self:GetLocalSpaceOBB ()
	return self.LocalSpaceOBB
end

-- VEntity
function self:GetIcon ()
	return "icon16/vector.png"
end

function self:GetTypeDisplayString ()
	return "Navigation Node"
end

-- NavigationGraphNodeEntity
function self:GetNavigationGraphNode ()
	return self.NavigationGraphNode
end

-- Internal, do not call
function self:InitializeSpatialNode3d ()
	self.BoundingSphere:SetRadius (self.HalfBoxSize * math.sqrt (3))
	self.OBB:SetAngle (GCAD.EulerAngle.Zero)
	self.OBB:SetMin (self.BoxMin)
	self.OBB:SetMax (self.BoxMax)
	self.NativeOBB:SetAngle (angle_zero)
	self.NativeOBB:SetMin (self.BoxMinNative)
	self.NativeOBB:SetMax (self.BoxMaxNative)
end

function self:HookNavigationGraphNode (navigationGraphNode)
	if not navigationGraphNode then return self end
	
	navigationGraphNode:AddEventListener ("PositionChanged", "GCAD.NavigationGraphNodeEntity." .. self:GetHashCode (),
		function (_, position)
			self:InvalidateBoundingVolumes ()
		end
	)
end

function self:UnhookNavigationGraphNode (navigationGraphNode)
	if not navigationGraphNode then return self end
	
	navigationGraphNode:RemoveEventListener ("PositionChanged", "GCAD.NavigationGraphNodeEntity." .. self:GetHashCode ())
end
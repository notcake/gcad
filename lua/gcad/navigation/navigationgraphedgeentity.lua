local self = {}
GCAD.Navigation.NavigationGraphEdgeEntity = GCAD.MakeConstructor (self,
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

	self.OutlineColorVector, self.OutlineColorAlpha = GLib.Color.ToVector (self.OutlineColor)
	self.ColorVector,        self.ColorAlpha        = GLib.Color.ToVector (self.Color)
	
	self.ColorMaterial = CreateMaterial ("GCAD.SingleColorMaterial", "UnlitGeneric",
		{
			["$translucent"] = 1
		}
	)
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

function self:ctor (navigationGraphEdge)
	self.NavigationGraphEdge = navigationGraphEdge
	
	-- IComponentHost
	self:SetRenderComponent (self)
	self:SetSpatialNode3d (self)
	
	self:InitializeSpatialNode3d ()
	self:HookNavigationGraphEdge (self.NavigationGraphEdge)
end

function self:dtor ()
	self:UnhookNavigationGraphEdge (self.NavigationGraphEdge)
end

-- IRenderComponent
function self:HasOpaqueRendering ()
	return true
end

function self:HasTranslucentRendering ()
	return true
end

function self:RenderOpaque (renderContext)
	IMaterial_SetVector (self.ColorMaterial, "$color", self.OutlineColorVector)
	IMaterial_SetFloat  (self.ColorMaterial, "$alpha", self.OutlineColorAlpha )
	render_SetMaterial (self.ColorMaterial)
	IMesh_Draw (self.WireframeBoxMesh)
end

function self:RenderTranslucent (renderContext)
	IMaterial_SetVector (self.ColorMaterial, "$color", self.ColorVector)
	IMaterial_SetFloat  (self.ColorMaterial, "$alpha", self.ColorAlpha )
	render_SetMaterial (self.ColorMaterial)
	IMesh_Draw (self.BoxMesh)
end

-- SpatialNode3d
function self:ComputeAABB ()
	self.AABBValid = true
	
	local position = self.NavigationGraphEdge:GetFirstNode ():GetPosition ()
	self.AABB:SetMinUnpacked (position - self.HalfBoxSize, position - self.HalfBoxSize, position - self.HalfBoxSize)
	self.AABB:SetMaxUnpacked (position + self.HalfBoxSize, position + self.HalfBoxSize, position + self.HalfBoxSize)
end

function self:ComputeBoundingSphere ()
	self.BoundingSphereValid = true
	
	self.BoundingSphere:SetPosition (self.NavigationGraphEdge:GetFirstNode ():GetPosition ())
end

function self:ComputeOBB ()
	self.OBBValid = true
	
	local x1, y1, z1 = self.NavigationGraphEdge:GetFirstNode  ():GetPositionUnpacked ()
	local x2, y2, z2 = self.NavigationGraphEdge:GetSecondNode ():GetPositionUnpacked ()
	local dx, dy, dz = GCAD.UnpackedVector3d.Subtract (x2, y2, z2, x1, y1, z1)
	self.OBB:SetPositionUnpacked (x1, y1, z1)
	self.OBB:SetAngleUnpacked (GCAD.UnpackedEulerAngle.FromUnpackedDirection (dx, dy, dz))
	self.OBB:SetMinUnpacked (0, -4, -4)
	self.OBB:SetMaxUnpacked (GCAD.UnpackedVector3d.Length (dx, dy, dz), 4, 4)
end

function self:ComputeNativeOBB ()
	self.NativeValid = true
	
	self.NativeOBB = GCAD.NativeOBB3d.FromOBB3d (self:GetOBB (), self.NativeOBB)
end

-- VEntity
function self:GetIcon ()
	return "icon16/vector.png"
end

function self:GetTypeDisplayString ()
	return "Navigation Edge"
end

-- NavigationGraphEdgeEntity
function self:GetNavigationGraphEdge ()
	return self.NavigationGraphEdge
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

function self:HookNavigationGraphEdge (navigationGraphEdge)
	if not navigationGraphEdge then return self end
	
	-- navigationGraphEdge:AddEventListener ("PositionChanged", "GCAD.NavigationGraphEdgeEntity." .. self:GetHashCode (),
	-- 	function (_, position)
	-- 		self:InvalidateBoundingVolumes ()
	-- 	end
	-- )
end

function self:UnhookNavigationGraphEdge (navigationGraphEdge)
	if not navigationGraphEdge then return self end
	
	-- navigationGraphEdge:RemoveEventListener ("PositionChanged", "GCAD.NavigationGraphEdgeEntity." .. self:GetHashCode ())
end
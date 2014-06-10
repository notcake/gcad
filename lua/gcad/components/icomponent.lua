local self = {}
GCAD.Components.IComponent = GCAD.MakeConstructor (self,
	GLib.IDisposable,
	GCAD.IRenderNodeHost,
	GCAD.ISpatialNode3dHost
)

function self:ctor ()
	self.SpatialNode = nil
	self.RenderNode  = nil
end

-- IRenderNodeHost
function self:GetRenderNode ()
	return self.RenderNode
end

-- ISpatialNode3dHost
function self:GetSpatialNode3d ()
	return self.SpatialNode3d
end

-- IComponent
function self:IsValid ()
	return not self:IsDisposed ()
end

function self:SetRenderNode (renderNode)
	if self.RenderNode == renderNode then return self end
	
	self.RenderNode = renderNode
	
	return self
end

function self:SetSpatialNode3d (spatialNode3d)
	if self.SpatialNode3d == spatialNode3d then return self end
	
	self.SpatialNode3d = spatialNode3d
	
	return self
end

-- Display
function self:GetDisplayString ()
	return self:GetTypeDisplayString ()
end

function self:GetIcon ()
	return "icon16/brick.png"
end

function self:GetTypeDisplayString ()
	return "IComponent"
end
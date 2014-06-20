local self = {}
GCAD.Navigation.NavigationGraphEdgeRenderComponent = GCAD.MakeConstructor (self, GCAD.Rendering.IRenderComponent)

function self:ctor (navigationGraphEdge)
	self.NavigationGraphEdge = navigationGraphEdge
end

-- IRenderComponent
function self:HasOpaqueRendering ()
	return true
end

function self:HasTranslucentRendering ()
	return false
end

function self:RenderOpaque (renderContext)
	if not self.NavigationGraphEdge then return end
	local node1 = self.NavigationGraphEdge:GetFirstNode ()
	local node2 = self.NavigationGraphEdge:GetSecondNode ()
	
	if not node1 then return end
	if not node2 then return end
	
	render.DrawLine (node1:GetPositionNative (), node2:GetPositionNative (), GLib.Colors.Red, true)
end

-- NavigationGraphEdgeRenderComponent
function self:GetNavigationGraphEdge ()
	return self.NavigationGraphEdge
end

function self:SetNavigationGraphEdge (navigationGraphEdge)
	if self.NavigationGraphEdge == navigationGraphEdge then return self end
	
	self.NavigationGraphEdge = navigationGraphEdge
	
	return self
end
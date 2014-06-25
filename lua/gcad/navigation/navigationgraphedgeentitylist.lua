local self = {}
GCAD.Navigation.NavigationGraphEdgeEntityList = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

function self:ctor (navigationGraph)
	self.NavigationGraph = nil
	
	self.NavigationGraphEdgeEntities = GLib.WeakTable ()
	
	self:SetNavigationGraph (navigationGraph)
end

-- Navigation graph
function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	self:UnhookNavigationGraph (self.NavigationGraph)
	self.NavigationGraph = navigationGraph
	self.NavigationGraphEdgeEntities = GLib.WeakTable ()
	self:HookNavigationGraph (self.NavigationGraph)
	
	return self
end

-- Navigation graph edges
function self:GetNavigationGraphEdgeEntity (navigationGraphEdge)
	if not self.NavigationGraphEdgeEntities [navigationGraphEdge] then
		local entity = GCAD.Navigation.NavigationGraphEdgeEntity (navigationGraphEdge)
		self.NavigationGraphEdgeEntities [navigationGraphEdge] = entity
	end
	
	return self.NavigationGraphEdgeEntities [navigationGraphEdge]
end

-- ISpatialQueryable3d
function self:FindInFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	return spatialQueryResult
end
self.FindInFrustum = GCAD.Profiler:Wrap (self.FindInFrustum, "NavigationGraphEdgeEntityList:FindInFrustum")

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	return spatialQueryResult
end
self.FindIntersectingFrustum = GCAD.Profiler:Wrap (self.FindIntersectingFrustum, "NavigationGraphEdgeEntityList:FindIntersectingFrustum")

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "NavigationGraphEdgeEntityList:TraceLine")

-- Internal, do not call
function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("EdgeRemoved", "GCAD.NavigationGraphEdgeEntityList." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			if self.NavigationGraphEdgeEntities [navigationGraphEdge] then
				self.NavigationGraphEdgeEntities [navigationGraphEdge]:DispatchEvent ("Removed")
				self.NavigationGraphEdgeEntities [navigationGraphEdge] = nil
			end
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("EdgeRemoved", "GCAD.NavigationGraphEdgeEntityList." .. self:GetHashCode ())
end
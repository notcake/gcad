local self = {}
GCAD.Navigation.NavigationGraphEntityList = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

function self:ctor (navigationGraph)
	self.NavigationGraph = nil
	
	self.NavigationGraphNodeEntities = GLib.WeakKeyTable ()
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
	self.NavigationGraphNodeEntities = GLib.WeakKeyTable ()
	self.NavigationGraphEdgeEntities = GLib.WeakTable ()
	self:HookNavigationGraph (self.NavigationGraph)
	for navigationGraphNode in self.NavigationGraph:GetNodeEnumerator () do
		self:CreateEntityForNavigationGraphNode (navigationGraphNode)
	end
	
	return self
end

-- Navigation graph nodes and edges
function self:CreateEntityForNavigationGraphNode (navigationGraphNode)
	if self.NavigationGraphNodeEntities [navigationGraphNode] then
		return self.NavigationGraphNodeEntities [navigationGraphNode]
	end
	
	local entity = GCAD.Navigation.NavigationGraphNodeEntity (navigationGraphNode)
	self.NavigationGraphNodeEntities [navigationGraphNode] = entity
	return entity
end

function self:GetNavigationGraphNodeEntity (navigationGraphNode)
	if not self.NavigationGraphNodeEntities [navigationGraphNode] then
		self:CreateEntityForNavigationGraphNode (navigationGraphNode)
	end
	
	return self.NavigationGraphNodeEntities [navigationGraphNode]
end

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
	
	for _, spatialNode3d in pairs (self.NavigationGraphNodeEntities) do
		local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (spatialNode3d:GetBoundingSphere ())
		
		if intersectsSphere then
			if containsSphere or
			   frustum3d:ContainsOBB (spatialNode3d:GetOBB ()) then
				spatialQueryResult:Add (spatialNode3d, true)
			end
		end
	end
	
	return spatialQueryResult
end
self.FindInFrustum = GCAD.Profiler:Wrap (self.FindInFrustum, "NavigationGraphEntityList:FindInFrustum")

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	for _, spatialNode3d in pairs (self.NavigationGraphNodeEntities) do
		local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (spatialNode3d:GetBoundingSphere ())
		
		if intersectsSphere then
			if containsSphere then
				spatialQueryResult:Add (spatialNode3d, true)
			elseif frustum3d:IntersectsOBB (spatialNode3d:GetOBB ()) then
				spatialQueryResult:Add (spatialNode3d)
			end
		end
	end
	
	return spatialQueryResult
end
self.FindIntersectingFrustum = GCAD.Profiler:Wrap (self.FindIntersectingFrustum, "NavigationGraphEntityList:FindIntersectingFrustum")

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	for _, spatialNode3d in pairs (self.NavigationGraphNodeEntities) do
		local intersectsSphere = spatialNode3d:GetBoundingSphere ():IntersectsLine (line3d)
		if intersectsSphere then
			local obb = spatialNode3d:GetOBB ()
			local tStart, tEnd = obb:IntersectLine (line3d)
			
			if tStart then
				lineTraceResult:AddIntersectionSpan (spatialNode3d, tStart, tEnd)
			end
		end
	end
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "NavigationGraphEntityList:TraceLine")

-- Internal, do not call
function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("EdgeRemoved", "GCAD.NavigationGraphEntityList." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			self.NavigationGraphEdgeEntities [navigationGraphNode] = nil
		end
	)
	
	navigationGraph:AddEventListener ("NodeAdded", "GCAD.NavigationGraphEntityList." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:CreateEntityForNavigationGraphNode (navigationGraphNode)
		end
	)
	
	navigationGraph:AddEventListener ("NodeRemoved", "GCAD.NavigationGraphEntityList." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self.NavigationGraphNodeEntities [navigationGraphNode] = nil
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("EdgeRemoved", "GCAD.NavigationGraphEntityList." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeAdded",   "GCAD.NavigationGraphEntityList." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeRemoved", "GCAD.NavigationGraphEntityList." .. self:GetHashCode ())
end
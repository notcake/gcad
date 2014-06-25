local self = {}
GCAD.Navigation.NavigationGraphNodeEntityList = GCAD.MakeConstructor (self, GCAD.OBBSpatialQueryable3d)

function self:ctor (navigationGraph)
	self.NavigationGraph = nil
	
	self.NavigationGraphNodeEntities = GLib.WeakKeyTable ()
	
	self:SetNavigationGraph (navigationGraph)
	
	-- Set up profiling
	for methodName, v in pairs (self.__base.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "NavigationGraphNodeEntityList:" .. methodName)
		end
	end
end

-- OBBSpatialQueryable
function self:GetObject (objectHandle)
	return objectHandle
end

function self:GetObjectHandles (out)
	for _, navigationGraphNodeEntity in pairs (self.NavigationGraphNodeEntities) do
		out [#out + 1] = navigationGraphNodeEntity
	end
	
	return out
end

function self:GetBoundingSpheres (objectHandles, out)
	for i = 1, #objectHandles do
		out [i] = objectHandles [i]:GetBoundingSphere ()
	end
	
	return out
end

function self:GetOBBs (objectHandles, out)
	for i = 1, #objectHandles do
		out [i] = objectHandles [i]:GetOBB ()
	end
	
	return out
end

-- NavigationGraphNodeEntityList
-- Navigation graph
function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	self:UnhookNavigationGraph (self.NavigationGraph)
	self.NavigationGraph = navigationGraph
	self.NavigationGraphNodeEntities = GLib.WeakKeyTable ()
	self:HookNavigationGraph (self.NavigationGraph)
	for navigationGraphNode in self.NavigationGraph:GetNodeEnumerator () do
		self:CreateEntityForNavigationGraphNode (navigationGraphNode)
	end
	
	return self
end

-- Navigation graph nodes
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

-- Internal, do not call
function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("NodeAdded", "GCAD.NavigationGraphNodeEntityList." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:CreateEntityForNavigationGraphNode (navigationGraphNode)
		end
	)
	
	navigationGraph:AddEventListener ("NodeRemoved", "GCAD.NavigationGraphNodeEntityList." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			if self.NavigationGraphNodeEntities [navigationGraphNode] then
				self.NavigationGraphNodeEntities [navigationGraphNode]:DispatchEvent ("Removed")
				self.NavigationGraphNodeEntities [navigationGraphNode] = nil
			end
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("NodeAdded",   "GCAD.NavigationGraphNodeEntityList." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeRemoved", "GCAD.NavigationGraphNodeEntityList." .. self:GetHashCode ())
end
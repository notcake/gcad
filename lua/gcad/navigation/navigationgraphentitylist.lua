local self = {}
GCAD.Navigation.NavigationGraphEntityList = GCAD.MakeConstructor (self, GCAD.AggregateSpatialQueryable3d)

function self:ctor (navigationGraph)
	self.NavigationGraph = navigationGraph
	
	self.NavigationGraphNodeEntityList = GCAD.Navigation.NavigationGraphNodeEntityList (navigationGraph)
	self.NavigationGraphEdgeEntityList = GCAD.Navigation.NavigationGraphEdgeEntityList (navigationGraph)
	
	self:AddSpatialQueryable (self.NavigationGraphNodeEntityList)
	self:AddSpatialQueryable (self.NavigationGraphEdgeEntityList)
	
	-- Set up profiling
	for methodName, v in pairs (self.__base.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "NavigationGraphEntityList:" .. methodName)
		end
	end
end

function self:dtor ()
	self.NavigationGraphNodeEntityList:dtor ()
	self.NavigationGraphEdgeEntityList:dtor ()
end

-- Navigation graph
function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	self.NavigationGraph = navigationGraph
	self.NavigationGraphNodeEntityList:SetNavigationGraph (navigationGraph)
	self.NavigationGraphEdgeEntityList:SetNavigationGraph (navigationGraph)
	
	return self
end

function self:GetNavigationGraphNodeEntityList ()
	return self.NavigationGraphNodeEntityList
end

function self:GetNavigationGraphEdgeEntityList ()
	return self.NavigationGraphEdgeEntityList
end
local self = {}
GCAD.Navigation.NavigationGraphEdgeGenerator = GCAD.MakeConstructor (self)

function self:ctor (navigationGraph)
	self.NavigationGraph = navigationGraph
	
	self:HookNavigationGraph (self.NavigationGraph)
end

function self:dtor ()
	self:SetNavigationGraph (nil)
end

function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	self:UnhookNavigationGraph (self.NavigationGraph)
	self.NavigationGraph = navigationGraph
	self:HookNavigationGraph (self.NavigationGraph)
	
	return self
end

-- Internal, do not call
local traceData = {}
traceData.start  = Vector ()
traceData.endpos = Vector ()
traceData.mask   = CONTENTS_SOLID

function self:AutolinkNode (navigationGraphNode)
	traceData.start = navigationGraphNode:GetPositionNative ()
	for navigationGraphNode2 in self.NavigationGraph:GetNodeEnumerator () do
		if navigationGraphNode2 ~= navigationGraphNode then
			traceData.endpos = navigationGraphNode2:GetPositionNative ()
			
			local traceResult = util.TraceLine (traceData)
			if not traceResult.Hit then
				self.NavigationGraph:AddEdge (navigationGraphNode, navigationGraphNode2)
			end
		end
	end
end

function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("NodeAdded", "GCAD.NavigationGraphEdgeGenerator." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:AutolinkNode (navigationGraphNode)
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("NodeAdded", "GCAD.NavigationGraphEdgeGenerator." .. self:GetHashCode ())
end


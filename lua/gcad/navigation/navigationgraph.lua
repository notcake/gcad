local self = {}
GCAD.Navigation.NavigationGraph = GCAD.MakeConstructor (self)

--[[
	Events:
		EdgeAdded (NavigationGraphNode sourceNode, NavigationGraphNode destinationNode, NavigationGraphEdge navigationGraphEdge)
			Fired when an edge has been added.
		EdgeRemoved (NavigationGraphNode sourceNode, NavigationGraphNode destinationNode, NavigationGraphEdge navigationGraphEdge)
			Fired when an edge has been removed.
		NodeAdded (NavigationGraphNode navigationGraphNode)
			Fired when a NavigationGraphNode has been added.
		NodeRemoved (NavigationGraphNode navigationGraphNode)
			Fired when a NavigationGraphNode has been removed.
]]

function self:ctor ()
	self.Graph = GCAD.DirectedGraph ()
	self.NodesByName = {}
	
	GCAD.EventProvider (self)
end

-- Nodes
function self:AddNode (navigationGraphNode, nodeId)
	if self.Graph:ContainsVertex (navigationGraphNode) then return end
	
	self.Graph:AddVertex (navigationGraphNode, nodeId)
	navigationGraphNode:SetNavigationGraph (self)
	
	self:HookNavigationGraphNode (navigationGraphNode)
	if navigationGraphNode:GetName () then
		self.NodesByName [navigationGraphNode:GetName ()] = navigationGraphNode
	end
	
	self:DispatchEvent ("NodeAdded", navigationGraphNode)
end

function self:CreateNode (position)
	local navigationGraphNode = GCAD.Navigation.NavigationGraphNode ()
	
	if position then
		navigationGraphNode:SetPosition (position)
	end
	
	self:AddNode (navigationGraphNode)
	
	return navigationGraphNode
end

function self:GetNode (id)
	return self.Graph:GetVertexById (id)
end

function self:GetNodeCount ()
	return self.Graph:GetVertexCount ()
end

function self:GetNodeEnumerator ()
	return self.Graph:GetVertexEnumerator ()
end

function self:GetNodeId (navigationGraphNode)
	return self.Graph:GetVertexId (navigationGraphNode)
end

function self:DestroyNode (navigationGraphNode)
	self:RemoveNode (navigationGraphNode)
end

function self:RemoveNode (navigationGraphNode)
	if not self.Graph:ContainsVertex (navigationGraphNode) then return end
	
	for sourceNode, destinationNode, navigationGraphEdge in self.Graph:GetVertexOutboundEdgeEnumerator (navigationGraphNode) do
		self:DispatchEvent ("EdgeRemoved", sourceNode, destinationNode, navigationGraphEdge)
	end
	for sourceNode, destinationNode, navigationGraphEdge in self.Graph:GetVertexInboundEdgeEnumerator (navigationGraphNode) do
		self:DispatchEvent ("EdgeRemoved", sourceNode, destinationNode, navigationGraphEdge)
	end
	
	self.Graph:RemoveVertex (navigationGraphNode)
	navigationGraphNode:SetNavigationGraph (nil)
	
	self:UnhookNavigationGraphNode (navigationGraphNode)
	if navigationGraphNode:GetName () then
		self.NodesByName [navigationGraphNode:GetName ()] = nil
	end
	
	self:DispatchEvent ("NodeRemoved", navigationGraphNode)
end

-- Edges
function self:AddEdge (sourceNode, destinationNode)
	if self.Graph:ContainsEdge (sourceNode, destinationNode) then return self:GetEdge (sourceNode, destinationNode) end
	
	local navigationGraphEdge = GCAD.Navigation.NavigationGraphEdge (self, sourceNode, destinationNode)
	
	self.Graph:AddEdge (sourceNode, destinationNode, navigationGraphEdge)
	
	self:DispatchEvent ("EdgeAdded", sourceNode, destinationNode, navigationGraphEdge)
	
	return navigationGraphEdge
end

function self:GetEdgeEnumerator ()
	return self.Graph:GetEdgeEnumerator ()
end

function self:GetNodeInboundEdgeEnumerator (navigationGraphNode)
	return self.Graph:GetVertexInboundEdgeEnumerator (navigationGraphNode)
end

function self:GetNodeOutboundEdgeEnumerator (navigationGraphNode)
	return self.Graph:GetVertexOutboundEdgeEnumerator (navigationGraphNode)
end

function self:RemoveEdge (sourceNode, destinationNode)
	if not self.Graph:ContainsEdge (sourceNode, destinationNode) then return end
	
	local navigationGraphEdge = self.Graph:GetEdge (sourceNode, destinationNode)
	self.Graph:RemoveEdge (sourceNode, destinationNode)
	
	self:DispatchEvent ("EdgeRemoved", sourceNode, destinationNode, navigationGraphEdge)
end

-- Internal, do not call
function self:HookNavigationGraphNode (navigationGraphNode)
	if not navigationGraphNode then return end
	
	navigationGraphNode:AddEventListener ("NameChanged", "NavigationGraph." .. self:GetHashCode (),
		function (_, oldName, newName)
			self.NodesByName [oldName] = nil
			if newName then
				self.NodesByName [newName] = navigationGraphNode
			end
		end
	)
end

function self:UnhookNavigationGraphNode (navigationGraphNode)
	if not navigationGraphNode then return end
	
	navigationGraphNode:RemoveEventListener ("NameChanged", "NavigationGraph." .. self:GetHashCode ())
end
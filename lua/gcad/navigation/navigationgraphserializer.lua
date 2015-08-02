local self = {}
GCAD.Navigation.NavigationGraphSerializer = GCAD.MakeConstructor (self, GLib.IDisposable)

function self:ctor (navigationGraph)
	self.NavigationGraph = nil
	
	self.Path = nil
	self.NeedsSave = false
	
	self:SetNavigationGraph (navigationGraph)
end

function self:dtor ()
	if self.NeedsSave then
		self:Save ()
	end
	
	self:SetNavigationGraph (nil)
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	self:UnhookNavigationGraph (navigationGraph)
	self.NavigationGraph = navigationGraph
	self:HookNavigationGraph (navigationGraph)
	
	return self
end

function self:Save (path)
	path = path or self.Path or "gcad/navigation/" .. game.GetMap () .. ".txt"
	self.Path = path or self.Path
	self.NeedsSave = false
	
	file.CreateDir (string.gsub (self.Path, "[^/]*$", ""))
	
	local outBuffer = GLib.StringOutBuffer ()
	
	for navigationGraphNode in self.NavigationGraph:GetNodeEnumerator () do
		self:SerializeNode (navigationGraphNode, outBuffer)
	end
	self:SerializeNode (nil, outBuffer)
	
	local serializedEdges = {}
	for _, _, navigationGraphEdge in self.NavigationGraph:GetEdgeEnumerator () do
		if serializedEdges [navigationGraphEdge] then break end
		
		self:SerializeEdge (navigationGraphEdge, outBuffer)
		serializedEdges [navigationGraphEdge] = true
	end
	self:SerializeEdge (nil, outBuffer)
	
	file.Write (self.Path, outBuffer:GetString ())
end

function self:Load (path)
	path = path or "gcad/navigation/" .. game.GetMap () .. ".txt"
	self.Path = path
	
	local data = file.Read (self.Path, "DATA")
	if not data then return end
	local inBuffer = GLib.StringInBuffer (data)
	
	while true do
		local nodeId, navigationGraphNode = self:DeserializeNode (inBuffer)
		if not navigationGraphNode then break end
		
		self.NavigationGraph:AddNode (navigationGraphNode, nodeId)
	end
	
	while true do
		local navigationGraphEdge = self:DeserializeEdge (inBuffer)
		if not navigationGraphEdge then break end
	end
end

function self:SerializeNode (navigationGraphNode, outBuffer)
	if not navigationGraphNode then
		outBuffer:UInt32 (0x00000000)
		return
	end
	
	outBuffer:UInt32 (navigationGraphNode:GetId ())
	outBuffer:Double (navigationGraphNode:GetPosition () [1])
	outBuffer:Double (navigationGraphNode:GetPosition () [2])
	outBuffer:Double (navigationGraphNode:GetPosition () [3])
	outBuffer:StringN8 (navigationGraphNode:GetName () or "")
end

function self:DeserializeNode (inBuffer)
	local nodeId = inBuffer:UInt32 ()
	if nodeId == 0x00000000 then return nil, nil end
	
	local navigationGraphNode = GCAD.Navigation.NavigationGraphNode ()
	local x = inBuffer:Double ()
	local y = inBuffer:Double ()
	local z = inBuffer:Double ()
	local name = inBuffer:StringN8 ()
	if name == "" then name = nil end
	
	navigationGraphNode:SetPositionUnpacked (x, y, z)
	navigationGraphNode:SetName (name)
	
	return nodeId, navigationGraphNode
end

function self:SerializeEdge (navigationGraphEdge, outBuffer)
	if not navigationGraphEdge then
		outBuffer:UInt32 (0x00000000)
		outBuffer:UInt32 (0x00000000)
		return
	end
	
	outBuffer:UInt32 (self.NavigationGraph:GetNodeId (navigationGraphEdge:GetFirstNode ()))
	outBuffer:UInt32 (self.NavigationGraph:GetNodeId (navigationGraphEdge:GetSecondNode ()))
	outBuffer:Boolean (navigationGraphEdge:IsBidirectional ())
end

function self:DeserializeEdge (inBuffer)
	local sourceNodeId      = inBuffer:UInt32 ()
	local destinationNodeId = inBuffer:UInt32 ()
	
	if sourceNodeId      == 0x00000000 and
	   destinationNodeId == 0x00000000 then
		return nil
	end
	
	local bidirectional = inBuffer:Boolean ()
	
	local edge = self.NavigationGraph:AddEdge (self.NavigationGraph:GetNode (sourceNodeId), self.NavigationGraph:GetNode (destinationNodeId))
	edge:SetBidirectional (bidirectional)
	
	return edge
end

function self:QueueSave ()
	if self.NeedsSave then return end
	
	self.NeedsSave = true
	
	timer.Simple (10,
		function ()
			if self:IsDisposed () then return end
			if not self.NeedsSave then return end
			self:Save ()
		end
	)
end

-- Internal, do not call
function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("EdgeAdded", "GCAD.NavigationGraphSerializer." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			self:QueueSave ()
		end
	)
	navigationGraph:AddEventListener ("EdgeRemoved", "GCAD.NavigationGraphSerializer." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			self:QueueSave ()
		end
	)
	navigationGraph:AddEventListener ("NodeAdded", "GCAD.NavigationGraphSerializer." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:QueueSave ()
		end
	)
	navigationGraph:AddEventListener ("NodeRemoved", "GCAD.NavigationGraphSerializer." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:QueueSave ()
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("EdgeAdded",   "GCAD.NavigationGraphSerializer." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("EdgeRemoved", "GCAD.NavigationGraphSerializer." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeAdded",   "GCAD.NavigationGraphSerializer." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeRemoved", "GCAD.NavigationGraphSerializer." .. self:GetHashCode ())
end
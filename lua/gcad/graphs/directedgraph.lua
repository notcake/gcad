local self = {}
GCAD.DirectedGraph = GCAD.MakeConstructor (self, GCAD.Graph)

function self:ctor ()
	self.ReverseEdges = {}
end

function self:Clear ()
	-- Vertices
	self.Vertices     = {}
	self.VertexIds    = {}
	self.VertexCount  = 0
	self.NextVertexId = 0
	
	-- Edges
	self.Edges        = {}
	self.ReverseEdges = {}
end

-- Edges
function self:AddEdge (v1, v2, edge)
	self:AddDirectedEdge (v1, v2, edge)
end

function self:AddDirectedEdge (v1, v2, edge)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	local edge = edge or true
	
	self.Edges [vertex1Id] = self.Edges [vertex1Id] or {}
	self.Edges [vertex1Id] [vertex2Id] = edge
	self.ReverseEdges [vertex2Id] = self.ReverseEdges [vertex2Id] or {}
	self.ReverseEdges [vertex2Id] [vertex1Id] = edge
end

function self:AddUndirectedEdge (v1, v2, edge)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	local edge = edge or true
	
	self.Edges [vertex1Id] = self.Edges [vertex1Id] or {}
	self.Edges [vertex1Id] [vertex2Id] = edge
	self.Edges [vertex2Id] = self.Edges [vertex2Id] or {}
	self.Edges [vertex2Id] [vertex1Id] = edge
	self.ReverseEdges [vertex1Id] = self.ReverseEdges [vertex1Id] or {}
	self.ReverseEdges [vertex1Id] [vertex2Id] = edge
	self.ReverseEdges [vertex2Id] = self.ReverseEdges [vertex2Id] or {}
	self.ReverseEdges [vertex2Id] [vertex1Id] = edge
end

function self:GetEdgeEnumerator ()
	return self:GetDirectedEdgeEnumerator ()
end

function self:GetVertexInboundEdgeEnumerator (destinationVertex)
	local destinationVertexId = self.VertexIds [destinationVertex]
	
	if not destinationVertexId                     then return GLib.NullEnumerator () end
	if not self.ReverseEdges [destinationVertexId] then return GLib.NullEnumerator () end
	
	local next, tbl, sourceVertexId = pairs (self.ReverseEdges [destinationVertexId])
	return function ()
		while sourceVertexId and not self.Vertices [sourceVertexId] do
			sourceVertexId = next (tbl, sourceVertexId)
		end
		
		return self.Vertices [sourceVertexId], destinationVertex, self.ReverseEdges [destinationVertexId] [sourceVertexId]
	end
end

function self:GetVertexOutboundEdgeEnumerator (sourceVertex)
	return self:GetVertexEdgeEnumerator (sourceVertex)
end

function self:RemoveEdge (v1, v2, edge)
	self:RemoveDirectedEdge (v1, v2, edge)
end

function self:RemoveDirectedEdge (v1, v2)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	
	if self.Edges [vertex1Id] then
		self.Edges        [vertex1Id] [vertex2Id] = nil
		self.ReverseEdges [vertex2Id] [vertex1Id] = nil
		if next (self.Edges        [vertex1Id]) == nil then self.Edges        [vertex1Id] = nil end
		if next (self.ReverseEdges [vertex2Id]) == nil then self.ReverseEdges [vertex2Id] = nil end
	end
end

function self:RemoveUndirectedEdge (v1, v2)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	
	if self.Edges [vertex1Id] then
		self.Edges        [vertex1Id] [vertex2Id] = nil
		self.ReverseEdges [vertex2Id] [vertex1Id] = nil
		if next (self.Edges        [vertex1Id]) == nil then self.Edges        [vertex1Id] = nil end
		if next (self.ReverseEdges [vertex2Id]) == nil then self.ReverseEdges [vertex2Id] = nil end
	end
	
	if self.Edges [vertex2Id] then
		self.Edges        [vertex2Id] [vertex1Id] = nil
		self.ReverseEdges [vertex1Id] [vertex2Id] = nil
		if next (self.Edges        [vertex2Id]) == nil then self.Edges        [vertex2Id] = nil end
		if next (self.ReverseEdges [vertex1Id]) == nil then self.ReverseEdges [vertex1Id] = nil end
	end
end

function self:RemoveVertexEdges (vertex)
	local vertex1Id = self.VertexIds [vertex]
	
	-- Remove forward edges
	if self.Edges [vertex1Id] then
		for vertex2Id, _ in pairs (self.Edges [vertex1Id]) do
			self.ReverseEdges [vertex2Id] [vertex1Id] = nil
			if next (self.ReverseEdges [vertex2Id]) == nil then self.ReverseEdges [vertex2Id] = nil end
		end
		self.Edges [vertex1Id] = nil
	end
	
	-- Remove reverse edges
	if self.ReverseEdges [vertex1Id] then
		for vertex2Id, _ in pairs (self.ReverseEdges [vertex1Id]) do
			self.Edges [vertex2Id] [vertex1Id] = nil
			if next (self.Edges [vertex2Id]) == nil then self.Edges [vertex2Id] = nil end
		end
		self.ReverseEdges [vertex1Id] = nil
	end
end
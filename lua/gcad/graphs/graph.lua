local self = {}
GCAD.Graph = GCAD.MakeConstructor (self, GCAD.IGraph)

function self:ctor ()
	-- Vertices
	self.Vertices     = {}
	self.VertexIds    = {}
	self.VertexCount  = 0
	self.NextVertexId = 1
	
	-- Edges
	self.Edges        = {}
end

function self:Clear ()
	self.Vertices     = {}
	self.VertexIds    = {}
	self.VertexCount  = 0
	self.NextVertexId = 1
	
	self.Edges        = {}
end

-- Vertices
function self:AddVertex (vertex, vertexId)
	if self.VertexIds [vertex] then return end
	
	if vertexId then
		self.NextVertexId = math.max (self.NextVertexId, vertexId + 1)
	else
		vertexId = self.NextVertexId
		self.NextVertexId = self.NextVertexId + 1
	end
	
	if self.Vertices [vertexId] then
		self:RemoveVertex (self.Vertices [vertexId])
	end
	
	self.Vertices [vertexId] = true
	self.VertexIds [vertex] = vertexId
	self.VertexCount = self.VertexCount + 1
end

function self:ContainsVertex (vertex)
	return self.VertexIds [vertex] ~= nil
end

function self:GetVertexById (vertexId)
	return self.Vertices [vertexId]
end

function self:GetVertexCount ()
	return self.VertexCount
end

function self:GetVertexId (vertex)
	return self.VertexIds [vertex]
end

function self:GetVertexEnumerator ()
	return GLib.KeyEnumerator (self.VertexIds)
end

function self:IsEmpty ()
	return self.Vertex
end

function self:RemoveVertex (vertex)
	if not self.VertexIds [vertex] then return end
	
	self:RemoveVertexEdges (vertex)
	
	local vertexId = self.VertexIds [vertex]
	self.VertexIds [vertex] = nil
	self.Vertices [vertexId] = nil
	self.VertexCount = self.VertexCount - 1
end

-- Edges
function self:ContainsEdge (v1, v2)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	if not self.Edges [vertex1Id] then return false end
	return self.Edges [vertex1Id] [vertex2Id] ~= nil
end

function self:GetDirectedEdgeEnumerator ()
	local vertexEnumerator     = self:GetVertexEnumerator ()
	local sourceVertex         = nil
	local sourceVertexId       = nil
	local vertexEdgeEnumerator = nil
	return function ()
		while true do
			if vertexEdgeEnumerator then
				local _, destinationVertex, edge = vertexEdgeEnumerator ()
				if destinationVertex then return sourceVertex, destinationVertex, edge end
			end
			sourceVertex   = vertexEnumerator ()
			sourceVertexId = self.VertexIds [sourceVertex]
			if not sourceVertex then return nil, nil, nil end
			
			vertexEdgeEnumerator = self:GetVertexEdgeEnumator (sourceVertex)
		end
	end
end

function self:GetEdge (v1, v2)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	if not self.Edges [vertex1Id] then return false end
	return self.Edges [vertex1Id] [vertex2Id]
end

function self:GetEdgeEnumerator ()
	return self:GetUndirectedEdgeEnumerator ()
end

function self:GetUndirectedEdgeEnumerator ()
	local vertexEnumerator     = self:GetVertexEnumerator ()
	local sourceVertex         = nil
	local sourceVertexId       = nil
	local vertexEdgeEnumerator = nil
	return function ()
		while true do
			if vertexEdgeEnumerator then
				while true do
					local _, destinationVertex, edge = vertexEdgeEnumerator ()
					if not destinationVertex then break end
					
					if self.VertexIds [destinationVertex] >= sourceVertexId then return sourceVertex, destinationVertex, edge end
				end
			end
			sourceVertex   = vertexEnumerator ()
			sourceVertexId = self.VertexIds [sourceVertex]
			if not sourceVertex then return nil, nil end
			
			vertexEdgeEnumerator = self:GetVertexEdgeEnumator (sourceVertex)
		end
	end
end

function self:GetVertexEdgeEnumerator (sourceVertex)
	local sourceVertexId = self.VertexIds [sourceVertex]
	
	if not sourceVertexId              then return GLib.NullEnumerator () end
	if not self.Edges [sourceVertexId] then return GLib.NullEnumerator () end
	
	local next, tbl, destinationVertexId = pairs (self.Edges [sourceVertexId])
	return function ()
		destinationVertexId = next (tbl, destinationVertexId)
		
		while destinationVertexId and not self.Vertices [destinationVertexId] do
			destinationVertexId = next (tbl, destinationVertexId)
		end
		
		if not destinationVertexId then return nil, nil, nil end
		
		return sourceVertex, self.Vertices [destinationVertexId], self.Edges [sourceVertexId] [destinationVertexId]
	end
end
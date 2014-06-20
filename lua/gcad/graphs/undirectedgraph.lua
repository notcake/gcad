local self = {}
GCAD.UndirectedGraph = GCAD.MakeConstructor (self, GCAD.Graph)

function self:ctor ()
end

-- Edges
function self:AddEdge (v1, v2, edge)
	self:AddUndirectedEdge (v1, v2, edge)
end

function self:AddUndirectedEdge (v1, v2, edge)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	local edge = edge or true
	
	self.Edges [vertex1Id] = self.Edges [vertex1Id] or {}
	self.Edges [vertex1Id] [vertex2Id] = edge
	self.Edges [vertex2Id] = self.Edges [vertex2Id] or {}
	self.Edges [vertex2Id] [vertex1Id] = edge
end

function self:RemoveEdge (v1, v2, edge)
	self:RemoveUndirectedEdge (v1, v2, edge)
end

function self:RemoveUndirectedEdge (v1, v2)
	local vertex1Id = self.VertexIds [v1]
	local vertex2Id = self.VertexIds [v2]
	
	if self.Edges [vertex1Id] then
		self.Edges        [vertex1Id] [vertex2Id] = nil
		if next (self.Edges        [vertex1Id]) == nil then self.Edges        [vertex1Id] = nil end
	end
	
	if self.Edges [vertex2Id] then
		self.Edges        [vertex2Id] [vertex1Id] = nil
		if next (self.Edges        [vertex2Id]) == nil then self.Edges        [vertex2Id] = nil end
	end
end

function self:RemoveVertexEdges (vertex)
	local vertex1Id = self.VertexIds [vertex]
	
	-- Remove complementary edges
	if self.Edges [vertex1Id] then
		for vertex2Id, _ in pairs (self.Edges [vertex1Id]) do
			self.Edges [vertex2Id] [vertex1Id] = nil
			if next (self.Edges [vertex2Id]) == nil then self.Edges [vertex2Id] = nil end
		end
		self.Edges [vertex1Id] = nil
	end
end
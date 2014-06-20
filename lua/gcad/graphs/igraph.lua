local self = {}
GCAD.IGraph = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:Clear ()
	GCAD.Error ("IGraph:Clear : Not implemented.")
end

-- Vertices
function self:AddVertex (vertex)
	GCAD.Error ("IGraph:AddVertex : Not implemented.")
end

function self:ContainsVertex (vertex)
	GCAD.Error ("IGraph:ContainsVertex : Not implemented.")
end

function self:GetVertexById (vertexId)
	GCAD.Error ("IGraph:GetVertexById : Not implemented.")
end

function self:GetVertexCount ()
	GCAD.Error ("IGraph:GetVertexCount : Not implemented.")
end

function self:GetVertexId (vertex)
	GCAD.Error ("IGraph:GetVertexId : Not implemented.")
end

function self:GetVertexEnumerator ()
	GCAD.Error ("IGraph:GetVertexEnumerator : Not implemented.")
end

function self:IsEmpty ()
	GCAD.Error ("IGraph:IsEmpty : Not implemented.")
end

function self:RemoveVertex (vertex)
	GCAD.Error ("IGraph:RemoveVertex : Not implemented.")
end

-- Edges
function self:AddEdge (v1, v2, edge)
	GCAD.Error ("IGraph:AddEdge : Not implemented.")
end

function self:ContainsEdge (v1, v2)
	GCAD.Error ("IGraph:ContainsEdge : Not implemented.")
end

function self:GetDirectedEdgeEnumerator ()
	GCAD.Error ("IGraph:GetDirectedEdgeEnumerator : Not implemented.")
end

function self:GetEdge (v1, v2)
	GCAD.Error ("IGraph:GetEdge : Not implemented.")
end

function self:GetEdgeEnumerator ()
	GCAD.Error ("IGraph:GetEdgeEnumerator : Not implemented.")
end

function self:GetUndirectedEdgeEnumerator ()
	GCAD.Error ("IGraph:GetUndirectedEdgeEnumerator : Not implemented.")
end

function self:GetVertexEdgeEnumerator (sourceVertex)
	GCAD.Error ("IGraph:GetVertexEdgeEnumerator : Not implemented.")
end

function self:RemoveEdge (v1, v2, edge)
	GCAD.Error ("IGraph:RemoveEdge : Not implemented.")
end

function self:RemoveVertexEdges (vertex)
	GCAD.Error ("IGraph:RemoveVertexEdges : Not implemented.")
end
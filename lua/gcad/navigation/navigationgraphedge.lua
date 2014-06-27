local self = {}
GCAD.Navigation.NavigationGraphEdge = GCAD.MakeConstructor (self)

function self:ctor (navigationGraph, firstNode, secondNode)
	self.NavigationGraph = navigationGraph
	
	self.FirstNode       = firstNode
	self.SecondNode      = secondNode
	
	self.Bidirectional   = false
end

-- Navigation graph
function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:GetFirstNode ()
	return self.FirstNode
end

function self:GetSecondNode ()
	return self.SecondNode
end

function self:Remove ()
	if not self.NavigationGraph then return end
	
	self.NavigationGraph:RemoveEdge (self.FirstNode, self.SecondNode)
	if self:IsBidirectional () then
		self.NavigationGraph:RemoveEdge (self.SecondNode, self.FirstNode)
	end
end

function self:IsBidirectional ()
	return self.Bidirectional
end

function self:SetBidirectional (bidirectional)
	if self.Bidirectional == bidirectional then return self end
	
	self.Bidirectional = bidirectional
	
	return self
end
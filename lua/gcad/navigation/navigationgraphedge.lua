local self = {}
GCAD.Navigation.NavigationGraphEdge = GCAD.MakeConstructor (self)

function self:ctor (navigationGraph, firstNode, secondNode)
	self.NavigationGraph = navigationGraph
	
	self.FirstNode       = firstNode
	self.SecondNode      = secondNode
end

function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:GetFirstNode ()
	return self.FirstNode
end

function self:GetSecondNode ()
	return self.SecondNode
end
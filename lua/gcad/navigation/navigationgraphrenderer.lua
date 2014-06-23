local self = {}
GCAD.Navigation.NavigationGraphRenderer = GCAD.MakeConstructor (self)

function self:ctor (navigationGraph, sceneGraph, navigationGraphEntityList)
	self.NavigationGraph           = navigationGraph
	self.NavigationGraphEntityList = navigationGraphEntityList
	self.SceneGraph                = sceneGraph
	
	self.RootSceneGraphNode = self.SceneGraph:CreateGroupNode ()
	self.SceneGraph:GetRootNode ():AddChild (self.RootSceneGraphNode)
	
	self:HookNavigationGraph (self.NavigationGraph)
	
	self.NavigationGraphNodeSceneGraphNodes = {}
	self.NavigationGraphEdgeSceneGraphNodes = {}
end

function self:dtor ()
	self.RootSceneGraphNode:Remove ()
end

-- Internal, do not call
function self:CreateNavigationGraphNodeSceneGraphNode (navigationGraphNode)
	if self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode] then return end
	
	local sceneGraphNode = self.SceneGraph:CreateModelNode ()
	self.RootSceneGraphNode:AddChild (sceneGraphNode)
	self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode] = sceneGraphNode
	
	local navigationGraphNodeEntity = self.NavigationGraphEntityList:GetNavigationGraphNodeEntity (navigationGraphNode)
	sceneGraphNode:SetRenderComponent (navigationGraphNodeEntity)
	navigationGraphNodeEntity:SetSceneGraphNode (sceneGraphNode)
	
	sceneGraphNode:SetPosition (navigationGraphNode:GetPosition ())
end

function self:CreateNavigationGraphEdgeSceneGraphNode (navigationGraphEdge)
	if self.NavigationGraphEdgeSceneGraphNodes [navigationGraphEdge] then return end
	
	local sceneGraphNode = self.SceneGraph:CreateModelNode ()
	self.RootSceneGraphNode:AddChild (sceneGraphNode)
	self.NavigationGraphEdgeSceneGraphNodes [navigationGraphEdge] = sceneGraphNode
	sceneGraphNode:SetRenderComponent (GCAD.Navigation.NavigationGraphEdgeRenderComponent (navigationGraphEdge))
end

function self:DestroyNavigationGraphNodeSceneGraphNode (navigationGraphNode)
	if not self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode] then return end
	
	self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode]:Remove ()
	self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode] = nil
end

function self:DestroyNavigationGraphEdgeSceneGraphNode (navigationGraphEdge)
	if not self.NavigationGraphEdgeSceneGraphNodes [navigationGraphEdge] then return end
	
	self.NavigationGraphEdgeSceneGraphNodes [navigationGraphEdge]:Remove ()
	self.NavigationGraphEdgeSceneGraphNodes [navigationGraphEdge] = nil
end

function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("EdgeAdded", "GCAD.NavigationGraphRenderer." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			self:CreateNavigationGraphEdgeSceneGraphNode (navigationGraphEdge)
			self:HookNavigationGraphEdge (navigationGraphEdge)
		end
	)
	navigationGraph:AddEventListener ("EdgeRemoved", "GCAD.NavigationGraphRenderer." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			self:DestroyNavigationGraphEdgeSceneGraphNode (navigationGraphEdge)
			self:UnhookNavigationGraphEdge (navigationGraphEdge)
		end
	)
	navigationGraph:AddEventListener ("NodeAdded", "GCAD.NavigationGraphRenderer." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:CreateNavigationGraphNodeSceneGraphNode (navigationGraphNode)
			self:HookNavigationGraphNode (navigationGraphNode)
		end
	)
	navigationGraph:AddEventListener ("NodeRemoved", "GCAD.NavigationGraphRenderer." .. self:GetHashCode (),
		function (_, navigationGraphNode)
			self:DestroyNavigationGraphNodeSceneGraphNode (navigationGraphNode)
			self:UnhookNavigationGraphNode (navigationGraphNode)
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("EdgeAdded",   "GCAD.NavigationGraphRenderer." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("EdgeRemoved", "GCAD.NavigationGraphRenderer." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeAdded",   "GCAD.NavigationGraphRenderer." .. self:GetHashCode ())
	navigationGraph:RemoveEventListener ("NodeRemoved", "GCAD.NavigationGraphRenderer." .. self:GetHashCode ())
end

function self:HookNavigationGraphEdge (navigationGraphEdge)
	if not navigationGraphEdge then return end
end

function self:UnhookNavigationGraphEdge (navigationGraphEdge)
	if not navigationGraphEdge then return end
end

function self:HookNavigationGraphNode (navigationGraphNode)
	if not navigationGraphNode then return end
	
	navigationGraphNode:AddEventListener ("PositionChanged", "GCAD.NavigationGraphRenderer." .. self:GetHashCode (),
		function (_, position)
			if not self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode] then return end
			
			self.NavigationGraphNodeSceneGraphNodes [navigationGraphNode]:SetPosition (position)
		end
	)
end

function self:UnhookNavigationGraphNode (navigationGraphNode)
	if not navigationGraphNode then return end
	
	navigationGraphNode:RemoveEventListener ("PositionChanged", "GCAD.NavigationGraphRenderer." .. self:GetHashCode ())
end
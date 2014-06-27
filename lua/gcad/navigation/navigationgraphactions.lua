GCAD.ActionProvider:AddAction ("NavigationGraphNode.Remove")
	:SetName ("Remove")
	:SetIcon ("icon16/cross.png")
	:SetDescription ("Remove this navigation node")
	:SetCanExecuteFunction (
		function (userId, ventity)
			if not ventity:Is (GCAD.Navigation.NavigationGraphNodeEntity) then return false end
			return true
		end
	)
	:SetExecuteFunction (
		function (userId, ventity)
			if not ventity:Is (GCAD.Navigation.NavigationGraphNodeEntity) then return false end
			ventity:GetNavigationGraphNode ():Remove ()
			return true
		end
	)
GCAD.ActionProvider:AddAction ("NavigationGraphNode.Link")
	:SetName ("Link")
	:SetIcon ("icon16/vector_add.png")
	:SetDescription ("Link navigation nodes")
	:SetCanExecuteFunction (
		function (userId, ventity)
			if not ventity:Is (GCAD.Navigation.NavigationGraphNodeEntity) then return false end
			return true
		end
	)
	:SetExecuteFunction (
		function (userId, ventity)
			if not ventity:Is (GCAD.Navigation.NavigationGraphNodeEntity) then return false end
			ventity:GetNavigationGraphNode ():Remove ()
			return true
		end
	)
GCAD.ActionProvider:AddAction ("NavigationGraphEdge.Remove")
	:SetName ("Remove")
	:SetIcon ("icon16/cross.png")
	:SetDescription ("Remove this navigation edge")
	:SetCanExecuteFunction (
		function (userId, ventity)
			if not ventity:Is (GCAD.Navigation.NavigationGraphEdgeEntity) then return false end
			return true
		end
	)
	:SetExecuteFunction (
		function (userId, ventity)
			if not ventity:Is (GCAD.Navigation.NavigationGraphEdgeEntity) then return false end
			ventity:GetNavigationGraphEdge ():Remove ()
			return true
		end
	)
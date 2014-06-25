GCAD.ActionProvider:AddAction ("Remove")
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
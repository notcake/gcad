function GCAD.UI.ContextMenuContextMenu (self)
	local contextMenu = Gooey.Menu ()
	local creationMenu = Gooey.Menu ()
	creationMenu:AddItem ("Model")
		:SetIcon ("icon16/car.png")
		:AddEventListener ("Click",
			function (_)
			end
		)
	creationMenu:AddItem ("Navigation Node")
		:SetIcon ("icon16/vector.png")
		:AddEventListener ("Click",
			function (_)
				GCAD.NavigationGraph:CreateNode (contextMenu.WorldIntersectionPosition)
			end
		)
	creationMenu:AddItem ("Navigation Node (x100)")
		:SetIcon ("icon16/vector.png")
		:AddEventListener ("Click",
			function (_)
				for i = 1, 100 do
					GCAD.NavigationGraph:CreateNode (contextMenu.WorldIntersectionPosition)
				end
			end
		)
	
	contextMenu:AddEventListener ("MenuClosed",
		function (_)
			if self.SelectionTemporary then
				self.SelectionTemporary = false
				self.Selection:Clear ()
			end
			
			self.SelectionPreviewSet:Clear ()
		end
	)
	
	local lastGroupName
	local function BeginItemGroup (groupName)
		if lastGroupName and
		   lastGroupName ~= groupName then
			contextMenu:AddSeparator ()
			lastGroupName = groupName
		end
		lastGroupName = groupName
	end
	
	contextMenu:AddEventListener ("MenuOpening",
		function (_)
			if contextMenu:GetItemById ("Create") then
				contextMenu:GetItemById ("Create"):SetSubMenu (nil)
			end
			contextMenu:Clear ()
			
			BeginItemGroup ("SelectionControl")
			contextMenu:AddItem ("Deselect all")
				:SetEnabled (not self.Selection:IsEmpty ())
				:AddEventListener ("Click",
					function ()
						self.Selection:Clear ()
					end
				)
			
			-- Ambiguous entity selection
			-- Add a menu item for each object intersecting the line segment from the cursor to the world.
			local lineTraceResult = self:TraceRay (self.MouseMoveX, self.MouseMoveY)
			contextMenu.LineTraceResult = lineTraceResult
			
			local objects = {}
			local count = 0
			for object, t in lineTraceResult:GetEnumerator () do
				if object:Is (GCAD.VEntities.EntityReference) and
				   object:GetEntity ():GetClass () == "worldspawn" then
					contextMenu.WorldIntersectionPosition = lineTraceResult:GetLine ():Evaluate (t, contextMenu.WorldIntersectionPosition)
					break
				end
				
				if not objects [object] then
					if count >= 10 then
						contextMenu:AddItem ("...")
						break
					end
					count = count + 1
					
					objects [object] = true
					
					BeginItemGroup ("SelectionDisambiguation")
					local menuItem = contextMenu:AddItem (object:GetDisplayString ())
					menuItem:SetIcon (object:GetIcon ())
					menuItem:SetText ("Select " .. object:GetDisplayString ())
					if object.GetEntity and
					   object:GetEntity () and
					   object:GetEntity ():IsValid () and
					   object:GetEntity ():GetModel () and
					   object:GetEntity ():GetModel () ~= "" then
						menuItem:SetToolTipText (object:GetEntity ():GetModel ())
					end
					
					if self.Selection:Contains (object) then
						menuItem:SetChecked (true)
					end
					
					menuItem:AddEventListener ("Click",
						function (_)
							if not object or not object:IsValid () then return end
							
							self.SelectionTemporary = false
							
							local shift   = input.IsKeyDown (KEY_LSHIFT)
							local control = input.IsKeyDown (KEY_LCONTROL)
							
							if shift then
								self.Selection:Add (object)
							elseif control then
								if self.Selection:Contains (object) then
									self.Selection:Remove (object)
								else
									self.Selection:Add (object)
								end
							else
								self.Selection:Clear ()
								self.Selection:Add (object)
							end
						end
					)
					
					menuItem:AddEventListener ("MouseEnter",
						function (_)
							if object:IsDisposed () then return end
							
							self.SelectionPreviewSet:Add (object)
						end
					)
					
					menuItem:AddEventListener ("MouseLeave",
						function (_)
							if object:IsDisposed () then return end
							
							self.SelectionPreviewSet:Remove (object)
						end
					)
				end
			end
			
			-- Add menu items for creation
			BeginItemGroup ("ComponentCreation")
			contextMenu:AddItem ("Create")
				:SetIcon ("icon16/add.png")
				:SetSubMenu (creationMenu)
			
			-- Add menu items for actions
			-- Collect list of applicable actions
			GCAD.Profiler:Begin ("ContextMenuContextMenu.MenuOpening : Collect applicable actions 1")
			local applicableActions = GCAD.Actions.ActionProvider ()
			local applicableActionNameSet = {}
			GCAD.Profiler:Begin ("ContextMenuContextMenu.MenuOpening : Collect applicable actions 11")
			local localId = GLib.GetLocalId ()
			for action in GCAD.AggregateActionProvider:GetEnumerator () do
				for object in self.Selection:GetEnumerator () do
					if action:CanExecute (localId, object) then
						applicableActionNameSet [action:GetName ()] = true
						applicableActions:AddAction (action)
						break
					end
				end
			end
			GCAD.Profiler:End ()
			
			if next (applicableActionNameSet) then
				BeginItemGroup ("Actions2")
			end
			
			-- Sort action names
			local applicableActionNames = {}
			for actionName, _ in pairs (applicableActionNameSet) do
				applicableActionNames [#applicableActionNames + 1] = actionName
			end
			table.sort (applicableActionNames)
			
			-- Create action menu items
			for _, actionName in ipairs (applicableActionNames) do
				local actions = applicableActions:GetActionsByName (actionName)
				
				local menuItem = contextMenu:AddItem (actionName,
					function ()
						for object in self.Selection:GetEnumerator () do
							for _, action in ipairs (actions) do
								if action:CanExecute (localId, object) then
									action:Execute (localId, object)
									break
								end
							end
						end
					end
				)
				
				for _, action in ipairs (actions) do
					if action:GetIcon () then
						menuItem:SetIcon (action:GetIcon ())
					end
				end
				
				local description = nil
				for _, action in ipairs (actions) do
					if action:GetDescription () then
						if description then
							description = description .. "\n"
						else
							description = ""
						end
						
						description = description .. action:GetDescription ()
					end
				end
				
				menuItem:SetToolTipText (description)
			end
			GCAD.Profiler:End ()
			
			-- ==================================================================
			-- ==================================================================
			-- ==================================================================
			
			-- Add menu items for actions
			-- Collect list of applicable actions
			local applicableActions = {}
			GCAD.Profiler:Begin ("ContextMenuContextMenu.MenuOpening : Collect applicable actions")
			if properties and properties.List then
				local localPlayer = LocalPlayer ()
				
				GCAD.Profiler:Begin ("ContextMenuContextMenu.MenuOpening : Collect applicable entities")
				local entities = {}
				for object in self.Selection:GetEnumerator () do
					if object:IsValid () and
					   object:Is (GCAD.VEntities.EntityReference) then
						entities [#entities + 1] = object:GetEntity ()
					end
				end
				GCAD.Profiler:End ()
				
				GCAD.Profiler:Begin ("ContextMenuContextMenu.MenuOpening : Filter to allowable actions")
				for _, actionInfo in pairs (properties.List) do
					for _, object in ipairs (entities) do
						GCAD.Profiler:Begin (GLib.Lua.GetFunctionName (actionInfo.Filter) or tostring (actionInfo.Filter))
						local filterResult = actionInfo:Filter (object, localPlayer)
						GCAD.Profiler:End ()
						if filterResult and
						   not actionInfo.MenuOpen then
							applicableActions [#applicableActions + 1] = actionInfo
							break
						end
					end
				end
				GCAD.Profiler:End ()
			end
			GCAD.Profiler:End ()
			
			-- Sort actions
			table.sort (applicableActions,
				function (a, b)
					if a.Type == "toggle" and b.Type ~= "toggle" then return false end
					if a.Type ~= "toggle" and b.Type == "toggle" then return true  end
					
					if a.Order ~= b.Order then return a.Order < b.Order end
					return a.MenuLabel < b.MenuLabel
				end
			)
			
			-- Separator
			if #applicableActions > 0 then
				BeginItemGroup ("Actions")
			end
			
			-- Create action menu items
			local toggleSpacerCreated = false
			for _, actionInfo in ipairs (applicableActions) do
				if actionInfo.Type == "toggle" and not toggleSpacerCreated then
					toggleSpacerCreated = true
					contextMenu:AddSeparator ()
				elseif actionInfo.PrependSpacer then
					contextMenu:AddSeparator ()
				end
				
				local text = actionInfo.MenuLabel
				
				if string.sub (text, 1, 1) == "#" then
					text = language.GetPhrase (string.sub (text, 2))
				end
				
				local menuItem = contextMenu:AddItem (text,
					function ()
						for object in self.Selection:GetEnumerator () do
							if object:IsValid () and
							   object:Is (GCAD.VEntities.EntityReference) and
							   actionInfo:Filter (object:GetEntity (), LocalPlayer ()) then
								actionInfo:Action (object:GetEntity ())
							end
						end
					end
				)
				
				if actionInfo.MenuIcon then
					menuItem:SetIcon (actionInfo.MenuIcon)
				end
				
				if actionInfo.Type == "toggle" then
					local checked = false
					
					for object in self.Selection:GetEnumerator () do
						if object:IsValid () and
						   object:Is (GCAD.VEntities.EntityReference) and
						   actionInfo:Checked (object:GetEntity (), LocalPlayer ()) then
							checked = true
							break
						end
					end
					
					menuItem:SetChecked (checked)
					if checked and not actionInfo.MenuIcon then
						menuItem:SetIcon ("icon16/tick.png")
					end
				end
			end
		end
	)
	
	return contextMenu
end
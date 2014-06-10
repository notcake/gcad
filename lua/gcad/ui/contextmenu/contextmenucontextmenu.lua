function GCAD.UI.ContextMenuContextMenu (self)
	local contextMenu = Gooey.Menu ()
	local creationMenu = Gooey.Menu ()
	creationMenu:AddItem ("Model")
		:SetIcon ("icon16/car.png")
		:AddEventListener ("Click",
			function (_)
				print ("FEG")
			end
		)
	creationMenu:AddItem ("Navigation Node")
		:SetIcon ("icon16/vector.png")
		:AddEventListener ("Click",
			function (_)
				print ("FEG")
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
			local objects = {}
			for object in lineTraceResult:GetEnumerator () do
				if object:Is (GCAD.Components.EntityReference) and
				   object:GetEntity ():GetClass () == "worldspawn" then break end
				
				if not objects [object] then
					objects [object] = true
					
					BeginItemGroup ("SelectionDisambiguation")
					local menuItem = contextMenu:AddItem (object:GetDisplayString ())
					menuItem:SetIcon (object:GetIcon ())
					menuItem:SetText (object:GetDisplayString ())
					
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
			local applicableActions = {}
			if properties and properties.List then
				for _, actionInfo in pairs (properties.List) do
					for object in self.Selection:GetEnumerator () do
						if object:IsValid () and
						   object:Is (GCAD.Components.EntityReference) and
						   actionInfo:Filter (object:GetEntity (), LocalPlayer ()) and
						   not actionInfo.MenuOpen then
							applicableActions [#applicableActions + 1] = actionInfo
							break
						end
					end
				end
			end
			
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
							   object:Is (GCAD.Components.EntityReference) and
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
						   object:Is (GCAD.Components.EntityReference) and
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
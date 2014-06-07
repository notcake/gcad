local self = {}
GCAD.UI.ContextMenuEventHandler = GCAD.MakeConstructor (self, GCAD.UI.IMouseEventSink)

function self:ctor ()
	self:SetMouseEventSource (GCAD.UI.ContextMenuEventSource)
	
	self.Selection = GCAD.UI.Selection ()
	self.SelectionTemporary = false
	
	self.TemporarySelectionSet = GLib.Containers.EventedSet ()
	self.SelectionPreviewSet = GCAD.Containers.EventedSet ()
	
	self.SelectionRenderer = GCAD.UI.SelectionRenderer (self.Selection)
	self.SelectionRenderer:SetSelectionPreview (self.SelectionPreviewSet)
	
	self.MouseDown = false
	self.MouseDownX = nil
	self.MouseDownY = nil
	self.MouseMoveX = nil
	self.MouseMoveY = nil
	
	self.ContextMenu = Gooey.Menu ()
	self.ContextMenu:AddEventListener ("MenuClosed",
		function (_)
			if self.SelectionTemporary then
				self.SelectionTemporary = false
				self.Selection:Clear ()
			end
			
			self.SelectionPreviewSet:Clear ()
		end
	)
	self.ContextMenu:AddEventListener ("MenuOpening",
		function (_)
			self.ContextMenu:Clear ()
			
			-- Ambiguous entity selection
			local lineTraceResult = self:TraceRay (self.MouseMoveX, self.MouseMoveY)
			local objects = {}
			for object in lineTraceResult:GetEnumerator () do
				if object:GetClass () == "worldspawn" then break end
				
				if not objects [object] then
					objects [object] = true
					
					local menuItem = self.ContextMenu:AddItem (tostring (object:EntIndex ()))
					if object:IsPlayer () then
						menuItem:SetIcon (object:IsAdmin () and "icon16/shield.png" or "icon16/user.png")
						menuItem:SetText (object:Nick ())
					else
						menuItem:SetText (object:GetClass ())
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
							if not object or not object:IsValid () then return end
							
							self.SelectionPreviewSet:Add (object)
						end
					)
					
					menuItem:AddEventListener ("MouseLeave",
						function (_)
							if not object or not object:IsValid () then return end
							
							self.SelectionPreviewSet:Remove (object)
						end
					)
				end
			end
			
			-- Collect list of applicable actions
			local applicableActions = {}
			if properties and properties.List then
				for _, actionInfo in pairs (properties.List) do
					for v in self.Selection:GetEnumerator () do
						if actionInfo:Filter (v, LocalPlayer ()) and
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
			if self.ContextMenu:GetItemCount () > 0 and
			   #applicableActions > 0 then
				self.ContextMenu:AddSeparator ()
			end
			
			-- Create action menu items
			local toggleSpacerCreated = false
			for _, actionInfo in ipairs (applicableActions) do
				if actionInfo.Type == "toggle" and not toggleSpacerCreated then
					toggleSpacerCreated = true
					self.ContextMenu:AddSeparator ()
				elseif actionInfo.PrependSpacer then
					self.ContextMenu:AddSeparator ()
				end
				
				local text = actionInfo.MenuLabel
				
				if string.sub (text, 1, 1) == "#" then
					text = language.GetPhrase (string.sub (text, 2))
				end
				
				local menuItem = self.ContextMenu:AddItem (text,
					function ()
						for v in self.Selection:GetEnumerator () do
							if v:IsValid () and actionInfo:Filter (v, LocalPlayer ()) then
								actionInfo:Action (v)
							end
						end
					end
				)
				
				if actionInfo.MenuIcon then
					menuItem:SetIcon (actionInfo.MenuIcon)
				end
				
				if actionInfo.Type == "toggle" then
					local checked = false
					
					for v in self.Selection:GetEnumerator () do
						if actionInfo:Checked (v, LocalPlayer ()) then
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
	
	local fillColor = GLib.Color.FromColor (GLib.Colors.CornflowerBlue, 128)
	hook.Add ("HUDPaint", "GCAD.ContextMenu",
		function ()
			if self.MouseDown then
				-- Box selection rectangle
				local x1 = math.min (self.MouseDownX, self.MouseMoveX)
				local x2 = math.max (self.MouseDownX, self.MouseMoveX)
				local y1 = math.min (self.MouseDownY, self.MouseMoveY)
				local y2 = math.max (self.MouseDownY, self.MouseMoveY)
				surface.SetDrawColor (fillColor)
				surface.DrawRect (x1, y1, x2 - x1, y2 - y1)
				surface.SetDrawColor (GLib.Colors.CornflowerBlue)
				surface.DrawOutlinedRect (x1, y1, x2 - x1, y2 - y1)
			end
		end
	)
	
	local obb = GCAD.OBB3d ()
	local v1 = Vector ()
	local v2 = Vector ()
	
	local lastQueryFrame = nil
	
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.ContextMenu",
		function ()
			if self.MouseDown then
				local x1 = math.min (self.MouseDownX, self.MouseMoveX)
				local x2 = math.max (self.MouseDownX, self.MouseMoveX)
				local y1 = math.min (self.MouseDownY, self.MouseMoveY)
				local y2 = math.max (self.MouseDownY, self.MouseMoveY)
				
				if FrameNumber () ~= lastQueryFrame then
					lastQueryFrame = FrameNumber ()
					
					self.TemporarySelectionSet:Clear ()
					
					if x1 == x2 and y1 == y2 then
						GCAD.Profiler:Begin ("TraceRay")
						local lineTraceResult = self:TraceRay (x1, y1)
						self.TemporarySelectionSet:AddRange (lineTraceResult)
						GCAD.Profiler:End ()
					else
						GCAD.Profiler:Begin ("FindInFrustum")
						local spatialQueryResult = self:FindInFrustum (x1, y1, x2, y2)
						self.TemporarySelectionSet:AddRange (spatialQueryResult)
						GCAD.Profiler:End ()
					end
					self.TemporarySelectionSet:Remove (SERVER and game.GetWorld () or Entity (0))
					
					local temporarySelectionSet = self.Selection:GetModifyingSet ()
					self.Selection:SetModifyingSet (self.TemporarySelectionSet)
					self.TemporarySelectionSet = temporarySelectionSet
					self.TemporarySelectionSet:Clear ()
				end
			end
			
			if self.Selection:IsEmpty () and
			   self.SelectionPreviewSet:IsEmpty () then
				return
			end
			
			self.SelectionRenderer:Render ()
		end
	)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.ContextMenuEventHandler",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	if self.ContextMenu then
		self.ContextMenu:dtor ()
		self.ContextMenu = nil
	end
	
	self:SetMouseEventSource (nil)
	
	hook.Remove ("HUDPaint", "GCAD.ContextMenu")
	hook.Remove ("PreDrawOpaqueRenderables",       "GCAD.ContextMenu")
	hook.Remove ("PostDrawOpaqueRenderables",      "GCAD.ContextMenu")
	hook.Remove ("PreDrawTranslucentRenderables",  "GCAD.ContextMenu")
	hook.Remove ("PostDrawTranslucentRenderables", "GCAD.ContextMenu")
	hook.Remove ("PreDrawViewModel",               "GCAD.ContextMenu")
	hook.Remove ("PostDrawViewModel",              "GCAD.ContextMenu")
	
	GCAD:RemoveEventListener ("Unloaded", "GCAD.ContextMenuEventHandler")
end

function self:OnMouseEnter ()
end

function self:OnMouseLeave ()
	self.MouseDown = false
	
	self.Selection:EndSelection ()
end

function self:OnMouseMove (mouseCode, mouseX, mouseY)
	self.MouseMoveX = mouseX
	self.MouseMoveY = mouseY
end

function self:OnMouseDown (mouseCode, mouseX, mouseY)
	local shift   = input.IsKeyDown (KEY_LSHIFT)
	local control = input.IsKeyDown (KEY_LCONTROL)
	
	local lineTraceResult = self:TraceRay (mouseX, mouseY)
	
	if mouseCode == MOUSE_LEFT then
		self.MouseDown = true
		
		self.MouseDownX = mouseX
		self.MouseDownY = mouseY
		self.MouseMoveX = self.MouseDownX
		self.MouseMoveY = self.MouseDownY
		
		local selectionType
		if     shift   then selectionType = GCAD.UI.SelectionType.Add
		elseif control then selectionType = GCAD.UI.SelectionType.Toggle
		else                selectionType = GCAD.UI.SelectionType.New    end
		
		self.Selection:BeginSelection (selectionType)
		
		self.Selection:GetModifyingSet ():Clear ()
		for object in lineTraceResult:GetEnumerator () do
			if object:GetClass () == "worldspawn" then break end
			self.Selection:GetModifyingSet ():Add (object)
			break
		end
	elseif mouseCode == MOUSE_RIGHT then
		local showMenu = false
		
		for v in lineTraceResult:GetIntersectionEnumerator () do
			if self.Selection:Contains (v) then
				showMenu = true
				break
			end
		end
		
		if not showMenu and lineTraceResult:GetIntersectionCount () > 0 then
			-- Set the selection
			self.Selection:Clear ()
			self.SelectionTemporary = true
			
			for object in lineTraceResult:GetEnumerator () do
				if object:GetClass () == "worldspawn" then break end
				self.Selection:Add (object)
				break
			end
			
			showMenu = true
		end
		
		if showMenu then
			self.ContextMenu:Show ()
		end
	end
end

function self:OnMouseUp (mouseCode, mouseX, mouseY)
	if mouseCode == MOUSE_LEFT then
		self.MouseDown = false
		
		self.Selection:EndSelection ()
	end
end

-- Internal, do not call
local frustum3d = GCAD.Frustum3d ()
local spatialQueryResult = GCAD.SpatialQueryResult ()
function self:FindInFrustum (x1, y1, x2, y2, out)
	out = out or spatialQueryResult
	
	frustum3d = GCAD.Frustum3d.FromScreenAABB (x1, y1, x2, y2, frustum3d)
	
	out:Clear ()
	out = GCAD.EngineEntitiesSpatialQueryable:FindIntersectingFrustum (frustum3d, out)
	
	return out
end

local line3d = GCAD.Line3d ()
local lineTraceResult = GCAD.LineTraceResult ()
function self:TraceRay (x, y, out)
	out = out or lineTraceResult
	
	line3d = GCAD.Line3d.FromPositionAndDirection (LocalPlayer ():EyePos (), gui.ScreenToVector (x, y), line3d)
	
	out:Clear ()
	out:SetMinimumParameter (0)
	out = GCAD.EngineEntitiesSpatialQueryable:TraceLine (line3d, out)
	
	return out
end

GCAD.UI.ContextMenuEventHandler = GCAD.UI.ContextMenuEventHandler ()
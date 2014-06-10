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
	
	self.ContextMenu = GCAD.UI.ContextMenuContextMenu (self)
	
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
						GCAD.Profiler:Begin ("GCAD.ContextMenu : TraceRay")
						
						-- Add everything up to and excluding the world to the selection modifier set
						local lineTraceResult = self:TraceRay (x1, y1)
						for object in lineTraceResult:GetEnumerator () do
							if object:Is (GCAD.Components.EntityReference) and
							   object:GetEntity ():GetClass () == "worldspawn" then break end
							self.TemporarySelectionSet:Add (object)
							break
						end
						
						GCAD.Profiler:End ()
					else
						GCAD.Profiler:Begin ("GCAD.ContextMenu : FindInFrustum")
						
						-- Add everything except the world to the selection modifier set
						local spatialQueryResult = self:FindInFrustum (x1, y1, x2, y2)
						for object in spatialQueryResult:GetEnumerator () do
							if not object:Is (GCAD.Components.EntityReference) or
							   object:GetEntity ():GetClass () ~= "worldspawn" then
								self.TemporarySelectionSet:Add (object)
							end
						end
						
						GCAD.Profiler:End ()
					end
					
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
	hook.Add ("PreDrawOpaqueRenderables",       "GCAD.ContextMenu")
	hook.Add ("PostDrawOpaqueRenderables",      "GCAD.ContextMenu")
	hook.Add ("PreDrawTranslucentRenderables",  "GCAD.ContextMenu")
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.ContextMenu")
	hook.Add ("PreDrawViewModel",               "GCAD.ContextMenu")
	hook.Add ("PostDrawViewModel",              "GCAD.ContextMenu")
	
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
			if object:Is (GCAD.Components.EntityReference) and
			   object:GetEntity ():GetClass () == "worldspawn" then break end
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
				if object:Is (GCAD.Components.EntityReference) and
				   object:GetEntity ():GetClass () == "worldspawn" then break end
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
	out = GCAD.AggregateSpatialQueryable:FindIntersectingFrustum (frustum3d, out)
	
	return out
end

local line3d = GCAD.Line3d ()
local lineTraceResult = GCAD.LineTraceResult ()
function self:TraceRay (x, y, out)
	out = out or lineTraceResult
	
	line3d = GCAD.Line3d.FromPositionAndDirection (LocalPlayer ():EyePos (), gui.ScreenToVector (x, y), line3d)
	
	out:Clear ()
	out:SetMinimumParameter (0)
	out = GCAD.AggregateSpatialQueryable:TraceLine (line3d, out)
	
	return out
end

GCAD.UI.ContextMenuEventHandler = GCAD.UI.ContextMenuEventHandler ()
local self = {}
GCAD.UI.ContextMenuEventHandler = GCAD.MakeConstructor (self, GCAD.UI.IMouseEventSink)

function self:ctor ()
	self:SetMouseEventSource (GCAD.UI.ContextMenuEventSource)
	
	self.Selection = GCAD.UI.Selection ()
	GCAD.UI.EventedCollectionCuller (self.Selection)
	self.SelectionTemporary = false
	
	-- Hacky setting of _G._0
	self.Selection:AddEventListener ("Changed",
		function ()
			if self.Selection:GetCount () == 0 then
				_G._0 = nil
			elseif self.Selection:GetCount () == 1 then
				local item = self.Selection:GetEnumerator () ()
				if item then
					_G._0 = item.Part or item.Entity or item
				else
					_G._0 = nil
				end
			else
				_G._0 = {}
				for item in self.Selection:GetEnumerator () do
					_G._0 [#_G._0 + 1] = item.Part or item.Entity or item
				end
			end
		end
	)
	
	self.TemporarySelectionSet = GLib.Containers.EventedSet ()
	self.SelectionPreviewSet   = GLib.Containers.EventedSet ()
	
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
	
	local lastQueryFrameId = nil
	local viewRenderInfo = GCAD.ViewRenderInfo ()
	hook.Add ("RenderScene", "GCAD.ContextMenu",
		function ()
			if self.MouseDown then
				viewRenderInfo = GCAD.ViewRenderInfo.FromCurrentScene ()
				
				local x1 = math.min (self.MouseDownX, self.MouseMoveX)
				local x2 = math.max (self.MouseDownX, self.MouseMoveX)
				local y1 = math.min (self.MouseDownY, self.MouseMoveY)
				local y2 = math.max (self.MouseDownY, self.MouseMoveY)
				
				if viewRenderInfo:GetFrameId () ~= lastQueryFrameId then
					lastQueryFrameId = viewRenderInfo:GetFrameId ()
					
					-- Change the selection's modifying set
					self.TemporarySelectionSet:Clear ()
					
					if x1 == x2 and y1 == y2 then
						-- Add everything up to and excluding the world to the selection modifier set
						local lineTraceResult = self:TraceRay (x1, y1)
						
						for object in lineTraceResult:GetEnumerator () do
							if object:Is (GCAD.VEntities.EntityReference) and
							   object:GetEntity ():GetClass () == "worldspawn" then break end
							self.TemporarySelectionSet:Add (object)
							break
						end
					else
						-- Add everything except the world to the selection modifier set
						local spatialQueryResult = self:FindInFrustum (x1, y1, x2, y2)
						for object in spatialQueryResult:GetEnumerator () do
							if not object:Is (GCAD.VEntities.EntityReference) or
							   object:GetEntity ():GetClass () ~= "worldspawn" then
								self.TemporarySelectionSet:Add (object)
							end
						end
					end
					
					local temporarySelectionSet = self.Selection:GetModifyingSet ()
					self.Selection:SetModifyingSet (self.TemporarySelectionSet)
					self.TemporarySelectionSet = temporarySelectionSet
					self.TemporarySelectionSet:Clear ()
				end
			end
		end
	)
	
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.ContextMenu",
		function (isDepthRender, isSkyboxRender)
			if self.Selection:IsEmpty () and
			   self.SelectionPreviewSet:IsEmpty () then
				return
			end
			
			viewRenderInfo = GCAD.ViewRenderInfo.FromDrawRenderablesHook (isDepthRender, isSkyboxRender, viewRenderInfo)
			
			self.SelectionRenderer:Render (viewRenderInfo)
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
	
	hook.Remove ("HUDPaint",    "GCAD.ContextMenu")
	hook.Remove ("RenderScene", "GCAD.ContextMenu")
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
			if object:Is (GCAD.VEntities.EntityReference) and
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
				if object:Is (GCAD.VEntities.EntityReference) and
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
	
	line3d = GCAD.Line3d.FromPositionAndDirection (GCAD.ViewRenderInfo.CurrentViewRender:GetCameraPositionNative (), gui.ScreenToVector (x, y), line3d)
	
	out:Clear ()
	out:SetMinimumParameter (0)
	out = GCAD.AggregateSpatialQueryable:TraceLine (line3d, out)
	
	print ("")
	print ("TRACE:")
	for object, t in out:GetEnumerator () do
		local desc = object:GetDisplayString ()
		print ("", t, desc)
	end
	
	return out
end

GCAD.UI.ContextMenuEventHandler = GCAD.UI.ContextMenuEventHandler ()
local self = {}
GCAD.ContextMenu = GCAD.MakeConstructor (self)

local entsGetAllTime = 0
local frustumIntersectsSphereTime = 0
local frustumContainsAnyVertexTime = 0

function self:ctor ()
	self.Control = nil
	
	self.MouseDown = false
	self.MouseDownX = nil
	self.MouseDownY = nil
	self.MouseMoveX = nil
	self.MouseMoveY = nil
	
	self.SelectedEntities  = {}
	self.SelectedEntitySet = {}
	
	self.ContextMenu = Gooey.Menu ()
	self.ContextMenu:AddEventListener ("MenuOpening",
		function (_)
			self.ContextMenu:Clear ()
			
			local applicableActions = {}
			if properties and properties.List then
				for _, actionInfo in pairs (properties.List) do
					for _, v in ipairs (self.SelectedEntities) do
						if actionInfo:Filter (v, LocalPlayer ()) and
						   not actionInfo.MenuOpen then
							applicableActions [#applicableActions + 1] = actionInfo
							break
						end
					end
				end
			end
			
			table.sort (applicableActions,
				function (a, b)
					if a.Type == "toggle" and b.Type ~= "toggle" then return false end
					if a.Type ~= "toggle" and b.Type == "toggle" then return true  end
					
					if a.Order ~= b.Order then return a.Order < b.Order end
					return a.MenuLabel < b.MenuLabel
				end
			)
			
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
						for _, v in ipairs (self.SelectedEntities) do
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
					
					for _, v in ipairs (self.SelectedEntities) do
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
	
	self:SetControl (g_ContextMenu)
	
	hook.Add ("OnContextMenuOpen", "GCAD.ContextMenu",
		function ()
			self:SetControl (g_ContextMenu)
		end
	)
	
	hook.Add ("OnContextMenuClose", "GCAD.ContextMenu",
		function ()
			self.MouseDown = false
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
	local results = {}
	local Entity_IsValid = debug.getregistry ().Entity.IsValid
	local whiteMaterial = Material ("debug/debugtranslucentvertexcolor")
	local selectionOutlineColor = GLib.Colors.CornflowerBlue
	local selectionColor        = GLib.Color.FromColor (GLib.Colors.CornflowerBlue, 64)
	
	local axesMesh = Mesh ()
	mesh.Begin (axesMesh, MATERIAL_LINES, 3)
		mesh.Position (Vector (0, 0, 0)) mesh.Color (255,   0,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (8, 0, 0)) mesh.Color (255,   0,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 0, 0)) mesh.Color (  0, 255,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 8, 0)) mesh.Color (  0, 255,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 0, 0)) mesh.Color (  0,   0, 255, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 0, 8)) mesh.Color (  0,   0, 255, 255) mesh.AdvanceVertex ()
	mesh.End ()
	
	local matrix = Matrix ()
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.ContextMenu",
		function ()
			if self.MouseDown then
				local x1 = math.min (self.MouseDownX, self.MouseMoveX)
				local x2 = math.max (self.MouseDownX, self.MouseMoveX)
				local y1 = math.min (self.MouseDownY, self.MouseMoveY)
				local y2 = math.max (self.MouseDownY, self.MouseMoveY)
				
				if FrameNumber () ~= lastQueryFrame then
					lastQueryFrame = FrameNumber ()
					
					GCAD.Profiler:Begin ("FindInFrustum")
					self:SetSelection (self:FindInFrustum (x1, y1, x2, y2))
					GCAD.Profiler:End ()
				end
			end
			
			if not next (self.SelectedEntities) then return end
			
			GCAD.Profiler:Begin ("OBB rendering")
			render.SetMaterial (whiteMaterial)
			for _, v in ipairs (self.SelectedEntities) do
				if Entity_IsValid (v) then
					local pos = v:GetPos ()
					local ang = v:GetAngles ()
					
					-- obb = GCAD.OBB3d.FromEntity (v, obb)
					-- 
					-- for v1, v2 in obb:GetEdgeEnumerator (v1, v2) do
					-- 	render.DrawLine (v1, v2, GLib.Colors.White, true)
					-- end
					
					-- Local coordinate axes
					local renderType = 1
					if renderType == 0 then
						local mesh_AdvanceVertex = mesh.AdvanceVertex
						local mesh_Color         = mesh.Color
						local mesh_Position      = mesh.Position
						cam.IgnoreZ (true)
						mesh.Begin (MATERIAL_LINES, 3)
							mesh_Position (pos)                      mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
							mesh_Position (pos + ang:Forward () * 8) mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
							mesh_Position (pos)                      mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
							mesh_Position (pos - ang:Right   () * 8) mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
							mesh_Position (pos)                      mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
							mesh_Position (pos + ang:Up      () * 8) mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
						mesh.End ()
						cam.IgnoreZ (false)
					elseif renderType == 1 then
						render.DrawLine (pos, pos + ang:Forward () * 8, GLib.Colors.Red  )
						render.DrawLine (pos, pos - ang:Right   () * 8, GLib.Colors.Green)
						render.DrawLine (pos, pos + ang:Up      () * 8, GLib.Colors.Blue )
					elseif renderType == 2 then
						matrix:Identity ()
						matrix:Translate (pos)
						matrix:Rotate (ang)
						cam.IgnoreZ (true)
						cam.PushModelMatrix (matrix)
						axesMesh:Draw ()
						cam.PopModelMatrix ()
						cam.IgnoreZ (false)
					end
					
					-- OBB
					local obbMins = v:OBBMins ()
					local obbMaxs = v:OBBMaxs ()
					render.DrawWireframeBox (pos, ang, obbMins, obbMaxs, selectionOutlineColor, true)
					render.DrawBox          (pos, ang, obbMins, obbMaxs, selectionColor,        true)
				end
			end
			GCAD.Profiler:End ()
		end
	)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.ContextMenu",
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
	
	self:SetControl (nil)
	
	hook.Remove ("OnContextMenuOpen",  "GCAD.ContextMenu")
	hook.Remove ("OnContextMenuClose", "GCAD.ContextMenu")
	
	hook.Remove ("HUDPaint", "GCAD.ContextMenu")
	hook.Add ("PreDrawOpaqueRenderables",       "GCAD.ContextMenu")
	hook.Add ("PostDrawOpaqueRenderables",      "GCAD.ContextMenu")
	hook.Add ("PreDrawTranslucentRenderables",  "GCAD.ContextMenu")
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.ContextMenu")
	hook.Add ("PreDrawViewModel",               "GCAD.ContextMenu")
	hook.Add ("PostDrawViewModel",              "GCAD.ContextMenu")
	
	GCAD:RemoveEventListener ("Unloaded", "GCAD.ContextMenu")
end

function self:GetControl ()
	return self.Control
end

-- Intenral, do not call
local frustum3d = GCAD.Frustum3d ()
local spatialQueryResults = GCAD.SpatialQueryResult ()

function self:FindInFrustum (x1, y1, x2, y2, out)
	out = out or {}
	
	if x1 == x2 and y1 == y2 then
		local trace = util.QuickTrace (LocalPlayer ():EyePos (), gui.ScreenToVector (x1, y1) * math.sqrt (3 * 32768 * 32768))
		if trace.Entity and trace.Entity:IsValid () then
			out [#out + 1] = trace.Entity
		end
		return out
	end
	
	local localPlayer = LocalPlayer ()
	
	frustum3d = GCAD.Frustum3d.FromScreenAABB (x1, y1, x2, y2)
	
	spatialQueryResults:Clear ()
	spatialQueryResults = GCAD.EngineEntitiesSpatialQueryable:FindIntersectingFrustum (frustum3d, spatialQueryResults)
	return spatialQueryResults:ToArray (out)
end

function self:SetControl (control)
	if self.Control == control then return self end
	
	if self.Control then
		self.Control:SetWorldClicker (true)
		for _, child in ipairs (self.Control:GetChildren ()) do
			if child.ClassName == "DIconLayout" then
				self.Control.Canvas:SetWorldClicker (true)
			end
		end
		
		self.Control.OnCursorMoved   = self.Control._OnCursorMoved
		self.Control.OnMousePressed  = self.Control._OnMousePressed
		self.Control.OnMouseReleased = self.Control._OnMouseReleased
	end
	
	self.Control = control
	
	if self.Control then
		self.Control:SetWorldClicker (false)
		self.Control.Canvas:SetWorldClicker (false)
		for _, child in ipairs (self.Control:GetChildren ()) do
			if child.ClassName == "DIconLayout" then
				child:SetWorldClicker (false)
			end
		end
		
		self.Control._OnCursorMoved   = self.Control._OnCursorMoved   or self.Control.OnCursorMoved
		self.Control._OnMousePressed  = self.Control._OnMousePressed  or self.Control.OnMousePressed
		self.Control._OnMouseReleased = self.Control._OnMouseReleased or self.Control.OnMouseReleased
		
		self.Control.OnCursorMoved = function (_, x, y)
			self.MouseMoveX = x
			self.MouseMoveY = y
		end
		
		self.Control.OnMousePressed = function (_, mouseCode)
			if mouseCode == MOUSE_LEFT then
				self.Control:MouseCapture (true)
				self.MouseDown = true
				
				local x, y = self.Control:CursorPos ()
				self.MouseDownX = x
				self.MouseDownY = y
			elseif mouseCode == MOUSE_RIGHT then
				local x, y = self.Control:CursorPos ()
				
				local entities = self:FindInFrustum (x, y, x, y)
				local showMenu = false
				for _, v in ipairs (entities) do
					if self.SelectedEntitySet [v] then
						showMenu = true
						break
					end
				end
				
				if not showMenu and #entities > 0 then
					self:SetSelection (entities)
					showMenu = true
				end
				
				if showMenu then
					self.ContextMenu:Show ()
				end
			end
		end
		
		self.Control.OnMouseReleased = function (_, mouseCode)
			if mouseCode == MOUSE_LEFT then
				self.Control:MouseCapture (false)
				self.MouseDown = false
			end
		end
	end
	
	return self
end

function self:SetSelection (selectedEntities)
	self.SelectedEntities = selectedEntities
	self.SelectedEntitySet = {}
	for _, v in ipairs (self.SelectedEntities) do
		self.SelectedEntitySet [v] = true
	end
end

GCAD.ContextMenu = GCAD.ContextMenu ()
local self = {}
GCAD.UI.SelectionRenderer = GCAD.MakeConstructor (self)

local Entity_IsValid = debug.getregistry ().Entity.IsValid

function self:ctor (selection)
	self.Selection = selection
	self.SelectionPreview = nil
	
	self.SelectionOutlineColor        = GLib.Colors.CornflowerBlue
	self.SelectionColor               = GLib.Color.FromColor (self.SelectionOutlineColor,        64)
	self.SelectionPreviewOutlineColor = GLib.Colors.Orange
	self.SelectionPreviewColor        = GLib.Color.FromColor (self.SelectionPreviewOutlineColor, 64)
	
	self.WhiteMaterial = Material ("debug/debugtranslucentvertexcolor")
	self.AxesMesh = Mesh ()
	mesh.Begin (axesMesh, MATERIAL_LINES, 3)
		mesh.Position (Vector (0, 0, 0)) mesh.Color (255,   0,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (8, 0, 0)) mesh.Color (255,   0,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 0, 0)) mesh.Color (  0, 255,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 8, 0)) mesh.Color (  0, 255,   0, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 0, 0)) mesh.Color (  0,   0, 255, 255) mesh.AdvanceVertex ()
		mesh.Position (Vector (0, 0, 8)) mesh.Color (  0,   0, 255, 255) mesh.AdvanceVertex ()
	mesh.End ()
end

function self:dtor ()
	self:SetSelection (nil)
	
	if self.AxesMesh then
		self.AxesMesh:Destroy ()
		self.AxesMesh = nil
	end
end

function self:GetSelection ()
	return self.Selection
end

function self:GetSelectionPreview ()
	return self.SelectionPreview
end

function self:SetSelection (selection)
	if self.Selection == selection then return self end
	
	self.Selection = selection
	
	return self
end

function self:SetSelectionPreview (selectionPreview)
	if self.SelectionPreview == selectionPreview then return self end
	
	self.SelectionPreview = selectionPreview
	
	return self
end

local matrix = Matrix ()
function self:Render ()
	GCAD.Profiler:Begin ("SelectionRenderer:Render")
	
	render.SetMaterial (self.WhiteMaterial)
	
	for object in self.Selection:GetEnumerator () do
		if Entity_IsValid (object) then
			self:DrawEntitySelection (object, self.SelectionOutlineColor, self.SelectionColor)
		end
	end
	
	if self.SelectionPreview then
		for object in self.SelectionPreview:GetEnumerator () do
			if Entity_IsValid (object) then
				self:DrawEntitySelection (object, self.SelectionPreviewOutlineColor, self.SelectionPreviewColor)
			end
		end
	end
	
	GCAD.Profiler:End ()
end

-- Internal, do not call
function self:DrawEntitySelection (entity, selectionOutlineColor, selectionColor)
	if not Entity_IsValid (entity) then return end
	
	local pos = entity:GetPos ()
	local ang = entity:GetAngles ()
	
	-- obb = GCAD.OBB3d.FromEntity (entity, obb)
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
		self.AxesMesh:Draw ()
		cam.PopModelMatrix ()
		cam.IgnoreZ (false)
	end
	
	-- OBB
	local obbMins = entity:OBBMins ()
	local obbMaxs = entity:OBBMaxs ()
	render.DrawWireframeBox (pos, ang, obbMins, obbMaxs, selectionOutlineColor, true)
	render.DrawBox          (pos, ang, obbMins, obbMaxs, selectionColor,        true)
end
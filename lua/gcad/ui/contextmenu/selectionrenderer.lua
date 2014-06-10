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
	mesh.Begin (self.AxesMesh, MATERIAL_LINES, 3)
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
	render.SetMaterial (self.WhiteMaterial)
	
	if false then
		for object in self.Selection:GetEnumerator () do
			self:DrawComponentSelection (object, self.SelectionOutlineColor, self.SelectionColor)
		end
	else
		self:DrawComponentSelections (self.Selection, self.SelectionOutlineColor, self.SelectionColor)
	end
	
	if self.SelectionPreview then
		for object in self.SelectionPreview:GetEnumerator () do
			self:DrawComponentSelection (object, self.SelectionPreviewOutlineColor, self.SelectionPreviewColor)
		end
	end
end
self.Render = GCAD.Profiler:Wrap (self.Render, "SelectionRenderer:Render")

-- Internal, do not call
local pos     = Vector ()
local obbMins = Vector ()
local obbMaxs = Vector ()
local angle   = Angle ()
local nativeOBB3d = GCAD.NativeOBB3d ()

local cam_IgnoreZ         = cam.IgnoreZ
local cam_PushModelMatrix = cam.PushModelMatrix
local cam_PopModelMatrix  = cam.PopModelMatrix
local mesh_AdvanceVertex  = mesh.AdvanceVertex
local mesh_Begin          = mesh.Begin
local mesh_Color          = mesh.Color
local mesh_End            = mesh.End
local mesh_Position       = mesh.Position
local render_DrawLine     = render.DrawLine

local Angle_Forward       = debug.getregistry ().Angle.Forward
local Angle_Right         = debug.getregistry ().Angle.Right
local Angle_Up            = debug.getregistry ().Angle.Up
local IMesh_Draw          = debug.getregistry ().IMesh.Draw
local Vector___add        = debug.getregistry ().Vector.__add
local Vector___mul        = debug.getregistry ().Vector.__mul
local Vector___sub        = debug.getregistry ().Vector.__sub
local Vector___unm        = debug.getregistry ().Vector.__unm
local VMatrix_Identity    = debug.getregistry ().VMatrix.Identity
local VMatrix_Rotate      = debug.getregistry ().VMatrix.Rotate
local VMatrix_Translate   = debug.getregistry ().VMatrix.Translate

local MATERIAL_LINES      = MATERIAL_LINES

-- cam_IgnoreZ         = GCAD.Profiler:Wrap (cam_IgnoreZ,         "cam.IgnoreZ"        )
-- cam_PushModelMatrix = GCAD.Profiler:Wrap (cam_PushModelMatrix, "cam.PushModelMatrix")
-- cam_PopModelMatrix  = GCAD.Profiler:Wrap (cam_PopModelMatrix,  "cam.PopModelMatrix" )
-- mesh_Begin          = GCAD.Profiler:Wrap (mesh_Begin,          "mesh.Begin"         )
-- mesh_End            = GCAD.Profiler:Wrap (mesh_End,            "mesh.End"           )
-- IMesh_Draw          = GCAD.Profiler:Wrap (IMesh_Draw,          "IMesh:Draw"         )

local components              = GLib.WeakValueTable ()
local componentSpatialNode3ds = GLib.WeakValueTable ()
local componentNativeOBB3ds   = GLib.WeakValueTable ()
local componentCount = 0
function self:DrawComponentSelections (componentEnumerable, selectionOutlineColor, selectionColor)
	-- Filter down to ISpatialNode3d components.
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Filter to ISpatialNode3ds")
	componentCount = 0
	for component in componentEnumerable:GetEnumerator () do
		if component and
		   component:IsValid () then
			local spatialNode3d = component:GetSpatialNode3d ()
			if spatialNode3d then
				componentCount = componentCount + 1
				components              [componentCount] = component
				componentSpatialNode3ds [componentCount] = spatialNode3d
			end
		end
	end
	GCAD.Profiler:End ()
	
	-- Compute OBBs
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Compute OBBs")
	for i = 1, componentCount do
		local component = components [i]
		if component:Is (GCAD.Components.EntityReference) then
			componentNativeOBB3ds [i] = GCAD.NativeOBB3d.FromEntity (component:GetEntity (), componentNativeOBB3ds [i])
		else
			local obb3d = componentSpatialNode3ds [i]:GetOBB ()
			componentNativeOBB3ds [i] = obb3d:ToNativeOBB3d (componentNativeOBB3ds [i])
		end
	end
	GCAD.Profiler:End ()
	
	-- Local coordinate axes
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw axes")
	local renderType = 0 -- Best rendering times for large numbers of objects
	if renderType == 0 then
		cam_IgnoreZ (true)
		for i = 1, componentCount do
			local nativeOBB3d = componentNativeOBB3ds [i]
			local pos   = nativeOBB3d.Position
			local angle = nativeOBB3d.Angle
			mesh_Begin (MATERIAL_LINES, 3)
				mesh_Position (pos)                                                         mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
				mesh_Position (Vector___add (pos, Vector___mul (Angle_Forward (angle), 8))) mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
				mesh_Position (pos)                                                         mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
				mesh_Position (Vector___sub (pos, Vector___mul (Angle_Right   (angle), 8))) mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
				mesh_Position (pos)                                                         mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
				mesh_Position (Vector___add (pos, Vector___mul (Angle_Up      (angle), 8))) mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
			mesh_End ()
		end
		cam_IgnoreZ (false)
	elseif renderType == 1 then
		for i = 1, componentCount do
			local nativeOBB3d = componentNativeOBB3ds [i]
			local pos   = nativeOBB3d.Position
			local angle = nativeOBB3d.Angle
			render_DrawLine (pos, Vector___add (pos, Vector___mul (Angle_Forward (angle), 8)), GLib.Colors.Red  )
			render_DrawLine (pos, Vector___sub (pos, Vector___mul (Angle_Right   (angle), 8)), GLib.Colors.Green)
			render_DrawLine (pos, Vector___add (pos, Vector___mul (Angle_Up      (angle), 8)), GLib.Colors.Blue )
		end
	elseif renderType == 2 then
		cam_IgnoreZ (true)
		for i = 1, componentCount do
			local nativeOBB3d = componentNativeOBB3ds [i]
			local pos   = nativeOBB3d.Position
			local angle = nativeOBB3d.Angle
			-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Compute matrix")
			VMatrix_Identity (matrix)
			VMatrix_Translate (matrix, pos)
			VMatrix_Rotate (matrix, angle)
			-- GCAD.Profiler:End ()
			cam_PushModelMatrix (matrix)
			IMesh_Draw (self.AxesMesh)
			cam_PopModelMatrix ()
		end
		cam_IgnoreZ (false)
	end
	GCAD.Profiler:End ()
	
	-- OBBs
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw OBBs")
	for i = 1, componentCount do
		local nativeOBB3d = componentNativeOBB3ds [i]
		render.DrawWireframeBox (nativeOBB3d.Position, nativeOBB3d.Angle, nativeOBB3d.Min, nativeOBB3d.Max, selectionOutlineColor, true)
		render.DrawBox          (nativeOBB3d.Position, nativeOBB3d.Angle, nativeOBB3d.Min, nativeOBB3d.Max, selectionColor,        true)
	end
	GCAD.Profiler:End ()
end
self.DrawComponentSelections = GCAD.Profiler:Wrap (self.DrawComponentSelections, "SelectionRenderer:DrawComponentSelections")

function self:DrawComponentSelection (component, selectionOutlineColor, selectionColor)
	if not component then return end
	if not component:IsValid () then return end
	if not component:GetSpatialNode3d () then return end
	
	-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Compute OBB")
	if component:Is (GCAD.Components.EntityReference) then
		nativeOBB3d = GCAD.NativeOBB3d.FromEntity (component:GetEntity (), nativeOBB3d)
	else
		local obb3d = component:GetSpatialNode3d ():GetOBB ()
		nativeOBB3d = obb3d:ToNativeOBB3d (nativeOBB3d)
	end
	local pos     = nativeOBB3d.Position
	local obbMins = nativeOBB3d.Min
	local obbMaxs = nativeOBB3d.Max
	local angle   = nativeOBB3d.Angle
	-- GCAD.Profiler:End ()
	
	-- obb = GCAD.OBB3d.FromEntity (entity, obb)
	-- 
	-- for v1, v2 in obb:GetEdgeEnumerator (v1, v2) do
	-- 	render.DrawLine (v1, v2, GLib.Colors.White, true)
	-- end
	
	-- Local coordinate axes
	local renderType = 0 -- Best rendering times for large numbers of objects
	-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Draw axes")
	if renderType == 0 then
		cam_IgnoreZ (true)
		mesh_Begin (MATERIAL_LINES, 3)
			mesh_Position (pos)                                                         mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
			mesh_Position (Vector___add (pos, Vector___mul (Angle_Forward (angle), 8))) mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
			mesh_Position (pos)                                                         mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
			mesh_Position (Vector___sub (pos, Vector___mul (Angle_Right   (angle), 8))) mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
			mesh_Position (pos)                                                         mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
			mesh_Position (Vector___add (pos, Vector___mul (Angle_Up      (angle), 8))) mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
		mesh_End ()
		cam_IgnoreZ (false)
	elseif renderType == 1 then
		render_DrawLine (pos, Vector___add (pos, Vector___mul (Angle_Forward (angle), 8)), GLib.Colors.Red  )
		render_DrawLine (pos, Vector___sub (pos, Vector___mul (Angle_Right   (angle), 8)), GLib.Colors.Green)
		render_DrawLine (pos, Vector___add (pos, Vector___mul (Angle_Up      (angle), 8)), GLib.Colors.Blue )
	elseif renderType == 2 then
		-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Compute matrix")
		VMatrix_Identity (matrix)
		VMatrix_Translate (matrix, pos)
		VMatrix_Rotate (matrix, angle)
		-- GCAD.Profiler:End ()
		cam_IgnoreZ (true)
		cam_PushModelMatrix (matrix)
		IMesh_Draw (self.AxesMesh)
		cam_PopModelMatrix ()
		cam_IgnoreZ (false)
	end
	-- GCAD.Profiler:End ()
	
	-- OBB
	-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Draw OBB")
	render.DrawWireframeBox (pos, angle, obbMins, obbMaxs, selectionOutlineColor, true)
	render.DrawBox          (pos, angle, obbMins, obbMaxs, selectionColor,        true)
	-- GCAD.Profiler:End ()
end
-- self.DrawComponentSelection = GCAD.Profiler:Wrap (self.DrawComponentSelection, "SelectionRenderer:DrawComponentSelection")
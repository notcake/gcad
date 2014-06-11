local self = {}
GCAD.UI.SelectionRenderer = GCAD.MakeConstructor (self)

local Angle                   = Angle
local LocalToWorld            = LocalToWorld
local Vector                  = Vector

local cam_IgnoreZ             = cam.IgnoreZ
local cam_PushModelMatrix     = cam._PushModelMatrix or cam.PushModelMatrix
local cam_PopModelMatrix      = cam._PopModelMatrix  or cam.PopModelMatrix
local mesh_Begin              = mesh._Begin          or mesh.Begin
local mesh_End                = mesh._End            or mesh.End
local mesh_AdvanceVertex      = mesh.AdvanceVertex
local mesh_Color              = mesh.Color
local mesh_Position           = mesh.Position
local render_DrawBox          = render.DrawBox
local render_DrawWireframeBox = render.DrawWireframeBox
local render_SetMaterial      = render.SetMaterial

local IMaterial_SetFloat      = debug.getregistry ().IMaterial.SetFloat
local IMaterial_SetVector     = debug.getregistry ().IMaterial.SetVector
local IMesh_Draw              = debug.getregistry ().IMesh.Draw
local Vector_Set              = debug.getregistry ().Vector.Set
local Vector_Sub              = debug.getregistry ().Vector.Sub
local VMatrix_Identity        = debug.getregistry ().VMatrix.Identity
local VMatrix_Rotate          = debug.getregistry ().VMatrix.Rotate
local VMatrix_Scale           = debug.getregistry ().VMatrix.Scale
local VMatrix_Translate       = debug.getregistry ().VMatrix.Translate

local MATERIAL_LINES          = MATERIAL_LINES
local MATERIAL_TRIANGLES      = MATERIAL_TRIANGLES

local GLib_Color_ToVector     = GLib.Color.ToVector

-- cam_IgnoreZ         = GCAD.Profiler:Wrap (cam_IgnoreZ,         "cam.IgnoreZ"        )
-- cam_PushModelMatrix = GCAD.Profiler:Wrap (cam_PushModelMatrix, "cam.PushModelMatrix")
-- cam_PopModelMatrix  = GCAD.Profiler:Wrap (cam_PopModelMatrix,  "cam.PopModelMatrix" )
-- IMesh_Draw          = GCAD.Profiler:Wrap (IMesh_Draw,          "IMesh:Draw"         )
-- render_SetMaterial  = GCAD.Profiler:Wrap (render_SetMaterial,  "render.SetMaterial" )

function self:ctor (selection)
	self.Selection = selection
	self.SelectionPreview = nil
	
	self.SelectionOutlineColor        = GLib.Colors.CornflowerBlue
	self.SelectionColor               = GLib.Color.FromColor (self.SelectionOutlineColor,        64)
	self.SelectionPreviewOutlineColor = GLib.Colors.Orange
	self.SelectionPreviewColor        = GLib.Color.FromColor (self.SelectionPreviewOutlineColor, 64)
	
	self.PerVertexColorMaterial = CreateMaterial ("GCAD.VertexColorMaterial", "UnlitGeneric",
		{
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1,
			["$translucent"] = 1
		}
	)
	self.ColorMaterial          = CreateMaterial ("GCAD.SingleColorMaterial", "UnlitGeneric",
		{
			["$translucent"] = 1
		}
	)
	
	self.RenderCache = GCAD.MapCache (
		function ()
			return
			{
				FrameId                        = nil,
				ComponentCount                 = 0,
				Components                     = GLib.WeakValueTable (),
				ComponentSpatialNode3ds        = GLib.WeakValueTable (),
				ComponentNativeOBB3ds          = {}, -- Should not be garbage collected
				ComponentAxesMatrices          = {}, -- Should not be garbage collected
				ComponentOBBMatrices           = {}, -- Should not be garbage collected
				ComponentsFrameId              = nil,
				ComponentSpatialNode3dsFrameId = nil,
				ComponentNativeOBB3dsFrameId   = nil,
				ComponentAxesMatricesFrameId   = nil,
				ComponentOBBMatricesFrameId    = nil
			}
		end
	)
	
	-- Axes mesh
	self.AxesMesh = Mesh ()
	mesh_Begin (self.AxesMesh, MATERIAL_LINES, 3)
		mesh_Position (Vector (0, 0, 0)) mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
		mesh_Position (Vector (8, 0, 0)) mesh_Color (255,   0,   0, 255) mesh_AdvanceVertex ()
		mesh_Position (Vector (0, 0, 0)) mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
		mesh_Position (Vector (0, 8, 0)) mesh_Color (  0, 255,   0, 255) mesh_AdvanceVertex ()
		mesh_Position (Vector (0, 0, 0)) mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (Vector (0, 0, 8)) mesh_Color (  0,   0, 255, 255) mesh_AdvanceVertex ()
	mesh_End ()
	
	-- Box mesh
	local vertices =
	{
		Vector (0, 0, 0),
		Vector (0, 1, 0),
		Vector (1, 1, 0),
		Vector (1, 0, 0),
		Vector (0, 0, 1),
		Vector (0, 1, 1),
		Vector (1, 1, 1),
		Vector (1, 0, 1)
	}
	
	self.BoxMesh = Mesh ()
	mesh_Begin (self.BoxMesh, MATERIAL_TRIANGLES, 12)
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
	mesh_End ()

	self.WireframeBoxMesh = Mesh ()
	mesh_Begin (self.WireframeBoxMesh, MATERIAL_LINES, 12)
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [1]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (255, 255, 255, 255) mesh_AdvanceVertex ()
	mesh_End ()
end

function self:dtor ()
	self:SetSelection (nil)
	
	if self.AxesMesh then
		self.AxesMesh:Destroy ()
		self.AxesMesh = nil
	end
	if self.BoxMesh then
		self.BoxMesh:Destroy ()
		self.BoxMesh = nil
	end
	if self.WireframeBoxMesh then
		self.WireframeBoxMesh:Destroy ()
		self.WireframeBoxMesh = nil
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
	
	self.RenderCache:Flush (self.Selection)
	self.Selection = selection
	
	return self
end

function self:SetSelectionPreview (selectionPreview)
	if self.SelectionPreview == selectionPreview then return self end
	
	self.RenderCache:Flush (self.SelectionPreview)
	self.SelectionPreview = selectionPreview
	
	return self
end

function self:Render (viewRenderInfo)
	self:DrawComponentSelections (viewRenderInfo, self.Selection, self.SelectionOutlineColor, self.SelectionColor)
	
	if self.SelectionPreview and
	   not self.SelectionPreview:IsEmpty () then
		self:DrawComponentSelections (viewRenderInfo, self.SelectionPreview, self.SelectionPreviewOutlineColor, self.SelectionPreviewColor)
	end
end
self.Render = GCAD.Profiler:Wrap (self.Render, "SelectionRenderer:Render")

-- Internal, do not call
local angle_zero = Angle (0, 0, 0)
local v = Vector ()

function self:DrawComponentSelections (viewRenderInfo, componentEnumerable, selectionOutlineColor, selectionColor)
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections [" .. componentEnumerable:GetCount () .. "]")
	
	local currentFrameId = viewRenderInfo:GetFrameId ()
	local renderCache = self.RenderCache:Get (componentEnumerable)
	
	-- Filter down to ISpatialNode3d components.
	if renderCache.ComponentsFrameId ~= currentFrameId or
	   renderCache.ComponentSpatialNode3dsFrameId ~= currentFrameId then
		GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Filter to ISpatialNode3ds")
		local componentCount          = 0
		local components              = renderCache.Components
		local componentSpatialNode3ds = renderCache.ComponentSpatialNode3ds
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
		renderCache.ComponentCount                 = componentCount
		renderCache.ComponentsFrameId              = currentFrameId
		renderCache.ComponentSpatialNode3dsFrameId = currentFrameId
		GCAD.Profiler:End ()
	end
	
	-- Compute OBBs
	if renderCache.ComponentNativeOBB3dsFrameId ~= currentFrameId then
		GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Compute OBBs")
		local componentCount          = renderCache.ComponentCount
		local componentSpatialNode3ds = renderCache.ComponentSpatialNode3ds
		local componentNativeOBB3ds   = renderCache.ComponentNativeOBB3ds
		
		for i = 1, componentCount do
			componentNativeOBB3ds [i] = componentSpatialNode3ds [i]:GetNativeOBB ()
		end
		
		renderCache.ComponentNativeOBB3dsFrameId = currentFrameId
		GCAD.Profiler:End ()
	end
	
	-- Local coordinate axes
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw axes")
	
	-- Axes matrices
	if renderCache.ComponentAxesMatricesFrameId ~= currentFrameId then
		GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Compute axes matrices")
		local componentCount        = renderCache.ComponentCount
		local componentNativeOBB3ds = renderCache.ComponentNativeOBB3ds
		local componentAxesMatrices = renderCache.ComponentAxesMatrices
		
		for i = 1, componentCount do
			local nativeOBB3d = componentNativeOBB3ds [i]
			local matrix = componentAxesMatrices [i] or Matrix ()
			componentAxesMatrices [i] = matrix
			
			VMatrix_Identity  (matrix)
			VMatrix_Translate (matrix, nativeOBB3d.Position)
			VMatrix_Rotate    (matrix, nativeOBB3d.Angle)
		end
		
		renderCache.ComponentAxesMatricesFrameId = currentFrameId
		GCAD.Profiler:End ()
	end
	
	-- Draw axes
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw axes for real")
	local componentCount        = renderCache.ComponentCount
	local componentAxesMatrices = renderCache.ComponentAxesMatrices
	
	local axesMesh = self.AxesMesh
	render_SetMaterial (self.PerVertexColorMaterial)
	cam_IgnoreZ (true)
	for i = 1, componentCount do
		cam_PushModelMatrix (componentAxesMatrices [i])
		IMesh_Draw (axesMesh)
		cam_PopModelMatrix ()
	end
	cam_IgnoreZ (false)
	GCAD.Profiler:End ()
	
	GCAD.Profiler:End ()
	
	-- OBBs
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw OBBs")
	
	-- OBB matrices
	if renderCache.ComponentOBBMatricesFrameId ~= currentFrameId then
		GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Compute OBB matrices")
		local componentCount        = renderCache.ComponentCount
		local componentNativeOBB3ds = renderCache.ComponentNativeOBB3ds
		local componentOBBMatrices  = renderCache.ComponentOBBMatrices
		
		for i = 1, componentCount do
			local nativeOBB3d = componentNativeOBB3ds [i]
			local matrix = componentOBBMatrices [i] or Matrix ()
			componentOBBMatrices [i] = matrix
			
			VMatrix_Identity  (matrix)
			VMatrix_Translate (matrix, LocalToWorld (nativeOBB3d.Min, angle_zero, nativeOBB3d.Position, nativeOBB3d.Angle))
			VMatrix_Rotate    (matrix, nativeOBB3d.Angle)
			
			Vector_Set (v, nativeOBB3d.Max)
			Vector_Sub (v, nativeOBB3d.Min)
			VMatrix_Scale (matrix, v)
		end
		
		renderCache.ComponentOBBMatricesFrameId = currentFrameId
		GCAD.Profiler:End ()
	end
	
	-- Wireframe OBBs
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw wireframe OBBs")
	local componentCount       = renderCache.ComponentCount
	local componentOBBMatrices = renderCache.ComponentOBBMatrices
	
	local wireframeBoxMesh = self.WireframeBoxMesh
	local v, alpha = GLib_Color_ToVector (selectionOutlineColor, v)
	IMaterial_SetVector (self.ColorMaterial, "$color", v    )
	IMaterial_SetFloat  (self.ColorMaterial, "$alpha", alpha)
	render_SetMaterial (self.ColorMaterial)
	
	for i = 1, componentCount do
		cam_PushModelMatrix (componentOBBMatrices [i])
		IMesh_Draw (wireframeBoxMesh)
		cam_PopModelMatrix ()
	end
	
	GCAD.Profiler:End ()
	
	-- Shaded OBBs
	GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelections : Draw solid OBBs")
	local componentCount       = renderCache.ComponentCount
	local componentOBBMatrices = renderCache.ComponentOBBMatrices
	
	local boxMesh = self.BoxMesh
	local v, alpha = GLib_Color_ToVector (selectionColor, v)
	IMaterial_SetVector (self.ColorMaterial, "$color", v    )
	IMaterial_SetFloat  (self.ColorMaterial, "$alpha", alpha)
	render_SetMaterial (self.ColorMaterial)
	
	for i = 1, componentCount do
		cam_PushModelMatrix (componentOBBMatrices [i])
		IMesh_Draw (boxMesh)
		cam_PopModelMatrix ()
	end
	
	GCAD.Profiler:End ()
	
	GCAD.Profiler:End ()
	
	GCAD.Profiler:End ()
end

function self:DrawComponentSelection (viewRenderInfo, component, selectionOutlineColor, selectionColor)
	if not component                     then return end
	if not component:IsValid ()          then return end
	if not component:GetSpatialNode3d () then return end
	
	-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Compute OBB")
	local nativeOBB3d = component:GetSpatialNode3d ():GetNativeOBB ()
	local pos         = nativeOBB3d.Position
	local obbMins     = nativeOBB3d.Min
	local obbMaxs     = nativeOBB3d.Max
	local angle       = nativeOBB3d.Angle
	-- GCAD.Profiler:End ()
	
	-- Local coordinate axes
	-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Draw axes")
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
	-- GCAD.Profiler:End ()
	
	-- OBB
	-- GCAD.Profiler:Begin ("SelectionRenderer:DrawComponentSelection : Draw OBB")
	render.DrawWireframeBox (pos, angle, obbMins, obbMaxs, selectionOutlineColor, true)
	render.DrawBox          (pos, angle, obbMins, obbMaxs, selectionColor,        true)
	-- GCAD.Profiler:End ()
end
-- self.DrawComponentSelection = GCAD.Profiler:Wrap (self.DrawComponentSelection, "SelectionRenderer:DrawComponentSelection")
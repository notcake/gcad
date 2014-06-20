local mesh_Begin              = mesh._Begin          or mesh.Begin
local mesh_End                = mesh._End            or mesh.End
local mesh_AdvanceVertex      = mesh.AdvanceVertex
local mesh_Color              = mesh.Color
local mesh_Position           = mesh.Position

local MATERIAL_LINES          = MATERIAL_LINES
local MATERIAL_TRIANGLES      = MATERIAL_TRIANGLES

function GCAD.Meshes.CreateAxisAlignedCube (min, max, color)
	color = color or GLib.Colors.White
	local r, g, b, a = color.r, color.g, color.b, color.a
	
	local vertices =
	{
		Vector (min, min, min),
		Vector (min, max, min),
		Vector (max, max, min),
		Vector (max, min, min),
		Vector (min, min, max),
		Vector (min, max, max),
		Vector (max, max, max),
		Vector (max, min, max)
	}
	
	local cubeMesh = Mesh ()
	mesh_Begin (cubeMesh, MATERIAL_TRIANGLES, 12)
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
	mesh_End ()
	
	return cubeMesh
end

function GCAD.Meshes.CreateAxisAlignedWireframeCube (min, max, color)
	color = color or GLib.Colors.White
	local r, g, b, a = color.r, color.g, color.b, color.a
	
	local vertices =
	{
		Vector (min, min, min),
		Vector (min, max, min),
		Vector (max, max, min),
		Vector (max, min, min),
		Vector (min, min, max),
		Vector (min, max, max),
		Vector (max, max, max),
		Vector (max, min, max)
	}
	
	local wireframeCubeMesh = Mesh ()
	mesh_Begin (wireframeCubeMesh, MATERIAL_LINES, 12)
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [1]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [2]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [3]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [4]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [6]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [7]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [8]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
		mesh_Position (vertices [5]) mesh_Color (r, g, b, a) mesh_AdvanceVertex ()
	mesh_End ()
	
	return wireframeCubeMesh
end
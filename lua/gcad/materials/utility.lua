if not CLIENT then return end

local v     = Vector ()
local alpha = 0

function GCAD.Materials.CreateVertexColorMaterial (id, color)
	local material = CreateMaterial (id, "UnlitGeneric",
		{
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1,
			["$translucent"] = 1
		}
	)
	
	if color then
		v, alpha = GLib.Color.ToVector (color, v)
		material:SetVector ("$color", v)
		material:SetFloat  ("$alpha", alpha)
	end
	
	return material
end

function GCAD.Materials.CreateColorMaterial (id, color)
	local material = CreateMaterial (id, "UnlitGeneric",
		{
			["$translucent"] = 1
		}
	)
	
	if color then
		v, alpha = GLib.Color.ToVector (color, v)
		material:SetVector ("$color", v)
		material:SetFloat  ("$alpha", alpha)
	end
	
	return material
end

function GCAD.Materials.CreateLitVertexColorMaterial (id, color)
	local material = CreateMaterial (id, "VertexLitGeneric",
		{
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1,
			["$translucent"] = 1
		}
	)
	
	if color then
		v, alpha = GLib.Color.ToVector (color, v)
		material:SetVector ("$color", v)
		material:SetFloat  ("$alpha", alpha)
	end
	
	return material
end

function GCAD.Materials.CreateLitColorMaterial (id, color)
	local material = CreateMaterial (id, "VertexLitGeneric",
		{
			["$translucent"] = 1
		}
	)
	
	if color then
		v, alpha = GLib.Color.ToVector (color, v)
		material:SetVector ("$color", v)
		material:SetFloat  ("$alpha", alpha)
	end
	
	return material
end
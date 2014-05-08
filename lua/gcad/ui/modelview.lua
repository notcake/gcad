local self = {}
local defaultMaterial     = Material ("models/debug/debugwhite")
local vertexColorMaterial = Material ("debug/debugvertexcolor")
local wireframeMaterial   = Material ("models/wireframe")

function self:Init ()
	self.DirectionalLight = {}
	self.FOV = 70
	
	self.AmbientLight = Color (50, 50, 50, 255)
	self.Color = Color (255, 255, 255, 255)
	
	self:SetDirectionalLight (BOX_TOP, Color (255, 255, 255))
	self:SetDirectionalLight (BOX_FRONT, Color (255, 255, 255))
	
	self.Model = nil
end

function self:GetModel ()
	return self.Model
end

function self:Paint (w, h)
	draw.RoundedBox (4, 0, 0, w, h, GLib.Colors.LightSkyBlue)
	
	if not self:GetModel () then return end
	
	local x, y = self:LocalToScreen (0, 0)
	
	local targetpos = 0.5 * (self.Model:GetAABBMin () + self.Model:GetAABBMax ())
	
	local angle = Angle (10, SysTime () * 10, 0)
	local campos = targetpos - angle:Forward () * (self.Model:GetAABBMax () - self.Model:GetAABBMin ()):Length () * 0.5 * 1.5
	
	cam.Start3D (campos, angle, self.FOV, x, y, w, h)
	
	-- Setup lighting
	-- render.SuppressEngineLighting (true)
	render.SetLightingOrigin (targetpos)
	render.ResetModelLighting (self.AmbientLight.r / 255, self.AmbientLight.g / 255, self.AmbientLight.b / 255)
	render.SetColorModulation (self.Color.r / 255, self.Color.g / 255, self.Color.b / 255)
	render.SetBlend (self.Color.a / 255)
	
	for i = 0, 6 do
		local col = self.DirectionalLight [i]
		if col then
			render.SetModelLighting (i, col.r / 255, col.g / 255, col.b / 255)
		end
	end
	
	-- Set rendering area
	render.SetScissorRect (x, y, x + w, y + h, true)
	
	cam.PushModelMatrix (Matrix ())
	
	-- Draw axes
	render.SetMaterial (vertexColorMaterial)
	render.SetColorModulation (self.Color.r / 255, self.Color.g / 255, self.Color.b / 255)
	mesh.Begin (MATERIAL_LINES, 3)
	
	mesh.Color (GLib.Colors.Red.r, GLib.Colors.Red.g, GLib.Colors.Red.b, GLib.Colors.Red.a)
	mesh.Position (Vector (-  64, 0, 0))
	mesh.AdvanceVertex ()
	mesh.Color (GLib.Colors.Red.r, GLib.Colors.Red.g, GLib.Colors.Red.b, GLib.Colors.Red.a)
	mesh.Position (Vector ( 1024, 0, 0))
	mesh.AdvanceVertex ()
	
	mesh.Color (GLib.Colors.Green.r, GLib.Colors.Green.g, GLib.Colors.Green.b, GLib.Colors.Green.a)
	mesh.Position (Vector (0, -  64, 0))
	mesh.AdvanceVertex ()
	mesh.Color (GLib.Colors.Green.r, GLib.Colors.Green.g, GLib.Colors.Green.b, GLib.Colors.Green.a)
	mesh.Position (Vector (0,  1024, 0))
	mesh.AdvanceVertex ()
	
	mesh.Color (GLib.Colors.Blue.r, GLib.Colors.Blue.g, GLib.Colors.Blue.b, GLib.Colors.Blue.a)
	mesh.Position (Vector (0, 0, -  64))
	mesh.AdvanceVertex ()
	mesh.Color (GLib.Colors.Blue.r, GLib.Colors.Blue.g, GLib.Colors.Blue.b, GLib.Colors.Blue.a)
	mesh.Position (Vector (0, 0,  1024))
	mesh.AdvanceVertex ()
	
	mesh.End ()
	
	-- Draw model
	render.SetMaterial (wireframeMaterial)
	local triangleCount = 0
	for part in self.Model:GetPartEnumerator () do
		triangleCount = triangleCount + part:GetTriangleCount ()
		render.CullMode (MATERIAL_CULLMODE_CCW)
		part:GetMesh ():Draw ()
		render.CullMode (MATERIAL_CULLMODE_CW)
		part:GetMesh ():Draw ()
	end
	render.CullMode (MATERIAL_CULLMODE_CCW)
	
	cam.PopModelMatrix ()
	
	render.SetScissorRect (0, 0, 0, 0, false)
	
	-- Restore lighting
	-- render.SuppressEngineLighting (false)
	
	cam.End3D ()
	
	draw.SimpleText (self.Model:GetVertexCount () .. " vertices", "DermaDefault", w - 8, 8, GLib.Colors.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText (self.Model:GetIndexCount () .. " indices", "DermaDefault", w - 8, 24, GLib.Colors.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText (triangleCount .. " triangles", "DermaDefault", w - 8, 40, GLib.Colors.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

function self:SetDirectionalLight (direction, color)
	self.DirectionalLight [direction] = color
end

function self:SetModel (model)
	self.Model = model
end

Gooey.Register ("GCodecModelView", self, "GPanel")
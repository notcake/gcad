local self = {}
GCAD.Components.PathfindingNode = GCAD.MakeConstructor (self,
	GCAD.Components.IComponent,
	GCAD.IRenderNode
)

local boxOutlineColor = GLib.Colors.White
local boxColor        = GLib.Color.FromColor (boxOutlineColor, 64)

function self:ctor ()
	-- IRenderNode
	self:SetRenderNode (self)
end

-- IRenderNode
local obbMins = Vector (-16, -16, -16)
local obbMaxs = Vector ( 16,  16,  16)
local position = Vector ()
function self:Render (renderContext)
	local position = self:GetPositionNative (position)
	render.DrawWireframeBox (position, angle_zero, obbMins, obbMaxs, boxOutlineColor, true)
	render.DrawBox          (position, angle_zero, obbMins, obbMaxs, boxColor,        true)
end
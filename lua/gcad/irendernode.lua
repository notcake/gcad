local self = {}
GCAD.IRenderNode = GCAD.MakeConstructor (self, GCAD.IRenderNodeHost)

function self:ctor ()
end

-- IRenderNodeHost
function self:GetRenderNode ()
	return self
end

-- IRenderNode
function self:Render (renderContext)
end
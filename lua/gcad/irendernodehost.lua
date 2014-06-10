local self = {}
GCAD.IRenderNodeHost = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetRenderNode ()
	GCAD.Error ("IRenderNodeHost:GetRenderNode : Not implemented.")
end
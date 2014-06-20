local self = {}
GCAD.Rendering.IRenderModifierComponent = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:HasPreRenderModifier ()
	GCAD.Error ("IRenderModifierComponent:HasPreRenderModifier : Not implemented.")
end

function self:HasPostRenderModifier ()
	GCAD.Error ("IRenderModifierComponent:HasPostRenderModifier : Not implemented.")
end

function self:PreRender (renderContext)
	GCAD.Error ("IRenderModifierComponent:PreRender : Not implemented.")
end

function self:PostRender (renderContext)
	GCAD.Error ("IRenderModifierComponent:PostRender : Not implemented.")
end
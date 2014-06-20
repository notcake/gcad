local self = {}
GCAD.Rendering.NullRenderModifierComponent = GCAD.MakeConstructor (self, GCAD.Rendering.IRenderModifierComponent)

function self:ctor ()
end

function self:HasPreRenderModifier ()
	return false
end

function self:HasPostRenderModifier ()
	return false
end

function self:PreRender (renderContext)
	return false
end

function self:PostRender (renderContext)
	return false
end

function self:__call ()
	return self
end

GCAD.Rendering.NullRenderModifierComponent = GCAD.Rendering.NullRenderModifierComponent ()
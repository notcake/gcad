local self = {}
GCAD.Rendering.NullRenderComponent = GCAD.MakeConstructor (self, GCAD.Rendering.IRenderComponent)

function self:ctor ()
end

-- Forward rendering
function self:HasOpaqueRendering ()
	return false
end

function self:HasTranslucentRendering ()
	return false
end

function self:RenderOpaque (renderContext)
end

function self:RenderTranslucent (renderContext)
end

function self:__call ()
	return self
end

GCAD.Rendering.NullRenderComponent = GCAD.Rendering.NullRenderComponent ()
local self = {}
GCAD.Rendering.IRenderComponent = GCAD.MakeConstructor (self)

function self:ctor ()
end

-- Forward rendering
function self:HasOpaqueRendering ()
	GCAD.Error ("IRenderComponent:HasOpaqueRendering : Not implemented.")
end

function self:HasTranslucentRendering ()
	GCAD.Error ("IRenderComponent:HasTranslucentRendering : Not implemented.")
end

function self:RenderOpaque (renderContext)
	GCAD.Error ("IRenderComponent:RenderOpaque : Not implemented.")
end

function self:RenderTranslucent (renderContext)
	GCAD.Error ("IRenderComponent:RenderTranslucent : Not implemented.")
end
local self = {}
GCAD.UI.IMouseEventHandler = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:dtor ()
end

function self:OnMouseEnter ()
end

function self:OnMouseLeave ()
end

function self:OnMouseMove (mouseCode, mouseX, mouseY)
end

function self:OnMouseDown (mouseCode, mouseX, mouseY)
end

function self:OnMouseUp (mouseCode, mouseX, mouseY)
end

function self:OnMouseWheel (delta, mouseX, mouseY)
end
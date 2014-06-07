local self = {}
GCAD.UI.IMouseEventSource = GCAD.MakeConstructor (self)

--[[
	Events:
		MouseEnter ()
			Fired when the mouse has entered the area of the control.
		MouseLeave ()
			Fired when the mouse has left the area of the control.
		MouseMove (mouseCode, mouseX, mouseY)
			Fired when the mouse has moved.
		MouseDown (mouseCode, mouseX, mouseY)
			Fired when a mouse button has been pressed.
		MouseUp (mouseCode, mouseX, mouseY)
			Fired when a mouse button has been released.
		MouseWheel (delta, mouseX, mouseY)
			Fired when the mouse wheel has been scrolled.
]]

function self:ctor ()
	GCAD.EventProvider (self)
end

function self:DispatchMouseEnter ()
	return self:DispatchEvent ("MouseEnter")
end

function self:DispatchMouseLeave ()
	return self:DispatchEvent ("MouseLeave")
end

function self:DispatchMouseMove (mouseCode, mouseX, mouseY)
	return self:DispatchEvent ("MouseMove", mouseCode, mouseX, mouseY)
end

function self:DispatchMouseDown (mouseCode, mouseX, mouseY)
	return self:DispatchEvent ("MouseDown", mouseCode, mouseX, mouseY)
end

function self:DispatchMouseUp (mouseCode, mouseX, mouseY)
	return self:DispatchEvent ("MouseUp", mouseCode, mouseX, mouseY)
end

function self:DispatchMouseWheel (delta, mouseX, mouseY)
	return self:DispatchEvent ("MouseWheel", delta, mouseX, mouseY)
end
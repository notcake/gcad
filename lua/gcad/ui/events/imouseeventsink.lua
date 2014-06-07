local self = {}
GCAD.UI.IMouseEventSink = GCAD.MakeConstructor (self, GCAD.UI.IMouseEventHandler)

function self:ctor ()
	self.MouseEventSource = nil
end

function self:dtor ()
	self:SetMouseEventSource (nil)
end

function self:SetMouseEventSource (mouseEventSource)
	if self.MouseEventSource == mouseEventSource then return self end
	
	self:UnhookMouseEventSource (self.MouseEventSource)
	self.MouseEventSource = mouseEventSource
	self:HookMouseEventSource (self.MouseEventSource)
	
	return self
end

-- Internal, do not call
function self:HookMouseEventSource (mouseEventSource)
	if not mouseEventSource then return end
	
	mouseEventSource:AddEventListener ("MouseEnter", "IMouseEventSink." .. self:GetHashCode (),
		function (_)
			return self:OnMouseEnter ()
		end
	)
	
	mouseEventSource:AddEventListener ("MouseLeave", "IMouseEventSink." .. self:GetHashCode (),
		function (_)
			return self:OnMouseLeave ()
		end
	)
	
	mouseEventSource:AddEventListener ("MouseMove", "IMouseEventSink." .. self:GetHashCode (),
		function (_, mouseCode, mouseX, mouseY)
			return self:OnMouseMove (mouseCode, mouseX, mouseY)
		end
	)
	
	mouseEventSource:AddEventListener ("MouseDown", "IMouseEventSink." .. self:GetHashCode (),
		function (_, mouseCode, mouseX, mouseY)
			return self:OnMouseDown (mouseCode, mouseX, mouseY)
		end
	)
	
	mouseEventSource:AddEventListener ("MouseUp", "IMouseEventSink." .. self:GetHashCode (),
		function (_, mouseCode, mouseX, mouseY)
			return self:OnMouseUp (mouseCode, mouseX, mouseY)
		end
	)
	
	mouseEventSource:AddEventListener ("MouseWheel", "IMouseEventSink." .. self:GetHashCode (),
		function (_, delta, mouseX, mouseY)
			return self:OnMouseWheel (delta, mouseX, mouseY)
		end
	)
end

function self:UnhookMouseEventSource (mouseEventSource)
	if not mouseEventSource then return end
	
	mouseEventSource:RemoveEventListener ("MouseEnter", "IMouseEventSink." .. self:GetHashCode ())
	mouseEventSource:RemoveEventListener ("MouseLeave", "IMouseEventSink." .. self:GetHashCode ())
	mouseEventSource:RemoveEventListener ("MouseMove",  "IMouseEventSink." .. self:GetHashCode ())
	mouseEventSource:RemoveEventListener ("MouseDown",  "IMouseEventSink." .. self:GetHashCode ())
	mouseEventSource:RemoveEventListener ("MouseUp",    "IMouseEventSink." .. self:GetHashCode ())
	mouseEventSource:RemoveEventListener ("MouseWheel", "IMouseEventSink." .. self:GetHashCode ())
end
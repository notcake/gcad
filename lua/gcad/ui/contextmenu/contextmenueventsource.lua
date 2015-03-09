local self = {}
GCAD.UI.ContextMenuEventSource = GCAD.MakeConstructor (self, GCAD.UI.IMouseEventSource)

function self:ctor ()
	self.Control = nil
	
	self:SetControl (g_ContextMenu)
	
	hook.Add ("OnContextMenuOpen", "GCAD.ContextMenuEventSource",
		function ()
			local hadControl = self:HasControl ()
			
			self:SetControl (g_ContextMenu)
			
			if not hadControl then
				self:DispatchMouseEnter ()
			end
		end
	)
	
	hook.Add ("OnContextMenuClose", "GCAD.ContextMenuEventSource",
		function ()
			if self.Control and self.Control:IsValid () then
				self.Control:MouseCapture (false)
			end
			
			self:DispatchMouseLeave ()
		end
	)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.ContextMenuEventSource",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	self:SetControl (nil)
	
	hook.Remove ("OnContextMenuOpen",  "GCAD.ContextMenuEventSource")
	hook.Remove ("OnContextMenuClose", "GCAD.ContextMenuEventSource")
	
	GCAD:RemoveEventListener ("Unloaded", "GCAD.ContextMenuEventSource")
end

function self:GetControl ()
	return self.Control
end

function self:HasControl ()
	if not self.Control then return false end
	return self.Control:IsValid ()
end

-- Internal, do not call
function self:SetControl (control)
	if self.Control == control then return self end
	
	if self.Control then
		self.Control:SetWorldClicker (true)
		for _, child in ipairs (self.Control:GetChildren ()) do
			if child.ClassName == "DIconLayout" then
				self.Control.Canvas:SetWorldClicker (true)
			end
		end
		
		self.Control.OnCursorEntered = self.Control._OnCursorEntered
		self.Control.OnCursorExited  = self.Control._OnCursorExited
		self.Control.OnCursorMoved   = self.Control._OnCursorMoved
		self.Control.OnMousePressed  = self.Control._OnMousePressed
		self.Control.OnMouseReleased = self.Control._OnMouseReleased
	end
	
	self.Control = control
	
	if self.Control then
		self.Control:SetWorldClicker (false)
		self.Control.Canvas:SetWorldClicker (false)
		for _, child in ipairs (self.Control:GetChildren ()) do
			if child.ClassName == "DIconLayout" then
				child:SetWorldClicker (false)
			end
		end
		
		self.Control._OnCursorEntered = self.Control._OnCursorEntered or self.Control.OnCursorEntered
		self.Control._OnCursorExited  = self.Control._OnCursorExited  or self.Control.OnCursorExited
		self.Control._OnCursorMoved   = self.Control._OnCursorMoved   or self.Control.OnCursorMoved
		self.Control._OnMousePressed  = self.Control._OnMousePressed  or self.Control.OnMousePressed
		self.Control._OnMouseReleased = self.Control._OnMouseReleased or self.Control.OnMouseReleased
		
		self.Control.OnCursorEntered = function (_)
			self:DispatchMouseEnter ()
		end
		
		self.Control.OnCursorExited = function (_)
			self:DispatchMouseLeave ()
		end
		
		self.Control.OnCursorMoved = function (_, x, y)
			local mouseCode = 0
			if input.IsMouseDown (MOUSE_LEFT)   then mouseCode = mouseCode + MOUSE_LEFT end
			if input.IsMouseDown (MOUSE_RIGHT)  then mouseCode = mouseCode + MOUSE_RIGHT end
			if input.IsMouseDown (MOUSE_MIDDLE) then mouseCode = mouseCode + MOUSE_MIDDLE end
			
			self:DispatchMouseMove (mouseCode, x, y)
		end
		
		self.Control.OnMousePressed = function (_, mouseCode)
			if mouseCode == MOUSE_LEFT then
				self.Control:MouseCapture (true)
			end
			
			self:DispatchMouseDown (mouseCode, self.Control:CursorPos ())
		end
		
		self.Control.OnMouseReleased = function (_, mouseCode)
			if mouseCode == MOUSE_LEFT then
				self.Control:MouseCapture (false)
			end
			
			self:DispatchMouseUp (mouseCode, self.Control:CursorPos ())
		end
	end
end

GCAD.UI.ContextMenuEventSource = GCAD.UI.ContextMenuEventSource ()
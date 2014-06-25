local self = {}
GCAD.Actions.ActionProvider = GCAD.MakeConstructor (self, GCAD.Actions.IActionProvider)

function self:ctor ()
	self.ActionsById   = {}
	self.ActionsByName = {}
end

function self:dtor ()
	self:Clear ()
end

-- IActionProvider
function self:GetAction (actionId)
	return self.ActionsById [actionId]
end

function self:GetActionByName (actionName)
	if not self.ActionsByName [actionName] then return nil end
	return next (self.ActionsByName [actionName])
end

function self:GetActionsByName (actionName)
	local t = {}
	
	if self.ActionsByName [actionName] then
		for k, _ in pairs (self.ActionsByName [actionName]) do
			t [#t + 1] = k
		end
	end
	
	return t
end

function self:GetEnumerator ()
	return GLib.ValueEnumerator (self.ActionsById)
end

-- ActionProvider
function self:AddAction (action)
	if isstring (action) then return self:CreateAction (action) end
	
	self.ActionsById [action:GetId ()] = action
	self:RegisterActionByName (action, action:GetName ())
	self:HookAction (action)
end

function self:Clear ()
	for actionId, action in pairs (self.ActionsById) do
		self:UnhookAction (action)
		self.ActionsById [actionId] = nil
	end
	
	self.ActionsByName = {}
end

function self:CreateAction (actionId)
	local action = GCAD.Actions.Action (actionId)
	
	self:AddAction (action)
	
	return action
end

function self:RemoveAction (action)
	self.ActionsById [action:GetId ()] = nil
	self:UnregisterActionByName (action, action:GetName ())
	self:UnhookAction (action)
end

-- Internal, do not call
function self:RegisterActionByName (action, name)
	if not name then return end
	
	self.ActionsByName [name] = self.ActionsByName [name] or {}
	self.ActionsByName [name] [action] = true
end

function self:UnregisterActionByName (action, name)
	if not name then return end
	if not self.ActionsByName [name] then return end
	
	self.ActionsByName [name] [action] = nil
	if not next (self.ActionsByName [name]) then
		self.ActionsByName [name] = nil
	end
end

function self:HookAction (action)
	if not action then return end
	
	action:AddEventListener ("NameChanged", "GCAD.ActionProvider." .. self:GetHashCode (),
		function (_, oldName, newName)
			self:UnregisterActionByName (action, oldName)
			self:RegisterActionByName (action, newName)
		end
	)
end

function self:UnhookAction (action)
	if not action then return end
	
	action:RemoveEventListener ("NameChanged", "GCAD.ActionProvider." .. self:GetHashCode ())
end
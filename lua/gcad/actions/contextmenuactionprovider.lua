local self = {}
GCAD.Actions.ContextMenuActionProvider = GCAD.MakeConstructor (self, GCAD.Actions.IActionProvider)

function self:ctor ()
	self.ActionsById   = {}
	self.ActionsByName = {}
end

function self:GetAction (actionId)
	self:CheckAction (actionId)
	
	return self.ActionsById [actionId]
end

function self:GetActionByName (actionName)
	if not self.ActionsByName [actionName] then
		self:Update ()
	end
	
	self:CheckAction (self.ActionsByName [actionName]:GetId ())
	
	return self.ActionsByName [actionName]
end

function self:GetActionsByName (actionName)
	return { self:GetActionByName (actionName) }
end

function self:GetEnumerator ()
	self:Update ()
	
	return GLib.ValueEnumerator (self.ActionsByName)
end

-- Internal, do not call
function self:Update ()
	for actionId, actionInfo in pairs (properties.List) do
		self:CheckAction (actionId)
	end
	
	for actionId, action in pairs (self.ActionsById) do
		self:CheckAction (actionId)
	end
end

function self:CheckAction (actionId)
	if properties.List [actionId] and not self.ActionsById [actionId] then
		self:AddAction (actionId, properties.List [actionId])
	end
	if not properties.List [actionId] and self.ActionsById [actionId] then
		self:RemoveAction (actionId)
	end
end

function self:AddAction (actionId, actionInfo)
	local action = GCAD.Actions.ContextMenuAction (actionId, actionInfo)
	self.ActionsById   [action:GetId   ()] = action
	self.ActionsByName [action:GetName ()] = action
end

function self:RemoveAction (actionId)
	local action = self.ActionsById [actionId]
	if not action then return end
	
	self.ActionsById [actionId] = nil
	self.ActionsByName [action:GetName ()] = nil
end

function self:__call ()
	return self
end

GCAD.Actions.ContextMenuActionProvider = GCAD.Actions.ContextMenuActionProvider ()
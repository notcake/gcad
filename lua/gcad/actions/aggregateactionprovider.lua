local self = {}
GCAD.Actions.AggregateActionProvider = GCAD.MakeConstructor (self)

function self:ctor ()
	self.ActionProviders = {}
end

-- IActionProvider
function self:GetAction (actionId)
	for actionProvider in self:GetActionProviderEnumerator () do
		local action = actionProvider:GetAction (actionId)
		if action then return action end
	end
	return nil
end

function self:GetActionByName (actionName)
	for actionProvider in self:GetActionProviderEnumerator () do
		local action = actionProvider:GetActionByName (actionName)
		if action then return action end
	end
	return nil
end

function self:GetActionsByName (actionName)
	local t = {}
	for actionProvider in self:GetActionProviderEnumerator () do
		for _, action in ipairs (actionProvider:GetActionsByName (actionName)) do
			t [#t + 1] = action
		end
	end
	
	return t
end

function self:GetEnumerator ()
	return GLib.Enumerator.Join (GLib.Enumerator.Unpack (GLib.Enumerator.Map (self:GetActionProviderEnumerator (),
		function (x)
			return x:GetEnumerator ()
		end
	)))
end

-- AggregateActionProvider
function self:AddActionProvider (actionProvider)
	self.ActionProviders [actionProvider] = true
end

function self:ContainsActionProvider (actionProvider)
	return self.ActionProviders [actionProvider] ~= nil
end

function self:GetActionProviderEnumerator ()
	return GLib.KeyEnumerator (self.ActionProviders)
end

function self:RemoveActionProvider (actionProvider)
	self.ActionProviders [actionProvider] = nil
end
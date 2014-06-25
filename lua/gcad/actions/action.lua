local self = {}
GCAD.Actions.Action = GCAD.MakeConstructor (self, GCAD.Actions.IAction)

--[[
	Events:
		NameChanged (oldName, newName)
			Fired when this action's name has changed.
]]

local function trueFunction ()
	return true
end

function self:ctor (id)
	self.Id                 = id
	self.Name               = nil
	self.Icon               = nil
	
	self.Description        = nil
	self.Parameters         = nil
	
	self.CanExecuteFunction = trueFunction
	self.ExecuteFunction    = GCAD.NullCallback
	
	GCAD.EventProvider (self)
end

-- IAction
function self:GetDescription ()
	return self.Description
end

function self:GetIcon ()
	return self.Icon
end

function self:GetId ()
	return self.Id
end

function self:GetParameterCount ()
	if not self.Parameters then return 0 end
	return #self.Parameters
end

function self:GetParameter (index)
	if not self.Parameters then return nil end
	return self.Parameters [index]
end

function self:GetParameterEnumerator ()
	return GLib.ArrayEnumerator (self.Parameters)
end

function self:GetName ()
	return self.Name
end

function self:CanExecute (userId, ...)
	return self.CanExecuteFunction (userId, ...)
end

function self:Execute (userId, ...)
	return self.ExecuteFunction (userId, ...)
end

-- Action
function self:AddParameter (name, type)
	self.Parameters = self.Parameters or {}
	
	local parameter = GCAD.Actions.ActionParameter (name, type)
	self.Parameters [#self.Parameters + 1] = parameter
	
	return parameter
end

function self:SetCanExecuteFunction (canExecuteFunction)
	if self.CanExecuteFunction == canExecuteFunction then return self end
	
	self.CanExecuteFunction = canExecuteFunction
	
	return self
end


function self:SetExecuteFunction (executeFunction)
	if self.ExecuteFunction == executeFunction then return self end
	
	self.ExecuteFunction = executeFunction
	
	return self
end

function self:SetDescription (description)
	if self.Description == description then return self end
	
	self.Description = description
	
	return self
end

function self:SetIcon (icon)
	if self.Icon == icon then return self end
	
	self.Icon = icon
	
	return self
end

function self:SetName (name)
	if self.Name == name then return self end
	
	local oldName = self.Name
	self.Name = name
	
	self:DispatchEvent ("NameChanged", oldName, self.Name)
	
	return self
end
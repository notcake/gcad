local self = {}
GCAD.Actions.IAction = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetDescription ()
	GCAD.Error ("IAction:GetDescription : Not implemented.")
end

function self:GetIcon ()
	GCAD.Error ("IAction:GetIcon : Not implemented.")
end

function self:GetId ()
	GCAD.Error ("IAction:GetId : Not implemented.")
end

function self:GetParameterCount ()
	GCAD.Error ("IAction:GetParameterCount : Not implemented.")
end

function self:GetParameter (index)
	GCAD.Error ("IAction:GetParameter : Not implemented.")
end

function self:GetParameterEnumerator ()
	GCAD.Error ("IAction:GetParameterEnumerator : Not implemented.")
end

function self:GetName ()
	GCAD.Error ("IAction:GetName : Not implemented.")
end

function self:CanExecute (userId, ...)
	GCAD.Error ("IAction:CanExecute : Not implemented.")
end

function self:Execute (userId, ...)
	GCAD.Error ("IAction:Execute : Not implemented.")
end
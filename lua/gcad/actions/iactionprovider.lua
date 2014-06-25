local self = {}
GCAD.Actions.IActionProvider = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetAction (actionId)
	GCAD.Error ("IActionProvider:GetAction : Not implemented.")
end

function self:GetActionByName (actionName)
	GCAD.Error ("IActionProvider:GetActionByName : Not implemented.")
end

function self:GetActionsByName (actionName)
	GCAD.Error ("IActionProvider:GetActionByNames : Not implemented.")
end

function self:GetEnumerator ()
	GCAD.Error ("IActionProvider:GetEnumerator : Not implemented.")
end
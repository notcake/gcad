local self = {}
GCAD.Actions.IActionParameter = GCAD.MakeConstructor (self)

function self:ctor ()
end

function self:GetDescription ()
	GCAD.Error ("IActionParameter:GetDescription : Not implemented.")
end

function self:GetName ()
	GCAD.Error ("IActionParameter:GetName : Not implemented.")
end

function self:GetType ()
	GCAD.Error ("IActionParameter:GetType : Not implemented.")
end
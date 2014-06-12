local self = {}
GCAD.Components.IComponent = GCAD.MakeConstructor (self, GCAD.Components.IComponentHost)

function self:ctor ()
end

function self:GetComponentHost ()
	GCAD.Error ("IComponent:GetComponentHost : Not implemented.")
end
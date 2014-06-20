local self = {}
GCAD.VEntities.VEntity = GCAD.MakeConstructor (self,
	GCAD.Components.ComponentHost,
	GCAD.IDisposable
)

function self:ctor ()
end

-- Display
function self:GetDisplayString ()
	return self:GetTypeDisplayString ()
end

function self:GetIcon ()
	return nil
end

function self:GetTypeDisplayString ()
	return "GCAD.VEntity"
end
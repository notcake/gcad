local self = {}
GCAD.VEntities.VEntity = GCAD.MakeConstructor (self,
	GCAD.Components.ComponentHost,
	GCAD.IDisposable
)

self.TypeName = "VEntity"

--[[
	Events:
		Removed ()
			Fired when this VEntity has been removed.
]]

function self:ctor ()
	GCAD.EventProvider (self)
	
	self:AddEventListener ("Disposed",
		function (_)
			self:DispatchEvent ("Removed")
		end
	)
end

-- Type
function self:GetTypeName ()
	return self.TypeName
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
local self = {}
GCAD.Actions.ActionParameter = GCAD.MakeConstructor (self, GCAD.Actions.IActionParameter)

function self:ctor (name, type)
	self.Name        = name
	self.Type        = type
	
	self.Description = nil
end

-- IActionParameter
function self:GetDescription ()
	GCAD.Error ("IActionParameter:GetDescription : Not implemented.")
end

function self:GetName ()
	GCAD.Error ("IActionParameter:GetName : Not implemented.")
end

function self:GetType ()
	GCAD.Error ("IActionParameter:GetType : Not implemented.")
end

-- ActionParameter
function self:SetDescription (description)
	if self.Description == description then return self end
	
	self.Description = description
	
	return self
end

function self:SetName (name)
	if self.Name == name then return self end
	
	self.Name = name
	
	return self
end

function self:SetType (type)
	if self.Type == type then return self end
	
	self.Type = type
	
	return self
end
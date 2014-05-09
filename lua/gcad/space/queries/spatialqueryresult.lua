local self = {}
GCAD.SpatialQueryResult = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Objects = {}
	self.ObjectsFullyContained = {}
end

function self:dtor ()
	-- Release references
	self.Objects = nil
	self.ObjectsFullyContained = nil
end

function self:Add (object, fullyContained)
	if fullyContained == nil then fullyContained = false end
	
	self.Objects [#self.Objects + 1] = object
	self.ObjectsFullyContained [#self.ObjectsFullyContained + 1] = fullyContained
end

function self:Clear ()
	if self:IsEmpty () then return end
	
	self.Objects = {}
	self.ObjectsFullyContained = {}
end

function self:GetEnumerator ()
	local i = 0
	return function ()
		i = i + 1
		return self.Objects [i], self.ObjectsFullyContained [i]
	end
end

function self:GetResultCount ()
	return #self.Objects
end

function self:GetResult (index)
	return self.Objects [index], self.ObjectsFullyContained [index]
end

function self:IsEmpty ()
	return #self.Objects == 0
end

function self:IsResultFullyContained (index)
	return self.ObjectsFullyContained [index]
end
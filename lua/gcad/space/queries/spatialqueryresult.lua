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

function self:Filter (f, out)
	if out == self then out = nil end
	out = out or GCAD.SpatialQueryResult ()
	
	for i = 1, #self.Objects [i] do
		if f (self.Objects [i], self.ObjectsFullyContained [i]) then
			out:Add (self.Objects [i], self.ObjectsFullyContained [i])
		end
	end
	
	return out
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

function self:ToArray (out)
	out = out or {}
	
	for i = 1, #self.Objects do
		out [#out + 1] = self.Objects [i]
	end
	
	return out
end
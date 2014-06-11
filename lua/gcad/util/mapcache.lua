local self = {}
GCAD.MapCache = GCAD.MakeConstructor (self)

function self:ctor (mapFunction)
	self.Cache = GCAD.WeakKeyTable ()
	self.MapFunction = mapFunction or GCAD.NullCallback
end

function self:Clear ()
	self:Invalidate ()
end

function self:Contains (k)
	return self.Cache [k] ~= nil
end

function self:Flush (k)
	self:Invalidate (k)
end

function self:Get (k)
	if not self.Cache [k] then
		self.Cache [k] = self.MapFunction (k)
	end
	
	return self.Cache [k]
end

function self:GetMapFunction ()
	return self.MapFunction
end

function self:Invalidate (k)
	if k then
		self.Cache [k] = nil
	else
		self.Cache = GCAD.WeakKeyTable ()
	end
end

function self:IsEmpty ()
	return next (self.Cache) == nil
end

function self:SetMapFunction (mapFunction)
	if self.MapFunction == mapFunction then return self end
	
	self.MapFunction = mapFunction
	self:Invalidate ()
	
	return self
end
local self = {}
GCAD.Pool = GCAD.MakeConstructor (self)

function self:ctor (factory)
	self.Factory = factory or GCAD.NullCallback
	
	self.Pool = {}
end

function self:dtor ()
end

function self:Allocate ()
	local item = next (self.Pool) or self.Factory ()
	self.Pool [item] = nil
	return item
end

function self:Deallocate (item)
	self.Pool [item] = true
end

function self:GetFactory ()
	return self.Factory
end

function self:SetFactory (factory)
	if self.Factory == factory then return end
	
	self.Factory = factory
	
	return self
end
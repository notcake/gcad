local self = {}
GCAD.UI.EventedCollectionCuller = GCAD.MakeConstructor (self)

function self:ctor (collection)
	self.Collection = nil
	self.Items = GLib.WeakKeyTable ()
	
	self:SetCollection (collection)
end

function self:dtor ()
	self:SetCollection (nil)
end

function self:SetCollection (collection)
	if self.Collection == collection then return self end
	
	self:UnhookCollection (self.Collection)
	self:ClearHookedItems ()
	
	self.Collection = collection
	
	self:HookCollection (self.Collection)
	self:HookItems (self.Collection)
	
	return self
end

-- Internal, do not call
function self:ClearHookedItems ()
	for item, _ in pairs (self.Items) do
		self:UnhookItem (item)
		self.Items [item] = nil
	end
end

function self:HookItems (enumerable)
	for item in self.Collection:GetEnumerator () do
		self.Items [item] = true
		self:HookItem (item)
	end
end

function self:HookCollection (collection)
	if not collection                  then return end
	if not collection.AddEventListener then return end
	
	collection:AddEventListener ("Cleared", "GCAD.EventedCollectionCuller." .. self:GetHashCode (),
		function (_)
			self:ClearHookedItems ()
		end
	)
	
	collection:AddEventListener ("ItemAdded", "GCAD.EventedCollectionCuller." .. self:GetHashCode (),
		function (_, item)
			self:HookItem (item)
			self.Items [item] = true
		end
	)
	
	collection:AddEventListener ("ItemRemoved", "GCAD.EventedCollectionCuller." .. self:GetHashCode (),
		function (_, item)
			self:UnhookItem (item)
			self.Items [item] = false
		end
	)
end

function self:UnhookCollection (collection)
	if not collection                     then return end
	if not collection.RemoveEventListener then return end
	
	collection:RemoveEventListener ("Cleared",     "GCAD.EventedCollectionCuller." .. self:GetHashCode ())
	collection:RemoveEventListener ("ItemAdded",   "GCAD.EventedCollectionCuller." .. self:GetHashCode ())
	collection:RemoveEventListener ("ItemRemoved", "GCAD.EventedCollectionCuller." .. self:GetHashCode ())
end

function self:HookItem (item)
	if not item                  then return end
	if not item.AddEventListener then return end
	
	item:AddEventListener ("Disposed", "GCAD.EventedCollectionCuller." .. self:GetHashCode (),
		function (_)
			self.Collection:Remove (item)
		end
	)
	
	item:AddEventListener ("Removed", "GCAD.EventedCollectionCuller." .. self:GetHashCode (),
		function (_)
			self.Collection:Remove (item)
		end
	)
end

function self:UnhookItem (item)
	if not item                     then return end
	if not item.RemoveEventListener then return end
	
	item:RemoveEventListener ("Disposed", "GCAD.EventedCollectionCuller." .. self:GetHashCode ())
	item:RemoveEventListener ("Removed",  "GCAD.EventedCollectionCuller." .. self:GetHashCode ())
end
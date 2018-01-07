local self = {}
GCAD.UI.Selection = GCAD.MakeConstructor (self)

--[[
	Events:
		Cleared ()
			Fired when this selection is cleared.
		Changed ()
			Fired when this selection's items have changed.
		ItemAdded (item)
			Fired when an item has been added to this selection.
		ItemRemoved (item)
			Fired when an item has been added to this selection.
]]

function self:ctor ()
	self.SelectionSet = GLib.Containers.EventedSet ()
	
	self.SetOperatorController = nil
	self.BaselineSelectionSet  = GLib.Containers.EventedSet ()
	self.ModifyingSelectionSet = GLib.Containers.EventedSet ()
	
	GCAD.EventProvider (self)
	
	self:HookSelectionSet (self.SelectionSet)
end

-- Set
function self:Add (item)
	self.SelectionSet:Add (item)
end

function self:AddRange (enumerable)
	for item in enumerable:GetEnumerator () do
		self:Add (item)
	end
end

function self:Clear ()
	self.SelectionSet:Clear ()
end

function self:Contains (item)
	return self.SelectionSet:Contains (item)
end

function self:GetCount ()
	return self.SelectionSet:GetCount ()
end

function self:GetEnumerator ()
	return self.SelectionSet:GetEnumerator ()
end

function self:IsEmpty ()
	return self.SelectionSet:IsEmpty ()
end

function self:Remove (item)
	self.SelectionSet:Remove (item)
end

-- Modifying set
function self:AddToModifyingSet (item)
	self.ModifyingSet:Add (item)
end

function self:AddRangeToModifyingSet (enumerable)
	for item in enumerable:GetEnumerator () do
		self:AddToModifyingSet (item)
	end
end

function self:ClearModifyingSet ()
	self.ModifyingSet:Clear ()
end

function self:ModifyingSetContains (item)
	return self.ModifyingSet:Contains (item)
end

function self:GetModifyingSetCount ()
	return self.ModifyingSet:GetCount ()
end

function self:GetModifyingSetEnumerator ()
	return self.ModifyingSet:GetEnumerator ()
end

function self:IsModifyingSetEmpty ()
	return self.ModifyingSet:IsEmpty ()
end

function self:RemoveFromModifyingSet (item)
	self.ModifyingSet:Remove (item)
end

-- Selection
function self:BeginSelection (selectionType)
	if self.SetOperatorController then
		return self.ModifyingSelectionSet
	end
	
	selectionType = selectionType or GCAD.UI.SelectionType.New
	
	if selectionType == GCAD.UI.SelectionType.New then
		self.SelectionSet:Clear ()
	end
	
	self:UnhookSelectionSet (self.SelectionSet)
	self.SelectionSet, self.BaselineSelectionSet = self.BaselineSelectionSet, self.SelectionSet
	self.SelectionSet:Clear ()
	self.ModifyingSelectionSet:Clear ()
	
	if selectionType == GCAD.UI.SelectionType.New then
		self.SetOperatorController = GLib.Containers.SetUnionController (self.BaselineSelectionSet, self.ModifyingSelectionSet, self.SelectionSet)
	elseif selectionType == GCAD.UI.SelectionType.Add then
		self.SetOperatorController = GLib.Containers.SetUnionController (self.BaselineSelectionSet, self.ModifyingSelectionSet, self.SelectionSet)
	elseif selectionType == GCAD.UI.SelectionType.Toggle then
		self.SetOperatorController = GLib.Containers.SetXorController   (self.BaselineSelectionSet, self.ModifyingSelectionSet, self.SelectionSet)
	end
	
	self:HookSelectionSet (self.SelectionSet)
end

function self:EndSelection ()
	if not self.SetOperatorController then return end
	
	self.SetOperatorController:dtor ()
	self.SetOperatorController = nil
	
	self.BaselineSelectionSet:Clear ()
	self.ModifyingSelectionSet:Clear ()
end

function self:GetBaselineSet ()
	return self.BaselineSelectionSet or self.SelectionSet
end

function self:GetModifyingSet ()
	return self.ModifyingSelectionSet
end

function self:IsSelectionInProgress ()
	return self.SetOperatorController ~= nil
end

function self:SetModifyingSet (modifyingSet)
	if self.ModifyingSelectionSet == modifyingSet then return self end
	
	self.ModifyingSelectionSet = modifyingSet
	
	if self.SetOperatorController then
		self.SetOperatorController:SetRight (self.ModifyingSelectionSet)
	end
	
	return self
end

-- Internal, do not call
function self:HookSelectionSet (selectionSet)
	if not selectionSet then return end
	
	selectionSet:AddEventListener ("Cleared", "GCAD.Selection." .. self:GetHashCode (),
		function (_)
			self:DispatchEvent ("Cleared")
			self:DispatchEvent ("Changed")
		end
	)
	
	selectionSet:AddEventListener ("ItemAdded", "GCAD.Selection." .. self:GetHashCode (),
		function (_, item)
			self:DispatchEvent ("ItemAdded", item)
			self:DispatchEvent ("Changed")
		end
	)
	
	selectionSet:AddEventListener ("ItemRemoved", "GCAD.Selection." .. self:GetHashCode (),
		function (_, item)
			self:DispatchEvent ("ItemRemoved", item)
			self:DispatchEvent ("Changed")
		end
	)
end

function self:UnhookSelectionSet (selectionSet)
	if not selectionSet then return end
	
	selectionSet:RemoveEventListener ("Cleared",     "GCAD.Selection." .. self:GetHashCode ())
	selectionSet:RemoveEventListener ("ItemAdded",   "GCAD.Selection." .. self:GetHashCode ())
	selectionSet:RemoveEventListener ("ItemRemoved", "GCAD.Selection." .. self:GetHashCode ())
end
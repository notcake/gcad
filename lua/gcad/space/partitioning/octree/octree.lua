local self = {}
GCAD.Octree = GCAD.MakeConstructor (self, GCAD.Space3d)

function self:ctor ()
	self.RootNode = GCAD.OctreeRootNode ()
	
	self.Count = 0
	self.ItemNodes = {}
end

-- ICollection
function self:Add (item)
	if self:Contains (item) then return end
	
	local node = GCAD.OctreeItemNode (item)
	
	self.ItemNodes [item] = node
	self.Count = self.Count + 1
	
	self.RootNode:Insert (node, node:GetAABB ())
end

function self:Clear ()
	self.RootNode:Clear ()
	
	self.ItemNodes = {}
	self.Count = 0
end

function self:Contains (item)
	return self.ItemNodes [item] ~= nil
end

function self:GetCount ()
	return self.Count
end

function self:GetEnumerator ()
	return GLib.KeyEnumerator (self.ItemNodes)
end

function self:Insert (item)
	return self:Add (item)
end

function self:Remove (item)
	if not self:Contains (item) then return end
	
	local node = self.ItemNodes [item]
	
	self.ItemNodes [item] = nil
	self.Count = self.Count - 1
	
	node:Remove ()
end

-- ISpace3d
function self:GetRootSpatialPartitionNode ()
	return self.RootNode
end

-- ISpace3d
function self:UpdateItem (item)
	if not self:Contains (item) then return end
	
	self.ItemNodes [item]:Update ()
end
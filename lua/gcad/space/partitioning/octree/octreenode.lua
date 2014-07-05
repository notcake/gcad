local self = {}
GCAD.OctreeNode = GCAD.MakeConstructor (self, GCAD.ISpatialPartitionNode3d)

local GCAD_AABB3d_ContainsPoint3                 = GCAD.AABB3d.ContainsPoint3
local GCAD_AABB3d_Equals                         = GCAD.AABB3d.Equals
local GCAD_UnpackedVector3d_Add                  = GCAD.UnpackedVector3d.Add
local GCAD_UnpackedVector3d_Length               = GCAD.UnpackedVector3d.Length
local GCAD_UnpackedVector3d_ScalarVectorMultiply = GCAD.UnpackedVector3d.ScalarVectorMultiply
local GCAD_UnpackedVector3d_Subtract             = GCAD.UnpackedVector3d.Subtract

function self:ctor ()
	self.Parent     = nil
	
	-- Children
	self.ChildNodes = nil
	
	self.Items = nil
	self.ExclusiveItemCount = 0
	self.InclusiveItemCount = 0
	
	-- Bounding volumes
	self.AABB3d = GCAD.AABB3d ()
	self.Centre = GCAD.Vector3d ()
	self.BoundingSphere = GCAD.Sphere3d ()
end

-- ISpatialNode3d
function self:GetAABB (out)
	if not out then return self.AABB3d end
	return GCAD.AABB3d.Clone (self.AABB3d, out)
end

function self:GetBoundingSphere (out)
	if not out then return self.BoundingSphere end
	return GCAD.Sphere3d.Clone (self.BoundingSphere, out)
end

-- ISpatialPartitionNode3d
function self:GetParent ()
	return self.Parent
end

function self:GetChildNodeEnumerator ()
	if not self.ChildNodes then return GLib.NullEnumerator () end
	return GLib.ArrayEnumerator (self.ChildNodes)
end

function self:GetExclusiveItemCount ()
	return self.ExclusiveItemCount
end

function self:GetExclusiveItemNodeEnumerator ()
	if not self.Items then return GLib.NullEnumerator () end
	return GLib.KeyEnumerator (self.Items)
end

function self:GetInclusiveItemCount ()
	return self.InclusiveItemCount
end

-- OctreeNode
function self:Insert (octreeItemNode, aabb3d)
	aabb3d = aabb3d or octreeItemNode:GetAABB ()
	
	if self.InclusiveItemCount == 0 then
		-- We can hold it.
		self:InsertHere ()
	else
		local failX, failY, failZ = GCAD_AABB3d_ContainsPoint3 (aabb3d, self.Centre)
		if failX or failY or failZ then
			-- None of our child nodes can hold it.
			self:InsertHere ()
		elseif octreeItemNode:IsPoint () and
		       GCAD_AABB3d_Equals (aabb3d, next (self.Items):GetAABB ()) then
			-- Avoid infinite recursion for identical points
			self:InsertHere ()
		else
			self:CreateChildNodes ()
			
			local xDiscriminant = aabb3d.Min [1] >= self.Centre [1] and 1 or 0
			local yDiscriminant = aabb3d.Min [2] >= self.Centre [2] and 1 or 0
			local zDiscriminant = aabb3d.Min [3] >= self.Centre [3] and 1 or 0
			self.ChildNodes [zDiscriminant * 4 + yDiscriminant * 2 + xDiscriminant * 1 + 1]:Insert (octreeItemNode, aabb3d)
		end
	end
end

function self:Remove (octreeItemNode)
	if not self.Items                   then return end
	if not self.Items [octreeItemNode] then return end
	
	octreeItemNode.Parent = nil
	self.Items [octreeItemNode] = nil
	
	-- Update item counts
	self.ExclusiveItemCount = self.ExclusiveItemCount - 1
	self:DecrementInclusiveItemCount ()
	
	-- Cull
	if self.InclusiveItemCount == 0 and
	   self.Parent then
		self.Parent:Cull ()
	end
end

function self:Update (octreeItemNode, aabb3d)
	if not self.Items                   then return end
	if not self.Items [octreeItemNode] then return end
	
	aabb3d = aabb3d or octreeItemNode:GetAABB ()
	
	if self:GetAABB ():ContainsAABB (aabb3d) then return end -- Panic over
	
	-- This object is too big for us
	local newParent = self
	while not newParent:GetAABB ():ContainsAABB (aabb3d) do
		if not newParent.Parent then
			-- We have hit the root node.
			-- NOTHING CAN TAKE THIS OBJECT
			-- Shove it into the root node anyway
			-- it'll expand to fit
			break
		end
		newParent = newParent.Parent
	end
	
	self:Remove (octreeItemNode)
	newParent:Insert (octreeItemNode, aabb3d)
end

-- Internal, do not call

-- Bounds
function self:GetMin         (out) return self.AABB3d:GetMin         (out) end
function self:GetMax         (out) return self.AABB3d:GetMax         (out) end
function self:GetMinNative   (out) return self.AABB3d:GetMinNative   (out) end
function self:GetMaxNative   (out) return self.AABB3d:GetMaxNative   (out) end
function self:GetMinUnpacked ()    return self.AABB3d:GetMinUnpacked ()    end
function self:GetMaxUnpacked ()    return self.AABB3d:GetMaxUnpacked ()    end

function self:GetCentre (out)
	return GCAD.Vector3d.Clone (self.Centre, out)
end

function self:GetCentreNative (out)
	return GCAD.Vector3d.ToNativeVector (self.Centre, out)
end

function self:GetCentreUnpacked ()
	return GCAD.Vector3d.Unpack (self.Centre)
end

function self:SetBounds (min, max, r)
	return self:SetBoundsUnpacked (min [1], min [2], min [3], max [1], max [2], max [3], r)
end

function self:SetBoundsUnpacked (x1, y1, z1, x2, y2, z2, r)
	local cx, cy, cz = GCAD_UnpackedVector3d_ScalarVectorMultiply (0.5, GCAD_UnpackedVector3d_Add (x1, y1, z1, x2, y2, z2))
	r = r or GCAD_UnpackedVector3d_Length (GCAD_UnpackedVector3d_Subtract (x2, y2, z2, cx, cy, cz))
	
	self.AABB3d.Min:Set (x1, y1, z1)
	self.AABB3d.Max:Set (x2, y2, z2)
	self.Centre:Set (cx, cy, cz)
	self.BoundingSphere:SetPositionUnpacked (cx, cy, cz)
	self.BoundingSphere:SetRadius (r)
	
	return self
end

-- Child nodes
function self:CreateChildNodes ()
	if self.ChildNodes then return end
	
	self.ChildNodes = {}
	for i = 1, 8 do
		self.ChildNodes [i] = GCAD.OctreeNode ()
		self.ChildNodes [i].Parent = self
	end
	
	local x1, y1, z1 = self:GetMinUnpacked ()
	local x2, y2, z2 = self:GetMaxUnpacked ()
	local cx, cy, cz = self:GetCentreUnpacked ()
	local r = GCAD_UnpackedVector3d_Length (GCAD_UnpackedVector3d_Subtract (x2, y2, z2, cx, cy, cz)) * 0.5
	self.ChildNodes [1]:SetBoundsUnpacked (x1, y1, z1, cx, cy, cz, r)
	self.ChildNodes [2]:SetBoundsUnpacked (cx, y1, z1, x2, cy, cz, r)
	self.ChildNodes [3]:SetBoundsUnpacked (x1, cy, z1, cx, y2, cz, r)
	self.ChildNodes [4]:SetBoundsUnpacked (cx, cy, z1, x2, y2, cz, r)
	self.ChildNodes [5]:SetBoundsUnpacked (x1, y1, cz, cx, cy, z2, r)
	self.ChildNodes [6]:SetBoundsUnpacked (cx, y1, cz, x2, cy, z2, r)
	self.ChildNodes [7]:SetBoundsUnpacked (x1, cy, cz, cx, y2, z2, r)
	self.ChildNodes [8]:SetBoundsUnpacked (cx, cy, cz, x2, y2, z2, r)
end

function self:CullChildren ()
	
end

-- Items
function self:InsertHere (octreeItemNode)
	self.Items = self.Items or {}
	
	octreeItemNode.Parent = self
	self.Items [octreeItemNode] = true
	
	-- Update item counts
	self.ExclusiveItemCount = self.ExclusiveItemCount + 1
	self:IncrementInclusiveItemCount ()
end

function self:DecrementInclusiveItemCount (n)
	n = n or 1
	
	local node = self
	while node do
		node.InclusiveItemCount = node.InclusiveItemCount - 1
		node = node.Parent
	end
end

function self:IncrementInclusiveItemCount (n)
	n = n or 1
	
	local node = self
	while node do
		node.InclusiveItemCount = node.InclusiveItemCount + 1
		node = node.Parent
	end
end
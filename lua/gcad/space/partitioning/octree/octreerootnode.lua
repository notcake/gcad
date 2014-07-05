local self = {}
GCAD.OctreeRootNode = GCAD.MakeConstructor (self, GCAD.OctreeNode)

function self:ctor ()
end

-- OctreeNode
function self:Insert (octreeItemNode, aabb3d)
	aabb3d = aabb3d or octreeItemNode:GetAABB ()
	
	if not self:GetAABB ():ContainsAABB (aabb3d) then
		-- Object is too big for us.
		self:ExpandToFit (aabb3d)
	end
	
	self.__base.Insert (self, octreeItemNode, aabb3d)
end

-- OctreeRootNode
function self:Clear ()
	self.ChildNodes = nil
	
	self.Items = nil
	self.ExclusiveItemCount = 0
	self.InclusiveItemCount = 0
	
	self:SetBoundsUnpacked (-1, -1, -1,
	                         1,  1,  1)
end

-- Internal, do not call
function self:ExpandToFit (aabb3d)
	while not self:GetAABB ():ContainsAABB (aabb3d) do
		self:Expand ()
	end
	
	-- No need to reinsert our items
	-- since they still belong with us and
	-- not in any child nodes
end

function self:Expand ()
	self.AABB3d.Min = GCAD.Vector3d.VectorScalarMultiply (self.AABB3d.Min, 2, self.AABB3d.Min)
	self.AABB3d.Max = GCAD.Vector3d.VectorScalarMultiply (self.AABB3d.Max, 2, self.AABB3d.Max)
	self:SetBounds (self.AABB3d.Min, self.AABB3d.Max)
	
	-- Recreate child nodes
	if self.ChildNodes then
		local childNodes = self.ChildNodes
		
		-- Recreate (bigger) child nodes
		self.ChildNodes = nil
		self:CreateChildNodes ()
		
		-- Reseat original child nodes
		for i = 1, 8 do
			local childNode = childNodes [i]
			if childNode:GetInclusiveItemCount () > 0 then
				self.ChildNodes [i]:CreateChildNodes ()
				self.ChildNodes [i].ChildNodes [9 - i] = childNode
				self.ChildNodes [i].ExclusiveItemCount = 0
				self.ChildNodes [i].InclusiveItemCount = childNode:GetInclusiveItemCount ()
			end
		end
	end
end
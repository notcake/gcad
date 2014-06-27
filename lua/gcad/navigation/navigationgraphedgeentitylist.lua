local self = {}
GCAD.Navigation.NavigationGraphEdgeEntityList = GCAD.MakeConstructor (self, GCAD.OBBSpatialQueryable3d)

function self:ctor (navigationGraph)
	self.NavigationGraph = nil
	
	self.NavigationGraphEdgeEntities = GLib.WeakTable ()
	
	self:SetNavigationGraph (navigationGraph)
	
	-- Set up profiling
	for methodName, v in pairs (self.__base.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "NavigationGraphEdgeEntityList:" .. methodName)
		end
	end
end

-- OBBSpatialQueryable
function self:GetObject (objectHandle)
	return self:GetNavigationGraphEdgeEntity (objectHandle)
end

function self:GetObjectHandles (out)
	for sourceNode, destinationNode, navigationGraphEdge in self.NavigationGraph:GetEdgeEnumerator () do
		out [#out + 1] = navigationGraphEdge
	end
	
	return out
end

function self:GetBoundingSpheres (objectHandles, out)
	for i = 1, #objectHandles do
		out [i] = out [i] or GCAD.Sphere3d ()
		
		local x1, y1, z1 = objectHandles [i]:GetFirstNode  ():GetPositionUnpacked ()
		local x2, y2, z2 = objectHandles [i]:GetSecondNode ():GetPositionUnpacked ()
		out [i]:SetPositionUnpacked (GCAD.UnpackedVector3d.ScalarVectorMultiply (0.5, GCAD.UnpackedVector3d.Add (x1, y1, z1, x2, y2, z2)))
		out [i]:SetRadius (GCAD.UnpackedVector3d.DistanceTo (x1, y1, z1, x2, y2, z2) * 0.5 + 4)
	end
	
	return out
end

function self:GetOBBs (objectHandles, out)
	for i = 1, #objectHandles do
		out [i] = out [i] or GCAD.OBB3d ()
		
		local x1, y1, z1 = objectHandles [i]:GetFirstNode  ():GetPositionUnpacked ()
		local x2, y2, z2 = objectHandles [i]:GetSecondNode ():GetPositionUnpacked ()
		local dx, dy, dz = GCAD.UnpackedVector3d.Subtract (x2, y2, z2, x1, y1, z1)
		out [i]:SetPositionUnpacked (x1, y1, z1)
		out [i]:SetAngleUnpacked (GCAD.UnpackedEulerAngle.FromUnpackedDirection (dx, dy, dz))
		out [i]:SetMinUnpacked (0, -4, -4)
		out [i]:SetMaxUnpacked (GCAD.UnpackedVector3d.Length (dx, dy, dz), 4, 4)
	end
	
	return out
end

-- Navigation graph
function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	self:UnhookNavigationGraph (self.NavigationGraph)
	self.NavigationGraph = navigationGraph
	self.NavigationGraphEdgeEntities = GLib.WeakTable ()
	self:HookNavigationGraph (self.NavigationGraph)
	
	return self
end

-- Navigation graph edges
function self:GetNavigationGraphEdgeEntity (navigationGraphEdge)
	if not self.NavigationGraphEdgeEntities [navigationGraphEdge] then
		local entity = GCAD.Navigation.NavigationGraphEdgeEntity (navigationGraphEdge)
		self.NavigationGraphEdgeEntities [navigationGraphEdge] = entity
	end
	
	return self.NavigationGraphEdgeEntities [navigationGraphEdge]
end

-- Internal, do not call
function self:HookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:AddEventListener ("EdgeRemoved", "GCAD.NavigationGraphEdgeEntityList." .. self:GetHashCode (),
		function (_, sourceNode, destinationNode, navigationGraphEdge)
			if self.NavigationGraphEdgeEntities [navigationGraphEdge] then
				self.NavigationGraphEdgeEntities [navigationGraphEdge]:DispatchEvent ("Removed")
				self.NavigationGraphEdgeEntities [navigationGraphEdge] = nil
			end
		end
	)
end

function self:UnhookNavigationGraph (navigationGraph)
	if not navigationGraph then return end
	
	navigationGraph:RemoveEventListener ("EdgeRemoved", "GCAD.NavigationGraphEdgeEntityList." .. self:GetHashCode ())
end
local self = {}
GCAD.Space3d = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

function self:ctor ()
	self.NodeHostSet = {}
end

-- ISpatialQueryable3d
function self:FindInFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	for spatialNode3dHost in self:GetEnumerator() do
		local spatialNode3d = spatialNode3dHost:GetSpatialNode3d ()
		local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (spatialNode3d:GetBoundingSphere ())
		
		if intersectsSphere then
			if containsSphere or
			   frustum3d:ContainsOBB (spatialNode3d:GetOBB ()) then
				spatialQueryResult:Add (spatialNode3dHost, true)
			end
		end
	end
	
	return spatialQueryResult
end
self.FindInFrustum = GCAD.Profiler:Wrap (self.FindInFrustum, "Space3d:FindInFrustum")

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	for spatialNode3dHost in self:GetEnumerator() do
		local spatialNode3d = spatialNode3dHost:GetSpatialNode3d ()
		local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (spatialNode3d:GetBoundingSphere ())
		
		if intersectsSphere then
			if containsSphere then
				spatialQueryResult:Add (spatialNode3dHost, true)
			elseif frustum3d:IntersectsOBB (spatialNode3d:GetOBB ()) then
				spatialQueryResult:Add (spatialNode3dHost)
			end
		end
	end
	
	return spatialQueryResult
end
self.FindIntersectingFrustum = GCAD.Profiler:Wrap (self.FindIntersectingFrustum, "Space3d:FindIntersectingFrustum")

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	for spatialNode3dHost in self:GetEnumerator () do
		local spatialNode3d = spatialNode3dHost:GetSpatialNode3d ()
		
		local intersectsSphere = spatialNode3d:GetBoundingSphere ():IntersectsLine (line3d)
		if intersectsSphere then
			local obb = spatialNode3d:GetOBB ()
			local tStart, tEnd = obb:IntersectLine (line3d)
			
			if tStart then
				lineTraceResult:AddIntersectionSpan (v, tStart, tEnd)
			end
		end
	end
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "Space3d:TraceLine")

-- Space3d
function self:Add (spatialNodeHost)
	if self:Contains (spatialNodeHost) then return end
	
	self.NodeHostSet [spatialNodeHost] = true
	self.NodeHostCount = self.NodeHostCount + 1
end

function self:Contains (spatialNodeHost)
	return self.NodeHostSet [spatialNodeHost] ~= nil
end

function self:GetCount ()
	return self.NodeHostCount
end

function self:GetEnumerator ()
	return GLib.KeyEnumerator (self.NodeHostSet)
end

function self:IsEmpty ()
	return self.NodeHostCount == 0
end

function self:Remove (spatialNodeHost)
	if not self:Contains (spatialNodeHost) then return end
	
	self.NodeHostSet [spatialNodeHost] = nil
	self.NodeHostCount = self.NodeHostCount - 1
end
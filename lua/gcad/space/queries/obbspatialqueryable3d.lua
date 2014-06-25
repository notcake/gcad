local self = {}
GCAD.OBBSpatialQueryable3d = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

function self:ctor ()
	self.ObjectHandles     = {}
	self.ObjectHandles2    = {}
	self.BoundingSphere3ds = {}
	self.OBB3ds            = {}
end

-- ISpatialQueryable3d
function self:FindInFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	-- Get array of handles for all objects
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindInFrustum : Get object handle array")
	self.ObjectHandles = self:GetObjectHandles (self.ObjectHandles)
	GCAD.Profiler:End ()
	
	local objectHandles  = self.ObjectHandles
	local objectHandles2 = self.ObjectHandles2
	
	-- Compute bounding spheres for objects
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindInFrustum : Compute bounding spheres", #objectHandles)
	self.BoundingSphere3ds = self:GetBoundingSpheres (objectHandles, self.BoundingSphere3ds)
	GCAD.Profiler:End ()
	
	-- Run bounding sphere tests
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindInFrustum : Sphere tests", #objectHandles)
	local boundingSphere3ds = self.BoundingSphere3ds
	for i = 1, #objectHandles do
		local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (boundingSphere3ds [i])
		if intersectsSphere then
			if containsSphere then
				spatialQueryResult:Add (self:GetObject (objectHandles [i]), true)
			else
				objectHandles2 [#objectHandles2 + 1] = objectHandles [i]
			end
		end
		objectHandles [i] = nil
	end
	GCAD.Profiler:End ()
	
	-- Compute OBBs for objects requiring further testing
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindInFrustum : Compute OBBs", #objectHandles2)
	self.OBB3ds = self:GetOBBs (objectHandles2, self.OBB3ds)
	GCAD.Profiler:End ()
	
	-- Run OBB tests
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindInFrustum : OBB tests", #objectHandles2)
	local obb3ds = self.OBB3ds
	for i = 1, #objectHandles2 do
		if frustum3d:ContainsOBB (obb3ds [i]) then
			spatialQueryResult:Add (self:GetObject (objectHandles2 [i]), true)
		end
		objectHandles2 [i] = nil
	end
	GCAD.Profiler:End ()
	
	return spatialQueryResult
end
self.FindInFrustum = GCAD.Profiler:Wrap (self.FindInFrustum, "OBBSpatialQueryable3d:FindInFrustum")

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	-- Get array of handles for all objects
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindIntersectingFrustum : Get object handle array")
	self.ObjectHandles = self:GetObjectHandles (self.ObjectHandles)
	GCAD.Profiler:End ()
	
	local objectHandles  = self.ObjectHandles
	local objectHandles2 = self.ObjectHandles2
	
	-- Compute bounding spheres for objects
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindIntersectingFrustum : Compute bounding spheres", #objectHandles)
	self.BoundingSphere3ds = self:GetBoundingSpheres (objectHandles, self.BoundingSphere3ds)
	GCAD.Profiler:End ()
	
	-- Run bounding sphere tests
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindIntersectingFrustum : Sphere tests", #objectHandles)
	local boundingSphere3ds = self.BoundingSphere3ds
	for i = 1, #objectHandles do
		local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (boundingSphere3ds [i])
		if intersectsSphere then
			if containsSphere then
				spatialQueryResult:Add (self:GetObject (objectHandles [i]), true)
			else
				objectHandles2 [#objectHandles2 + 1] = objectHandles [i]
			end
		end
		objectHandles [i] = nil
	end
	GCAD.Profiler:End ()
	
	-- Compute OBBs for objects requiring further testing
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindIntersectingFrustum : Compute OBBs", #objectHandles2)
	self.OBB3ds = self:GetOBBs (objectHandles2, self.OBB3ds)
	GCAD.Profiler:End ()
	
	-- Run OBB tests
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:FindIntersectingFrustum : OBB tests", #objectHandles2)
	local obb3ds = self.OBB3ds
	for i = 1, #objectHandles2 do
		if frustum3d:IntersectsOBB (obb3ds [i]) then
			spatialQueryResult:Add (self:GetObject (objectHandles2 [i]))
		end
		objectHandles2 [i] = nil
	end
	GCAD.Profiler:End ()
	
	return spatialQueryResult
end
self.FindIntersectingFrustum = GCAD.Profiler:Wrap (self.FindIntersectingFrustum, "OBBSpatialQueryable3d:FindIntersectingFrustum")

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	-- Get array of handles for all objects
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:TraceLine : Get object handle array")
	self.ObjectHandles = self:GetObjectHandles (self.ObjectHandles)
	GCAD.Profiler:End ()
	
	local objectHandles  = self.ObjectHandles
	local objectHandles2 = self.ObjectHandles2
	
	-- Compute bounding spheres for objects
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:TraceLine : Compute bounding spheres", #objectHandles)
	self.BoundingSphere3ds = self:GetBoundingSpheres (objectHandles, self.BoundingSphere3ds)
	GCAD.Profiler:End ()
	
	-- Run bounding sphere tests
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:TraceLine : Sphere tests", #objectHandles)
	local boundingSphere3ds = self.BoundingSphere3ds
	for i = 1, #objectHandles do
		if boundingSphere3ds [i]:IntersectsLine (line3d) then
			objectHandles2 [#objectHandles2 + 1] = objectHandles [i]
		end
		objectHandles [i] = nil
	end
	GCAD.Profiler:End ()
	
	-- Compute OBBs for objects requiring further testing
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:TraceLine : Compute OBBs", #objectHandles2)
	self.OBB3ds = self:GetOBBs (objectHandles2, self.OBB3ds)
	GCAD.Profiler:End ()
	
	-- Run OBB tests
	GCAD.Profiler:Begin ("OBBSpatialQueryable3d:TraceLine : OBB tests", #objectHandles2)
	local obb3ds = self.OBB3ds
	for i = 1, #objectHandles2 do
		local tStart, tEnd = obb3ds [i]:IntersectLine (line3d)
		
		if tStart then
			lineTraceResult:AddIntersectionSpan (self:GetObject (objectHandles2 [i]), tStart, tEnd)
		end
		objectHandles2 [i] = nil
	end
	GCAD.Profiler:End ()
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "OBBSpatialQueryable3d:TraceLine")

-- OBBSpatialQueryable3d
function self:GetObjectHandleEnumerator ()
end

function self:GetBoundingSphere (objectHandle, sphere3d)
end

function self:GetOBB (objectHandle, obb3d)
end

function self:GetObject (objectHandle)
end
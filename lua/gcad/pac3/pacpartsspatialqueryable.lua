local self = {}
GCAD.PACPartsSpatialQueryable = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

function self:ctor ()
	self.PACPartReferenceCache = GCAD.MapCache (GCAD.VEntities.PACPartReference.FromPACPart)
end

-- ISpatialQueryable3d
local sphere3d = GCAD.Sphere3d ()
local obb3d    = GCAD.OBB3d ()

function self:FindInFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	-- Get all parts
	GCAD.Profiler:Begin ("pac.GetParts")
	local parts = pac.GetParts ()
	GCAD.Profiler:End ()
	
	for _, part in pairs (parts) do
		if part.ClassName == "model" then
			local entity = part.Entity
			if entity and entity:IsValid () then
				-- Sphere culling
				GCAD.Profiler:Begin ("PACPartsSpatialQueryable:FindInFrustum : Sphere cull")
				sphere3d = GCAD.Sphere3d.FromPACPartBoundingSphere (part, sphere3d)
				local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (sphere3d)
				GCAD.Profiler:End ()
				
				-- OBB intersection
				if intersectsSphere then
					local contained = containsSphere
					if not contained then
						obb3d = GCAD.OBB3d.FromPACPart (part, obb3d)
						contained = frustum3d:ContainsOBB (obb3d)
					end
					
					if contained then
						spatialQueryResult:Add (self.PACPartReferenceCache:Get (part), true)
					end
				end
			end
		end
	end
	
	return spatialQueryResult
end
self.FindInFrustum = GCAD.Profiler:Wrap (self.FindInFrustum, "PACPartsSpatialQueryable:FindInFrustum")

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	-- Get all parts
	GCAD.Profiler:Begin ("pac.GetParts")
	local parts = pac.GetParts ()
	GCAD.Profiler:End ()
	
	for _, part in pairs (parts) do
		if part.ClassName == "model" then
			local entity = part.Entity
			if entity and entity:IsValid () then
				-- Sphere culling
				GCAD.Profiler:Begin ("PACPartsSpatialQueryable:FindIntersectingFrustum : Sphere cull")
				sphere3d = GCAD.Sphere3d.FromPACPartBoundingSphere (part, sphere3d)
				local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (sphere3d)
				GCAD.Profiler:End ()
				
				-- OBB intersection
				if intersectsSphere then
					if containsSphere then
						spatialQueryResult:Add (self.PACPartReferenceCache:Get (part), true)
					else
						obb3d = GCAD.OBB3d.FromPACPart (part, obb3d)
						if frustum3d:IntersectsOBB (obb3d) then
							spatialQueryResult:Add (self.PACPartReferenceCache:Get (part))
						end
					end
				end
			end
		end
	end
	
	return spatialQueryResult
end
self.FindIntersectingFrustum = GCAD.Profiler:Wrap (self.FindIntersectingFrustum, "PACPartsSpatialQueryable:FindIntersectingFrustum")

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	-- Get all parts
	GCAD.Profiler:Begin ("pac.GetParts")
	local parts = pac.GetParts ()
	GCAD.Profiler:End ()
	
	-- Check intersections for all entities
	for _, part in pairs (parts) do
		if part.ClassName == "model" then
			local entity = part.Entity
			if entity and entity:IsValid () then
				-- Sphere culling
				GCAD.Profiler:Begin ("PACPartsSpatialQueryable:TraceLine : Sphere cull")
				sphere3d = GCAD.Sphere3d.FromPACPartBoundingSphere (part, sphere3d)
				local intersectsSphere = sphere3d:IntersectsLine (line3d)
				GCAD.Profiler:End ()
				
				if intersectsSphere then
					obb = GCAD.OBB3d.FromPACPart (part, obb)
					local tStart, tEnd = obb:IntersectLine (line3d)
					
					if tStart then
						lineTraceResult:AddIntersectionSpan (self.PACPartReferenceCache:Get (part), tStart, tEnd)
					end
				end
			end
		end
	end
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "PACPartsSpatialQueryable:TraceLine")

-- PACPartsSpatialQueryable
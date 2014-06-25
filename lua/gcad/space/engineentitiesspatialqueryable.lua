local self = {}
GCAD.EngineEntitiesSpatialQueryable = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

local Entity_GetOwner       = debug.getregistry ().Entity.GetOwner
local Entity_IsEffectActive = debug.getregistry ().Entity.IsEffectActive

local EF_NODRAW             = EF_NODRAW

function self:ctor ()
	self.EntityReferenceCache = GCAD.MapCache (GCAD.VEntities.EntityReference.FromEntity)
end

-- ISpatialQueryable3d
local sphere3d = GCAD.Sphere3d ()
local obb3d    = GCAD.OBB3d ()

function self:FindInFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	-- Get all entities
	GCAD.Profiler:Begin ("ents.GetAll")
	local entities = ents.GetAll ()
	GCAD.Profiler:End ()
	
	local localPlayer = LocalPlayer ()
	
	for _, v in ipairs (entities) do
		if not Entity_IsEffectActive (v, EF_NODRAW) and
		   v ~= localPlayer and
		   not Entity_GetOwner (v):IsPlayer () then
			-- Sphere culling
			GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:FindInFrustum : Sphere cull")
			sphere3d = GCAD.Sphere3d.FromEntityBoundingSphere (v, sphere3d)
			local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (sphere3d)
			GCAD.Profiler:End ()
			
			-- OBB containment
			if intersectsSphere then
				local contained = containsSphere
				if not contained then
					obb3d = GCAD.OBB3d.FromEntity (v, obb3d)
					contained = frustum3d:ContainsOBB (obb3d)
				end
				
				if contained then
					spatialQueryResult:Add (self.EntityReferenceCache:Get (v), true)
				end
			end
		end
	end
	
	return spatialQueryResult
end
self.FindInFrustum = GCAD.Profiler:Wrap (self.FindInFrustum, "EngineEntitiesSpatialQueryable:FindInFrustum")

function self:FindIntersectingFrustum (frustum3d, spatialQueryResult)
	spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
	
	-- Get all entities
	GCAD.Profiler:Begin ("ents.GetAll")
	local entities = ents.GetAll ()
	GCAD.Profiler:End ()
	
	local localPlayer = LocalPlayer ()
	
	for _, v in ipairs (entities) do
		if not Entity_IsEffectActive (v, EF_NODRAW) and
		   v ~= localPlayer and
		   not Entity_GetOwner (v):IsPlayer () then
			-- Sphere culling
			--GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:FindIntersectingFrustum : Sphere cull")
			sphere3d = GCAD.Sphere3d.FromEntityBoundingSphere (v, sphere3d)
			local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (sphere3d)
			--GCAD.Profiler:End ()
			
			-- OBB intersection
			if intersectsSphere then
				if containsSphere then
					spatialQueryResult:Add (self.EntityReferenceCache:Get (v), true)
				else
					obb3d = GCAD.OBB3d.FromEntity (v, obb3d)
					if frustum3d:IntersectsOBB (obb3d) then
						spatialQueryResult:Add (self.EntityReferenceCache:Get (v))
					end
				end
			end
		end
	end
	
	return spatialQueryResult
end
self.FindIntersectingFrustum = GCAD.Profiler:Wrap (self.FindIntersectingFrustum, "EngineEntitiesSpatialQueryable:FindIntersectingFrustum")

local traceData = {}
traceData.start  = Vector ()
traceData.endpos = Vector ()
traceData.mask   = CONTENTS_SOLID

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
	lineTraceResult:SetLine (line3d)
	
	-- Calculate the first world intersection
	GCAD.Profiler:Begin ("util.TraceLine")
	traceData.start  = line3d:GetPositionNative (traceData.start)
	local x, y, z = GCAD.UnpackedVector3d.ScalarVectorMultiply (math.sqrt (3 * 32768 * 32768), line3d:GetDirectionUnpacked ())
	x, y, z = GCAD.UnpackedVector3d.Add (x, y, z, line3d:GetPositionUnpacked ())
	traceData.endpos = GCAD.UnpackedVector3d.ToNativeVector (x, y, z, traceData.endpos)
	
	local traceResult = util.TraceLine (traceData)
	lineTraceResult:AddEntryIntersection (self.EntityReferenceCache:Get (SERVER and game.GetWorld () or Entity (0)), traceResult.Fraction * math.sqrt (3 * 32768 * 32768) / line3d:GetDirectionLength ())
	GCAD.Profiler:End ()
	
	-- Get all entities
	GCAD.Profiler:Begin ("ents.GetAll")
	local entities = ents.GetAll ()
	GCAD.Profiler:End ()
	
	-- Check intersections for all entities
	local localPlayer = LocalPlayer ()
	for _, v in ipairs (entities) do
		if not Entity_IsEffectActive (v, EF_NODRAW) and
		   v ~= localPlayer and
		   not Entity_GetOwner (v):IsPlayer () then
			-- Sphere culling
			--GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:TraceLine : Sphere cull")
			sphere3d = GCAD.Sphere3d.FromEntityBoundingSphere (v, sphere3d)
			local intersectsSphere = sphere3d:IntersectsLine (line3d)
			--GCAD.Profiler:End ()
			
			if intersectsSphere then
				obb3d = GCAD.OBB3d.FromEntity (v, obb3d)
				local tStart, tEnd = obb3d:IntersectLine (line3d)
				
				if tStart then
					lineTraceResult:AddIntersectionSpan (self.EntityReferenceCache:Get (v), tStart, tEnd)
				end
			end
		end
	end
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "EngineEntitiesSpatialQueryable:TraceLine")

-- EngineEntitiesSpatialQueryable
function self:GetEntityReference (ent)
	if not self.EntityReferenceCache:Contains (ent) then return nil end
	
	return self.EntityReferenceCache:Get (ent)
end
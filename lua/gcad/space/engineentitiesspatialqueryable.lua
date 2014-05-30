local self = {}
GCAD.EngineEntitiesSpatialQueryable = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

local Entity_GetOwner       = debug.getregistry ().Entity.GetOwner
local Entity_IsEffectActive = debug.getregistry ().Entity.IsEffectActive
local EF_NODRAW = EF_NODRAW

local sphere3d        = GCAD.Sphere3d ()
local obb             = GCAD.OBB3d ()

function self:ctor ()
end

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
			GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:FindIntersectingFrustum : Sphere cull")
			sphere3d = GCAD.Sphere3d.FromEntityBoundingSphere (v, sphere3d)
			local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (sphere3d)
			GCAD.Profiler:End ()
			
			if intersectsSphere then
				local contained = containsSphere
				if not contained then
					obb = GCAD.OBB3d.FromEntity (v, obb)
					contained = frustum3d:ContainsOBB (obb)
				end
				
				if contained then
					spatialQueryResult:Add (v)
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
			GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:FindIntersectingFrustum : Sphere cull")
			sphere3d = GCAD.Sphere3d.FromEntityBoundingSphere (v, sphere3d)
			local intersectsSphere, containsSphere = frustum3d:IntersectsSphere (sphere3d)
			GCAD.Profiler:End ()
			
			if intersectsSphere then
				local contained = containsSphere
				if not contained then
					obb = GCAD.OBB3d.FromEntity (v, obb)
					contained = frustum3d:IntersectsOBB (obb)
				end
				
				if contained then
					spatialQueryResult:Add (v)
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
	
	-- Calculate the first world intersection
	GCAD.Profiler:Begin ("util.TraceLine")
	traceData.start  = line3d:GetPositionNative (traceData.start)
	local x, y, z = GCAD.UnpackedVector3d.ScalarVectorMultiply (math.sqrt (3 * 32768 * 32768), line3d:GetDirectionUnpacked ())
	x, y, z = GCAD.UnpackedVector3d.Add (x, y, z, line3d:GetPositionUnpacked ())
	traceData.endpos = GCAD.UnpackedVector3d.ToNativeVector (x, y, z, traceData.endpos)
	
	local traceResult = util.TraceLine (traceData)
	lineTraceResult:AddEntryIntersection (SERVER and game.GetWorld () or Entity (0), traceResult.Fraction * math.sqrt (3 * 32768 * 32768) / line3d:GetDirectionLength ())
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
			GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:TraceLine : Sphere cull")
			sphere3d = GCAD.Sphere3d.FromEntityBoundingSphere (v, sphere3d)
			local intersectsSphere = sphere3d:IntersectsLine (line3d)
			GCAD.Profiler:End ()
			
			if intersectsSphere then
				obb = GCAD.OBB3d.FromEntity (v, obb)
				local tStart, tEnd = obb:IntersectLine (line3d)
				
				if tStart then
					lineTraceResult:AddIntersectionSpan (v, tStart, tEnd)
				end
			end
		end
	end
	
	return lineTraceResult
end
self.TraceLine = GCAD.Profiler:Wrap (self.TraceLine, "EngineEntitiesSpatialQueryable:TraceLine")

GCAD.EngineEntitiesSpatialQueryable = GCAD.EngineEntitiesSpatialQueryable ()
local self = {}
GCAD.EngineEntitiesSpatialQueryable = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

local Entity_GetOwner       = debug.getregistry ().Entity.GetOwner
local Entity_IsEffectActive = debug.getregistry ().Entity.IsEffectActive
local EF_NODRAW = EF_NODRAW

function self:ctor ()
end

local sphere3d        = GCAD.Sphere3d ()
local obb             = GCAD.OBB3d ()

function self:FindInFrustum (frustum3d, spatialQueryResults)
	GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:FindInFrustum")
	
	spatialQueryResults = spatialQueryResults or GCAD.SpatialQueryResults ()
	GCAD.Profiler:Begin ("ents.GetAll")
	local entities = ents.GetAll ()
	GCAD.Profiler:End ()
	
	local localPlayer = LocalPlayer ()
	
	for _, v in ipairs (entities) do
		if not Entity_IsEffectActive (v, EF_NODRAW) and
		   v ~= localPlayer and
		   not Entity_GetOwner (v):IsPlayer () then
			
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
					spatialQueryResults:Add (v)
				end
			end
		end
	end
	
	GCAD.Profiler:End ()
	return spatialQueryResults
end

function self:FindIntersectingFrustum (frustum3d, spatialQueryResults)
	GCAD.Profiler:Begin ("EngineEntitiesSpatialQueryable:FindIntersectingFrustum")
	
	spatialQueryResults = spatialQueryResults or GCAD.SpatialQueryResults ()
	
	GCAD.Profiler:Begin ("ents.GetAll")
	local entities = ents.GetAll ()
	GCAD.Profiler:End ()
	
	local localPlayer = LocalPlayer ()
	
	for _, v in ipairs (entities) do
		if not Entity_IsEffectActive (v, EF_NODRAW) and
		   v ~= localPlayer and
		   not Entity_GetOwner (v):IsPlayer () then
			
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
					spatialQueryResults:Add (v)
				end
			end
		end
	end
	
	GCAD.Profiler:End ()
	return spatialQueryResults
end

GCAD.EngineEntitiesSpatialQueryable = GCAD.EngineEntitiesSpatialQueryable ()
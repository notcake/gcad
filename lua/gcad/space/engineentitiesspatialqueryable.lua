local self = {}
GCAD.EngineEntitiesSpatialQueryable = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

local Entity_GetOwner       = debug.getregistry ().Entity.GetOwner
local Entity_IsEffectActive = debug.getregistry ().Entity.IsEffectActive
local EF_NODRAW = EF_NODRAW

function self:ctor ()
end

local boundingSphere = GCAD.NativeSphere3d ()
local obb            = GCAD.OBB3d ()

local vec1 = GLib.ColumnVector (3)

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
			
			boundingSphere = GCAD.NativeSphere3d.FromEntity (v, boundingSphere)
			local intersectsSphere, containsSphere = frustum3d:IntersectsNativeSphere (boundingSphere)
			
			if intersectsSphere then
				local contained = containsSphere
				if not contained then
					obb = GCAD.OBB3d.FromEntity (v, obb)
					contained = frustum3d:ContainsVertices (obb, vec1)
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
			
			boundingSphere = GCAD.NativeSphere3d.FromEntity (v, boundingSphere)
			local intersectsSphere, containsSphere = frustum3d:IntersectsNativeSphere (boundingSphere)
			
			if intersectsSphere then
				local contained = containsSphere
				if not contained then
					obb = GCAD.OBB3d.FromEntity (v, obb)
					contained = frustum3d:ContainsAnyVertex (obb, vec1)
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
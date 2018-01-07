local self = {}
GCAD.PACPartList = GCAD.MakeConstructor (self, GCAD.OBBSpatialQueryable3d)

local Entity_IsValid = debug.getregistry ().Entity.IsValid

local GCAD_Sphere3d_FromPACPartBoundingSphere = GCAD.Sphere3d.FromPACPartBoundingSphere
local GCAD_OBB3d_FromPACPart                  = GCAD.OBB3d.FromPACPart

function self:ctor ()
	self.PACPartReferenceCache = GCAD.MapCache (GCAD.VEntities.PACPartReference.FromPACPart)
	
	-- Set up profiling
	for methodName, v in pairs (self.__base.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "PACPartList:" .. methodName)
		end
	end
end

-- OBBSpatialQueryable3d
function self:GetObject (objectHandle)
	return self.PACPartReferenceCache:Get (objectHandle)
end

function self:GetObjectHandles (out)
	if not pac or not pac.GetLocalParts then return out end
	
	local _, uniqueIdParts = debug.getupvalue (pac.GetLocalParts, 1)
	if not uniqueIdParts then return out end
	
	GCAD.Profiler:Begin ("PACPartList : Filter parts")
	for _, parts in pairs (uniqueIdParts) do
		for _, part in pairs (parts) do
			if part.ClassName == "model" and
			   Entity_IsValid (part.Entity) then
				out [#out + 1] = part
			end
		end
	end
	GCAD.Profiler:End ()
	
	return out
end

function self:GetBoundingSpheres (objectHandles, out)
	local objectHandleCount = #objectHandles
	for i = 1, #objectHandles do
		out [i] = GCAD_Sphere3d_FromPACPartBoundingSphere (objectHandles [i], out [i])
	end
	
	return out
end

function self:GetOBBs (objectHandles, out)
	local objectHandleCount = #objectHandles
	for i = 1, objectHandleCount do
		out [i] = GCAD_OBB3d_FromPACPart (objectHandles [i], out [i])
	end
	
	return out
end
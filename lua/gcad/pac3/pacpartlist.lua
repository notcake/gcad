local self = {}
GCAD.PACPartList = GCAD.MakeConstructor (self, GCAD.OBBSpatialQueryable3d)

local Entity_IsValid = debug.getregistry ().Entity.IsValid

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
	GCAD.Profiler:Begin ("ents.GetAll")
	local parts = pac and pac.GetParts () or {}
	GCAD.Profiler:End ()
	
	local localPlayer = LocalPlayer ()
	
	GCAD.Profiler:Begin ("PACPartList : Filter parts", #parts)
	for _, part in pairs (parts) do
		if part.ClassName == "model" and
		   Entity_IsValid (part.Entity) then
			out [#out + 1] = part
		end
	end
	GCAD.Profiler:End ()
	
	return out
end

function self:GetBoundingSpheres (objectHandles, out)
	for i = 1, #objectHandles do
		out [i] = GCAD.Sphere3d.FromPACPartBoundingSphere (objectHandles [i], out [i])
	end
	
	return out
end

function self:GetOBBs (objectHandles, out)
	for i = 1, #objectHandles do
		out [i] = GCAD.OBB3d.FromPACPart (objectHandles [i], out [i])
	end
	
	return out
end
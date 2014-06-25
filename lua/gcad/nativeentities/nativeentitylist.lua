local self = {}
GCAD.NativeEntityList = GCAD.MakeConstructor (self, GCAD.OBBSpatialQueryable3d)

local Entity_GetOwner       = debug.getregistry ().Entity.GetOwner
local Entity_IsEffectActive = debug.getregistry ().Entity.IsEffectActive

local EF_NODRAW             = EF_NODRAW

function self:ctor ()
	self.EntityReferenceCache = GCAD.MapCache (GCAD.VEntities.EntityReference.FromEntity)
	
	-- Set up profiling
	for methodName, v in pairs (self.__base.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "NativeEntityList:" .. methodName)
		end
	end
end

-- ISpatialQueryable3d
local traceData = {}
traceData.start  = Vector ()
traceData.endpos = Vector ()
traceData.mask   = CONTENTS_SOLID

function self:TraceLine (line3d, lineTraceResult)
	lineTraceResult = self.__base.TraceLine (self, line3d, lineTraceResult)
	
	-- Calculate the first world intersection
	GCAD.Profiler:Begin ("util.TraceLine")
	traceData.start = line3d:GetPositionNative (traceData.start)
	local x, y, z = GCAD.UnpackedVector3d.ScalarVectorMultiply (math.sqrt (3 * 32768 * 32768), line3d:GetDirectionUnpacked ())
	x, y, z = GCAD.UnpackedVector3d.Add (x, y, z, line3d:GetPositionUnpacked ())
	traceData.endpos = GCAD.UnpackedVector3d.ToNativeVector (x, y, z, traceData.endpos)
	
	local traceResult = util.TraceLine (traceData)
	lineTraceResult:AddEntryIntersection (self.EntityReferenceCache:Get (SERVER and game.GetWorld () or Entity (0)), traceResult.Fraction * math.sqrt (3 * 32768 * 32768) / line3d:GetDirectionLength ())
	GCAD.Profiler:End ()
	
	return lineTraceResult
end

-- OBBSpatialQueryable3d
function self:GetObject (objectHandle)
	return self.EntityReferenceCache:Get (objectHandle)
end

function self:GetObjectHandles (out)
	GCAD.Profiler:Begin ("ents.GetAll")
	local entities = ents.GetAll ()
	GCAD.Profiler:End ()
	
	local localPlayer = LocalPlayer ()
	
	GCAD.Profiler:Begin ("NativeEntityList : Filter entities", #entities)
	for i = 1, #entities do
		if not Entity_IsEffectActive (entities [i], EF_NODRAW) and
		   entities [i] ~= localPlayer and
		   not Entity_GetOwner (entities [i]):IsPlayer () then
			out [#out + 1] = entities [i]
		end
	end
	GCAD.Profiler:End ()
	
	return out
end

function self:GetBoundingSpheres (objectHandles, out)
	local objectHandleCount = #objectHandles
	for i = 1, objectHandleCount do
		out [i] = GCAD.Sphere3d.FromEntityBoundingSphere (objectHandles [i], out [i])
	end
	
	return out
end

function self:GetOBBs (objectHandles, out)
	local objectHandleCount = #objectHandles
	for i = 1, objectHandleCount do
		out [i] = GCAD.OBB3d.FromEntity (objectHandles [i], out [i])
	end
	
	return out
end
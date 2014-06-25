local self = {}
GCAD.AggregateSpatialQueryable3d = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable3d)

function self:ctor ()
	self.SpatialQueryables = {}
	
	self.TemporarySpatialQueryResult = GCAD.SpatialQueryResult ()
	self.TemporaryLineTraceResult    = GCAD.LineTraceResult ()
	
	-- Set up profiling
	for methodName, v in pairs (self.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "AggregateSpatialQueryable3d:" .. methodName)
		end
	end
end

-- ISpatialQueryable3d
local regionQueryFunctions =
{
	"FindInAABB",
	"FindIntersectingAABB",
	"FindInSphere",
	"FindIntersectingSphere",
	"FindInPlane",
	"FindIntersectingPlane",
	"FindInFrustum",
	"FindIntersectingFrustum"
}

for _, queryMethodName in ipairs (regionQueryFunctions) do
	self [queryMethodName] = function (self, region, spatialQueryResult)
		spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
		
		for spatialQueryable in self:GetSpatialQueryableEnumerator () do
			self.TemporarySpatialQueryResult = spatialQueryable [queryMethodName] (spatialQueryable, region, self.TemporarySpatialQueryResult)
			for object, fullyContained in self.TemporarySpatialQueryResult:GetEnumerator () do
				spatialQueryResult:Add (object, fullyContained)
			end
			self.TemporarySpatialQueryResult:Clear ()
		end
		
		return spatialQueryResult
	end
end

local lineQueryFunctions =
{
	"TraceLine"
}

for _, queryMethodName in ipairs (lineQueryFunctions) do
	self [queryMethodName] = function (self, line, lineTraceResult)
		lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
		lineTraceResult:SetLine (line)
		
		for spatialQueryable in self:GetSpatialQueryableEnumerator () do
			self.TemporaryLineTraceResult:SetMinimumParameter (lineTraceResult:GetMinimumParameter ())
			self.TemporaryLineTraceResult:SetMaximumParameter (lineTraceResult:GetMaximumParameter ())
			self.TemporaryLineTraceResult = spatialQueryable [queryMethodName] (spatialQueryable, line, self.TemporaryLineTraceResult)
			for object, t, intersectionType in self.TemporaryLineTraceResult:GetFullIntersectionEnumerator () do
				lineTraceResult:AddIntersection (object, t, intersectionType, true)
			end
			self.TemporaryLineTraceResult:Clear ()
		end
		
		return lineTraceResult
	end
end

-- AggregateSpatialQueryable3d
function self:AddSpatialQueryable (spatialQueryable3d)
	if self:ContainsSpatialQueryable (spatialQueryable3d) then return end
	
	self.SpatialQueryables [spatialQueryable3d] = true
end

function self:ContainsSpatialQueryable (spatialQueryable3d)
	return self.SpatialQueryables [spatialQueryable3d] ~= nil
end

function self:GetSpatialQueryableEnumerator ()
	return GLib.KeyEnumerator (self.SpatialQueryables)
end

function self:RemoveSpatialQueryable (spatialQueryable3d)
	if not self:ContainsSpatialQueryable (spatialQueryable3d) then return end
	
	self.SpatialQueryables [spatialQueryable3d] = nil
end
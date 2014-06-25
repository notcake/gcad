local self = {}
GCAD.AggregateSpatialQueryable2d = GCAD.MakeConstructor (self, GCAD.ISpatialQueryable2d)

function self:ctor ()
	self.SpatialQueryables = {}
	
	self.TemporarySpatialQueryResult = GCAD.SpatialQueryResult ()
	self.TemporaryLineTraceResult    = GCAD.LineTraceResult ()
	
	-- Set up profiling
	for methodName, v in pairs (self.__base) do
		if isfunction (v) then
			self [methodName] = GCAD.Profiler:Wrap (self [methodName], "AggregateSpatialQueryable2d:" .. methodName)
		end
	end
end

-- ISpatialQueryable2d
local regionQueryFunctions =
{
	"FindInAABB",
	"FindIntersectingAABB",
	"FindInCircle",
	"FindIntersectingCircle",
	"FindInPlane",
	"FindIntersectingPlane",
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

-- AggregateSpatialQueryable2d
function self:AddSpatialQueryable (spatialQueryable2d)
	if self:ContainsSpatialQueryable (spatialQueryable2d) then return end
	
	self.SpatialQueryables [spatialQueryable2d] = true
end

function self:ContainsSpatialQueryable (spatialQueryable2d)
	return self.SpatialQueryables [spatialQueryable2d] ~= nil
end

function self:GetSpatialQueryableEnumerator ()
	return GLib.KeyEnumerator (self.SpatialQueryables)
end

function self:RemoveSpatialQueryable (spatialQueryable2d)
	if not self:ContainsSpatialQueryable (spatialQueryable2d) then return end
	
	self.SpatialQueryables [spatialQueryable2d] = nil
end
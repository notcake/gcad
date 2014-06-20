local self = {}
GCAD.AggregateSpatialQueryable2d = GCAD.MakeConstructor (self, ISpatialQueryable2d)

function self:ctor ()
	self.SpatialQueryables = {}
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

local tempSpatialQueryResult = GCAD.SpatialQueryResult ()
for _, queryMethodName in ipairs (regionQueryFunctions) do
	self [queryMethodName] = function (self, region, spatialQueryResult)
		spatialQueryResult = spatialQueryResult or GCAD.SpatialQueryResult ()
		
		for spatialQueryable in self:GetSpatialQueryableEnumerator () do
			local tempSpatialQueryResult = spatialQueryable [queryMethodName] (spatialQueryable, region, tempSpatialQueryResult)
			for object, fullyContained in tempSpatialQueryResult:GetEnumerator () do
				spatialQueryResult:Add (object, fullyContained)
			end
			tempSpatialQueryResult:Clear ()
		end
		
		return spatialQueryResult
	end
end

local lineQueryFunctions =
{
	"TraceLine"
}

local tempLineTraceResult = GCAD.LineTraceResult ()
for _, queryMethodName in ipairs (lineQueryFunctions) do
	self [queryMethodName] = function (self, line, lineTraceResult)
		lineTraceResult = lineTraceResult or GCAD.LineTraceResult ()
		lineTraceResult:SetLine (line)
		
		for spatialQueryable in self:GetSpatialQueryableEnumerator () do
			tempLineTraceResult:SetMinimumParameter (lineTraceResult:GetMinimumParameter ())
			tempLineTraceResult:SetMaximumParameter (lineTraceResult:GetMaximumParameter ())
			local tempLineTraceResult = spatialQueryable [queryMethodName] (spatialQueryable, line, tempLineTraceResult)
			for object, t, intersectionType in tempLineTraceResult:GetFullIntersectionEnumerator () do
				lineTraceResult:AddIntersection (object, t, intersectionType, true)
			end
			tempLineTraceResult:Clear ()
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
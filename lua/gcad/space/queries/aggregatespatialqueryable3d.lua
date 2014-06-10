local self = {}
GCAD.AggregateSpatialQueryable3d = GCAD.MakeConstructor (self, ISpatialQueryable3d)

function self:ctor ()
	self.SpatialQueryables = {}
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
		lineTraceResult:SetLine (line3d)
		
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
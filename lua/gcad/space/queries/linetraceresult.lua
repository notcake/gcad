local self = {}
GCAD.LineTraceResult = GCAD.MakeConstructor (self)

local math_huge                          = math.huge
local table_sort                         = table.sort

local GCAD_UnpackedRange1d_ContainsPoint = GCAD.UnpackedRange1d.ContainsPoint
local GCAD_UnpackedRange1d_Intersect     = GCAD.UnpackedRange1d.Intersect
local GCAD_UnpackedRange1d_IsEmpty       = GCAD.UnpackedRange1d.IsEmpty

function self:ctor ()
	self.MinimumParameter = -math_huge
	self.MaximumParameter =  math_huge
	
	self:Clear ()
end

-- Parameter range
function self:SetMinimumParameter (tMin)
	self.MinimumParameter = tMin
	
	return self
end

function self:SetMaximumParameter (tMax)
	self.MaximumParameter = tMax
	
	return self
end

function self:SetParameterRange (tMin, tMax)
	self.MinimumParameter = tMin
	self.MaximumParameter = tMax
	
	return self
end

-- Intersection insertion
function self:AddEntryIntersection (object, t, forceAdd)
	self:AddIntersection (object, t, GCAD.LineTraceIntersectionType.Entry, forceAdd)
end

function self:AddExitIntersection (object, t, forceAdd)
	self:AddIntersection (object, t, GCAD.LineTraceIntersectionType.Exit,  forceAdd)
end

function self:AddIntersection (object, t, intersectionType, forceAdd)
	if not t                then return end
	if not intersectionType then return end
	
	local properIntersection = GCAD_UnpackedRange1d_ContainsPoint (self.MinimumParameter, self.MaximumParameter, t)
	if not forceAdd and
	   not properIntersection then
		return
	end
	
	self.SortedIntersectionIdsValid = false
	
	-- Assign intersection id
	local intersectionId = #self.IntersectionObjects + 1
	self.IntersectionObjects [intersectionId] = object
	
	-- Add to sorted intersection ids list
	self.SortedIntersectionIds [#self.SortedIntersectionIds + 1] = intersectionId
	
	-- Fill in intersection information
	self.IntersectionTypes      [intersectionId] = intersectionType
	self.IntersectionParameters [intersectionId] = t
	
	if properIntersection then
		self.IntersectingObjectSet [object] = true
	end
	
	if intersectionType == GCAD.LineTraceIntersectionType.Entry then
		self.ObjectEntryIds [object] = intersectionId
	elseif intersectionType == GCAD.LineTraceIntersectionType.Exit then
		self.ObjectExitIds  [object] = intersectionId
	elseif intersectionType == GCAD.LineTraceIntersectionType.Touch then
		self.ObjectEntryIds [object] = intersectionId
		self.ObjectExitIds  [object] = intersectionId
	end
end

function self:AddIntersectionSpan (object, tStart, tEnd, forceAdd)
	tStart = tStart or -math_huge
	tEnd   = tEnd   or  math_huge
	
	if not forceAdd and
	   GCAD_UnpackedRange1d_IsEmpty (GCAD_UnpackedRange1d_Intersect (self.MinimumParameter, self.MaximumParameter, tStart, tEnd)) then
		return
	end
	
	self:AddEntryIntersection (object, tStart, true)
	self:AddExitIntersection  (object, tEnd,   true)
end

function self:Clear ()
	self.SortedIntersectionIds = {}
	self.SortedIntersectionIdsValid = true
	self.IntersectionObjects    = {}
	self.IntersectionTypes      = {}
	self.IntersectionParameters = {}
	
	self.IntersectingObjectSet = {}
	self.ObjectEntryIds = {}
	self.ObjectExitIds  = {}
	
	self.FirstIntersectionIdId      = 1
	self.FirstEntryIntersectionIdId = nil
	self.FirstExitIntersectionIdId  = nil
	self.LastIntersectionIdId       = 0
	self.IntersectionCount          = 0
end

function self:Filter (f, out)
	if out == self then out = nil end
	out = out or GCAD.LineTraceResult ()
	
	for object, t, intersectionType in self:GetFullIntersectionEnumerator () do
		if f (object, t, intersectionType) then
			out:AddIntersection (object, t, intersectionType, true)
		end
	end
	
	return out
end

-- Intersection queries
function self:GetEnumerator ()
	return self:GetIntersectionEnumerator ()
end

function self:GetFirstEntryIntersection ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	return self:GetIntersection (self.FirstEntryIntersectionIdId)
end

function self:GetFirstExitIntersection ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	return self:GetIntersection (self.FirstExitIntersectionIdId)
end

function self:GetFirstIntersection ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	if self.IntersectionCount == 0 then return nil, nil, nil end
	
	return self:GetIntersection (self.FirstIntersectionIdId)
end

function self:GetFullIntersectionCount ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	return self.FirstIntersectionIdId - 1, self.IntersectionCount, #self.SortedIntersectionIds - self.LastIntersectionIdId
end

function self:GetFullIntersectionEnumerator ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	if not self.FirstIntersectionIdId then
		return GLib.NullEnumerator ()
	end
	
	local i = -self.FirstIntersectionIdId + 1
	
	return function ()
		i = i + 1
		
		return self:GetIntersection (i)
	end
end

function self:GetIntersectingObjectEnumerator ()
	return GCAD.KeyEnumerator (self.IntersectingObjectSet)
end

function self:GetIntersection (index)
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	local intersectionId = self.SortedIntersectionIds [self.FirstIntersectionIdId + index - 1]
	return self.IntersectionObjects [intersectionId], self.IntersectionParameters [intersectionId], self.IntersectionTypes [intersectionId]
end

function self:GetIntersectionCount ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	return self.IntersectionCount
end

function self:GetIntersectionEnumerator ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	if not self.FirstIntersectionIdId then
		return GLib.NullEnumerator ()
	end
	
	local i = 0
	
	return function ()
		i = i + 1
		
		if i > self.IntersectionCount then return nil end
		
		return self:GetIntersection (i)
	end
end

function self:IntersectsObject (object)
	return self.IntersectingObjectSet [object] ~= nil
end

function self:IsEmpty ()
	if not self.SortedIntersectionIdsValid then
		self:SortIntersectionIds ()
	end
	
	return self.IntersectionCount == 0
end

function self:IsFullyEmpty ()
	return #self.SortedIntersectionIds == 0
end

-- Internal, do not call
function self:SortIntersectionIds ()
	self.SortedIntersectionIdsValid = true
	
	self.FirstIntersectionIdId      = 1
	self.FirstEntryIntersectionIdId = nil
	self.FirstExitIntersectionIdId  = nil
	self.LastIntersectionIdId       = 0
	
	table_sort (self.SortedIntersectionIds,
		function (a, b)
			return self.IntersectionParameters [a] < self.IntersectionParameters [b]
		end
	)
	
	-- Update start and end intersection ids
	for i = 1, #self.SortedIntersectionIds do
		if self.IntersectionParameters [self.SortedIntersectionIds [i]] >= self.MinimumParameter then
			self.FirstIntersectionIdId = i
			break
		end
	end
	
	for i = 1, #self.SortedIntersectionIds do
		if self.IntersectionTypes [self.SortedIntersectionIds [i]] == GCAD.LineTraceIntersectionType.Entry and
		   self.IntersectionParameters [self.SortedIntersectionIds [i]] >= self.MinimumParameter then
			self.FirstEntryIntersectionIdId = i
			break
		end
	end
	
	for i = 1, #self.SortedIntersectionIds do
		if self.IntersectionTypes [self.SortedIntersectionIds [i]] == GCAD.LineTraceIntersectionType.Exit and
		   self.IntersectionParameters [self.SortedIntersectionIds [i]] >= self.MinimumParameter then
			self.FirstExitIntersectionIdId = i
			break
		end
	end
	
	for i = #self.SortedIntersectionIds, 1, -1 do
		if self.IntersectionParameters [self.SortedIntersectionIds [i]] <= self.MaximumParameter then
			self.LastIntersectionIdId = i
			break
		end
	end
	
	self.IntersectionCount = (self.LastIntersectionIdId or 0) - (self.FirstIntersectionIdId or 0) + 1
end
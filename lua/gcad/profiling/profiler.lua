local self = {}
GCAD.Profiler = GCAD.MakeConstructor (self)

function self:ctor ()
	self.ActiveSections = {}
	
	self.SectionStartTimes = {}
	
	self.SectionStack = {}
	
	self.SectionFrames = {}
	self.SectionDurations = {}
	self.SectionFrameCounts = {}
	self.SectionFrameDurations = {}
	self.SectionSmoothingCoefficients = {}
	
	self.SectionStackLevels = {}
	
	self.LastFrameNumber     = nil
	self.LastFrameSections   = {}
	self.LastFrameSectionSet = {}
	
	self.FrameNumber     = nil
	self.FrameSections   = {}
	self.FrameSectionSet = {}
end

function self:Begin (sectionName)
	self.ActiveSections [sectionName] = self.ActiveSections [sectionName] or 0
	self.ActiveSections [sectionName] = self.ActiveSections [sectionName] + 1
	
	if self.ActiveSections [sectionName] == 1 then
		self.SectionStartTimes [sectionName] = SysTime ()
	end
	
	-- Frame section ordering
	if self.FrameNumber ~= FrameNumber () then
		self:AdvanceFrame ()
	end
	
	if not self.FrameSectionSet [sectionName] then
		self.FrameSections [#self.FrameSections + 1] = sectionName
		self.FrameSectionSet [sectionName] = true
	end
	
	-- Section stack
	self.SectionStackLevels [sectionName] = #self.SectionStack
	self.SectionStack [#self.SectionStack + 1] = sectionName
end

function self:End (sectionName)
	sectionName = sectionName or self.SectionStack [#self.SectionStack]
	self.SectionStack [#self.SectionStack] = nil
	
	if not self.ActiveSections [sectionName] then
		GLib.Error ("GCAD.Profiler:End : Section " .. sectionName .. " is not active!")
	end
	
	self.ActiveSections [sectionName] = self.ActiveSections [sectionName] - 1
	if self.ActiveSections [sectionName] == 0 then
		self.ActiveSections [sectionName] = nil
		
		self:CreditSection (sectionName, SysTime () - self.SectionStartTimes [sectionName])
		self.SectionStartTimes [sectionName] = nil
	end
end

function self:GetEnumerator ()
	self:CheckFrame ()
	
	for _, sectionName in ipairs (self.LastFrameSections) do
		coroutine.yield (sectionName, self.SectionDurations [sectionName], self.SectionFrameDurations [sectionName], self.SectionFrameCounts [sectionName])
	end
end
self.GetEnumerator = GLib.YieldEnumeratorFactory (self.GetEnumerator)

function self:GetSectionCount ()
	self:CheckFrame ()
	
	return #self.LastFrameSections
end

function self:GetSectionDuration (sectionName)
	return self.SectionDurations [sectionName] or 0
end

function self:GetSectionFrameCount (sectionName)
	return self.SectionFrameCounts [sectionName] or 0
end

function self:GetSectionFrameDuration (sectionName)
	return self.SectionFrameDurations [sectionName] or 0
end

function self:GetSectionName (index)
	return self.LastFrameSections [index]
end

function self:GetSectionStackLevel (sectionName)
	return self.SectionStackLevels [sectionName] or 0
end

function self:Wrap (f, sectionName)
	return function (...)
		self:Begin (sectionName)
		local r1, r2, r3, r4 = f (...)
		self:End ()
		
		return r1, r2, r3, r4
	end
end

-- Internal, do not call
function self:AdvanceFrame ()
	self.LastFrameNumber     = self.FrameNumber
	self.LastFrameSections   = self.FrameSections
	self.LastFrameSectionSet = self.FrameSectionSet
	
	self.FrameNumber     = FrameNumber ()
	self.FrameSections   = {}
	self.FrameSectionSet = {}
end

function self:CheckFrame ()
	if self.FrameNumber ~= FrameNumber () then
		self:AdvanceFrame ()
	end
end

function self:CreditSection (sectionName, duration)
	local frameNumber = FrameNumber ()
	if self.SectionFrames [sectionName] ~= frameNumber then
		if self.SectionFrames [sectionName] == frameNumber - 1 then
			self.SectionFrameDurations [sectionName] = 0.95 * self.SectionFrameDurations [sectionName]
			self.SectionSmoothingCoefficients [sectionName] = 0.05
		else
			self.SectionFrameDurations [sectionName] = 0
			self.SectionSmoothingCoefficients [sectionName] = 1
		end
		self.SectionFrameCounts [sectionName] = 0
		self.SectionFrames [sectionName] = frameNumber
	end
	
	self.SectionFrameCounts [sectionName] = self.SectionFrameCounts [sectionName] + 1
	self.SectionDurations [sectionName] = 0.95 * (self.SectionDurations [sectionName] or 0) + (1 - 0.95) * duration
	self.SectionFrameDurations [sectionName] = self.SectionFrameDurations [sectionName] + self.SectionSmoothingCoefficients [sectionName] * duration
end

GCAD.Profiler = GCAD.Profiler ()
local self = {}
GCAD.ProfilerSectionEntry = GCAD.MakeConstructor (self)

local FrameNumber = FrameNumber or CurTime

function self:ctor (sectionName, depth)
	self.Name                = sectionName
	self.Depth               = depth or 0
	
	self.LastFrameStartTime  = 0
	self.LastFrameId         = 0
	self.LastFrameEntryCount = 0
	self.LastFrameDuration   = 0
	self.LastDuration        = 0
	
	self.FrameStartTime      = 0
	self.FrameId             = 0
	self.FrameEntryCount     = 0
	self.FrameDuration       = 0
	self.FrameDurationSmoothingCoefficient = 0
	self.Duration            = 0
	
	self.InSection           = 0
	self.EntryTime           = 0
	
	self.ChildSections       = {}
	self.ChildSectionsByName = {}
end

function self:Begin ()
	local frameId = FrameNumber ()
	if self.FrameId ~= frameId then
		self:AdvanceFrame (frameId)
	end
	
	if self.InSection == 0 then
		self.EntryTime = SysTime ()
	end
	
	self.InSection = self.InSection + 1
end

function self:BeginChildSection (sectionName)
	if not self.ChildSectionsByName [sectionName] then
		self.ChildSectionsByName [sectionName] = GCAD.ProfilerSectionEntry (sectionName, self.Depth + 1)
		self.ChildSections [#self.ChildSections + 1] = self.ChildSectionsByName [sectionName]
	end
	
	self.ChildSectionsByName [sectionName]:Begin ()
	
	return self.ChildSectionsByName [sectionName]
end

function self:CreateChildSection (sectionName)
	if self.ChildSectionsByName [sectionName] then
		return self.ChildSectionsByName [sectionName]
	end
	
	self.ChildSectionsByName [sectionName] = GCAD.ProfilerSectionEntry (sectionName, self.Depth + 1)
	self.ChildSections [#self.ChildSections + 1] = self.ChildSectionsByName [sectionName]
	
	return self.ChildSectionsByName [sectionName]
end

function self:End (...)
	if self.InSection == 0 then return end
	
	self.InSection = self.InSection - 1
	
	if self.InSection == 0 then
		self:Credit (SysTime () - self.EntryTime)
	end
	
	return ...
end

function self:EndNoCredit (...)
	if self.InSection == 0 then return end
	
	self.InSection = self.InSection - 1
	
	return ...
end

function self:EndChildSection (sectionName)
	if not self.ChildSectionsByName [sectionName] then
		self.ChildSectionsByName [sectionName] = GCAD.ProfilerSectionEntry (sectionName, self.Depth + 1)
	end
	
	self.ChildSectionsByName [sectionName]:End ()
end

function self:GetChildEnumerator ()
	local frameId = FrameNumber ()
	local sysTime = SysTime ()
	
	local valueEnumerator = GLib.ValueEnumerator (self.ChildSections)
	local childEnumerator = GLib.NullCallback
	return function ()
		local sectionEntry, depth, sectionName, duration, frameDuration, frameEntryCount = childEnumerator ()
		
		while not sectionName do
			childEnumerator = nil
			
			-- Move to next child
			local childSection = valueEnumerator ()
			while childSection and
				  sysTime - childSection:GetLastFrameStartTime () > 1 do
				childSection = valueEnumerator ()
			end
			
			-- If we're out of children, we're done here
			if not childSection then return nil, nil, nil, nil end
			
			-- Call the child enumerator
			childEnumerator = childSection:GetEnumerator ()
			sectionEntry, depth, sectionName, duration, frameDuration, frameEntryCount = childEnumerator ()
		end
		
		return sectionEntry, depth, sectionName, duration, frameDuration, frameEntryCount
	end
end

function self:GetChildSection (sectionName)
	return self.ChildSectionsByName [sectionName]
end

function self:GetEnumerator ()
	self:CheckFlushFrame (FrameNumber ())
	
	local childEnumerator
	return function ()
		if not childEnumerator then
			childEnumerator = self:GetChildEnumerator ()
			return self:GetInfo ()
		end
		
		return childEnumerator ()
	end
end

function self:GetInfo ()
	self:CheckFlushFrame (FrameNumber ())
	
	return self, self.Depth, self.Name, self.LastDuration, self.LastFrameDuration, self.LastFrameEntryCount
end

function self:GetName ()
	return self.Name
end

function self:GetDepth ()
	return self.Depth
end

function self:GetLastFrameId ()
	self:CheckFlushFrame (FrameNumber ())
	
	return self.LastFrameId
end

function self:GetLastFrameStartTime ()
	self:CheckFlushFrame (FrameNumber ())
	
	return self.LastFrameStartTime
end

function self:GetLastFrameEntryCount ()
	self:CheckFlushFrame (FrameNumber ())
	
	return self.LastFrameEntryCount
end

function self:GetLastFrameDuration ()
	self:CheckFlushFrame (FrameNumber ())
	
	return self.LastFrameDuration
end

function self:GetFrameId ()
	return self.FrameId
end

function self:GetFrameStartTime ()
	return self.FrameStartTime
end

function self:GetFrameStartTime ()
	return self.FrameStartTime
end

function self:GetDuration ()
	return self.Duration
end

function self:SetName (sectionName)
	self.Name = sectionName
end

function self:SetDepth (depth)
	self.Depth = depth
end

-- Internal, do not call
function self:AdvanceFrame (frameId)
	if self.FrameId == frameId then return end
	
	self:FlushFrame ()
	
	self.FrameId             = FrameNumber ()
	self.FrameStartTime      = SysTime ()
	self.FrameEntryCount     = 0
	self.FrameDuration       = 0.95 * self.LastFrameDuration
	self.FrameDurationSmoothingCoefficient = 1 - 0.95
	
	if not self.LastFrameId or self.FrameId > self.LastFrameId + 5 then
		-- Reset all stats
		self.FrameDuration = 0
		self.FrameDurationSmoothingCoefficient = 1
		
		self.Duration = nil
	end
end

function self:CheckFlushFrame (frameId)
	if frameId - self.FrameId > 1 then
		self:FlushFrame ()
	end
end

function self:CheckFrame (frameId)
	if self.FrameId ~= frameId then
		self:AdvanceFrame (frameId)
	end
end

function self:Credit (duration)
	self.FrameEntryCount = self.FrameEntryCount + 1
	self.Duration        = self.Duration and (0.95 * self.Duration + (1 - 0.95) * duration) or duration
	self.FrameDuration   = self.FrameDuration + self.FrameDurationSmoothingCoefficient * duration
end

function self:FlushFrame ()
	self.LastFrameId         = self.FrameId
	self.LastFrameStartTime  = self.FrameStartTime
	self.LastFrameEntryCount = self.FrameEntryCount
	self.LastFrameDuration   = self.FrameDuration
	self.LastDuration        = self.Duration
end
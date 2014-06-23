local self = {}
GCAD.ProfilerSectionEntry = GCAD.MakeConstructor (self)

local FrameNumber = FrameNumber or CurTime

function self:ctor (sectionName, depth)
	self.Name                   = sectionName
	self.Depth                  = depth or 0
	
	self.DisplayName            = nil
	
	self.LastFrameId            = 0
	self.LastFrameStartTime     = 0
	self.LastFrameEntryCount    = 0
	self.LastFrameDuration      = 0
	self.LastDuration           = 0
	
	self.CurrentFrameId         = 0
	self.CurrentFrameStartTime  = 0
	self.CurrentFrameEntryCount = 0
	self.CurrentFrameDuration   = 0
	self.CurrentFrameDurationSmoothingCoefficient = 0
	self.CurrentDuration        = 0
	
	self.InSection              = 0
	self.EntryTime              = 0
	
	self.ChildSections          = {}
	self.ChildSectionsByName    = {}
end

function self:Begin (note)
	local frameId = FrameNumber ()
	if self.CurrentFrameId ~= currentFrameId then
		self:AdvanceFrame (frameId)
	end
	
	if self.InSection == 0 then
		self.EntryTime = SysTime ()
	end
	
	if note then
		self.DisplayName = self.Name .. " [" .. tostring (note) .. "]"
	else
		self.DisplayName = nil
	end
	
	self.InSection = self.InSection + 1
end

function self:BeginChildSection (sectionName, note)
	if not self.ChildSectionsByName [sectionName] then
		self.ChildSectionsByName [sectionName] = GCAD.ProfilerSectionEntry (sectionName, self.Depth + 1)
		self.ChildSections [#self.ChildSections + 1] = self.ChildSectionsByName [sectionName]
	end
	
	self.ChildSectionsByName [sectionName]:Begin (note)
	
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

function self:GetChildEnumerator (filterFunction)
	filterFunction = filterFunction or function () return true end
	
	table.sort (self.ChildSections,
		function (a, b)
			return a.LastFrameDuration > b.LastFrameDuration
		end
	)
	
	local valueEnumerator = GLib.ArrayEnumerator (self.ChildSections)
	local childEnumerator = GLib.NullCallback
	return function ()
		local sectionEntry = childEnumerator ()
		
		while not sectionEntry do
			childEnumerator = nil
			
			-- Move to next child
			local childSection = valueEnumerator ()
			while childSection and not filterFunction (childSection) do
				childSection = valueEnumerator ()
			end
			
			-- If we're out of children, we're done here
			if not childSection then return nil end
			
			-- Call the child enumerator
			childEnumerator = childSection:GetEnumerator (filterFunction)
			sectionEntry = childEnumerator ()
		end
		
		return sectionEntry
	end
end

function self:GetChildSection (sectionName)
	return self.ChildSectionsByName [sectionName]
end

function self:GetEnumerator (filterFunction)
	filterFunction = filterFunction or function () return true end
	
	self:CheckFlushFrame (FrameNumber ())
	
	local childEnumerator
	return function ()
		if not childEnumerator then
			childEnumerator = self:GetChildEnumerator (filterFunction)
			if not filterFunction (self) then return nil end
			return self
		end
		
		return childEnumerator ()
	end
end

function self:GetName ()
	return self.Name
end

function self:GetDepth ()
	return self.Depth
end

function self:GetDisplayName ()
	return self.DisplayName or self.Name
end

function self:SetName (sectionName)
	self.Name = sectionName
end

function self:SetDepth (depth)
	self.Depth = depth
end

function self:SetDisplayName (displayName)
	self.DisplayName = displayName
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

function self:GetLastDuration ()
	self:CheckFlushFrame (FrameNumber ())
	
	return self.LastDuration
end

function self:GetCurrentFrameId ()
	return self.CurrentFrameId
end

function self:GetCurrentFrameStartTime ()
	return self.CurrentFrameStartTime
end

function self:GetCurrentFrameEntryCount ()
	return self.CurrentFrameEntryCount
end

function self:GetCurrentFrameDuration ()
	return self.CurrentFrameDuration
end

function self:GetCurrentDuration ()
	return self.CurrentDuration
end

-- Internal, do not call
function self:AdvanceFrame (frameId)
	if self.CurrentFrameId == frameId then return end
	
	self:FlushFrame ()
	
	self.CurrentFrameId         = FrameNumber ()
	self.CurrentFrameStartTime  = SysTime ()
	self.CurrentFrameEntryCount = 0
	self.CurrentFrameDuration   = 0.95 * self.LastFrameDuration
	self.CurrentFrameDurationSmoothingCoefficient = 1 - 0.95
	
	if not self.LastFrameId or self.CurrentFrameId > self.LastFrameId + 5 then
		-- Reset all stats
		self.CurrentFrameDuration = 0
		self.CurrentFrameDurationSmoothingCoefficient = 1
		
		self.CurrentDuration = nil
	end
end

function self:CheckFlushFrame (frameId)
	if frameId - self.CurrentFrameId > 1 then
		self:FlushFrame ()
	end
end

function self:CheckFrame (frameId)
	if self.CurrentFrameId ~= frameId then
		self:AdvanceFrame (frameId)
	end
end

function self:Credit (duration)
	self.CurrentFrameEntryCount = self.CurrentFrameEntryCount + 1
	self.CurrentDuration        = self.CurrentDuration and (0.95 * self.CurrentDuration + (1 - 0.95) * duration) or duration
	self.CurrentFrameDuration   = self.CurrentFrameDuration + self.CurrentFrameDurationSmoothingCoefficient * duration
end

function self:FlushFrame ()
	self.LastFrameId         = self.CurrentFrameId         or 0
	self.LastFrameStartTime  = self.CurrentFrameStartTime  or 0
	self.LastFrameEntryCount = self.CurrentFrameEntryCount or 0
	self.LastFrameDuration   = self.CurrentFrameDuration   or 0
	self.LastDuration        = self.CurrentDuration        or 0
end
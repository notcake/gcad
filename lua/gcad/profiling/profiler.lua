local self = {}
GCAD.Profiler = GCAD.MakeConstructor (self)

function self:ctor ()
	self.RootSection = GCAD.ProfilerSectionEntry ("<root>")
	self.RootSection:SetDepth (-1)
	
	self.SectionStack = {}
	self.SectionStackSet = {}
	self.SectionStackRefCount = {}
	
	self.NonRecursiveSections = {}
end

function self:Begin (sectionName, note)
	local section
	if #self.SectionStack > 5 and self.SectionStackSet [sectionName] then
		section = self.SectionStackSet [sectionName]
	else
		local parentSection = self.SectionStack [#self.SectionStack] or self.RootSection
		section = parentSection:CreateChildSection (sectionName)
	end
	
	-- Recursive section
	section:Begin (note)
	self.SectionStack [#self.SectionStack + 1] = section
	self.SectionStackRefCount [section] = (self.SectionStackRefCount [section] or 0) + 1
	self.SectionStackSet [sectionName] = section
	
	-- -- Non-recursive section
	-- self.NonRecursiveSections [sectionName] = self.NonRecursiveSections [sectionName] or GCAD.ProfilerSectionEntry (sectionName)
	-- self.NonRecursiveSections [sectionName]:Begin ()
end

function self:End ()
	if #self.SectionStack == 0 then return end
	
	local section = self.SectionStack [#self.SectionStack]
	local sectionName = section:GetName ()
	
	-- Recursive section
	self.SectionStack [#self.SectionStack]:End ()
	self.SectionStack [#self.SectionStack] = nil
	self.SectionStackRefCount [section] = (self.SectionStackRefCount [section] or 1) - 1
	if self.SectionStackRefCount [section] == 0 then
		self.SectionStackRefCount [section] = nil
		self.SectionStackSet [sectionName] = nil
	end
	
	-- -- Non-recursive section
	-- self.NonRecursiveSections [sectionName] = self.NonRecursiveSections [sectionName] or GCAD.ProfilerSectionEntry (sectionName)
	-- self.NonRecursiveSections [sectionName]:End ()
end

function self:EndNoCredit ()
	if #self.SectionStack == 0 then return end
	
	local section = self.SectionStack [#self.SectionStack]
	local sectionName = section:GetName ()
	
	-- Recursive section
	self.SectionStack [#self.SectionStack]:EndNoCredit ()
	self.SectionStack [#self.SectionStack] = nil
	self.SectionStackRefCount [section] = (self.SectionStackRefCount [section] or 1) - 1
	if self.SectionStackRefCount [section] == 0 then
		self.SectionStackRefCount [section] = nil
		self.SectionStackSet [sectionName] = nil
	end
	
	-- -- Non-recursive section
	-- self.NonRecursiveSections [sectionName] = self.NonRecursiveSections [sectionName] or GCAD.ProfilerSectionEntry (sectionName)
	-- self.NonRecursiveSections [sectionName]:EndNoCredit ()
end

function self:GetEnumerator (filterFunction)
	return self.RootSection:GetChildEnumerator (filterFunction)
end

function self:Profile (f, ...)
	local SysTime = SysTime
	
	local t0 = SysTime ()
	local callCount = 0
	while SysTime () - t0 < 0.005 do
		callCount = callCount + 1
		f (...)
	end
	
	return (SysTime () - t0) / callCount
end

function self:ProfileOnce (f, ...)
	local SysTime = SysTime
	
	local t0 = SysTime ()
	f (...)
	
	return SysTime () - t0
end

function self:Wrap (f, sectionName)
	return function (...)
		self:Begin (sectionName)
		local r1, r2, r3, r4, r5, r6 = f (...)
		self:End ()
		
		return r1, r2, r3, r4, r5, r6
	end
end

GCAD.Profiler = GCAD.Profiler ()
Profiler = GCAD.Profiler
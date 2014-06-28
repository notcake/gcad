local self = {}
GCAD.ProfilingStatisticsPrinter = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Priority0Color = GLib.Colors.Gray
	self.Priority1Color = GLib.Colors.Orange
	self.Priority2Color = GLib.Colors.OrangeRed
	
	concommand.Add ("gcad_profiler_print",
		function (ply, _, args)
			if not GCAD.CanRunConCommand (ply) then return end
			
			if #args == 1 and args [1] == "help" then
				print ("gcad_profiler_print [showold] [showsmall]")
				return
			end
			
			local showOldEntries   = false
			local showSmallEntries = false
			
			for _, v in ipairs (args) do
				v = string.lower (v)
				v = string.gsub (v, "[^a-z0-9]", "")
				
				if v == "showold" then
					showOldEntries = true
				elseif v == "showsmall" then
					showSmallEntries = true
				end
			end
			
			self:Print (showOldEntries, showSmallEntries)
		end
	)
end

function self:dtor ()
end

function self:Print (showOldEntries, showSmallEntries)
	local sectionFilter
	if showOldEntries then
		sectionFilter = function (sectionEntry)
			return true
		end
	else
		local sysTime = SysTime ()
		sectionFilter = function (sectionEntry)
			return sysTime - sectionEntry:GetLastFrameStartTime () < 1
		end
	end
	
	local sectionEntries = {}
	for sectionEntry in GCAD.Profiler:GetEnumerator (sectionFilter) do
		sectionEntries [#sectionEntries + 1] = sectionEntry
	end
	
	if #sectionEntries == 0 and not showOldEntries then
		for sectionEntry in GCAD.Profiler:GetEnumerator () do
			sectionEntries [#sectionEntries + 1] = sectionEntry
		end
	end
	
	local depths                  = {}
	local colors                  = {}
	local names                   = {}
	local formattedDurations      = {}
	local formattedEntryCounts    = {}
	local formattedFrameDurations = {}
	for i = 1, #sectionEntries do
		local sectionEntry = sectionEntries [i]
		if showSmallEntries or sectionEntry:GetLastFrameDuration () > 0.00002 then
			local sectionFrameDuration = sectionEntry:GetLastFrameDuration ()
			if sectionFrameDuration >= 0.000750 then
				colors [#colors + 1] = self.Priority2Color
			elseif sectionFrameDuration >= 0.000100 then
				colors [#colors + 1] = self.Priority1Color
			else
				colors [#colors + 1] = self.Priority0Color
			end
			
			depths                  [#depths                  + 1] = sectionEntry:GetDepth ()
			names                   [#names                   + 1] = sectionEntry:GetDisplayName ()
			formattedDurations      [#formattedDurations      + 1] = GLib.FormatDuration (sectionEntry:GetLastDuration ())
			formattedEntryCounts    [#formattedEntryCounts    + 1] = tostring (sectionEntry:GetLastFrameEntryCount ()) .. "x / frame"
			formattedFrameDurations [#formattedFrameDurations + 1] = GLib.FormatDuration (sectionEntry:GetLastFrameDuration ())
		end
	end
	
	local maximumDepth                        = 0
	local maximumNameLength                   = 0
	local maximumFormattedDurationLength      = 0
	local maximumFormattedEntryCountLength    = 0
	local maximumFormattedFrameDurationLength = 0
	for i = 1, #names do
		maximumDepth                        = math.max (maximumDepth,                         depths                  [i])
		maximumNameLength                   = math.max (maximumNameLength,                   #names                   [i])
		maximumFormattedDurationLength      = math.max (maximumFormattedDurationLength,      #formattedDurations      [i])
		maximumFormattedEntryCountLength    = math.max (maximumFormattedEntryCountLength,    #formattedEntryCounts    [i])
		maximumFormattedFrameDurationLength = math.max (maximumFormattedFrameDurationLength, #formattedFrameDurations [i])
	end
	
	-- Print header
	local nameHeader                   = "Section name"
	local formattedDurationHeader      = "Call duration"
	local formattedEntryCountHeader    = "Calls per frame"
	local formattedFrameDurationHeader = "Duration per frame"
	maximumNameLength                   = math.max (maximumNameLength,                   #nameHeader                  )
	maximumFormattedDurationLength      = math.max (maximumFormattedDurationLength,      #formattedDurationHeader     )
	maximumFormattedEntryCountLength    = math.max (maximumFormattedEntryCountLength,    #formattedEntryCountHeader   )
	maximumFormattedFrameDurationLength = math.max (maximumFormattedFrameDurationLength, #formattedFrameDurationHeader)
	
	MsgC (GLib.Colors.White, nameHeader                   .. string.rep (" ", maximumNameLength                   - #nameHeader                  ))
	MsgC (GLib.Colors.White, "        ")
	MsgC (GLib.Colors.White, formattedDurationHeader      .. string.rep (" ", maximumFormattedDurationLength      - #formattedDurationHeader     ))
	MsgC (GLib.Colors.White, "        ")
	MsgC (GLib.Colors.White, formattedEntryCountHeader    .. string.rep (" ", maximumFormattedEntryCountLength    - #formattedEntryCountHeader   ))
	MsgC (GLib.Colors.White, "        ")
	MsgC (GLib.Colors.White, formattedFrameDurationHeader .. string.rep (" ", maximumFormattedFrameDurationLength - #formattedFrameDurationHeader))
	MsgN ("")
	MsgC (GLib.Colors.White, string.rep ("-", maximumDepth * 4 + maximumNameLength + 8 + maximumFormattedDurationLength + 8 + maximumFormattedEntryCountLength + 8 + maximumFormattedFrameDurationLength))
	MsgN ("")
	
	-- Print lines
	for i = 1, #names do
		MsgC (colors [i], string.rep ("    ", depths [i]))
		MsgC (colors [i], names [i] .. string.rep (" ", maximumNameLength - #names [i]))
		MsgC (colors [i], "        ")
		MsgC (colors [i], string.rep (" ", maximumFormattedDurationLength      - #formattedDurations      [i]) .. formattedDurations      [i])
		MsgC (colors [i], "        ")
		MsgC (colors [i], string.rep (" ", maximumFormattedEntryCountLength    - #formattedEntryCounts    [i]) .. formattedEntryCounts    [i])
		MsgC (colors [i], "        ")
		MsgC (colors [i], string.rep (" ", maximumFormattedFrameDurationLength - #formattedFrameDurations [i]) .. formattedFrameDurations [i])
		MsgN ("")
	end
end

GCAD.ProfilingStatisticsPrinter = GCAD.ProfilingStatisticsPrinter ()
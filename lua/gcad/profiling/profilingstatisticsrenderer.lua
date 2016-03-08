local self = {}
GCAD.ProfilingStatisticsRenderer = GCAD.MakeConstructor (self)

local surface_DrawLine     = surface.DrawLine
local surface_DrawRect     = surface.DrawRect
local surface_DrawText     = surface.DrawText
local surface_GetTextSize  = surface.GetTextSize
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetFont      = surface.SetFont
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos   = surface.SetTextPos

function self:ctor ()
	self.Enabled = false
	
	self.Priority0BackgroundColor1 = GLib.Color.FromColor (GLib.Colors.Gray,       128)
	self.Priority0BackgroundColor2 = GLib.Color.FromColor (GLib.Colors.Silver,     128)
	self.Priority1BackgroundColor1 = GLib.Color.FromColor (GLib.Colors.Orange,     128)
	self.Priority1BackgroundColor2 = GLib.Color.FromColor (GLib.Colors.DarkOrange, 128)
	self.Priority2BackgroundColor1 = GLib.Color.FromColor (GLib.Colors.Red,        128)
	self.Priority2BackgroundColor2 = GLib.Color.FromColor (GLib.Colors.Crimson,    128)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.ProfilingStatisticsRenderer",
		function ()
			self:dtor ()
		end
	)
	
	GLib.WaitForLocalPlayer (
		function ()
			-- self:SetEnabled (LocalPlayer ():SteamID () == "STEAM_0:1:19269760")
		end
	)
	
	self.ShowAll = CreateClientConVar ("gcad_profiling_display_show_all", 0, true, false)
	concommand.Add ("gcad_profiling_display_enable",  function () self:SetEnabled (true ) end)
	concommand.Add ("gcad_profiling_display_disable", function () self:SetEnabled (false) end)
	concommand.Add ("+gcad_profiling_display",        function () self:SetEnabled (true ) end)
	concommand.Add ("-gcad_profiling_display",        function () self:SetEnabled (false) end)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.ProfilingStatisticsRenderer")
	
	self:SetEnabled (false)
end

function self:SetEnabled (enabled)
	if self.Enabled == enabled then return self end
	
	self.Enabled = enabled
	if self.Enabled then
		local lastFrameStartTime = 0
		hook.Add ("PostRenderVGUI", "GCAD.ProfilingStatisticsRenderer",
			function ()
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render")
				
				local frameDuration = SysTime () - lastFrameStartTime
				local frameRate     = 1 / frameDuration
				lastFrameStartTime = SysTime ()
				
				surface_SetFont ("DermaDefault")
				surface_SetTextColor (GLib.Colors.White)
				
				local _, lineHeight = surface_GetTextSize ("")
				lineHeight = lineHeight + 6
				
				local x = ScrW () / 2
				local y0 = ScrH () * 0.10
				
				-- Columns
				-- Name, average call duration, calls per frame, frame duration, cumulative frame duration, hypothetical fps
				local x0 = x  - 360 -- Left aligned name
				local x1 = x0 + 440 
				local x2 = x1 +  80 -- Right aligned average call duration
				local x3 = x2 +  80
				local x4 = x3 +  80
				local x5 = x4 +  80
				local x6 = x5 +  80
				
				local sysTime = SysTime ()
				local sectionFilter
				
				local showAll = self.ShowAll:GetBool ()
				if showAll then
					sectionFilter = function (sectionEntry)
						return true
					end
				else
					sectionFilter = function (sectionEntry)
						return sysTime - sectionEntry:GetLastFrameStartTime () < 1
					end
				end
				
				-- Get list of section entries
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render : Enumerate section entries")
				local sectionEntries = {}
				for sectionEntry in GCAD.Profiler:GetEnumerator (sectionFilter) do
					local shouldDraw = sectionEntry:GetLastFrameDuration () > 0.00002 or showAll
					sectionEntry.LastShouldDrawTime = sectionEntry.LastShouldDrawTime or 0
					if shouldDraw then
						sectionEntry.LastShouldDrawTime = SysTime ()
					end
					
					if showAll or
					   SysTime () - sectionEntry.LastShouldDrawTime < 1 then
						sectionEntries [#sectionEntries + 1] = sectionEntry
					end
				end
				GCAD.Profiler:End ()
				
				-- Calculate maximum indent				
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render : Calculate maximum indent")
				local totalProfiledFrameDuration = 0
				local maximumSectionDepth = 0
				local stackLevelIndent = 16
				for _, sectionEntry in ipairs (sectionEntries) do
					local depth = sectionEntry:GetDepth ()
					maximumSectionDepth = math.max (maximumSectionDepth, depth)
					if depth == 0 then
						totalProfiledFrameDuration = totalProfiledFrameDuration + sectionEntry:GetLastFrameDuration ()
					end
				end
				local maximumIndent = stackLevelIndent * maximumSectionDepth
				local w = x4 - x0 + stackLevelIndent * maximumSectionDepth
				GCAD.Profiler:End ()
				
				-- Header
				local y = y0
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render : Draw header")
				surface_SetDrawColor (self.Priority0BackgroundColor1)
				surface_DrawRect (x3, y - lineHeight, x6 - x3 + maximumIndent, lineHeight)
				
				-- Total frame duration
				local text = GLib.FormatDuration (totalProfiledFrameDuration)
				surface_SetTextPos (x4 - 8 - surface_GetTextSize (text), y + 2 - lineHeight)
				surface_DrawText (text .. " / " .. GLib.FormatDuration (frameDuration))
				
				-- FPS loss
				text = string.format ("-%.2f fps", 1 / (frameDuration - totalProfiledFrameDuration) - frameRate)
				surface_SetTextPos (x6 + maximumIndent - 8 - surface_GetTextSize (text), y + 2 - lineHeight)
				surface_DrawText (text)
				
				y = y + 4
				GCAD.Profiler:End ()
				
				-- Draw lines
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render : Determine line rendering type")
				local lastCumulativeFrameDuration = 0
				local cumulativeFrameDuration     = 0
				
				local sectionEntriesDrawCumulative = {}
				for _, sectionEntry in ipairs (sectionEntries) do
					local depth = sectionEntry:GetDepth ()
					
					if depth == 0 then
						lastCumulativeFrameDuration = cumulativeFrameDuration
						cumulativeFrameDuration = cumulativeFrameDuration + sectionEntry:GetLastFrameDuration ()
						if math.floor (lastCumulativeFrameDuration / 0.0025) ~= math.floor (cumulativeFrameDuration / 0.0025) then
							sectionEntriesDrawCumulative [sectionEntry] = true
						end
					end
				end
				GCAD.Profiler:End ()
				
				local screenHeight = ScrH ()
				local contentY     = y
				
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render : Draw line backgrounds")
				y = contentY
				local lineCount = 0
				for _, sectionEntry in ipairs (sectionEntries) do
					-- Background
					local sectionFrameDuration = sectionEntry:GetLastFrameDuration ()
					if sectionFrameDuration >= 0.000750 then
						surface_SetDrawColor (lineCount % 2 == 0 and self.Priority2BackgroundColor1 or self.Priority2BackgroundColor2)
					elseif sectionFrameDuration >= 0.000100 then
						surface_SetDrawColor (lineCount % 2 == 0 and self.Priority1BackgroundColor1 or self.Priority1BackgroundColor2)
					else
						surface_SetDrawColor (lineCount % 2 == 0 and self.Priority0BackgroundColor1 or self.Priority0BackgroundColor2)
					end
					surface_DrawRect (x0, y, w + (sectionEntriesDrawCumulative [sectionEntry] and 160 or 0), lineHeight)
					lineCount = lineCount + 1
					
					y = y + lineHeight
					
					if y > screenHeight then break end
				end
				GCAD.Profiler:End ()
				
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render : Draw line text")
				y = contentY
				for _, sectionEntry in ipairs (sectionEntries) do
					-- Columns
					local indent = stackLevelIndent * sectionEntry:GetDepth ()
					
					-- Section name
					text = sectionEntry:GetDisplayName ()
					surface_SetTextPos (x0 + 8 + indent, y + 2)
					surface_DrawText (text)
					
					-- Average call duration
					text = GLib.FormatDuration (sectionEntry:GetLastDuration ())
					surface_SetTextPos (x2 + indent - 8 - surface_GetTextSize (text), y + 2)
					surface_DrawText (text)
					
					-- Frame entry count
					text = sectionEntry:GetLastFrameEntryCount () .. "x / frame"
					surface_SetTextPos (x3 + indent - 8 - surface_GetTextSize (text), y + 2)
					surface_DrawText (text)
					
					-- Frame duration
					text = GLib.FormatDuration (sectionEntry:GetLastFrameDuration ())
					surface_SetTextPos (x4 + indent - 8 - surface_GetTextSize (text), y + 2)
					surface_DrawText (text)
					
					if sectionEntriesDrawCumulative [sectionEntry] then
						-- Cumulative frame duration
						text = GLib.FormatDuration (cumulativeFrameDuration)
						surface_SetTextPos (x5 + maximumIndent - 8 - surface_GetTextSize (text), y + 2)
						surface_DrawText (text)
						
						-- Cumulative FPS loss
						text = string.format ("-%.2f fps", 1 / (frameDuration - cumulativeFrameDuration) - frameRate)
						surface_SetTextPos (x6 + maximumIndent - 8 - surface_GetTextSize (text), y + 2)
						surface_DrawText (text)
					end
					
					y = y + lineHeight
					
					if y > screenHeight then break end
				end
				GCAD.Profiler:End ()
				
				GCAD.Profiler:End ()
			end
		)
	else
		hook.Remove ("PostRenderVGUI", "GCAD.ProfilingStatisticsRenderer")
	end
	
	return self
end

GCAD.ProfilingStatisticsRenderer = GCAD.ProfilingStatisticsRenderer ()
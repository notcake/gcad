if not CLIENT then return end

local self = {}
GCAD.ProfilingStatisticsRenderer = GCAD.MakeConstructor (self)

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
			self:SetEnabled (LocalPlayer ():SteamID () == "STEAM_0:1:19269760")
		end
	)
	
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
		hook.Add ("PostRenderVGUI", "GCAD.ProfilingStatisticsRenderer",
			function ()
				GCAD.Profiler:Begin ("ProfilingStatisticsRenderer:Render")
				
				surface_SetFont ("DermaDefault")
				surface_SetTextColor (GLib.Colors.White)
				
				local _, lineHeight = surface_GetTextSize ("")
				lineHeight = lineHeight + 6
				
				local x = ScrW () / 2
				local y = ScrH () * 0.10
				
				local x0 = x - 360
				local x1 = x + 64
				local x2 = x + 160
				local x3 = x + 240
				
				local maximumSectionStackLevel = 0
				local stackLevelIndent = 16
				for sectionEntry, depth, sectionName, duration, frameDuration, frameEntryCount in GCAD.Profiler:GetEnumerator () do
					maximumSectionStackLevel = math.max (maximumSectionStackLevel, depth)
				end
				
				local lineCount = 0
				for sectionEntry, depth, sectionName, duration, frameDuration, frameEntryCount in GCAD.Profiler:GetEnumerator () do
					local shouldDraw = frameDuration > 0.00002
					sectionEntry.LastShouldDrawTime = sectionEntry.LastShouldDrawTime or 0
					if shouldDraw then
						sectionEntry.LastShouldDrawTime = SysTime ()
					end
					if SysTime () - sectionEntry.LastShouldDrawTime > 1 then continue end
					
					local indent = stackLevelIndent * depth
					
					if frameDuration >= 0.000750 then
						surface_SetDrawColor (lineCount % 2 == 0 and self.Priority2BackgroundColor1 or self.Priority2BackgroundColor2)
					elseif frameDuration >= 0.000100 then
						surface_SetDrawColor (lineCount % 2 == 0 and self.Priority1BackgroundColor1 or self.Priority1BackgroundColor2)
					else
						surface_SetDrawColor (lineCount % 2 == 0 and self.Priority0BackgroundColor1 or self.Priority0BackgroundColor2)
					end
					surface_DrawRect (x0 - 8, y - 2, x3 - x0 + 16 + stackLevelIndent * maximumSectionStackLevel, lineHeight)
					lineCount = lineCount + 1
					
					local text = sectionName
					surface_SetTextPos (x0 + indent, y)
					surface_DrawText (text)
					
					text = GLib.FormatDuration (duration)
					surface_SetTextPos (x1 + indent - surface_GetTextSize (text), y)
					surface_DrawText (text)
					
					text = frameEntryCount .. "x / frame"
					surface_SetTextPos (x2 + indent - surface_GetTextSize (text), y)
					surface_DrawText (text)
					
					text = GLib.FormatDuration (frameDuration)
					surface_SetTextPos (x3 + indent - surface_GetTextSize (text), y)
					surface_DrawText (text)
					
					y = y + lineHeight
				end
				
				GCAD.Profiler:End ()
			end
		)
	else
		hook.Remove ("PostRenderVGUI", "GCAD.ProfilingStatisticsRenderer")
	end
	
	return self
end

GCAD.ProfilingStatisticsRenderer = GCAD.ProfilingStatisticsRenderer ()
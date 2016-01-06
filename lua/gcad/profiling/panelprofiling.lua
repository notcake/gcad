local self = {}
GCAD.PanelProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	concommand.Add ("gcad_panel_profiling_enable",  function () self:SetEnabled (true ) end)
	concommand.Add ("gcad_panel_profiling_disable", function () self:SetEnabled (false) end)
	concommand.Add ("+gcad_panel_profiling",        function () self:SetEnabled (true ) end)
	concommand.Add ("-gcad_panel_profiling",        function () self:SetEnabled (false) end)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.PanelProfiling",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.PanelProfiling")
	
	self:SetEnabled (false)
end

function self:SetEnabled (enabled)
	if self.Enabled == enabled then return self end
	
	if enabled then
		self:Enable ()
	else
		self:Disable ()
	end
	
	return self
end

-- Internal, do not call
function self:Enable ()
	if self.Enabled then return end
	
	self.Enabled = true
	
	self:EnumeratePanels (
		function (panel)
			self:HookPanel (panel)
		end
	)
end

function self:Disable ()
	if not self.Enabled then return end
	
	self.Enabled = false
	
	self:EnumeratePanels (
		function (panel)
			self:UnhookPanel (panel)
		end
	)
end

function self:EnumeratePanels (callback)
	callback (vgui.GetWorldPanel ())
	self:EnumeratePanelChildren (vgui.GetWorldPanel (), callback)
	callback (GetHUDPanel ())
	self:EnumeratePanelChildren (GetHUDPanel (), callback)
end

function self:EnumeratePanelChildren (panel, callback)
	for _, childPanel in ipairs (panel:GetChildren ()) do
		callback (childPanel)
		self:EnumeratePanelChildren (childPanel, callback)
	end
end

local profiledMethods =
{
	"AnimationThink",
	"Paint",
	"PaintOver",
	"PerformLayout",
	"Think"
}

function self:HookPanel (panel)
	if not panel            then return end
	if not panel:IsValid () then return end
	
	for _, methodName in ipairs (profiledMethods) do
		local oldMethodName = "____" .. methodName
		local groupName   = "PANEL:" .. methodName
		local sectionName = (panel.ClassName or "Unknown") .. ":" .. methodName
		
		if panel [methodName] then
			panel [oldMethodName] = panel [oldMethodName] or panel [methodName]
			panel [methodName] = function (self, ...)
				if GCAD and GCAD.Profiler then
					GCAD.Profiler:Begin (groupName)
					GCAD.Profiler:Begin (sectionName)
				end
				
				local a, b, c, d = self [oldMethodName] (self, ...)
				
				if GCAD and GCAD.Profiler then
					GCAD.Profiler:End ()
					GCAD.Profiler:End (groupName)
				end
				
				return a, b, c, d
			end
		end
	end
end

function self:UnhookPanel (panel)
	if not panel            then return end
	if not panel:IsValid () then return end
	
	for _, methodName in ipairs (profiledMethods) do
		local oldMethodName = "____" .. methodName
		panel [methodName] = panel [oldMethodName] or panel [methodName]
	end
end

GCAD.PanelProfiling = GCAD.PanelProfiling ()
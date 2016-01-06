local self = {}
GCAD.GamemodeHookProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Gamemode = nil

	self.Enabled = false
	
	self.OriginalGamemodeHooks = {}
	self.GamemodeHooks         = {}
	
	concommand.Add ("gcad_gamemode_hook_profiling_enable",  function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("gcad_gamemode_hook_profiling_disable", function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	concommand.Add ("+gcad_gamemode_hook_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("-gcad_gamemode_hook_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.GamemodeHookProfiling",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.GamemodeHookProfiling")
	
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
	
	self.Gamemode = GAMEMODE or GM
	
	for methodName, f in pairs (self.Gamemode) do
		if type (f) == "function" then
			self.OriginalGamemodeHooks [methodName] = f
			self.GamemodeHooks         [methodName] = GCAD.Profiler:Wrap (self.OriginalGamemodeHooks [methodName], "GAMEMODE:" .. methodName)
			
			self.Gamemode [methodName] = self.GamemodeHooks [methodName]
		end
	end
end

function self:Disable ()
	if not self.Enabled then return end
	
	self.Enabled = false
	
	for methodName, f in pairs (self.Gamemode) do
		if type (f) == "function" and
		   f == self.GamemodeHooks [methodName] then
			self.Gamemode [methodName] = self.OriginalGamemodeHooks [commandName]
		end
	end
	
	self.OriginalGamemodeHooks = {}
	self.GamemodeHooks         = {}
end

GCAD.GamemodeHookProfiling = GCAD.GamemodeHookProfiling ()

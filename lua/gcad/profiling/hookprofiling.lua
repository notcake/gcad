local self = {}
GCAD.HookProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	self.OriginalHooks = {}
	self.Hooks         = {}
	
	concommand.Add ("gcad_hook_profiling_enable",  function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("gcad_hook_profiling_disable", function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	concommand.Add ("+gcad_hook_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("-gcad_hook_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.HookProfiling",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.HookProfiling")
	
	self:SetEnabled (false)
end

function self:SetEnabled (enabled)
	if self.Enabled == enabled then return self end
	
	self.Enabled = enabled
	
	if self.Enabled then
		self:Enable ()
	else
		self:Disable ()
	end
	
	return self
end

-- Internal, do not call
function self:Enable ()
	self.Enabled = true
	
	for eventName, eventTable in pairs (hook.GetTable ()) do
		self.OriginalHooks [eventName] = self.OriginalHooks [eventName] or {}
		self.Hooks         [eventName] = self.Hooks         [eventName] or {}
		
		for hookName, hookFunction in pairs (eventTable) do
			self.OriginalHooks [eventName] [hookName] = hookFunction
			self.Hooks         [eventName] [hookName] = GCAD.Profiler:Wrap (self.OriginalHooks [eventName] [hookName], eventName .. ":" .. tostring (hookName))
			
			hook.Add (eventName, hookName, self.Hooks [eventName] [hookName])
		end
	end
end

function self:Disable ()
	self.Enabled = false
	
	for eventName, eventTable in pairs (hook.GetTable ()) do
		self.OriginalHooks [eventName] = self.OriginalHooks [eventName] or {}
		self.Hooks         [eventName] = self.Hooks         [eventName] or {}
		
		for hookName, hookFunction in pairs (eventTable) do
			if hookFunction == self.Hooks [eventName] [hookName] then
				hook.Add (eventName, hookName, self.OriginalHooks [eventName] [hookName])
			end
		end
	end
	
	self.OriginalHooks = {}
	self.Hooks         = {}
end

GCAD.HookProfiling = GCAD.HookProfiling ()
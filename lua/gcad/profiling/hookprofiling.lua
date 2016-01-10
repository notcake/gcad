local self = {}
GCAD.HookProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	self.OriginalHooks   = {}
	self.Hooks           = {}
	self.OriginalHookAdd = nil
	self.HookAdd         = nil
	
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
	
	for eventName, eventTable in pairs (hook.GetTable ()) do
		self.OriginalHooks [eventName] = self.OriginalHooks [eventName] or {}
		self.Hooks         [eventName] = self.Hooks         [eventName] or {}
		
		for hookName, hookFunction in pairs (eventTable) do
			local valid = true
			if type (hookName) == "string" or
			   type (hookName) == "number" or
			   type (hookName) == "function" or
			   type (hookName) == "boolean" then
				valid = true
			else
				valid = IsValid(hookName)
			end
			
			if valid then
				self.OriginalHooks [eventName] [hookName] = hookFunction
				self.Hooks         [eventName] [hookName] = GCAD.Profiler:Wrap (self.OriginalHooks [eventName] [hookName], eventName .. ":" .. tostring (hookName))
				self.Hooks         [eventName] [hookName] = GCAD.Profiler:Wrap (self.Hooks [eventName] [hookName], eventName)
				
				eventTable [hookName] = self.Hooks [eventName] [hookName]
			end
		end
	end
	
	hook.Add ("PreRender", "GCAD.HookProfiling",
		function ()
			GCAD.Profiler:Begin ("Render")
		end
	)
	hook.Add ("PreDrawViewModel", "GCAD.HookProfiling",
		function ()
			-- GCAD.Profiler:Begin ("DrawViewModel")
		end
	)
	hook.Add ("PreDrawHUD", "GCAD.HookProfiling",
		function ()
			GCAD.Profiler:Begin ("DrawHUD")
		end
	)
	hook.Add ("PreDrawOpaqueRenderables", "GCAD.HookProfiling",
		function ()
			GCAD.Profiler:Begin ("DrawOpaqueRenderables")
		end
	)
	hook.Add ("PreDrawTranslucentRenderables", "GCAD.HookProfiling",
		function ()
			GCAD.Profiler:Begin ("DrawTranslucentRenderables")
		end
	)
	hook.Add ("PostRender",                     "GCAD.HookProfiling", function () GCAD.Profiler:End () end)
	-- hook.Add ("PostDrawViewModel",              "GCAD.HookProfiling", function () GCAD.Profiler:End () end)
	hook.Add ("PostDrawHUD",                    "GCAD.HookProfiling", function () GCAD.Profiler:End () end)
	hook.Add ("PostDrawOpaqueRenderables",      "GCAD.HookProfiling", function () GCAD.Profiler:End () end)
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.HookProfiling", function () GCAD.Profiler:End () end)
	
	self.OriginalHookAdd = hook.Add
	self.HookAdd = function (eventName, hookName, f)
		self.OriginalHookAdd (eventName, hookName, f)
		
		local f = hook.GetTable () [eventName] [hookName]
		if not f then return end
		
		self.OriginalHooks [eventName] = self.OriginalHooks [eventName] or {}
		self.Hooks         [eventName] = self.Hooks         [eventName] or {}
		
		self.OriginalHooks [eventName] [hookName] = f
		self.Hooks         [eventName] [hookName] = GCAD.Profiler:Wrap (self.OriginalHooks [eventName] [hookName], eventName .. ":" .. tostring (hookName))
		self.Hooks         [eventName] [hookName] = GCAD.Profiler:Wrap (self.Hooks [eventName] [hookName], eventName)
		
		hook.GetTable () [eventName] [hookName] = self.Hooks [eventName] [hookName]
	end
	
	hook.Add = self.HookAdd
end

function self:Disable ()
	if not self.Enabled then return end
	
	self.Enabled = false
	
	if hook.Add == self.HookAdd then
		hook.Add = self.OriginalHookAdd
	end
	
	hook.Remove ("PreRender",                      "GCAD.HookProfiling")
	hook.Remove ("PostRender",                     "GCAD.HookProfiling")
	hook.Remove ("PreDrawViewModel",               "GCAD.HookProfiling")
	hook.Remove ("PostDrawViewModel",              "GCAD.HookProfiling")
	hook.Remove ("PreDrawHUD",                     "GCAD.HookProfiling")
	hook.Remove ("PostDrawHUD",                    "GCAD.HookProfiling")
	hook.Remove ("PreDrawOpaqueRenderables",       "GCAD.HookProfiling")
	hook.Remove ("PostDrawOpaqueRenderables",      "GCAD.HookProfiling")
	hook.Remove ("PreDrawTranslucentRenderables",  "GCAD.HookProfiling")
	hook.Remove ("PostDrawTranslucentRenderables", "GCAD.HookProfiling")
	
	for eventName, eventTable in pairs (hook.GetTable ()) do
		self.OriginalHooks [eventName] = self.OriginalHooks [eventName] or {}
		self.Hooks         [eventName] = self.Hooks         [eventName] or {}
		
		for hookName, hookFunction in pairs (eventTable) do
			if hookFunction == self.Hooks [eventName] [hookName] then
				eventTable [hookName] = self.OriginalHooks [eventName] [hookName]
			end
		end
	end
	
	self.OriginalHooks = {}
	self.Hooks         = {}
end

GCAD.HookProfiling = GCAD.HookProfiling ()
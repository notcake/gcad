local self = {}
GCAD.ConcommandProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	self.OriginalConcommands = {}
	self.Concommands         = {}
	
	concommand.Add ("gcad_concommand_profiling_enable",  function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("gcad_concommand_profiling_disable", function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	concommand.Add ("+gcad_concommand_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("-gcad_concommand_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.ConcommandProfiling",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.ConcommandProfiling")
	
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
	
	for commandName, handler in pairs (concommand.GetTable ()) do
		self.OriginalConcommands [commandName] = handler
		self.Concommands         [commandName] = GCAD.Profiler:Wrap (self.OriginalConcommands [commandName], "concommand.GetTable () [\"" .. GLib.String.EscapeNonprintable (commandName) .. "\"]")
		
		concommand.GetTable () [commandName] = self.Concommands [commandName]
	end
end

function self:Disable ()
	if not self.Enabled then return end
	
	self.Enabled = false
	
	for commandName, handler in pairs (concommand.GetTable ()) do
		if handler == self.Concommands [commandName] then
			concommand.GetTable () [commandName] = self.OriginalConcommands [commandName]
		end
	end
	
	self.OriginalConcommands = {}
	self.Concommands         = {}
end

GCAD.ConcommandProfiling = GCAD.ConcommandProfiling ()

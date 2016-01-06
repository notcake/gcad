local self = {}
GCAD.NetProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	self.OriginalReceivers = {}
	self.Receivers         = {}
	
	concommand.Add ("gcad_net_profiling_enable",  function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("gcad_net_profiling_disable", function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	concommand.Add ("+gcad_net_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (true ) end)
	concommand.Add ("-gcad_net_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end self:SetEnabled (false) end)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.NetProfiling",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.NetProfiling")
	
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
	
	for channelName, handler in pairs (net.Receivers) do
		self.OriginalReceivers [channelName] = handler
		self.Receivers         [channelName] = GCAD.Profiler:Wrap (self.OriginalReceivers [channelName], "net.Receivers [\"" .. GLib.String.EscapeNonprintable (channelName) .. "\"]")
		
		net.Receivers [channelName] = self.Receivers [channelName]
	end
end

function self:Disable ()
	if not self.Enabled then return end
	
	self.Enabled = false
	
	for channelName, handler in pairs (net.Receivers) do
		if handler == self.Receivers [channelName] then
			net.Receivers [channelName] = self.OriginalReceivers [channelName]
		end
	end
	
	self.OriginalReceivers = {}
	self.Receivers         = {}
end

GCAD.NetProfiling = GCAD.NetProfiling ()

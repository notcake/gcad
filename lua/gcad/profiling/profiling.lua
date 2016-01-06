local function EnableProfiling ()
	GCAD.HookProfiling        :SetEnabled (true)
	GCAD.GamemodeHookProfiling:SetEnabled (true)
	GCAD.NetProfiling         :SetEnabled (true)
	GCAD.ConcommandProfiling  :SetEnabled (true)
	
	if GCAD.PanelProfiling then
		GCAD.PanelProfiling:SetEnabled (true)
	end
end

local function DisableProfiling ()
	GCAD.HookProfiling        :SetEnabled (false)
	GCAD.GamemodeHookProfiling:SetEnabled (false)
	GCAD.NetProfiling         :SetEnabled (false)
	GCAD.ConcommandProfiling  :SetEnabled (false)
	
	if GCAD.PanelProfiling then
		GCAD.PanelProfiling:SetEnabled (false)
	end
end

concommand.Add ("gcad_profiling_enable",  function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end EnableProfiling  () end)
concommand.Add ("gcad_profiling_disable", function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end DisableProfiling () end)
concommand.Add ("+gcad_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end EnableProfiling  () end)
concommand.Add ("-gcad_profiling",        function (ply, _, _) if not GCAD.CanRunConCommand (ply) then return end DisableProfiling () end)

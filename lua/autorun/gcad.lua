if SERVER or
   file.Exists ("gcad/gcad.lua", "LUA") or
   file.Exists ("gcad/gcad.lua", "LCL") and GetConVar ("sv_allowcslua"):GetBool () then
	include ("gcad/gcad.lua")
end
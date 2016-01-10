if not LocalPlayer or
   not LocalPlayer () or
   not LocalPlayer ():IsValid () or
   not LocalPlayer ().SteamID or
   LocalPlayer ():SteamID () ~= "STEAM_0:1:19269760" then
	return
end

include ("contextmenu/selectionrenderer.lua")
include ("contextmenu/eventedcollectionculler.lua")
include ("contextmenu/contextmenucontextmenu.lua")
include ("contextmenu/contextmenueventsource.lua")
include ("contextmenu/contextmenueventhandler.lua")

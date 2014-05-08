if GCAD then return end
GCAD = GCAD or {}

include ("glib/glib.lua")
include ("gooey/gooey.lua")
pcall (include, "gcompute/gcompute.lua")
pcall (include, "gcodec/gcodec.lua")

GLib.Initialize ("GCAD", GCAD)
GLib.AddCSLuaPackSystem ("GCAD")
GLib.AddCSLuaPackFile ("autorun/gcad.lua")
GLib.AddCSLuaPackFolderRecursive ("gcad")

include ("space/plane3d.lua")
include ("space/aabb3d.lua")
include ("space/obb3d.lua")
include ("space/sphere3d.lua")
include ("space/frustum3d.lua")
include ("space/nativesphere3d.lua")

GCAD.AddReloadCommand ("gcad/gcad.lua", "gcad", "GCAD")

if CLIENT then
	GCAD.IncludeDirectory ("gcad/ui")
end
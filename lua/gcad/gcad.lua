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

-- Spatial queries
include ("space/queries/spatialqueryresult.lua")
include ("space/queries/ispatialqueryable2d.lua")
include ("space/queries/ispatialqueryable3d.lua")

-- Spatial primitives
include ("space/primitives/plane3d.lua")
include ("space/primitives/aabb3d.lua")
include ("space/primitives/obb3d.lua")
include ("space/primitives/sphere3d.lua")
include ("space/primitives/frustum3d.lua")
include ("space/primitives/nativesphere3d.lua")

GCAD.AddReloadCommand ("gcad/gcad.lua", "gcad", "GCAD")

if CLIENT then
	GCAD.IncludeDirectory ("gcad/ui")
end
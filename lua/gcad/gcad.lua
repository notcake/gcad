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

-- Profiling
include ("profiling/profiler.lua")
include ("profiling/profilingstatisticsrenderer.lua")

-- Linear algebra
include ("linearalgebra/unpackedvector2d.lua")
include ("linearalgebra/unpackedvector3d.lua")
include ("linearalgebra/vector2d.lua")
include ("linearalgebra/vector3d.lua")
include ("linearalgebra/matrix2x2.lua")
include ("linearalgebra/matrix3x3.lua")

-- Spatial queries
include ("space/queries/spatialqueryresult.lua")
include ("space/queries/ispatialqueryable2d.lua")
include ("space/queries/ispatialqueryable3d.lua")

-- Solids
include ("space/shapes/plane3d.lua")
include ("space/shapes/aabb3d.lua")
include ("space/shapes/obb3d.lua")
include ("space/shapes/sphere3d.lua")
include ("space/shapes/frustum3d.lua")
include ("space/shapes/nativesphere3d.lua")

-- Spatial queryables
include ("space/engineentitiesspatialqueryable.lua")

GCAD.AddReloadCommand ("gcad/gcad.lua", "gcad", "GCAD")

if CLIENT then
	GCAD.IncludeDirectory ("gcad/ui")
end
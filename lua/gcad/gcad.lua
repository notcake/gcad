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

-- Mathematics
include ("math/eulerangle.lua")
include ("math/unpackedeulerangle.lua")

include ("math/range1d.lua")
include ("math/range2d.lua")
include ("math/range3d.lua")
include ("math/unpackedrange1d.lua")
include ("math/unpackedrange2d.lua")
include ("math/unpackedrange3d.lua")

-- Spatial queries
include ("space/queries/linetraceintersectiontype.lua")
include ("space/queries/linetraceresult.lua")
include ("space/queries/spatialqueryresult.lua")
include ("space/queries/ispatialqueryable2d.lua")
include ("space/queries/ispatialqueryable3d.lua")

-- Solids
-- Planes
include ("space/shapes/planes/plane2d.lua")
include ("space/shapes/planes/plane3d.lua")
include ("space/shapes/planes/normalizedplane2d.lua")
include ("space/shapes/planes/normalizedplane3d.lua")
include ("space/shapes/planes/unpackedplane2d.lua")
include ("space/shapes/planes/unpackedplane3d.lua")
include ("space/shapes/planes/unpackednormalizedplane2d.lua")
include ("space/shapes/planes/unpackednormalizedplane3d.lua")
include ("space/shapes/planes/nativeplane3d.lua")
include ("space/shapes/planes/nativenormalizedplane3d.lua")

-- Spheres
include ("space/shapes/spheres/circle2d.lua")
include ("space/shapes/spheres/sphere3d.lua")
include ("space/shapes/spheres/unpackedcircle2d.lua")
include ("space/shapes/spheres/unpackedsphere3d.lua")
include ("space/shapes/spheres/nativesphere3d.lua")

-- Boxes
-- include ("space/shapes/boxes/aabb2d.lua")
include ("space/shapes/boxes/aabb3d.lua")
-- include ("space/shapes/boxes/obb2d.lua")
include ("space/shapes/boxes/obb3d.lua")

include ("space/shapes/boxes/legacyaabb3d.lua")

-- Lines
-- include ("space/shapes/lines/line2d.lua")
include ("space/shapes/lines/line3d.lua")
-- include ("space/shapes/lines/nativeline3d.lua")

-- include ("space/shapes/lines/ray2d.lua")
-- include ("space/shapes/lines/ray3d.lua")
-- include ("space/shapes/lines/nativeray3d.lua")

-- include ("space/shapes/lines/linesegment2d.lua")
-- include ("space/shapes/lines/linesegment3d.lua")
-- include ("space/shapes/lines/nativelinesegment3d.lua")

-- Frustums
include ("space/shapes/frustums/frustum3d.lua")
include ("space/shapes/frustums/nativefrustum3d.lua")

-- Spatial queryables
include ("space/engineentitiesspatialqueryable.lua")

-- Signal Processing
include ("signalprocessing/digitalfilters/realfirfilter.lua")
include ("signalprocessing/digitalfilters/realiirfilter.lua")
-- include ("signalprocessing/digitalfilters/complexfirfilter.lua")
-- include ("signalprocessing/digitalfilters/complexiirfilter.lua")

GCAD.AddReloadCommand ("gcad/gcad.lua", "gcad", "GCAD")

if CLIENT then
	GCAD.UI = {}
	include ("ui/events.lua")
	include ("ui/selection.lua")
	GCAD.IncludeDirectory ("gcad/ui")
end
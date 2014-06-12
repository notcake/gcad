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
include ("profiling/profilersectionentry.lua")
include ("profiling/profiler.lua")
include ("profiling/entityprofiling.lua")
include ("profiling/panelprofiling.lua")
include ("profiling/profilingstatisticsrenderer.lua")

-- Utility
include ("util/mapcache.lua")
include ("util/pool.lua")

GCAD.Pools = GCAD.MapCache (GCAD.Pool) -- Booyah
GCAD.Pools.Deallocate = function (self, item)
	self:Get (item:__GetStaticTable ()):Deallocate (item)
end

-- Linear algebra
include ("linearalgebra/unpackedvector2d.lua")
include ("linearalgebra/unpackedvector3d.lua")
include ("linearalgebra/unpackedvector4d.lua")
include ("linearalgebra/vector2d.lua")
include ("linearalgebra/vector3d.lua")
include ("linearalgebra/vector4d.lua")
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

include ("space/queries/aggregatespatialqueryable2d.lua")
include ("space/queries/aggregatespatialqueryable3d.lua")

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
include ("space/shapes/boxes/nativeobb3d.lua")

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

-- Models
-- include ("models/model.lua")
-- include ("models/modelcache.lua")
-- include ("models/modelinstance.lua")
-- include ("models/modelinstancecache.lua")

-- Components
GCAD.Components = {}
include ("components/icomponenthost.lua")
include ("components/componenthost.lua")
include ("components/componenthostproxy.lua")

include ("components/icomponent.lua")
include ("components/component.lua")

-- Spatial nodes
include ("space/ispatialnode2dhost.lua")
include ("space/ispatialnode2d.lua")

include ("space/ispatialnode3dhost.lua")
include ("space/ispatialnode3d.lua")

-- Space
include ("space/space3d.lua")

-- Rendering
include ("irendernode.lua")
include ("irendernodehost.lua")

-- VEntities
GCAD.VEntities = {}
include ("ventities/ventity.lua")

include ("ventities/point3dcomponent.lua")
include ("ventities/model.lua")
include ("ventities/pathfindingnode.lua")

-- Signal Processing
include ("signalprocessing/digitalfilters/realfirfilter.lua")
include ("signalprocessing/digitalfilters/realiirfilter.lua")
-- include ("signalprocessing/digitalfilters/complexfirfilter.lua")
-- include ("signalprocessing/digitalfilters/complexiirfilter.lua")

-- Rendering
include ("rendering/viewrenderinfo.lua")

-- Engine Interop
include ("space/engineentitiesspatialqueryable.lua")
include ("ventities/entityreference.lua")

-- PAC3 Interop
GCAD.PAC3 = {}
include ("pac3/spatialextensions.lua")
include ("pac3/pacpartsspatialqueryable.lua")
include ("pac3/pacpartreference.lua")

GCAD.AddReloadCommand ("gcad/gcad.lua", "gcad", "GCAD")

-- Fun starts here
GCAD.EngineEntitiesSpatialQueryable = GCAD.EngineEntitiesSpatialQueryable ()
GCAD.PACPartsSpatialQueryable       = GCAD.PACPartsSpatialQueryable ()
GCAD.VSpace3d                       = GCAD.Space3d ()

GCAD.AggregateSpatialQueryable      = GCAD.AggregateSpatialQueryable3d ()
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.EngineEntitiesSpatialQueryable)
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.PACPartsSpatialQueryable      )
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.VSpace3d                      )

if CLIENT then
	GCAD.UI = {}
	include ("ui/events.lua")
	include ("ui/selection.lua")
	GCAD.IncludeDirectory ("gcad/ui")
end
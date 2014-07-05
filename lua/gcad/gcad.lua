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
if CLIENT then
	include ("profiling/panelprofiling.lua")
	include ("profiling/profilingstatisticsrenderer.lua")
end
include ("profiling/profilingstatisticsprinter.lua")

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
include ("linearalgebra/matrix4x4.lua")

-- Mathematics
include ("math/eulerangle.lua")
include ("math/unpackedeulerangle.lua")

include ("math/range1d.lua")
include ("math/range2d.lua")
include ("math/range3d.lua")
include ("math/unpackedrange1d.lua")
include ("math/unpackedrange2d.lua")
include ("math/unpackedrange3d.lua")

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
-- include ("space/shapes/boxes/nativeaabb3d.lua")
-- include ("space/shapes/boxes/obb2d.lua")
include ("space/shapes/boxes/obb3d.lua")
include ("space/shapes/boxes/nativeobb3d.lua")

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

-- Spatial queries
include ("space/queries/linetraceintersectiontype.lua")
include ("space/queries/linetraceresult.lua")
include ("space/queries/spatialqueryresult.lua")
include ("space/queries/ispatialqueryable2d.lua")
include ("space/queries/ispatialqueryable3d.lua")

include ("space/queries/obbspatialqueryable3d.lua")
include ("space/queries/aggregatespatialqueryable2d.lua")
include ("space/queries/aggregatespatialqueryable3d.lua")

-- Materials
GCAD.Materials = {}
include ("materials/utility.lua")

-- Meshes
GCAD.Meshes = {}
include ("meshes/utility.lua")

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
include ("space/spatialnode2d.lua")

include ("space/ispatialnode3dhost.lua")
include ("space/ispatialnode3d.lua")
include ("space/spatialnode3d.lua")

-- Space
include ("space/space3d.lua")

-- Actions
GCAD.Actions = {}
include ("actions/iaction.lua")
include ("actions/iactionparameter.lua")
include ("actions/iactionprovider.lua")
include ("actions/action.lua")
include ("actions/actionparameter.lua")
include ("actions/actionprovider.lua")
include ("actions/aggregateactionprovider.lua")
include ("actions/contextmenuaction.lua")
include ("actions/contextmenuactionprovider.lua")
GCAD.ActionProvider          = GCAD.Actions.ActionProvider ()
GCAD.AggregateActionProvider = GCAD.Actions.AggregateActionProvider ()
GCAD.AggregateActionProvider:AddActionProvider (GCAD.ActionProvider)
-- GCAD.AggregateActionProvider:AddActionProvider (GCAD.Actions.ContextMenuActionProvider)

-- VEntities
GCAD.VEntities = {}
include ("ventities/ventity.lua")

include ("ventities/point3dcomponent.lua")
include ("ventities/model.lua")

-- Signal Processing
include ("signalprocessing/digitalfilters/realfirfilter.lua")
include ("signalprocessing/digitalfilters/realiirfilter.lua")
-- include ("signalprocessing/digitalfilters/complexfirfilter.lua")
-- include ("signalprocessing/digitalfilters/complexiirfilter.lua")

-- Rendering
include ("rendering/irendercomponent.lua")
include ("rendering/irendermodifiercomponent.lua")
include ("rendering/nullrendercomponent.lua")
include ("rendering/nullrendermodifiercomponent.lua")
include ("rendering/viewrenderinfo.lua")

-- Graphs
GCAD.Graphs = {}
include ("graphs/igraph.lua")
include ("graphs/graph.lua")
include ("graphs/directedgraph.lua")
include ("graphs/undirectedgraph.lua")

-- Scene Graph
GCAD.SceneGraph = {}
GCAD.SceneGraph.Components = {}
include ("scenegraph/iscenegraph.lua")
include ("scenegraph/iscenegraphnode.lua")
include ("scenegraph/scenegraph.lua")
include ("scenegraph/scenegraphnode.lua")
include ("scenegraph/components/nontransformationnode.lua")
include ("scenegraph/components/groupnode.lua")
include ("scenegraph/components/transformationnode.lua")
include ("scenegraph/components/orthogonalaffinetransformationnode.lua")
include ("scenegraph/matrixtransformationnode.lua")
include ("scenegraph/orthogonalaffinetransformationnode.lua")
include ("scenegraph/transformationnode.lua")
include ("scenegraph/groupnode.lua")
include ("scenegraph/modelnode.lua")
include ("scenegraph/scenegraphrenderer.lua")

-- Engine Interop
include ("nativeentities/nativeentitylist.lua")
include ("ventities/entityreference.lua")

-- PAC3 Interop
GCAD.PAC3 = {}
include ("pac3/spatialextensions.lua")
include ("pac3/pacpartlist.lua")
include ("pac3/pacpartreference.lua")

-- Navigation
GCAD.Navigation = {}
include ("navigation/navigationgraph.lua")
include ("navigation/navigationgraphedge.lua")
include ("navigation/navigationgraphnode.lua")

include ("navigation/navigationgraphedgegenerator.lua")

include ("navigation/navigationgraphentitylist.lua")
include ("navigation/navigationgraphnodeentitylist.lua")
include ("navigation/navigationgraphedgeentitylist.lua")
include ("navigation/navigationgraphnodeentity.lua")
include ("navigation/navigationgraphedgeentity.lua")

include ("navigation/navigationgraphactions.lua")
include ("navigation/navigationgraphserializer.lua")

if CLIENT then
	include ("navigation/navigationgraphedgerendercomponent.lua")
	include ("navigation/navigationgraphrenderer.lua")
end

include ("autopilot.lua")

function GCAD.CanRunConCommand (ply)
	if CLIENT then return true end
	if SERVER then
		if not ply            then return true end
		if not ply:IsValid () then return true end
		if ply:IsAdmin ()     then return true end
	end
	
	return false
end

GCAD.AddReloadCommand ("gcad/gcad.lua", "gcad", "GCAD")

-- Fun starts here
GCAD.DestructorInvoker              = GCAD.Invoker ()
GCAD:AddEventListener ("Unloaded",
	function ()
		GCAD.DestructorInvoker:Invoke ()
	end
)

GCAD.RootSceneGraph                 = GCAD.SceneGraph.SceneGraph ()
GCAD.RootSceneGraphRenderer         = GCAD.SceneGraph.SceneGraphRenderer (GCAD.RootSceneGraph)
GCAD.DestructorInvoker:AddDestructor (GCAD.RootSceneGraphRenderer)

GCAD.NavigationGraph                = GCAD.Navigation.NavigationGraph ()
GCAD.NavigationGraphEntityList      = GCAD.Navigation.NavigationGraphEntityList (GCAD.NavigationGraph)
GCAD.NavigationGraphEdgeGenerator   = GCAD.Navigation.NavigationGraphEdgeGenerator (GCAD.NavigationGraph)
if CLIENT then
	GCAD.NavigationGraphRenderer    = GCAD.Navigation.NavigationGraphRenderer (GCAD.NavigationGraph, GCAD.RootSceneGraph, GCAD.NavigationGraphEntityList)
end
GCAD.NavigationGraphSerializer      = GCAD.Navigation.NavigationGraphSerializer (GCAD.NavigationGraph)
GCAD.NavigationGraphSerializer:Load ()
GCAD.DestructorInvoker:AddDestructor (GCAD.NavigationGraphSerializer)

GCAD.NativeEntityList               = GCAD.NativeEntityList ()
GCAD.PACPartList                    = GCAD.PACPartList ()
GCAD.VSpace3d                       = GCAD.Space3d ()

GCAD.AggregateSpatialQueryable      = GCAD.AggregateSpatialQueryable3d ()
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.NativeEntityList              )
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.PACPartList                   )
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.NavigationGraphEntityList     )
GCAD.AggregateSpatialQueryable:AddSpatialQueryable (GCAD.VSpace3d                      )

if CLIENT then
	GCAD.Autopilot = GCAD.Autopilot ()
end

if CLIENT then
	GCAD.UI = {}
	include ("ui/events.lua")
	include ("ui/selection.lua")
	GCAD.IncludeDirectory ("gcad/ui")
end
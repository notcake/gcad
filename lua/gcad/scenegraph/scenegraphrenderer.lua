local self = {}
GCAD.SceneGraph.SceneGraphRenderer = GCAD.MakeConstructor (self)

local cam_PushModelMatrix = cam._PushModelMatrix or cam.PushModelMatrix
local cam_PopModelMatrix  = cam._PopModelMatrix  or cam.PopModelMatrix

function self:ctor (sceneGraph)
	self.SceneGraph = sceneGraph
	
	local viewRenderInfo = GCAD.ViewRenderInfo ()
	hook.Add ("PostDrawOpaqueRenderables", "GCAD.SceneGraphRenderer." .. self:GetHashCode (),
		function (isDepthRender, isSkyboxRender)
			GCAD.Profiler:Begin ("PostDrawOpaqueRenderables:GCAD.SceneGraphRenderer")
			viewRenderInfo = GCAD.ViewRenderInfo.FromDrawRenderablesHook (isDepthRender, isSkyboxRender, viewRenderInfo)
			self:RenderOpaque (viewRenderInfo)
			GCAD.Profiler:End ()
		end
	)
	hook.Add ("PostDrawTranslucentRenderables", "GCAD.SceneGraphRenderer." .. self:GetHashCode (),
		function (isDepthRender, isSkyboxRender)
			GCAD.Profiler:Begin ("PostDrawTranslucentRenderables:GCAD.SceneGraphRenderer")
			viewRenderInfo = GCAD.ViewRenderInfo.FromDrawRenderablesHook (isDepthRender, isSkyboxRender, viewRenderInfo)
			self:RenderTranslucent (viewRenderInfo)
			GCAD.Profiler:End ()
		end
	)
end

function self:dtor ()
	hook.Remove ("PostDrawOpaqueRenderables",      "GCAD.SceneGraphRenderer." .. self:GetHashCode ())
	hook.Remove ("PostDrawTranslucentRenderables", "GCAD.SceneGraphRenderer." .. self:GetHashCode ())
end

function self:GetSceneGraph ()
	return self.SceneGraph
end

function self:SetSceneGraph (sceneGraph)
	if self.SceneGraph == sceneGraph then return self end
	
	self.SceneGraph = sceneGraph
	
	return self
end

function self:RenderOpaque (viewRenderInfo)
	self:RenderNodeOpaque (viewRenderInfo, self.SceneGraph:GetRootNode ())
	
	render.SetColorMaterial ()
end

function self:RenderTranslucent (viewRenderInfo)
	self:RenderNodeTranslucent (viewRenderInfo, self.SceneGraph:GetRootNode ())
	
	render.SetColorMaterial ()
end

function self:RenderNodeOpaque (viewRenderInfo, sceneGraphNode)
	local renderComponent = sceneGraphNode:GetRenderComponent ()
	local renderModifierComponent = sceneGraphNode:GetRenderModifierComponent ()
	
	-- Pre render
	if renderModifierComponent:HasPreRenderModifier () then
		renderModifierComponent:PreRender ()
	end
	
	-- Render children
	if sceneGraphNode.Space3d then
		local spatialQueryResult = GCAD.Pools:Get (GCAD.SpatialQueryResult):Allocate ()
		spatialQueryResult:Clear ()
		Profiler:Begin ("Space3d:FindIntersectingFrustum")
		spatialQueryResult = sceneGraphNode.Space3d:FindIntersectingFrustum (viewRenderInfo:GetFrustum (), spatialQueryResult)
		Profiler:End ()
		
		Profiler:Begin ("Dispatch RenderNodeOpaque", spatialQueryResult:GetResultCount ())
		for childNode in spatialQueryResult:GetEnumerator () do
			if childNode:IsVisible () then
				self:RenderNodeOpaque (viewRenderInfo, childNode)
			end
		end
		Profiler:End ()
		
		GCAD.Pools:Get (GCAD.SpatialQueryResult):Deallocate (spatialQueryResult)
	else
		for childNode in sceneGraphNode:GetChildEnumerator () do
			if childNode:IsVisible () then
				self:RenderNodeOpaque (viewRenderInfo, childNode)
			end
		end
	end
	
	-- Render this
	if renderComponent:HasOpaqueRendering () then
		cam_PushModelMatrix (sceneGraphNode:GetLocalToWorldMatrixNative ())
		renderComponent:RenderOpaque ()
		cam_PopModelMatrix ()
	end
	
	-- Post render
	if renderModifierComponent:HasPostRenderModifier () then
		renderModifierComponent:PostRender ()
	end
end

function self:RenderNodeTranslucent (viewRenderInfo, sceneGraphNode)
	local renderModifierComponent = sceneGraphNode:GetRenderModifierComponent ()
	
	-- Pre render
	if renderModifierComponent:HasPreRenderModifier () then
		renderModifierComponent:PreRender ()
	end
	
	-- Render children
	if sceneGraphNode.Space3d then
		local spatialQueryResult = GCAD.Pools:Get (GCAD.SpatialQueryResult):Allocate ()
		spatialQueryResult:Clear ()
		Profiler:Begin ("Space3d:FindIntersectingFrustum")
		spatialQueryResult = sceneGraphNode.Space3d:FindIntersectingFrustum (viewRenderInfo:GetFrustum (), spatialQueryResult)
		Profiler:End ()
		
		Profiler:Begin ("Dispatch RenderNodeTranslucent", spatialQueryResult:GetResultCount ())
		for childNode in spatialQueryResult:GetEnumerator () do
			if childNode:IsVisible () then
				self:RenderNodeTranslucent (viewRenderInfo, childNode)
			end
		end
		Profiler:End ()
		
		GCAD.Pools:Get (GCAD.SpatialQueryResult):Deallocate (spatialQueryResult)
	else
		for childNode in sceneGraphNode:GetChildEnumerator () do
			if childNode:IsVisible () then
				self:RenderNodeTranslucent (viewRenderInfo, childNode)
			end
		end
	end
	
	-- Render this
	local renderComponent = sceneGraphNode:GetRenderComponent ()
	if renderComponent:HasTranslucentRendering () then
		cam_PushModelMatrix (sceneGraphNode:GetLocalToWorldMatrixNative ())
		renderComponent:RenderTranslucent ()
		cam_PopModelMatrix ()
	end
	
	-- Post render
	if renderModifierComponent:HasPostRenderModifier () then
		renderModifierComponent:PostRender ()
	end
end
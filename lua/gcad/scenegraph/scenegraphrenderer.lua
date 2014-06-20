local self = {}
GCAD.SceneGraph.SceneGraphRenderer = GCAD.MakeConstructor (self)

function self:ctor (sceneGraph)
	self.SceneGraph = sceneGraph
	
	GCAD:AddEventListener ("Unloaded", "GCAD.SceneGraphRenderer." .. self:GetHashCode (),
		function ()
			self:dtor ()
		end
	)
	
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
	GCAD:RemoveEventListener ("Unloaded", "GCAD.SceneGraphRenderer." .. self:GetHashCode ())
	
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
end

function self:RenderTranslucent (viewRenderInfo)
	self:RenderNodeTranslucent (viewRenderInfo, self.SceneGraph:GetRootNode ())
end

function self:RenderNodeOpaque (viewRenderInfo, sceneGraphNode)
	local renderComponent = sceneGraphNode:GetRenderComponent ()
	local renderModifierComponent = sceneGraphNode:GetRenderModifierComponent ()
	
	if renderModifierComponent:HasPreRenderModifier () then
		renderModifierComponent:PreRender ()
	end
	
	for childNode in sceneGraphNode:GetChildEnumerator () do
		self:RenderNodeOpaque (viewRenderInfo, childNode)
	end
	
	if renderComponent:HasOpaqueRendering () then
		cam.PushModelMatrix (sceneGraphNode:GetLocalToWorldMatrixNative ())
		renderComponent:RenderOpaque ()
		cam.PopModelMatrix ()
	end
	
	if renderModifierComponent:HasPostRenderModifier () then
		renderModifierComponent:PostRender ()
	end
end

function self:RenderNodeTranslucent (viewRenderInfo, sceneGraphNode)
	local renderComponent = sceneGraphNode:GetRenderComponent ()
	local renderModifierComponent = sceneGraphNode:GetRenderModifierComponent ()
	
	if renderModifierComponent:HasPreRenderModifier () then
		renderModifierComponent:PreRender ()
	end
	
	for childNode in sceneGraphNode:GetChildEnumerator () do
		self:RenderNodeTranslucent (viewRenderInfo, childNode)
	end
	
	if renderComponent:HasTranslucentRendering () then
		cam.PushModelMatrix (sceneGraphNode:GetLocalToWorldMatrixNative ())
		renderComponent:RenderTranslucent ()
		cam.PopModelMatrix ()
	end
	
	if renderModifierComponent:HasPostRenderModifier () then
		renderModifierComponent:PostRender ()
	end
end
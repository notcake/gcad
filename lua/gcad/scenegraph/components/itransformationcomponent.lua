local self = {}
GCAD.SceneGraph.Components.ITransformationComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.ISceneGraphNode)

function self:ctor ()
end

function self:Initialize ()
	GCAD.Error ("ITransformationComponent:Initialize : Not implemented.")
end

function self:Uninitialize ()
	GCAD.Error ("ITransformationComponent:Uninitialize : Not implemented.")
end

-- Scene graph node
function self:GetSceneGraphNode ()
	GCAD.Error ("ITransformationComponent:GetSceneGraphNode : Not implemented.")
end

-- Bounding volumes
function self:GetParentSpaceAABB ()
	GCAD.Error ("ITransformationComponent:GetParentSpaceAABB : Not implemented.")
end

function self:GetParentSpaceBoundingSphere ()
	GCAD.Error ("ITransformationComponent:GetParentSpaceBoundingSphere : Not implemented.")
end

function self:GetParentSpaceOBB ()
	GCAD.Error ("ITransformationComponent:GetParentSpaceOBB : Not implemented.")
end

-- Transformations
function self:GetLocalToParentMatrix ()
	GCAD.Error ("ITransformationComponent:GetLocalToParentMatrix : Not implemented.")
end

function self:GetLocalToParentMatrixNative ()
	GCAD.Error ("ITransformationComponent:GetLocalToParentMatrixNative : Not implemented.")
end

function self:GetParentToLocalMatrix ()
	GCAD.Error ("ITransformationComponent:GetParentToLocalMatrix : Not implemented.")
end

function self:GetParentToLocalMatrixNative ()
	GCAD.Error ("ITransformationComponent:GetParentToLocalMatrixNative : Not implemented.")
end

function self:GetLocalToWorldMatrix ()
	GCAD.Error ("ITransformationComponent:GetLocalToWorldMatrix : Not implemented.")
end

function self:GetLocalToWorldMatrixNative ()
	GCAD.Error ("ITransformationComponent:GetLocalToWorldMatrixNative : Not implemented.")
end

function self:GetWorldToLocalMatrix ()
	GCAD.Error ("ITransformationComponent:GetWorldToLocalMatrix : Not implemented.")
end

function self:GetWorldToLocalMatrixNative ()
	GCAD.Error ("ITransformationComponent:GetWorldToLocalMatrixNative : Not implemented.")
end

-- Invalidation
function self:InvalidateTransformation ()
	GCAD.Error ("ITransformationComponent:InvalidateTransformation : Not implemented.")
end

function self:InvalidateParentSpaceBoundingVolumes ()
	GCAD.Error ("ITransformationComponent:InvalidateParentSpaceBoundingVolumes : Not implemented.")
end
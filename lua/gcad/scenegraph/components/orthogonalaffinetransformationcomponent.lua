local self = {}
GCAD.SceneGraph.Components.OrthogonalAffineTransformationComponent = GCAD.MakeConstructor (self, GCAD.SceneGraph.Components.TransformationComponent)
local base = self.__base

function self:ctor ()
end

-- ITransformationComponent
function self:Initialize ()
	base.Initialize (self)
	
	self.Angle       = GCAD.EulerAngle (0, 0, 0)
	self.Scale       = GCAD.Vector3d (1, 1, 1)
	self.Translation = GCAD.Vector3d (0, 0, 0)
end

-- TransformationComponent
function self:ComputeLocalToParentMatrix ()
	self.LocalToParentMatrixValid = true
	
	-- Scale, then rotate, then translate
	-- M = T R S
	-- M = [ RxSx RySy RzSz T ]
	--     [    0    0    0 1 ]
	
	local m = GCAD.Matrix4x4.Rotate (self.Angle, self.LocalToParentMatrix)
	local k = self.Scale
	local kx, ky, kz = k [1], k [2], k [3]
	m [ 1], m [ 2], m [ 3] = kx * m [ 1], ky * m [ 2], kz * m [ 3]
	m [ 5], m [ 6], m [ 7] = kx * m [ 5], ky * m [ 6], kz * m [ 7]
	m [ 9], m [10], m [11] = kx * m [ 9], ky * m [10], kz * m [11]
	
	local t = self.Translation
	m [ 4], m [ 8], m [12] = t [1], t [2], t [3]
	
	self.LocalToParentMatrix = m
end

function self:ComputeParentToLocalMatrix ()
	self.ParentToLocalMatrixValid = true
	
	self.ParentToLocalMatrix = GCAD.Matrix4x4.InvertAffine (self:GetLocalToParentMatrix (), self.ParentToLocalMatrix)
end

-- OrthogonalAffineTransformationComponent
function self:GetAngle ()
	return self.Angle
end

function self:GetScale ()
	return self.Scale
end

function self:GetPosition ()
	return self.Translation
end

function self:GetTranslation ()
	return self.Translation
end

function self:SetAngle (angle)
	self.Angle = GCAD.EulerAngle.Clone (angle, self.Angle)
	
	self:InvalidateTransformation ()
	
	return self
end

function self:SetScale (scale)
	self.Scale = GCAD.Vector3d.Clone (scale, self.Scale)
	
	self:InvalidateTransformation ()
	
	return self
end

function self:SetPosition (pos)
	self.Translation = GCAD.Vector3d.Clone (pos, self.Translation)
	
	self:InvalidateTransformation ()
	
	return self
end

function self:SetTranslation (translation)
	self.Translation = GCAD.Vector3d.Clone (translation, self.Translation)
	
	self:InvalidateTransformation ()
	
	return self
end

GCAD.SceneGraph.Components.OrthogonalAffineTransformationComponent.Instance = GCAD.SceneGraph.Components.OrthogonalAffineTransformationComponent ()
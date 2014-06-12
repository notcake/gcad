local self = {}
GCAD.VEntities.Model = GCAD.MakeConstructor (self,
	GCAD.VEntities.VEntity,
	GCAD.ISpatialNode3d,
	GCAD.IRenderNode
)

function self:ctor ()
	-- ISpatialNode3d
	self:SetSpatialNode3d (self)
	
	-- IRenderNode
	self:SetRenderNode (self)
	
	-- Model
	self.ModelInstance = nil
end

-- IRenderNode
function self:Render (renderContext)
end

-- Model
function self:GetModel ()
	return self.ModelInstance:GetModel ()
end

function self:GetModelInstance ()
	return self.ModelInstance
end

function self:SetModel (model)
	if isstring (model) then
		model = GCAD.Model.From
	end
	
	if self.ModelInstance == model then return self end
	
	return self
end

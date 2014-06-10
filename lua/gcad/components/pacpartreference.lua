local self = {}
GCAD.Components.PACPartReference = GCAD.MakeConstructor (self,
	GCAD.Components.IComponent,
	GCAD.ISpatialNode3d
)

function GCAD.Components.PACPartReference.FromPACPart (part, out)
	out = out or GCAD.Components.PACPartReference ()
	out:SetPart (part)
	return out
end

function self:ctor ()
	-- ISpatialNode3d
	self.AABB           = GCAD.AABB3d ()
	self.BoundingSphere = GCAD.Sphere3d ()
	self.OBB            = GCAD.OBB3d ()
	self.NativeOBB      = GCAD.NativeOBB3d ()
	
	-- PACPartReference
	self.Part = nil
end

-- IRenderNodeHost
function self:GetRenderNode ()
	return nil
end

-- ISpatialNode3dHost
function self:GetSpatialNode3d ()
	if not self:IsResolved () then return nil end
	if self.Part.ClassName ~= "model" then return nil end
	
	return self
end

-- IComponent
function self:GetDisplayString ()
	if not self:IsResolved () then return self:GetTypeDisplayString () end
	
	if self:GetPart ().Name and
	   self:GetPart ().Name ~= "" then
		return self:GetTypeDisplayString () .. ": " .. self:GetPart ().Name
	end
	return self:GetTypeDisplayString ()
end

function self:GetIcon ()
	if not self:IsResolved () then return nil end
	
	if self:GetPart ().ClassName == "model" then return "icon16/brick.png" end
end

local classNameTypeDisplayStrings =
{
	["model"] = "PAC Model"
}

function self:GetTypeDisplayString ()
	if not self:IsResolved () then return "PAC Part" end
	
	return classNameTypeDisplayStrings [self:GetPart ().ClassName] or ("PAC " .. self:GetPart ().ClassName)
end

-- ISpatialNode3d
function self:GetAABB (out)
	out = out or self.AABB
	return GCAD.AABB3d.FromEntity (self.Part.Entity, out)
end

function self:GetBoundingSphere (out)
	out = out or self.BoundingSphere
	return GCAD.Sphere3d.FromPACPartBoundingSphere (self.Part, out)
end

function self:GetOBB (out)
	out = out or self.OBB
	return GCAD.OBB3d.FromPACPart (self.Part, out)
end

function self:GetNativeOBB (out)
	out = out or self.NativeOBB
	return GCAD.NativeOBB3d.FromPACPart (self.Part, out)
end

-- PACPartReference
function self:GetPart ()
	return self.Part
end

function self:IsResolved ()
	return self.Part ~= nil
end

function self:SetPart (part)
	if self.Part == part then return self end
	
	self.Part = part
	
	return self
end
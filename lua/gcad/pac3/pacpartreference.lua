local self = {}
GCAD.VEntities.PACPartReference = GCAD.MakeConstructor (self,
	GCAD.VEntities.VEntity,
	GCAD.ISpatialNode3d
)

function GCAD.VEntities.PACPartReference.FromPACPart (part, out)
	out = out or GCAD.VEntities.PACPartReference ()
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

-- IComponentHost
function self:GetSpatialNode3d ()
	if not self:IsResolved () then return nil end
	if self.Part.ClassName ~= "model" then return nil end
	
	return self
end

-- ISpatialNode3d
function self:GetAABB (out)
	out = out or self.AABB
	return GCAD.AABB3d.FromPACPart (self.Part, out)
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

-- VEntity
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

-- PACPartReference
function self:GetEntity ()
	if not self:IsResolved ()          then return nil end
	if not self.Part.Entity            then return nil end
	if not self.Part.Entity:IsValid () then return nil end
	
	return self.Part.Entity
end

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
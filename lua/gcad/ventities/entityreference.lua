local self = {}
GCAD.VEntities.EntityReference = GCAD.MakeConstructor (self,
	GCAD.VEntities.VEntity,
	GCAD.ISpatialNode3d
)

local Entity_GetTable = debug.getregistry ().Entity.GetTable
local Entity_IsValid  = debug.getregistry ().Entity.IsValid

function GCAD.VEntities.EntityReference.FromEntity (ent, out)
	out = out or GCAD.VEntities.EntityReference ()
	out:SetEntity (ent)
	return out
end

function self:ctor ()
	-- ISpatialNode3d
	self:SetSpatialNode3d (self)
	
	self.AABB           = GCAD.AABB3d ()
	self.BoundingSphere = GCAD.Sphere3d ()
	self.OBB            = GCAD.OBB3d ()
	self.NativeOBB      = GCAD.NativeOBB3d ()
	
	-- EntityReference
	self.Entity = nil
end

-- IDisposable
function self:IsValid ()
	return not self:IsDisposed () and self:IsResolved ()
end

-- ISpatialNode3d
function self:GetAABB (out)
	out = out or self.AABB
	return GCAD.AABB3d.FromEntity (self:GetEntity (), out)
end

function self:GetBoundingSphere (out)
	out = out or self.BoundingSphere
	return GCAD.Sphere3d.FromEntityBoundingSphere (self:GetEntity (), out)
end

function self:GetOBB (out)
	out = out or self.OBB
	return GCAD.OBB3d.FromEntity (self:GetEntity (), out)
end

function self:GetNativeOBB (out)
	out = out or self.NativeOBB
	return GCAD.NativeOBB3d.FromEntity (self:GetEntity (), out)
end

-- VEntity
function self:GetTypeName ()
	return "Entity"
end

-- Display
function self:GetDisplayString ()
	if not self:IsResolved () then return "Invalid entity" end
	
	if self:GetEntity ():IsPlayer () then
		return self:GetEntity ():Nick ()
	end
	
	return self:GetEntity ():GetClass () .. " [" .. self:GetEntity ():EntIndex () .. "]"
end

function self:GetIcon ()
	if not self:IsResolved () then return nil end
	
	if self:GetEntity ():IsPlayer () then
		return self:GetEntity ():IsAdmin () and "icon16/shield.png" or "icon16/user.png"
	end
	
	return nil
end

function self:GetTypeDisplayString ()
	return "Entity"
end

-- EntityReference
function self:GetEntity ()
	if self.Entity and not Entity_GetTable (self.Entity) then
		self.Entity = nil
	end
	return self.Entity
end

function self:SetEntity (ent)
	if ent and not Entity_GetTable (ent) then
		ent = nil
	end
	
	if self.Entity == ent then return self end
	
	self.Entity = ent
	
	return self
end

function self:IsResolved ()
	return self:GetEntity () ~= nil
end

function self:Resolve ()
	if self:IsResolved () then return true end
	
	return false
end
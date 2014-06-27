local self = {}
GCAD.Navigation.NavigationGraphNode = GCAD.MakeConstructor (self)

local Vector              = Vector

local Vector_Set          = debug.getregistry ().Vector.Set

local GCAD_UnpackedVector3d_ToNativeVector = GCAD.UnpackedVector3d.ToNativeVector
local GCAD_Vector3d_Clone                  = GCAD.Vector3d.Clone
local GCAD_Vector3d_Copy                   = GCAD.Vector3d.Copy
local GCAD_Vector3d_FromNativeVector       = GCAD.Vector3d.FromNativeVector
local GCAD_Vector3d_ToNativeVector         = GCAD.Vector3d.ToNativeVector
local GCAD_Vector3d_Unpack                 = GCAD.Vector3d.Unpack

--[[
	Events:
		NameChanged (string oldName, string newName)
			Fired when this NavigationGraphNode's name has changed.
		PositionChanged (Vector3d position)
			Fired when this NavigationGraphNode's position has changed.
]]

function self:ctor ()
	self.NavigationGraph = nil
	
	self.Name            = nil
	
	self.Position        = GCAD.Vector3d ()
	self.PositionNative  = Vector ()
	
	GCAD.EventProvider (self)
end

-- Navigation graph
function self:GetNavigationGraph ()
	return self.NavigationGraph
end

function self:GetId ()
	return self.NavigationGraph:GetNodeId (self)
end

function self:Remove ()
	if not self.NavigationGraph then return end
	
	self.NavigationGraph:RemoveNode (self)
end

function self:SetNavigationGraph (navigationGraph)
	if self.NavigationGraph == navigationGraph then return self end
	
	if self.NavigationGraph then
		local lastNavigationGraph = self.NavigationGraph
		self.NavigationGraph = nil
		lastNavigationGraph:RemoveNode (self)
	end
	self.NavigationGraph = navigationGraph
	if self.NavigationGraph then
		self.NavigationGraph:AddNode (self)
	end
	
	return self
end

-- Identity
function self:GetName ()
	return self.Name
end

function self:SetName (name)
	if self.Name == name then return self end
	
	local lastName = self.Last
	self.Name = name
	
	self:DispatchEvent ("NameChanged", lastName, self.Name)
	
	return self
end

-- Position
function self:GetPosition (out)
	return out and GCAD_Vector3d_Clone (self.Position, out) or self.Position
end

function self:GetPositionNative (out)
	if out then
		Vector_Set (out, self.PositionNative)
	else
		out = self.PositionNative
	end
	return out
end
function self:GetPositionUnpacked ()
	return GCAD_Vector3d_Unpack (self.Position)
end

function self:SetPosition (pos)
	self.Position       = GCAD_Vector3d_Clone          (pos, self.Position      )
	self.PositionNative = GCAD_Vector3d_ToNativeVector (pos, self.PositionNative)
	
	self:DispatchEvent ("PositionChanged", self.Position)
	
	return self
end

function self:SetPositionNative (pos)
	self.Position = GCAD_Vector3d_FromNativeVector (pos, self.Position)
	Vector_Set (self.PositionNative, pos)
	
	self:DispatchEvent ("PositionChanged", self.Position)
	
	return self
end

function self:SetPositionUnpacked (x, y, z)
	self.Position:Set (x, y, z)
	self.PositionnNative = GCAD_UnpackedVector3d_ToNativeVector (x, y, z, self.PositionNative)
	
	self:DispatchEvent ("PositionChanged", self.Position)
	
	return self
end
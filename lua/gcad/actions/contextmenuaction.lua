local self = {}
GCAD.Actions.ContextMenuAction = GCAD.MakeConstructor (self, GCAD.Actions.Action)

function self:ctor (id, actionInfo)
	self.ActionInfo = actionInfo
	
	self:AddParameter ("entity", "Entity")
	
	if string.sub (self.ActionInfo.MenuLabel, 1, 1) == "#" then
		self:SetName (language.GetPhrase (string.sub (self.ActionInfo.MenuLabel, 2)))
	else
		self:SetName (self.ActionInfo.MenuLabel)
	end
	
	self:SetIcon (self.ActionInfo.MenuIcon)
end

function self:CanExecute (userId, ventity)
	if not ventity:IsValid () or ventity:GetTypeName () ~= "Entity" then return false end
	local entity = ventity:GetEntity ()
	return self.ActionInfo:Filter (entity, GCAD.PlayerMonitor:GetUserEntity (userId))
end

function self:Execute (userId, ventity)
	if not ventity:IsValid () or ventity:GetTypeName () ~= "Entity" then return false end
	local entity = ventity:GetEntity ()
	self.ActionInfo:Action (entity)
	return true
end
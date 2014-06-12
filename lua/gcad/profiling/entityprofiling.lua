if not CLIENT then return end

local self = {}
GCAD.EntityProfiling = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	concommand.Add ("gcad_entity_profiling_enable",  function () self:SetEnabled (true ) end)
	concommand.Add ("gcad_entity_profiling_disable", function () self:SetEnabled (false) end)
	concommand.Add ("+gcad_entity_profiling",        function () self:SetEnabled (true ) end)
	concommand.Add ("-gcad_entity_profiling",        function () self:SetEnabled (false) end)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.EntityProfiling",
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	GCAD:RemoveEventListener ("Unloaded", "GCAD.EntityProfiling")
	
	self:SetEnabled (false)
end

function self:SetEnabled (enabled)
	if self.Enabled == enabled then return self end
	
	self.Enabled = enabled
	
	if self.Enabled then
		self:Enable ()
	else
		self:Disable ()
	end
	
	return self
end

-- Internal, do not call
function self:Enable ()
	self.Enabled = true
	
	self:EnumerateEntities (
		function (panel)
			self:HookEntity (panel)
		end
	)
	
	hook.Add ("OnEntityCreated", "GCAD.EntityProfiling",
		function (entity)
			self:HookEntity (entity)
		end
	)
	
	hook.Add ("NetworkEntityCreated", "GCAD.EntityProfiling",
		function (entity)
			self:HookEntity (entity)
		end
	)
end

function self:Disable ()
	self.Enabled = false
	
	self:EnumerateEntities (
		function (panel)
			self:UnhookEntity (panel)
		end
	)
	
	hook.Remove ("OnEntityCreated",      "GCAD.EntityProfiling")
	hook.Remove ("NetworkEntityCreated", "GCAD.EntityProfiling")
end

function self:EnumerateEntities (callback)
	for _, entity in ipairs (ents.GetAll ()) do
		callback (entity)
	end
end

local profiledMethods =
{
	"BuildBonePositions",
	"CalcAbsolutePosition",
	"Draw",
	"DrawTranslucent",
	"PhysicsSimulate",
	"PhysicsUpdate",
	"RenderOverride",
	"Think"
}

function self:HookEntity (entity)
	if not entity            then return end
	if not entity:IsValid () then return end
	
	for _, methodName in ipairs (profiledMethods) do
		local oldMethodName = "____" .. methodName
		local groupName   = "ENTITY:" .. methodName
		local sectionName = (entity:GetClass ()) .. ":" .. methodName
		
		if entity [methodName] then
			entity [oldMethodName] = entity [oldMethodName] or entity [methodName]
			entity [methodName] = function (self, ...)
				if GCAD and GCAD.Profiler then
					GCAD.Profiler:Begin (groupName)
					GCAD.Profiler:Begin (sectionName)
				end
				
				local a, b, c, d = self [oldMethodName] (self, ...)
				
				if GCAD and GCAD.Profiler then
					GCAD.Profiler:End ()
					GCAD.Profiler:End (groupName)
				end
				
				return a, b, c, d
			end
		end
	end
end

function self:UnhookEntity (entity)
	if not entity            then return end
	if not entity:IsValid () then return end
	
	for _, methodName in ipairs (profiledMethods) do
		local oldMethodName = "____" .. methodName
		entity [methodName] = entity [oldMethodName] or entity [methodName]
	end
end

GCAD.EntityProfiling = GCAD.EntityProfiling ()
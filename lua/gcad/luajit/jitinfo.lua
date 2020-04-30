local self = {}
GCAD.JITInfo = GCAD.MakeConstructor (self)

function self:ctor ()
	self.Enabled = false
	
	self.FunctionTraceIds = GLib.WeakKeyTable ()
	
	self.TraceCallback = function (eventType, traceId, func, pc, parentTraceIdOrAbortCode, parentTraceExitNumberOrAbortReason)
	end
	self.RecordCallback = function (traceId, func, pc, inliningDepth)
		self:AddFunctionTraceId (func, traceId, inliningDepth)
	end
end

function self:dtor ()
	self:Disable ()
end

function self:Enable ()
	if self.Enabled then return end
	
	self.Enabled = true
	jit.attach (self.RecordCallback, "record")
end

function self:Disable ()
	if not self.Enabled then return end
	
	jit.attach (self.RecordCallback)
	self.Enabled = false
end

function self:AddFunctionTraceId (f, traceId, inliningDepth)
	self.FunctionTraceIds [f] = self.FunctionTraceIds [f] or {}
	self.FunctionTraceIds [f] [traceId] = self.FunctionTraceIds [f] [traceId] or {}
	self.FunctionTraceIds [f] [traceId].Depth = inliningDepth
end

function self:GetFunctionTraceIdEnumerator (f)
	if not self.FunctionTraceIds [f] then return GLib.NullEnumerator () end
	return GLib.KeyEnumerator (self.FunctionTraceIds [f])
end

function self:GetFunctionMachineCode (f)
	if not self.FunctionTraceIds [f] then return nil end
	
	for traceId, traceInfo in pairs (self.FunctionTraceIds [f]) do
		local machineCode = jit.util.tracemc (traceId)
		if machineCode then
			print (traceInfo.Depth)
			return machineCode
		end
	end
end

function self:DumpFunctionMachineCode (f, name)
	name = name or GLib.Lua.GetFunctionName (f)
	name = string.gsub (name, "[^a-zA-Z0-9_%.]", "_") .. ".txt"
	
	file.CreateDir ("gcad/luajit/")
	file.Write ("gcad/luajit/" .. name, self:GetFunctionMachineCode (f))
	
	print ("Dumped to gcad/luajit/" .. name .. ".")
end

GCAD.JITInfo = GCAD.JITInfo ()

GCAD:AddEventListener ("Unloaded", "GCAD.JITInfo",
	function ()
		GCAD.JITInfo:dtor ()
		GCAD:RemoveEventListener ("Unloaded", "GCAD.JITInfo")
	end
)
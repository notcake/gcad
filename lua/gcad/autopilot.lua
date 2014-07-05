local self = {}
GCAD.Autopilot = GCAD.MakeConstructor (self)

local gcad_autopilot = CreateClientConVar ("gcad_autopilot", 0, true, false)

function self:ctor ()
	self.SourceNode      = nil
	self.DestinationNode = nil
	self.State           = "Initializing"
	
	self.LastMovementCheckPosition = Vector (0, 0, 0)
	self.NextMovementCheckTime     = CurTime () + 5
	
	hook.Add ("CreateMove", "GCAD.Autopilot." .. self:GetHashCode (),
		function (usercmd)
			if not gcad_autopilot:GetBool () then return end
			self:HandleCreateMove (usercmd)
		end
	)
	
	hook.Add ("HUDPaint", "GCAD.Autopilot." .. self:GetHashCode (),
		function ()
			if not gcad_autopilot:GetBool () then return end
			
			surface.SetFont ("DermaLarge")
			draw.SimpleText ("Autopilot is on.", "DermaLarge", ScrW () * 0.5, ScrH () * 0.4, GLib.Colors.Blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.Autopilot." .. self:GetHashCode (),
		function ()
			self:dtor ()
		end
	)
end

function self:dtor ()
	hook.Remove ("CreateMove", "GCAD.Autopilot." .. self:GetHashCode ())
	hook.Remove ("HUDPaint",   "GCAD.Autopilot." .. self:GetHashCode ())
end

function self:HandleInitializing ()
	self:Initialize ()
end

function self:Initialize ()
	local closestDistance = math.huge
	local closestNode     = nil
	local pos = GCAD.Vector3d.FromNativeVector (LocalPlayer ():GetPos ())
	
	
	for node in GCAD.NavigationGraph:GetNodeEnumerator () do
		local distance = node:GetPosition ():DistanceTo (pos)
		if distance < closestDistance then
			closestDistance = distance
			closestNode = node
		end
	end
	
	self.SourceNode      = nil
	self.DestinationNode = closestNode
	self.State           = "MovingTowards"
end

function self:HandleCreateMove (usercmd)
	self ["Handle" .. self.State] (self, usercmd)
end

function self:BeginReversing (duration)
	duration = duration or 0.5
	self.ReverseEndTime = CurTime () + duration
	self.State = "Reversing"
end

function self:HandleReversing (usercmd)
	-- Check if we're done
	if CurTime () > self.ReverseEndTime then
		self:Initialize ()
		self.State = "MovingTowards"
		return
	end
	
	usercmd:SetForwardMove (-10000)
end

function self:HandleMovingTowards (usercmd)
	-- Check if we're stuck
	if CurTime () > self.NextMovementCheckTime then
		self.NextMovementCheckTime = CurTime () + 2
		local position = LocalPlayer ():GetPos ()
		local distanceMoved = position:Distance (self.LastMovementCheckPosition)
		
		if distanceMoved < 64 then
			self:Initialize ()
			self:BeginReversing ()
			return
		end
		
		self.LastMovementCheckPosition = position
	end
	
	-- Check if we've arrived
	local distanceToDestination = LocalPlayer ():GetPos ():Distance (self.DestinationNode:GetPositionNative ())
	if distanceToDestination < 32 then
		self:PickNextDestination ()
		return
	end
	
	local targetYaw = (self.DestinationNode:GetPositionNative () - LocalPlayer ():GetPos ()):Angle ().y
	local viewAngles = usercmd:GetViewAngles ()
	
	local currentYaw = viewAngles.y
	
	local deltaYaw = targetYaw - currentYaw
	deltaYaw = deltaYaw % 360
	if deltaYaw > 180 then
		deltaYaw = deltaYaw - 360
	end
	
	local yaw = currentYaw
	if deltaYaw > 0 then
		yaw = yaw + math.min (deltaYaw,  5)
	else
		yaw = yaw + math.max (deltaYaw, -5)
	end
	viewAngles.y = yaw
	
	usercmd:SetViewAngles (viewAngles)
	if math.abs (deltaYaw) < 10 then
		usercmd:SetForwardMove (10000)
	end
	
	local canJump = distanceToDestination > 256
	usercmd:SetButtons (bit.bor (
		usercmd:GetButtons (),
		IN_SPEED,
		math.random () > 0.95 and IN_USE or 0,
		canJump and math.random () > 0.95 and IN_JUMP or 0
	))
end

function self:PickNextDestination ()
	local potentialDestinationSet = {}
	for sourceNode, destinationNode, navigationGraphEdge in GCAD.NavigationGraph:GetNodeOutboundEdgeEnumerator (self.DestinationNode) do
		if destinationNode ~= self.SourceNode then
			potentialDestinationSet [destinationNode] = true
		end
	end
	for sourceNode, destinationNode, navigationGraphEdge in GCAD.NavigationGraph:GetNodeInboundEdgeEnumerator (self.DestinationNode) do
		if sourceNode ~= self.SourceNode then
			potentialDestinationSet [sourceNode] = true
		end
	end
	
	local potentialDestinations = {}
	for navigationGraphNode, _ in pairs (potentialDestinationSet) do
		potentialDestinations [#potentialDestinations + 1] = navigationGraphNode
	end
	
	if #potentialDestinations == 0 then
		potentialDestinations [#potentialDestinations + 1] = self.SourceNode
	end
	
	self.SourceNode      = self.DestinationNode
	self.DestinationNode = potentialDestinations [math.random (1, #potentialDestinations)]
end
local self = {}
GCAD.AABB3d = GCAD.MakeConstructor (self)

-- AABB corner queries
function GCAD.AABB3d.GetCorner (self, cornerId, out)
	out = out or GCAD.Vector3d ()
	
	GCAD.Error ("AABB3d:GetCorner : Not implemented.")
end

function GCAD.AABB3d.GetCornerUnpacked (self, cornerId)
	GCAD.Error ("AABB3d:GetCornerUnpacked : Not implemented.")
end

local GCAD_AABB3d_GetCorner = GCAD.AABB3d.GetCorner

function GCAD.AABB3d.GetCornerEnumerator (self, out)
	local i = 0
	return function ()
		i = i + 1
		if i > 8 then return nil end
		
		return GCAD_AABB3d_GetCorner (self, i, out)
	end
end

GCAD.AABB3d.GetVertex           = GCAD.AABB3d.GetCorner
GCAD.AABB3d.GetVertexUnpacked   = GCAD.AABB3d.GetCornerUnpacked
GCAD.AABB3d.GetVertexEnumerator = GCAD.AABB3d.GetCornerEnumerator

local edgeCornerIds1 = { 1, 2, 3, 4, 1, 2, 3, 4, 5, 6, 7, 8 }
local edgeCornerIds2 = { 2, 3, 4, 1, 5, 6, 7, 8, 6, 7, 8, 5 }
function GCAD.AABB3d.GetEdgeEnumerator (self, out1, out2)
	local i = 0
	
	return function ()
		i = i + 1
		if i > 12 then return nil, nil end
		
		return GCAD_AABB3d_GetCorner (self, edgeCornerIds1 [i], out1), GCAD_AABB3d_GetCorner (self, edgeCornerIds2 [i], out2)
	end
end

local oppositeCornerIds =
{
	[1] = 7,
	[2] = 8,
	[3] = 5,
	[4] = 6,
	[5] = 3,
	[6] = 4,
	[7] = 1,
	[8] = 2
}

function GCAD.AABB3d.GetOppositeCorner (self, cornerId, out)
	return GCAD.AABB3d.GetCorner (oppositeCornerIds [cornerId], out)
end

function GCAD.AABB3d.GetOppositeCornerId (self, cornerId)
	return oppositeCornerIds [cornerId]
end

function GCAD.AABB3d.GetExtremeCornerIds (self, direction)
	if direction [3] < 0 then
		if direction [2] < 0 then
			extremeCornerId = direction [1] < 0 and 1 or 2
		else
			extremeCornerId = direction [1] < 0 and 4 or 3
		end
	else
		if direction [2] < 0 then
			extremeCornerId = direction [1] < 0 and 5 or 6
		else
			extremeCornerId = direction [1] < 0 and 8 or 7
		end
	end
	
	return extremeCornerId, oppositeCornerIds [extremeCornerId]
end

function GCAD.AABB3d.GetExtremeCornerIdsUnpacked (self, x, y, z)
	if z < 0 then
		if y < 0 then
			extremeCornerId = x < 0 and 1 or 2
		else
			extremeCornerId = x < 0 and 4 or 3
		end
	else
		if y < 0 then
			extremeCornerId = x < 0 and 5 or 6
		else
			extremeCornerId = x < 0 and 8 or 7
		end
	end
	
	return extremeCornerId, opposideCornerIds [extremeCornerId]
end

GCAD.AABB3d.GetExtremeCornerId         = GCAD.AABB3d.GetExtremeCornerIds
GCAD.AABB3d.GetExtremeCornerIdUnpacked = GCAD.AABB3d.GetExtremeCornerIdsUnpacked

local GCAD_AABB3d_GetCorner          = GCAD.AABB3d.GetCorner
local GCAD_AABB3d_GetExtremeCornerId = GCAD.AABB3d.GetExtremeCornerId

function GCAD.AABB3d.GetExtremeCorner (self, direction, out)
	return GCAD_AABB3d_GetCorner (GCAD_AABB3d_GetExtremeCornerId (self, direction), out)
end
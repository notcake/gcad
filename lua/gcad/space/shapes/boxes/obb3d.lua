local self = {}
GCAD.OBB3d = GCAD.MakeConstructor (self)

local GCAD_Vector3d_FromNativeVector = GCAD.Vector3d.FromNativeVector

function GCAD.OBB3d.FromEntity (ent, out)
	GCAD.Profiler:Begin ("OBB3d.FromEntity")
	
	out = out or GCAD.OBB3d ()
	
	out.Center = GCAD_Vector3d_FromNativeVector (ent:GetPos  (), out.Center)
	out.Min    = GCAD_Vector3d_FromNativeVector (ent:OBBMins (), out.Min   )
	out.Max    = GCAD_Vector3d_FromNativeVector (ent:OBBMaxs (), out.Max   )
	
	out:SetAngle (ent:GetAngles ())
	
	GCAD.Profiler:End ()
	return out
end
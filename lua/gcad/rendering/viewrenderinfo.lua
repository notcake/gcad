local self = {}
GCAD.ViewRenderInfo = GCAD.MakeConstructor (self)

local EyeAngles                        = EyeAngles
local EyePos                           = EyePos

local Angle                            = Angle
local Vector                           = Vector

local Angle_Set                        = debug.getregistry ().Angle.Set
local Vector_Set                       = debug.getregistry ().Vector.Set

local GCAD_EulerAngle_Clone            = GCAD.EulerAngle.Clone
local GCAD_EulerAngle_Copy             = GCAD.EulerAngle.Copy
local GCAD_EulerAngle_FromNativeAngle  = GCAD.EulerAngle.FromNativeAngle
local GCAD_Frustum3d_Clone             = GCAD.Frustum3d.Clone
local GCAD_Frustum3d_FromScreen        = GCAD.Frustum3d.FromScreen
local GCAD_Frustum3d_ToNativeFrustum3d = GCAD.Frustum3d.ToNativeFrustum3d
local GCAD_NativeFrustum3d_Clone       = GCAD.NativeFrustum3d.Clone
local GCAD_NativeFrustum3d_ToFrustum3d = GCAD.NativeFrustum3d.ToFrustum3d
local GCAD_Vector3d_Clone              = GCAD.Vector3d.Clone
local GCAD_Vector3d_Copy               = GCAD.Vector3d.Copy
local GCAD_Vector3d_FromNativeVector   = GCAD.Vector3d.FromNativeVector

if CLIENT then
	hook.Add ("RenderScene", "GCAD.ViewRenderInfo",
		function (cameraPosition, cameraAngle, horizontalFov)
			GCAD.ViewRenderInfo.CurrentViewRender:SetFrameId (FrameNumber ())
			GCAD.ViewRenderInfo.CurrentViewRender:SetCameraPositionNative (cameraPosition)
			GCAD.ViewRenderInfo.CurrentViewRender:SetCameraAngleNative (cameraAngle)
			GCAD.ViewRenderInfo.CurrentViewRender:SetFOV (horizontalFov)
		end
	)
	
	GCAD:AddEventListener ("Unloaded", "GCAD.ViewRenderInfo",
		function ()
			GCAD:RemoveEventListener ("Unloaded", "GCAD.ViewRenderInfo")
			hook.Remove ("RenderScene", "GCAD.ViewRenderInfo")
		end
	)
	
	local frustum3d = GCAD.Frustum3d ()
	
	function GCAD.ViewRenderInfo.FromCurrentScene (out)
		out = out or GCAD.ViewRenderInfo ()
		
		out:Copy (GCAD.ViewRenderInfo.CurrentViewRender)
		
		out:SetFrameId (FrameNumber ())
		out:SetDepthRender (false)
		out:SetSkyboxRender (false)
		
		-- Frustum
		GCAD_Frustum3d_FromScreen (frustum3d)
		out:SetFrustum (frustum3d)
		
		return out
	end
	
	function GCAD.ViewRenderInfo.FromDrawRenderablesHook (depthRender, skyboxRender, out)
		out = out or GCAD.ViewRenderInfo ()
		
		out:Copy (GCAD.ViewRenderInfo.CurrentViewRender)
		
		out:SetFrameId (FrameNumber ())
		out:SetDepthRender (depthRender)
		out:SetSkyboxRender (skyboxRender)
		
		-- Camera
		out:SetCameraPositionNative (EyePos ())
		out:SetCameraAngleNative (EyeAngles ())
		
		-- Frustum
		GCAD_Frustum3d_FromScreen (frustum3d)
		out:SetFrustum (frustum3d)
		
		return out
	end
end

function self:ctor ()
	self.FrameId              = nil
	
	self.CameraPosition       = GCAD.Vector3d ()
	self.CameraAngle          = GCAD.EulerAngle ()
	self.CameraPositionNative = Vector ()
	self.CameraAngleNative    = Angle ()
	self.FOV                  = 90
	
	self.SkyboxRender         = false
	self.DepthRender          = false
	
	self.Frustum3d            = GCAD.Frustum3d ()
	self.NativeFrustum3d      = GCAD.NativeFrustum3d ()
end

-- Copying
function self:Clone (out)
	out = out or GCAD.ViewRenderInfo ()
	
	out.FrameId        = self.FrameId
	
	out.CameraPosition = GCAD_Vector3d_Clone   (self.CameraPosition, out.CameraPosition)
	out.CameraAngle    = GCAD_EulerAngle_Clone (self.CameraAngle,    out.CameraAngle   )
	Vector_Set (out.CameraPositionNative, self.CameraPositionNative)
	Angle_Set  (out.CameraAngleNative,    self.CameraAngleNative)
	out.FOV            = self.FOV
	
	out.SkyboxRender   = self.SkyboxRender
	out.DepthRender    = self.DepthRender
	
	return out
end

function self:Copy (source)
	self.FrameId        = source.FrameId
	self.CameraPosition = GCAD_Vector3d_Copy   (self.CameraPosition, source.CameraPosition)
	self.CameraAngle    = GCAD_EulerAngle_Copy (self.CameraAngle,    source.CameraAngle   )
	Vector_Set (self.CameraPositionNative, source.CameraPositionNative)
	Angle_Set  (self.CameraAngleNative,    source.CameraAngleNative   )
	self.FOV            = source.FOV
	
	self.SkyboxRender   = source.SkyboxRender
	self.DepthRender    = source.DepthRender
	
	return self
end

-- Frame ID
function self:GetFrameId ()
	return self.FrameId
end

function self:SetFrameId (frameId)
	self.FrameId = frameId
end

-- Camera info
-- If out is not specified, the returned object should not be modified
function self:GetCameraPosition (out)
	if not out then return self.CameraPosition end
	return GCAD_Vector3d_Clone (self.CameraPosition, out)
end

-- If out is not specified, the returned object should not be modified
function self:GetCameraPositionNative (out)
	if not out then return self.CameraPositionNative end
	
	Vector_Set (out, self.CameraPositionNative)
	return out
end

-- If out is not specified, the returned object should not be modified
function self:GetCameraAngle (out)
	if not out then return self.CameraAngle end
	return GCAD_EulerAngle_Clone (self.CameraAngle, out)
end

-- If out is not specified, the returned object should not be modified
function self:GetCameraAngleNative (out)
	if not out then return self.CameraAngleNative end
	
	Angle_Set (out, self.CameraAngleNative)
	return out
end

function self:GetFOV ()
	return self.FOV
end

function self:SetCameraPosition (cameraPosition)
	self.CameraPosition = GCAD_Vector3d_Clone (cameraPosition, self.CameraPosition)
	self.CameraPositionNative = GCAD_Vector3d_ToNativeVector (cameraPosition, self.CameraPositionNative)
	
	return self
end

function self:SetCameraPositionNative (cameraPosition)
	self.CameraPosition = GCAD_Vector3d_FromNativeVector (cameraPosition, self.CameraPosition)
	Vector_Set (self.CameraPositionNative, cameraPosition)
	
	return self
end

function self:SetCameraAngle (cameraAngle)
	self.CameraAngle = GCAD_EulerAngle_Clone (cameraAngle, self.CameraAngle)
	self.CameraAngleNative = GCAD_EulerAngle_ToNativeAngle (cameraAngle, self.CameraAngleNative)
	
	return self
end

function self:SetCameraAngleNative (cameraAngle)
	self.CameraAngle = GCAD_EulerAngle_FromNativeAngle (cameraAngle, self.CameraAngle)
	Angle_Set (self.CameraAngleNative, cameraAngle)
	
	return self
end

function self:SetFOV (fov)
	self.FOV = fov
	
	return self
end

-- Render info
function self:IsDepthRender ()
	return self.DepthRender
end

function self:IsSkyboxRender ()
	return self.SkyboxRender
end

function self:SetDepthRender (depthRender)
	self.DepthRender = depthRender
	
	return self
end

function self:SetSkyboxRender (skyboxRender)
	self.SkyboxRender = skyboxRender
	
	return self
end

-- Frustum
function self:GetFrustum (out)
	if not out then return self.Frustum3d end
	return GCAD_Frustum3d_Clone (self.Frustum3d, out)
end

function self:GetNativeFrustum (out)
	if not out then return self.NativeFrustum3d end
	return GCAD_NativeFrustum3d_Clone (self.NativeFrustum3d, out)
end

function self:SetFrustum (frustum3d)
	self.Frustum3d       = GCAD_Frustum3d_Clone (frustum3d, self.Frustum3d)
	self.NativeFrustum3d = GCAD_Frustum3d_ToNativeFrustum3d (frustum3d, self.NativeFrustum3d)
	
	return self
end

function self:SetNativeFrustum (nativeFrustum3d)
	self.Frustum3d       = GCAD_NativeFrustum3d_ToFrustum3d (nativeFrustum3d, self.Frustum3d)
	self.NativeFrustum3d = GCAD_NativeFrustum3d_Clone (nativeFrustum3d, self.NativeFrustum3d)
	
	return self
end

if CLIENT then
	GCAD.ViewRenderInfo.CurrentViewRender = GCAD.ViewRenderInfo ()
end
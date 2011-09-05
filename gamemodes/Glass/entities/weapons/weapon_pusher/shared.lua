//resource.AddFile( "materials/weapons/haxicon.vmt" )
//resource.AddFile( "materials/weapons/haxicon.vtf" )


SWEP.Author = "Kwigg - Stolen by Bellminator"; 
SWEP.Contact = ""; 
SWEP.Purpose = "Push players away!"; 
SWEP.Instructions = "Point n'shoot.";
 
SWEP.Spawnable = false; 
SWEP.AdminSpawnable = true; 
   
SWEP.ViewModel = ""; 
SWEP.WorldModel = "models/props_lab/monitor01a.mdl";
SWEP.ViewModelFOV = 95
  
   
SWEP.Primary.ClipSize = -1; 
SWEP.Primary.DefaultClip = -1; 
SWEP.Primary.Automatic = false; 
SWEP.Primary.Ammo = "none";
 
 
   
local ShootSound2 = Sound ("weapons/iceaxe/iceaxe_swing1.wav");
 
function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
end 

  
function SWEP:Reload() 
end 
 
 function SWEP:Initialize()
	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_MELEE
	self.ActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_MELEE
	self.ActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_MELEE
	self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_MELEE
	self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_MELEE
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_MELEE
	self.ActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_MELEE
	self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_MELEE
end 
   
function SWEP:Think() 
end 
   
function SWEP:throw_attack()
	if (SERVER) then
		self.Weapon:EmitSound (ShootSound2);
		self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Prop = ents.Create("gl_pusher_prop")
			self.Prop:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
			self.Prop:SetAngles( self.Owner:EyeAngles() )
			self.Prop:SetPhysicsAttacker(self.Owner)
			self.Prop:SetOwner(self.Owner)
			self.Prop:Spawn()
		
			local phys = self.Prop:GetPhysicsObject(); 
			local tr = self.Owner:GetEyeTrace();
			local PlayerPos = self.Owner:GetShootPos()
		
		local shot_length = tr.HitPos:Length(); 
		phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() *  math.pow(shot_length, 3));
		phys:ApplyForceOffset(VectorRand()*math.Rand(10000,30000),PlayerPos + VectorRand()*math.Rand(0.5,1.5))
	end
end
   
function SWEP:PrimaryAttack() 
    self.Weapon:EmitSound (ShootSound2);
	//self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
	self.Owner:DrawViewModel(false)
	self:throw_attack() 
	self:Remove()
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + 4 )
	local tr = self.Owner:GetEyeTrace();
end
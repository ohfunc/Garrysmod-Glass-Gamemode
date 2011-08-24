//Speedboost cl_init

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Touch( ent )
	//SpeedBoostParticle = ParticleEffectAttach("gl_powerup_red",PATTACH_ABSORIGIN_FOLLOW,ent,0)
	//SpeedBoostParticle = ParticleEffect("gl_powerup_red",Vector(0,0,0),Angle(0,0,0),ent)
	//SpeedBoostParticle:SetDieTime(30) // For some reason this prevents the entity from deleting itself, look into it.
end
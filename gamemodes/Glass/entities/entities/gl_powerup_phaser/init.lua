//Phaser init

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	util.PrecacheModel( "models/magnusson_device.mdl" )
	self.Entity:SetModel( "models/magnusson_device.mdl" )
	
	--Allow the entity to be "touched" without actually having collisions
	self.Entity:SetSolid( SOLID_BBOX )
	self.Entity:SetTrigger( true )
   	self.Entity:PhysWake( )
   	self.Entity:SetNotSolid( true )
   	
	self.Entity:SetColor( 255, 255, 255, 0 )

	BRad = self.Entity:BoundingRadius()
	local min = Vector( -BRad, -BRad, -BRad )
	local max = Vector( BRad, BRad, BRad + 100)
	self.Entity:SetCollisionBounds( min, max )

	ParticleEffectAttach("gl_powerup_phaser",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
end

function ENT:Think( )
end

function phaseShouldCollide(ent1, ent2)
		if (ent1:GetName() == "gl_wall" or ent2:GetName() == "gl_wall") 
		and (Phase == 1)
		and (ent1:IsPlayer() or ent2:IsPlayer())
		and (ent1:GetName() == Nickname or ent2:GetName() == Nickname) then
			return false
		else
			return true
		end
	end
hook.Add("ShouldCollide", "Phase", phaseShouldCollide)

function ENT:Touch( ent )
	if( IsEntity( ent ) and ent:IsPlayer( )  and !ent:GetNWBool( "powerup_used" ) ) then
		ent:SetNWBool( "powerup_used", true )
		ent:SetNWInt( "Powerup", 3 )

		Nickname = ent:Nick()
	
		Phase = 1
		timer.Create( "PhaseTimer", 15, 1, RemovePhase, ent )
	
		ent:EmitSound("ambient/machines/teleport3.wav", 500, 100)

		self:Remove()
	end
end

function RemovePhase( ent )
	if( IsEntity( ent ) and ent:IsPlayer( ) ) then
		ent:SetNWBool( "powerup_used", false )
		ent:SetNWInt( "Powerup", 0 )

		Phase = 0
		Nickname = nil

		ent:EmitSound("ambient/levels/labs/teleport_postblast_winddown1.wav", 400, 200)
	end
end




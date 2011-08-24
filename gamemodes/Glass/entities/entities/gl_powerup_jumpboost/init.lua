//JumpBoost init

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
	
	self.Entity:SetColor( 255, 255, 255, 0)

	BRad = self.Entity:BoundingRadius()
	local min = Vector( -BRad, -BRad, -BRad )
	local max = Vector( BRad, BRad, BRad + 100)
	self.Entity:SetCollisionBounds( min, max )

	ParticleEffectAttach("gl_powerup_jumpboost",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
end

function ENT:Think( )
end

function ENT:Touch( ent )
	if( IsEntity( ent ) and ent:IsPlayer( ) and !ent:GetNWBool( "powerup_used" ) ) then
			ent:SetNWBool( "powerup_used", true )
			umsg.Start( "CreativeNamingSkills", ent )
				umsg.String( "jumpboost" )
				umsg.Bool( true ) 
			umsg.End()

			ent:SetJumpPower( 275 )
			timer.Create( "JumpTimer", 30, 1, RemovePlayerJump, ent )
			ent:EmitSound("ambient/machines/teleport3.wav", 500, 100)
			
			self:Remove()
	end
end

function RemovePlayerJump( ent )
	if( IsEntity( ent ) and ent:IsPlayer( ) ) then
		ent:SetNWBool( "powerup_used", false )
		umsg.Start( "CreativeNamingSkills", ent )
			umsg.String( "none" )
			umsg.Bool( false )
		umsg.End()

		ent:StopParticles()
		ent:SetJumpPower( 200 )
		ent:EmitSound("ambient/levels/labs/teleport_postblast_winddown1.wav", 400, 200)
	end
end
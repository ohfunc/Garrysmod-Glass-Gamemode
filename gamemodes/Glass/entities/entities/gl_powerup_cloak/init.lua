//Cloak init

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
	
	ParticleEffectAttach("gl_powerup_cloak",PATTACH_ABSORIGIN_FOLLOW,self.Entity,0)
end

function ENT:Think( )
end

function ENT:Touch( ent )
	if( IsEntity( ent ) and ent:IsPlayer( ) and !ent:GetNWBool( "powerup_used" ) ) then
		Cloak = 1
		Player = ent

		ent:SetNWBool( "powerup_used", true )
		ent:SetColor( 255, 255, 255, 0 )

		timer.Create("CloakTimer", 30, 1, RemovePlayerCloak, ent)
		ent:EmitSound("ambient/machines/teleport3.wav", 500, 100)

		self:Remove()
	end
end

function RemovePlayerCloak( ent )
	if(IsEntity( ent ) and ent:IsPlayer( ) ) then
		Cloak = 0

		ent:DrawWorldModel(true)
		ent:DrawViewModel(true)
		ent:SetNWBool( "powerup_used", false )
		ent:SetColor( 255, 255, 255, 255 )
		ent:EmitSound("ambient/levels/labs/teleport_postblast_winddown1.wav", 400, 200)
	end
end

function CheckWeaponVisibility()
	if(Cloak==1) then
		Player:DrawWorldModel(false) 
		Player:DrawViewModel(false)
	end
end
hook.Add( "Think", "CheckWeaponVisibility", CheckWeaponVisibility)

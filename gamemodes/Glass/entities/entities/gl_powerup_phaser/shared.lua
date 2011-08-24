//Phaser init

ENT.Type = "anim"
 
ENT.PrintName		= "Phaser"
ENT.Author			= "Bellminator"
ENT.Contact			= ""
ENT.Purpose			= "Walk through walls!"
ENT.Instructions	= "None!"

local function ShouldCollideTestHook( ent1, ent2 )
	if ( ent1:IsPlayer() and ent2:IsPlayer() ) then
		return false
	end 
end
hook.Add( "ShouldCollide", "ShouldCollideTestHook", ShouldCollideTestHook )

PrecacheParticleSystem("gl_powerup_phaser")
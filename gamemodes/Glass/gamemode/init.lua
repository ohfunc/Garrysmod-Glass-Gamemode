--Gamemode init.lua
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
--AddCSLuaFile( "cl_glow.lua" )

include( "tables.lua" )
include( "shared.lua" )

--Who the hell is alive???
function GM:AlivePlayers( t )
	local tbl = {}
	for k,v in pairs( team.GetPlayers( t ) ) do
		if v:Alive() then
			table.insert( tbl, v )
		end
	end
	return tbl
end

function GM:ActivePlayers()
	local tbl = team.GetPlayers( TEAM_DEAD )
	table.Add( tbl, team.GetPlayers( TEAM_ALIVE ) )
	return tbl
end

--Holy shit the round might have ended!
function GM:CheckRoundEnd()

	-- Do checks here!
	if ( !GAMEMODE:InRound() ) then return end

	if ( #GAMEMODE:AlivePlayers( TEAM_ALIVE ) == 1 and #GAMEMODE:ActivePlayers() > 1 ) then
		local ply = GAMEMODE:AlivePlayers( TEAM_ALIVE )[1]
		GAMEMODE:RoundEndWithResult( ply )
		GAMEMODE.LastWinner = ply
	end
	
	--Check to see if everyone has died
	if( #GAMEMODE:AlivePlayers( TEAM_ALIVE ) == 0 and #GAMEMODE:ActivePlayers() > 0 ) then
		local ply = nil
		GAMEMODE:RoundEndWithResult( ply )
		GAMEMODE.LastWinner = ply
	end
end

--Holy shit we've won!
function GM:OnRoundWinner( ply, resulttext )
	if(ply != nil) then
		ply:AddFrags( 1 )
		ply:GiveScrapMetal(100,"Congrats! You have gained 100 pieces of scrap metal. (Press F4 to access the store)")
	end

	--Reset powerups
	for k,v in pairs( player.GetAll() ) do
		v:SetColor( 255, 255, 255, 255 )
		v:DrawWorldModel( true )
		v:DrawViewModel( true )

		if timer.IsTimer("SpeedBoostTimer") then timer.Destroy("SpeedBoostTimer") end
		if timer.IsTimer("CloakTimer") then timer.Destroy("CloakTimer") end
			hook.Remove("Think","CheckWeaponVisibility")
		if timer.IsTimer("JumpTimer") then timer.Destroy("JumpTimer") end
		if timer.IsTimer("PhaseTimer") then timer.Destroy("PhaseTimer") end

		v:SetNWBool( "powerup_used", false )
		v:SetNWInt( "Powerup", 0 )

		Phase = 0
		Nickname = nil
	end
	
	for k,v in pairs( GAMEMODE:ActivePlayers() ) do
		if not v:Alive() then
			v:SetTeam( TEAM_ALIVE )
		end
		game.CleanUpMap()
	end

end

--Lets see if someone has gotten stuck while using the Phaser..
function CheckPhaser()
	for k,v in pairs(player.GetAll()) do
		local tboy = v:GetPhysicsObject()
		
		if (v:IsPlayer() and IsEntity( v )) and (tboy:IsPenetrating() == true) then
			v:TakeDamage( 100, nil, nil )
		end
	end
	
	timer.Simple( 1, CheckPhaser )
end

--Powerup spawner
function SpawnPowerUps( PowerUp )
	--WhereTheFuckAreMyWalls()
	for k,v in pairs( ents.FindByClass("gl_spawn") ) do
		local Check = math.random(0,4)
		if Check >= 3 then
			local PowerUp = ents.Create( table.Random( GAMEMODE.PowerUps ) )
			local Pos = v:GetPos() + Vector( 0, 0, 10 )
			PowerUp:SetPos(Pos)
				PowerUp:Spawn() -- You dumbass, this HAS to be here!
			print("Spawned " .. tostring( PowerUp ) .. " at " .. tostring( Pos ))
		end
	end
end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
	
	SpawnPowerUps()
	CheckPhaser()
end

--Custom death sounds
function GM:DoPlayerDeath( ply, attacker, dmginfo )
	--Damn game trying to beep n' boop
	function OverrideDeathSound()
		return true
	end
	hook.Add("PlayerDeathSound","OverrideDeathSound",OverrideDeathSound)
	
	ply:EmitSound( table.Random( GAMEMODE.DeathSounds ), 300, 100 )
	ply:CreateRagdoll()
	ply:AddDeaths( 1 )

	ply:SetNWBool( "powerup_used", false )
	ply:SetNWInt( "Powerup", 0 )
end

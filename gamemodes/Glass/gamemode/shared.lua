DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Name 	= "Glass"
GM.Author 	= "Bellminator & TBoy205"
GM.Email 	= "bellminator@garrysmodrailworks.com"
GM.Website 	= ""
GM.Help		= "Break the floor below opposing players making them fall to their death. Be the last man standing an d you win the round. Use the randomized powerups around the map (identified with floating icons) to gain advantages over players. There are FOUR powerups and ONE special weapon. Cloak - Invisibility for 30 seconds. Speedboost - Increased speed for 30 seconds. Phase - Walk through (possible) walls around the map for 15 seconds. Jumpboost - Increased jump height for 30 seconds."

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 100		
GM.RoundLimit = 100			
GM.VotingDelay = 5					-- Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = true
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = true		-- Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		-- Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = true 		-- Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	-- Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		-- When true, all players have silent footsteps
GM.PlayerCanNoClip = false			-- When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false		-- -1 frag on suicide

GM.MaximumDeathLength = 121			-- Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 120			-- Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     -- Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false	-- Players wont be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = true
GM.AddFragsToTeamScore = false		-- Adds players individual kills to team score (must be team based)

GM.NoAutomaticSpawning = true		-- Players dont spawn automatically when they die, some other system spawns them
GM.RoundBased = true				-- Round based, like CS
GM.RoundLength = 120				-- Round length, in seconds
GM.RoundPreStartTime = 0			-- Preperation time before a round starts
GM.RoundPostLength = 5				-- Seconds to show the x team won! screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.EnableFreezeCam = false			-- TF2 Style Freezecam
GM.DeathLingerTime = 3				-- The time between you dying and it going into spectator mode, 0 disables

TEAM_ALIVE = 1
TEAM_DEAD = 2

function GM:CreateTeams()
	team.SetUp( TEAM_ALIVE, "Humans", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_ALIVE, {"info_player_counterterrorist","info_player_rebel","info_player_start"} )
	team.SetClass( TEAM_ALIVE, { "Human" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"} ) 
end

function GM:PlayerCanJoinTeam( ply, teamid )

	if ( SERVER && !self.BaseClass:PlayerCanJoinTeam( ply, teamid ) ) then 
		return false 
	end

	if ( ply:Team() == TEAM_DEAD && teamid != TEAM_SPECTATOR ) then
		ply:ChatPrint( "Wait until the round ends!" )
		return false
	end
	
	return true
	
end

function OverrideDeathSound()
	return true
end
hook.Add("PlayerDeathSound", "OverrideDeathSound", OverrideDeathSound)

--Fuck yeah lets nocollide all the players
function PlayersShouldCollide( player1, player2 )
	if ( player1:IsPlayer() and player2:IsPlayer() ) then
		return false
	end 
end
hook.Add( "ShouldCollide", "PlayersShouldCollide", PlayersShouldCollide )

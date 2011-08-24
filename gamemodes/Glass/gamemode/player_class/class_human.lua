
local CLASS = {}

CLASS.DisplayName			= "Human"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 3
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.1
CLASS.JumpPower				= 250
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100

function CLASS:Loadout( pl )
	pl:Give( "weapon_crowbar" )
	pl:Give( "weapon_pistol" )
	pl:Give( "item_ammo_pistol" )
end

function CLASS:OnDeath( pl )
	pl:SetTeam( TEAM_SPECTATOR )
end

player_class.Register( "Human", CLASS )
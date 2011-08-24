local function PP( )
	if( UmsgAllow == true ) then
		if( UmsgPowerup == "cloak" ) then
			DrawMaterialOverlay( "models/shadertest/shader3.vmt", 0.01 )
		elseif( UmsgPowerup == "speedboost" ) then
			DrawMotionBlur( 0.30, 1, 0)
			DrawToyTown( 5, 1000 )
		elseif( UmsgPowerup == "jumpboost" ) then
			DrawBloom( 0, 1, 0, 0, 0, 0.75, 0, 1.35, 2.55  )
		elseif( UmsgPowerup == "phaser" ) then
			--Someshit
		end
	end
end
hook.Add( "RenderScreenspaceEffects", "PP", PP )

usermessage.Hook( "CreativeNamingSkills", 
	function( data )
		UmsgPowerup = data:ReadString()
		UmsgAllow = data:ReadBool()
	end
)
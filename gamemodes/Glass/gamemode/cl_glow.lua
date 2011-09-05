local MaterialBlurX = Material( "pp/blurx" );
local MaterialBlurY = Material( "pp/blury" );
local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexalpha"] = "1",
    ["$model"] = "1",
} );
local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$additive"] = "1",
} );
 
// we need two render targets, if you dont want to create them yourself, you can
// use the bloom textures, they are quite low resolution though.
// render.GetBloomTex0() and render.GetBloomTex1();
local RT1 = GetRenderTarget( "L4D1" );
local RT2 = GetRenderTarget( "L4D2" );
 
/*------------------------------------
   RenderToStencil()
------------------------------------*/
local function RenderToStencil( entity )
 
   // tell the stencil buffer were going to write a value of one wherever the model
    // is rendered
    render.SetStencilEnable( true );
    render.SetStencilFailOperation( STENCILOPERATION_KEEP );
    render.SetStencilZFailOperation( STENCILOPERATION_KEEP );
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE );
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS );
    render.SetStencilWriteMask( 1 );
    render.SetStencilReferenceValue( 1 );
     
    // this uses a small hack to render ignoring depth while not drawing color
    // i couldnt find a function in the engine to disable writing to the color channels
   // i did find one for shaders though, but I dont feel like writing a shader for this.
    cam.IgnoreZ( true );
        render.SetBlend( 0 );
			local weap = nil
			if entity:GetActiveWeapon() != nil then
					weap = entity:GetActiveWeapon()
			end
			
            SetMaterialOverride( MaterialWhite );
                entity:DrawModel();
				if weap != nil and ValidEntity(weap) then
					weap:DrawModel();
				end
            SetMaterialOverride();
             
        render.SetBlend( 1 );
    cam.IgnoreZ( false );
     
    // dont need this for the next pass
   render.SetStencilEnable( false );
 
end
 
/*------------------------------------
   RenderToGlowTexture()
------------------------------------*/
local function RenderToGlowTexture( entity )

	local w, h = ScrW(), ScrH();

	// draw into the white texture
	local oldRT = render.GetRenderTarget();
	render.SetRenderTarget( RT1 );
		render.SetViewPort( 0, 0, 512, 512 );
		
		cam.IgnoreZ( true );
			local weap = nil
			render.SuppressEngineLighting( true );
			if entity:IsPlayer() then
       Powerup = entity:GetNWInt("Powerup")
       if(Powerup == 1) then col = Color( 200, 50, 50 ) end
       if(Powerup == 2) then col = Color( 50, 50, 200 ) end
       if(Powerup == 3) then col = Color( 217, 154, 0 ) end
       if(Powerup == 0) then col = Color( 0, 0, 0) end

        render.SetColorModulation( col.r/255, col.g/255, col.b/255);
				
				if entity:GetActiveWeapon() != nil then
					weap = entity:GetActiveWeapon()
				end
			else
				render.SetColorModulation(1,1,1);
			end
			
				SetMaterialOverride( MaterialWhite );
					entity:DrawModel();
					if weap != nil and ValidEntity(weap) then
						weap:DrawModel();
					end
				SetMaterialOverride();
				
			render.SetColorModulation( 1, 1, 1 );
			render.SuppressEngineLighting( false );
			
		cam.IgnoreZ( false );
		
		render.SetViewPort( 0, 0, w, h );
	render.SetRenderTarget( oldRT );

end
 
/*------------------------------------
   RenderScene()
------------------------------------*/
local function RenderScene( Origin, Angles )
 
   local oldRT = render.GetRenderTarget();
        render.SetRenderTarget( RT1 );
        render.Clear( 0, 0, 0, 255, true ); --Dont forget this either
        render.SetRenderTarget( oldRT );
 
end
hook.Add( "RenderScene", "ResetGlow", RenderScene );
 
/*------------------------------------
   RenderScreenspaceEffects()
------------------------------------*/
local function RenderScreenspaceEffects( )
 
   MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 );
   MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 );
   MaterialBlurX:SetMaterialFloat( "$size", 2 );
   MaterialBlurY:SetMaterialFloat( "$size", 2 );
       
   local oldRT = render.GetRenderTarget();
   
   // blur horizontally
   render.SetRenderTarget( RT2 );
   render.SetMaterial( MaterialBlurX );
   render.DrawScreenQuad();
 
   // blur vertically
   render.SetRenderTarget( RT1 );
   render.SetMaterial( MaterialBlurY );
   render.DrawScreenQuad();
 
   render.SetRenderTarget( oldRT );
   
   // tell the stencil buffer were only going to draw
    // where the player models are not.
    render.SetStencilEnable( true );
    render.SetStencilReferenceValue( 0 );
    render.SetStencilTestMask( 1 );
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL );
    render.SetStencilPassOperation( STENCILOPERATION_ZERO );
     
    // composite the scene
    MaterialComposite:SetMaterialTexture( "$basetexture", RT1 );
    render.SetMaterial( MaterialComposite );
    render.DrawScreenQuad();
 
    // dont need this anymore
   render.SetStencilEnable( false );
 
end
hook.Add( "RenderScreenspaceEffects", "CompositeGlow", RenderScreenspaceEffects );
 
/*------------------------------------
   PrePlayerDraw()
------------------------------------*/
local function PostPlayerDraw( pl )
       
   // prevent recursion
   if( OUTLINING_PLAYER ) then return; end
   OUTLINING_PLAYER = true;
   
   RenderToStencil( pl );
   RenderToGlowTexture( pl );
   
   // prevents recursion time
   OUTLINING_PLAYER = false;
   
    if( ScrW() == ScrH() ) then return; end

end //PostDrawOpaqueRenderables
hook.Add( "PostPlayerDraw", "RenderGlow", PostPlayerDraw );
local convar = CreateClientConVar( "l4d_glow", "1", true )
local teamcolors = CreateClientConVar( "l4d_teamcolors", "1", true )
local passes = CreateClientConVar( "l4d_passes", "2", true )
 
local MaterialBlurX = Material( "pp/blurx" )
local MaterialBlurY = Material( "pp/blury" )
local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexalpha"] = "1",
    ["$model"] = "1",
} )
local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$additive"] = "1",
} )
 
local RT1 = render.GetBloomTex0()
local RT2 = render.GetBloomTex1()
 
/*------------------------------------
    RenderGlow()
------------------------------------*/
local function RenderGlow( entity )
 
    // tell the stencil buffer were going to write a value of one wherever the model
    // is rendered
    render.SetStencilEnable( true )
    render.SetStencilFailOperation( STENCILOPERATION_KEEP )
    render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
    render.SetStencilWriteMask( 1 )
    render.SetStencilReferenceValue( 1 )
     
    // this uses a small hack to render ignoring depth while not drawing color
    // i couldnt find a function in the engine to disable writing to the color channels
    // i did find one for shaders though, but I dont feel like writing a shader for this.
    cam.IgnoreZ( true )
        render.SetBlend( 0 )
            SetMaterialOverride( MaterialWhite )
                entity:DrawModel()
            SetMaterialOverride()
        render.SetBlend( 1 )
    cam.IgnoreZ( false )
     
    local w, h = ScrW(), ScrH()
     
    // draw into the white texture
    local oldRT = render.GetRenderTarget()
     
    render.SetRenderTarget( RT1 )
     
        render.SetViewPort( 0, 0, RT1:GetActualWidth(), RT1:GetActualHeight() )
         
        cam.IgnoreZ( true )
         
            render.SuppressEngineLighting( true )
             
            if entity:IsPlayer() then
                    local Powerup = entity:GetNWInt("Powerup")
                    if(Powerup == 1) then color = Color( 200, 50, 50 ) end
                    if(Powerup == 2) then color = Color( 50, 50, 200 ) end
                    if(Powerup == 3) then color = Color( 217, 154, 0 ) end
                    if(Powerup == 0) then color = Color( 0, 0, 0) end
                    render.SetColorModulation( color.r/255, color.g/255, color.b/255 )  
            end
             
                SetMaterialOverride( MaterialWhite )
                    entity:DrawModel()
                SetMaterialOverride()
                 
            render.SetColorModulation( 1, 1, 1 )
            render.SuppressEngineLighting( false )
             
        cam.IgnoreZ( false )
         
        render.SetViewPort( 0, 0, w, h )
    render.SetRenderTarget( oldRT )
     
    // dont need this for the next pass
    render.SetStencilEnable( false )
 
end
 
/*------------------------------------
    RenderScene()
------------------------------------*/
hook.Add( "RenderScene", "ResetGlow", function( Origin, Angles )
 
    local oldRT = render.GetRenderTarget()
    render.SetRenderTarget( RT1 )
        render.Clear( 0, 0, 0, 255, true )
    render.SetRenderTarget( oldRT )
     
end )
 
/*------------------------------------
    RenderScreenspaceEffects()
------------------------------------*/
hook.Add( "RenderScreenspaceEffects", "CompositeGlow", function()
 
    MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 )
    MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 )
    MaterialBlurX:SetMaterialFloat( "$size", 2 )
    MaterialBlurY:SetMaterialFloat( "$size", 2 )
         
    local oldRT = render.GetRenderTarget()
     
    for i = 1, passes:GetFloat() do
     
        // blur horizontally
        render.SetRenderTarget( RT2 )
        render.SetMaterial( MaterialBlurX )
        render.DrawScreenQuad()
 
        // blur vertically
        render.SetRenderTarget( RT1 )
        render.SetMaterial( MaterialBlurY )
        render.DrawScreenQuad()
         
    end
 
    render.SetRenderTarget( oldRT )
     
    // tell the stencil buffer were only going to draw
    // where the <span class="highlight">player</span> models are not.
    render.SetStencilEnable( true )
    render.SetStencilReferenceValue( 0 )
    render.SetStencilTestMask( 1 )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
     
    // composite the scene
    MaterialComposite:SetMaterialTexture( "$basetexture", RT1 )
    render.SetMaterial( MaterialComposite )
    render.DrawScreenQuad()
 
    // dot need this anymore
    render.SetStencilEnable( false )
     
end )
 
local playerheldweap = nil
 
hook.Add( "PostPlayerDraw", "RenderEntityGlow", function( ply )
 
    if !convar:GetBool() then return end
 
    if( ScrW() == ScrH() ) then return end
 
    // prevent recursion
    if( OUTLINING_ENTITY ) then return end
    OUTLINING_ENTITY = true
     
    RenderGlow( ply )
     
    playerheldweap = ply:GetActiveWeapon()
     
    if IsValid( playerheldweap ) and playerheldweap:IsWeapon() then
        RenderGlow( playerheldweap )
    end
     
    // prevents recursion time
    OUTLINING_ENTITY = false
         
end )
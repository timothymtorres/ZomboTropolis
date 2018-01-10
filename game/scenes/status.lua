-----------------------------------------------------------------------------------------
--
-- player.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local width, height = display.contentWidth, display.contentHeight

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc. 
 
  -- create a constant for the left spacing of the row content
  local LEFT_PADDING = 10

  --Group to hold our status icons and info
  local StatusGroup = display.newGroup()   
  
  local username, mob_type = main_player:getUsername(), main_player:getMobType()
  local hp, max_hp = main_player.stats:get('hp')
  local ap, max_ap = main_player.stats:get('ap')
  local xp, max_xp = main_player.stats:get('xp') 
  local ip, max_ip
  
  if main_player:isMobType('human') then ip, max_ip = main_player.stats:get('ip') end  
  
  local bars_y_offset = 40
  local bar_num = 1
  local background_stat_text_size = height*0.05
  
  local mob_type_text = display.newText(StatusGroup, 'You are a '..mob_type, width*0.5, 10, native.systemFont, 20)
  mob_type_text.anchorY = 0
  
  local background_AP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
  background_AP_text.anchorX = 0
  background_AP_text:setFillColor( 0.5 )

  local AP_text = display.newText(StatusGroup, "AP", width*0.115, bars_y_offset + height*((0.025*2)*bar_num), native.systemFontBold, 16 )
  AP_text.anchorX = 0
  
  local background_bar_AP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*bar_num), width*0.65, height*0.05, 8 )
  background_bar_AP.anchorX, background_bar_AP.anchorY = 0, 0
  background_bar_AP.strokeWidth = 2
  background_bar_AP:setFillColor( 0.5 )
  background_bar_AP:setStrokeColor(0, 0, 0)
    
  local AP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*bar_num), (width*0.65)*(math.max(ap, 3)/max_ap), height*0.05, 8 )
  AP_bar.anchorX, AP_bar.anchorY = 0, 0
  AP_bar.strokeWidth = 2
  AP_bar:setFillColor( 0, 0, 0.95 )
  AP_bar:setStrokeColor( 0, 0, 0 )
  
  local AP_stat = display.newText(StatusGroup, '('..ap..'/'..max_ap..')', width*0.65, bars_y_offset + height*((0.025*2)*bar_num), native.systemFontBold, 12 )
  AP_text.anchorX = 0  
  
  bar_num = bar_num + 1
  
  local background_HP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.5)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
  background_HP_text.anchorX = 0
  background_HP_text:setFillColor( 0.5 )

  local HP_text = display.newText(StatusGroup, "HP", width*0.115, bars_y_offset + height*((0.025*2.5)*bar_num), native.systemFontBold, 16 )
  HP_text.anchorX = 0
  
  local background_bar_HP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2)*bar_num, width*0.65, height*0.05, 8 )
  background_bar_HP.anchorX, background_bar_HP.anchorY = 0, 0
  background_bar_HP.strokeWidth = 2
  background_bar_HP:setFillColor( 0.5 )
  background_bar_HP:setStrokeColor(0, 0, 0)
    
  local HP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2)*bar_num, (width*0.65)*(math.max(hp,3)/max_hp), height*0.05, 8 )
  HP_bar.anchorX, HP_bar.anchorY = 0, 0
  HP_bar.strokeWidth = 2
  HP_bar:setFillColor( 0.80, 0, 0 )
  HP_bar:setStrokeColor( 0, 0, 0 )
  
  local HP_stat = display.newText(StatusGroup, '('..hp..'/'..max_hp..')', width*0.65, bars_y_offset + height*((0.025*2.5)*bar_num), native.systemFontBold, 12 )
  HP_text.anchorX = 0  
  
  bar_num = bar_num + 1 
  
  local background_XP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.7)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
  background_XP_text.anchorX = 0
  background_XP_text:setFillColor( 0.5 )

  local XP_text = display.newText(StatusGroup, "XP", width*0.115, bars_y_offset + height*((0.025*2.7)*bar_num), native.systemFontBold, 16 )
  XP_text.anchorX = 0
  
  local background_bar_XP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.3)*bar_num, width*0.65, height*0.05, 8 )
  background_bar_XP.anchorX, background_bar_XP.anchorY = 0, 0
  background_bar_XP.strokeWidth = 2
  background_bar_XP:setFillColor( 0.5 )
  background_bar_XP:setStrokeColor(0, 0, 0)
    
  local XP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.3)*bar_num, (width*0.65)*(math.max(xp,50)/max_xp), height*0.05, 8 )
  XP_bar.anchorX, XP_bar.anchorY = 0, 0
  XP_bar.strokeWidth = 2
  XP_bar:setFillColor( 0.5, 0, 0.5 )
  XP_bar:setStrokeColor( 0, 0, 0 )
  
  local XP_stat = display.newText(StatusGroup, '('..xp..'/'..max_xp..')', width*0.65, bars_y_offset + height*((0.025*2.7)*bar_num), native.systemFontBold, 12 )
  XP_text.anchorX = 0  
  
  bar_num = bar_num + 1  
  
  if main_player:isMobType('human') then 
    local background_IP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.8)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
    background_IP_text.anchorX = 0
    background_IP_text:setFillColor( 0.5 )

    local IP_text = display.newText(StatusGroup, "IP", width*0.115, bars_y_offset + height*((0.025*2.8)*bar_num), native.systemFontBold, 16 )
    IP_text.anchorX = 0
    
    local background_bar_IP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.5)*bar_num, width*0.65, height*0.05, 8 )
    background_bar_IP.anchorX, background_bar_IP.anchorY = 0, 0
    background_bar_IP.strokeWidth = 2
    background_bar_IP:setFillColor( 0.5 )
    background_bar_IP:setStrokeColor(0, 0, 0)
      
    local IP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.5)*bar_num, (width*0.65)*(math.max(ip,50)/max_ip), height*0.05, 8 )
    IP_bar.anchorX, IP_bar.anchorY = 0, 0
    IP_bar.strokeWidth = 2
    IP_bar:setFillColor( 0.7, 0.7, 0.2  )
    IP_bar:setStrokeColor( 0, 0, 0 )
    
    local IP_stat = display.newText(StatusGroup, '('..ip..'/'..max_ip..')', width*0.65, bars_y_offset + height*((0.025*2.75)*bar_num), native.systemFontBold, 12 )
    IP_text.anchorX = 0  
    
    bar_num = bar_num + 1  
  end
  
  sceneGroup:insert(StatusGroup)
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      listItems = main_player.log:read()
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
      composer.removeScene( "scenes.status" )  
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
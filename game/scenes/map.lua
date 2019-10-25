-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local berry = require( 'code.libs.berry' )
local json = require( "json" )
local scene = composer.newScene()
local createMob = require('scenes.functions.createMob')


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- display.contentWidth, display.contentHeight -- 320x480

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view

  -- Load our map
  --local filename = "graphics/map/world.json"
  --world = berry.loadMap( filename, "graphics/map" )
  world.isVisible = true
  world_height, world_width = world.contentHeight, world.contentWidth
  world:scale(2, 2)
  sceneGroup:insert(world)

  world:addLayer("Corpse") -- this may not be neccessary
  world:addLayer("Mob")

  world:setExtension("scenes.objects.")

  local mob = createMob(main_player, world)
  mob:scale(0.25, 0.25)

  local player_y, player_x = main_player:getPos()
  local y, x = world:convertTileToPixel( player_y-1, player_x-1 )

--[[
      image.row    = mFloor( 
                   ( position + layer.size - 1 ) / layer.size 
                 ) - 1
      image.column = position - image.row * layer.size - 1
--]]

-- 16, 32  (y, x)
print(player_y, player_x, y, x )
  mob.y, mob.x =  y - 8, x 

  return sceneGroup
end

-- The zooming in/out is still broken as fuck!
local scale = world.xScale -- both xScale & yScale should be same
local MAX_SCALE, MIN_SCALE = 2, 1
local lastEvent = {}

local function key( event )
  local phase = event.phase
  local name = event.keyName
  --if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys

  local SCALE_INCREMENT = 0.50

  if phase == "down" then
    if "up" == name and scale < MAX_SCALE then
      transition.scaleBy(world, {xScale=SCALE_INCREMENT, yScale=SCALE_INCREMENT, time=2000}) 
    elseif "down" == name and scale > MIN_SCALE then
      transition.scaleBy(world, {xScale=-1*SCALE_INCREMENT, yScale=-1*SCALE_INCREMENT, time=2000})
    elseif "up" == name then -- zoom into world if viewing map
      --local scene = composer.getSceneName('current')
      --composer.removeScene(scene)      

      local options = {effect = "fade", time = 500,}   
      composer.gotoScene('scenes.location', options)     
    elseif "down" == name then -- zoom into map if viewing room
    end

    scale = world.xScale
  end

  lastEvent = event
end

local function movePlatform(event)
    local platformTouched = event.target

    if (event.phase == "began") then
        display.getCurrentStage():setFocus( platformTouched )

        -- here the first position is stored in x and y         
        platformTouched.startMoveX = platformTouched.x
        platformTouched.startMoveY = platformTouched.y 
    elseif (event.phase == "moved") then
        local startMoveX = platformTouched.startMoveX or platformTouched.x
        local startMoveY = platformTouched.startMoveY or platformTouched.y

        -- here the distance is calculated between the start of the movement and its current position of the drag  
        local x_pos = (event.x - event.xStart) + startMoveX
        local y_pos = (event.y - event.yStart) + startMoveY

        platformTouched.x =  x_pos 
        platformTouched.y = y_pos    
    elseif event.phase == "ended" or event.phase == "cancelled"  then
        -- here the focus is removed from the last position
        display.getCurrentStage():setFocus( nil )
    end
    return true
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    
        Runtime:addEventListener("key", key)  
        world:addEventListener( "touch", movePlatform )  -- Add a "touch" listener to the object        
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
        Runtime:removeEventListener( "key", key )          
    end  
end


-- "scene:destroy()"
function scene:destroy( event )
     
    Runtime:removeEventListener( "key", key )     

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
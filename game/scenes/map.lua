-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
berry = require( 'code.libs.berry.berry' )
local json = require( "json" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local phone_screen_width, phone_screen_height = display.contentWidth, display.contentHeight -- 320x480
local widget = require('widget')
local world
local world_height, world_width
local world_background_offset 

local x1, x2, y1, y2
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view

  -- Load our map
  local filename = "graphics/map/world.json"
  world = berry.loadMap( filename, "graphics/map" )
  local visual = berry.createVisual( world )
  world_height, world_width = visual.contentHeight, visual.contentWidth
  world_background_offset = world:getPropertyValue('background_tile_offset')

  world:setScale(2.5)

  local player_y, player_x = main_player:getPos()
  local region_layer = world:getTileLayer('Regions') -- we could pick any layer, I picked Regions randomly
  local tile = region_layer:getTileFromPosition(player_x, player_y)
  -- not sure why we need this offset but the y axis won't stay centered without it
  -- even with the offset it's still a few pixels off when changing scale
  -- but it's close enough to rock and roll!
  local offset_y = -1 * tile.sprite.height
  local x, y = tile.sprite:localToContent( 0, offset_y)

  x = -1 * x + phone_screen_width*0.5
  y = -1 * y + phone_screen_height*0.5

  world:setPosition(x, y)

--[[
  local hidden_layer = world:getTileLayer('Hidden')
  local tile_NW = hidden_layer:getTileFromPosition(-3, 5)
  local tile_SE = hidden_layer:getTileFromPosition(45, 35)
  -- not sure why we need this offset but the y axis won't stay centered without it
  -- even with the offset it's still a few pixels off when changing scale
  -- but it's close enough to rock and roll!
  local offset_y = -1 * tile_NW.sprite.height
  x1, y1 = tile_NW.sprite:localToContent( 0, offset_y)
  x2, y2 = tile_SE.sprite:localToContent( 0, offset_y)

  x1, x2 = -1*x1 - phone_screen_width*0.5, -1*x2 + phone_screen_width*0.5
  y1, y2 = -1*y1 + phone_screen_height*0.5, -1*y2 + phone_screen_height*0.5
--]]
  return sceneGroup
end

local lastEvent = {}
local max_scale, min_scale = 3.00, 1.00  -- only applies to zoom in/out

local function key( event )
  local phase = event.phase
  local name = event.keyName
  --if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys

  local scale = world:getScale()
  local scale_amt = 0.50

  if phase == "down" then
    if "up" == name and scale < max_scale then
      world:scale(scale_amt)
    elseif "down" == name and scale > min_scale then
      world:scale(-1*scale_amt)
    elseif "up" == name then -- zoom into world if viewing map
      local scene = composer.getSceneName('current')
      composer.removeScene(scene)      

      local options = {effect = "fade", time = 500,}   
      composer.gotoScene('scenes.room', options)      
    elseif "down" == name then -- zoom into map if viewing room
    end

--[[
    local hidden_layer = world:getTileLayer('Hidden')
    local tile_NW = hidden_layer:getTileFromPosition(-3, 5)
    local tile_SE = hidden_layer:getTileFromPosition(45, 35)
    -- not sure why we need this offset but the y axis won't stay centered without it
    -- even with the offset it's still a few pixels off when changing scale
    -- but it's close enough to rock and roll!
    local offset_y = -1 * tile_NW.sprite.height
    x1, y1 = tile_NW.sprite:localToContent( 0, offset_y)
    x2, y2 = tile_SE.sprite:localToContent( 0, offset_y)

    x1, x2 = -1*x1 - phone_screen_width*0.5, -1*x2 + phone_screen_width*0.5
    y1, y2 = -1*y1 + phone_screen_height*0.5, -1*y2 + phone_screen_height*0.5
--]]
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
        -- here the distance is calculated between the start of the movement and its current position of the drag  
        local x_pos = (event.x - event.xStart) + platformTouched.startMoveX
        local y_pos = (event.y - event.yStart) + platformTouched.startMoveY
        local scale_x, scale_y = world:getScale()

        platformTouched.x = x_pos 
        platformTouched.y = y_pos

--[[
        print(x1, x2, y1, y2)

  --x = -1 * x + phone_screen_width*0.5
  --y = -1 * y + phone_screen_height*0.5

        local offset_top = scale_y * world.tileheight*0.5*3
        local offset_bottom = scale_y * world.tileheight*0.5*3

        local offset_left = scale_x * world.tilewidth*3
        local offset_right = scale_x * world.tilewidth*3

        local left_boundry = 0 - offset_left       --x1 -- -1 * (world_background_offset*world.tilewidth) * scale_x
        local right_boundry = -1 * world_width + phone_screen_width + offset_right --x2-- -1 * world_width --((world_width - world_background_offset*world.tilewidth) * scale_x) + phone_screen_width

        local top_boundry = 0 - offset_top --y1 ---1 * (world_background_offset*world.tileheight *0.5) * scale_y
        local bottom_boundry = -1* world_height - phone_screen_height + offset_bottom --y2 -- -1 * world_height --((world_height - world_background_offset*world.tileheight) * scale_y ) + phone_screen_height

        platformTouched.x = (x_pos > left_boundry and math.min(x_pos, left_boundry)) or (x_pos < right_boundry and math.max(x_pos, right_boundry)) or x_pos 
        platformTouched.y = (y_pos > top_boundry and math.min(y_pos, top_boundry)) or (y_pos < bottom_boundry and math.max(y_pos, bottom_boundry)) or y_pos

        print(x_pos, y_pos)
--]]

--[[
        local boundry_offset_left = 0.5*world.tilewidth 
        local boundry_offset_right = -30*world.tilewidth - phone_screen_width
        local left_boundry = (-2.0 * (y_pos/world.tileheight) * (world.tilewidth/2) ) + boundry_offset_left -- 5000
        local right_boundry = (-2.0 * (y_pos/world.tileheight)*(world.tilewidth/2) ) + (world.data.height/world.tileheight * world.tilewidth/2) + boundry_offset_right

        local boundry_offset_top = -7* world.tileheight
        local boundry_offset_bottom = -30* world.tileheight - phone_screen_height
        local top_boundry = (2 * (x_pos/world.tilewidth) * (world.tileheight/2)) + boundry_offset_top  -- 5000
        local bottom_boundry = (2 * (x_pos/world.tilewidth) * (world.tileheight/2)) - (world.data.width/world.tilewidth * world.tileheight/2) + boundry_offset_bottom -- -5000

        --  self.sprite.x = (-1 * self.row * self.map.tilewidth / 2) + (self.column * self.map.tilewidth  / 2) + offsetX
        --  self.sprite.y = (self.column * self.map.tileheight / 2) - (-1 * self.row * self.map.tileheight / 2) + offsetY

print('---NEW INFO---')
print('x_pos > left_boundry', 'y_pos > top_boundry')
print('('..x_pos..' > '..left_boundry..')', '('..y_pos..' > '..top_boundry..')')
print(x_pos > left_boundry, x_pos < right_boundry, y_pos > top_boundry, y_pos < bottom_boundry)
print(math.min(x_pos, left_boundry), math.min(y_pos, top_boundry))
print(platformTouched.x, platformTouched.y)

        local NW_boundry = (x_pos > left_boundry) and (y_pos > top_boundry)
        local NE_boundry = (x_pos < right_boundry) and (y_pos < bottom_boundry)
        local SW_boundry = (x_pos > left_boundry) and (y_pos < bottom_boundry)
        local SE_boundry = (x_pos < right_boundry) and (y_pos < bottom_boundry)

        if NW_boundry or NE_boundry or SW_boundry or SE_boundry then
          -- the x/y pos are hitting a corner boundry  (ie.  NW, NE, SW, SE) and we aren't going to update the x/y
    
        elseif x_pos > left_boundry then
          platformTouched.x = math.min(x_pos, left_boundry)
          platformTouched.y = y_pos
        elseif x_pos < right_boundry then
          platformTouched.x = math.max(x_pos, right_boundry)
          platformTouched.y = y_pos
        elseif y_pos > top_boundry then
          platformTouched.x = x_pos
          platformTouched.y = math.min(y_pos, top_boundry)
        elseif y_pos < bottom_boundry then
          platformTouched.x = x_pos
          platformTouched.y = math.max(y_pos, bottom_boundry)          
        elseif x_pos < left_boundry and x_pos > right_boundry and y_pos < top_boundry and y_pos > bottom_boundry then -- not bypassing any boundry 
          platformTouched.x = x_pos
          platformTouched.y = y_pos
        end
        --platformTouched.x = (x_pos > left_boundry and math.min(x_pos, left_boundry)) or (x_pos < right_boundry and math.max(x_pos, right_boundry)) or x_pos 
        --platformTouched.y = (y_pos > top_boundry and math.min(y_pos, top_boundry)) or (y_pos < bottom_boundry and math.max(y_pos, bottom_boundry)) or y_pos 
print(platformTouched.x, platformTouched.y)

        elseif y_pos < bottom_boundry then
          platformTouched.y = math.max(y_pos, bottom_boundry)
        else 
          platformTouched.y = y_pos
        end
--]]
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
        world.world:addEventListener( "touch", movePlatform )  -- Add a "touch" listener to the object        
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
        timer.pause(room_timer)
    end  
end


-- "scene:destroy()"
function scene:destroy( event )

    world:destroy()   
    Runtime:removeEventListener( "enterFrame", enterFrame )      
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
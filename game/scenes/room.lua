-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
berry = require( 'code.libs.berry.berry' )
local json = require( "json" )
local room, mob

local Object     = require 'code.libs.berry.Object'  -- using this to test fake mob/object spawn with room

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local width, height = display.contentWidth, display.contentHeight -- 320x480
local widget = require('widget')

local room, room_timer
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local map, y, x = main_player:getMap(), main_player:getPos()
  local location = map[y][x]

--if map[y][x]:isBuilding() and main_player:isStaged('inside') then 
--else main_player:isStaged('outside') then

  -- Load our room
  -- we need to have a atlas for different rooms on the map to load the specific room we are in  
  local filename = "graphics/map/room/ZTRoom.json"
  room = berry.loadMap( filename, "graphics/map/room" )

  local Mob_layer = room:getObjectLayer('Mob')
  local Name_layer = room:getObjectLayer('Mob Name')
  local Name_bkgr_layer = room:getObjectLayer('Mob Name Background')

  local mobs = location:getPlayers(main_player:getStage()) 

  local human_tileset = room:getTileSet('human') -- this should be called mob tileset, NOT human
  local sequences_data = human_tileset:getSequencesData()
  local first_gid = human_tileset.firstgid

  local sequence_names = {}  -- going to store our name and corresponding GID in this table
  for _, sequence in pairs(sequences_data) do 
    sequence_names[sequence.name] = first_gid + sequence.frames[3] - 1 -- frames[3] is north (for mobs only) and we need to subtract by one  
  end

  for player in pairs(mobs) do
    local text_str = player:getUsername()
    local sprite_name = player:isMobType('zombie') and 'husk' or 'white-male'
    local gid = sequence_names[sprite_name]

    local fake_mob_json_data = {
      gid = gid,
      height = 32,
      --id = 10,
      name = text_str,
      rotation = 0,
      type = "mob",
      visible = true,
      width = 32,
      x = math.random(40, 600),
      y = math.random(40, 300),
      properties = {
        isAnimated = true,
      },
    }

    Mob_layer:addObject(Object:new(fake_mob_json_data, room, Mob_layer))

    local border = 4
    local font_size = 9
    local above_mob_x, above_mob_y = fake_mob_json_data.x + 16, fake_mob_json_data.y - 24 - border*2 - font_size

    local name_data = {
      --id = 3,
      name = text_str,
      rotation = 0,
      type = "name",
      visible = true,
      x = above_mob_x,
      y = above_mob_y,
      properties = {stroked = true},

      text = {
        text = text_str,
        fontfamily = "scene/game/font/GermaniaOne-Regular.ttf",
        pixelsize = font_size,
        halign = 'center',
      },
    }

    local name = Object:new(name_data, room, Name_layer)
    Name_layer:addObject(name)

    -- this is a hack to measure the width of the text obj, then delete the text obj
    local _ = display.newText(text_str, 0, 0, name_data.text.fontfamily, font_size )
    local text_width = _.contentWidth
    _:removeSelf()
    _ = nil

    local rect_data = {
      height = font_size + border*2,
      width = text_width + border*2,
      name = text_str,
      rotation = 0,
      type = "rect",
      visible = true,
      x = above_mob_x,
      y = above_mob_y,
    }

    local name_bkgr = Object:new(rect_data, room, Name_bkgr_layer)
    Name_bkgr_layer:addObject(name_bkgr)  
  end

  local visual = berry.createVisual( room )
  --berry.buildPhysical( room )  This is used for physics... no need 

  -- the sprite must be loaded first via berry.createVisual before we can extend the objects
  room.extensions = "scenes.objects."
  room:extendObjects( "mob", "terminal", "apc", "generator", "transmitter")  -- animations, movement, death?, etc.

  --mob = room:getObjectWithName( "Rocco W" ):getVisual()
  --mob.filename = filename  

  return sceneGroup
end

--[[
-- Function to scroll the map
local function enterFrame( event )

  local elapsed = event.time

  -- Easy way to scroll a map based on a character
  if hero and hero.x and hero.y and not hero.isDead then
    local x, y = hero:localToContent( 0, 0 )
    x, y = display.contentCenterX - x, display.contentCenterY - y  -- this centers hero on the screen always
    --map.x, map.y = map.x + x, map.y + y
    local visual = map:getVisual()
    visual.x, visual.y = visual.x + x, visual.y + y
  end
end
--]]

local max, acceleration, dy, dx = 375, 5, 0, 0, 0, 0
local lastEvent = {}
local max_scale, min_scale = 1.25, 0.75  -- only applies to zoom in/out

local function key( event )
  local phase = event.phase
  local name = event.keyName
  --if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys
  if phase == "down" then
    local scale = room:getScale()

    if "up" == name and scale < max_scale then
      room:scale(0.25)
    elseif "down" == name and scale > min_scale then
      room:scale(-0.25)
    elseif "up" == name then -- zoom into room if viewing map
    elseif "down" == name then -- zoom into map if viewing room
      local scene = composer.getSceneName('current')
      composer.removeScene(scene)      

      local options = {effect = "fade", time = 500,}   
      composer.gotoScene('scenes.map', options)
    end
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
        local left_boundry, right_boundry = platformTouched.contentWidth * 0.25, display.actualContentWidth - platformTouched.contentWidth * 1.25
        local top_boundry, bottom_boundry = platformTouched.contentHeight * 0.25, display.actualContentHeight - platformTouched.contentHeight * 1.25

        platformTouched.x = (x_pos > left_boundry and math.min(x_pos, left_boundry)) or (x_pos < right_boundry and math.max(x_pos, right_boundry)) or x_pos 
        platformTouched.y = (y_pos > top_boundry and math.min(y_pos, top_boundry)) or (y_pos < bottom_boundry and math.max(y_pos, bottom_boundry)) or y_pos 
    elseif event.phase == "ended" or event.phase == "cancelled"  then
        -- here the focus is removed from the last position
        display.getCurrentStage():setFocus( nil )
    end
    return true
end
 
local function mobMovement()
  local dir = math.random(1, 4)

  local mob_list = room:getObjectsWithType('mob')
  for _, mob in ipairs(mob_list) do 
    mob.sprite:travel(dir)
  end  
end

local function enterFrame()
  -- Do this every frame  
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        --local delay = 500 -- 1 second?
        room_timer = timer.performWithDelay( math.random(2500, 5000), mobMovement, -1)    

        --Runtime:addEventListener( "enterFrame", enterFrame )      
        Runtime:addEventListener("key", key)  

        room.world:addEventListener( "touch", movePlatform )  -- Add a "touch" listener to the object        
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
        Runtime:removeEventListener( "enterFrame", enterFrame )      
        Runtime:removeEventListener( "key", key )          
        timer.pause(room_timer)
    end  
end


-- "scene:destroy()"
function scene:destroy( event )

    room:destroy()
    Runtime:removeEventListener("key", key)    
    Runtime:removeEventListener( "enterFrame", enterFrame )      
    Runtime:removeEventListener( "key", key )     
    timer.cancel(room_timer) 

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
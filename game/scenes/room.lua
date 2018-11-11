-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
berry = require( 'code.libs.berry.berry' )
local json = require( "json" )
local Object = require('code.libs.berry.Object')

local room, room_timer, mob

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local phone_screen_width, phone_screen_height = display.contentWidth, display.contentHeight -- 320x480
local widget = require('widget')

local player_stage = main_player:getStage()

local stage_boundry_x_left, stage_boundry_x_right
local stage_boundry_y_top, stage_boundry_y_bottom
local stage_width, stage_height 
local hardcoded_offset = 32 * 0.75

local room_width, room_height
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local map, y, x = main_player:getMap(), main_player:getPos()
  local location = map[y][x]

  -- We need to load our map, get the room template data, convert player position to tile_pos, subtract the gid
  -- it's a big clusterfuck but meh.
  local filename = "graphics/map/world.json"
  local world = berry.loadMap( filename, "graphics/map" )

  local tile_offset = world:getPropertyValue('background_tile_offset') -- this is how many tiles surround the world in all directions
  local template_layer = world:getTileLayer('Location Template ID')
  local world_width = template_layer.data.width

  -- we have to overwrite x/y because the background tiles offset our coords and we need to account for it
  x = x + tile_offset
  y = (y - 1 + tile_offset) * world_width

  local tile_pos = x + y  -- the positioning for layers uses a single array instead of a double array ie.  map[j] vs map[y][x]
  local tile_gid = template_layer.data.data[tile_pos]
  local template_name = world:getTilePropertyValueForGID (tile_gid, 'template')

  -- Load our room
  -- we need to have a atlas for different rooms on the map to load the specific room we are in  
  local filename = "graphics/rooms/"..template_name.. ".json"
  room = berry.loadMap( filename, "graphics/ss13" )

  -- gets the section of room the player is staged in
  stage_layer = room:getTileLayer(player_stage)

  -- sets the boundry for the section of the room
  stage_boundry_x_left, stage_boundry_x_right = stage_layer:getPropertyValue('boundry_left'), stage_layer:getPropertyValue('boundry_right')
  stage_boundry_y_top, stage_boundry_y_bottom = stage_layer:getPropertyValue('boundry_top'), stage_layer:getPropertyValue('boundry_bottom')
  stage_width, stage_height = stage_layer:getPropertyValue('section_width'), stage_layer:getPropertyValue('section_height')

  -- okay so for whatever reason the y position of our room is offset by 3/4ths of a tile on the top?  Not sure why or how but for now
  -- just going to ignore it and offset it thru hardcoding 
  stage_boundry_y_top = stage_boundry_y_top - hardcoded_offset
  stage_boundry_y_bottom = stage_boundry_y_bottom + hardcoded_offset  

  local Mob_layer = room:getObjectLayer('Mob')
  local Name_layer = room:getObjectLayer('Mob Name')
  local Name_bkgr_layer = room:getObjectLayer('Mob Name Background')

  local human_tileset = room:getTileSet('human') -- this should be called mob tileset, NOT human
  local sequences_data = human_tileset:getSequencesData()
  local first_gid = human_tileset.firstgid

  local sequence_names = {}  -- going to store our name and corresponding GID in this table
  for _, sequence in pairs(sequences_data) do 
    sequence_names[sequence.name] = first_gid + sequence.frames[3] - 1 -- frames[3] is north (for mobs only) and we need to subtract by one  
  end

  local mobs = location:getPlayers(main_player:getStage()) 
  local spawn_offset = 32

  for player in pairs(mobs) do
    local text_str = player:getUsername()
    local sprite_name = player:isMobType('zombie') and 'husk' or 'white-male'
    local gid = sequence_names[sprite_name]
    local is_player_standing = player:isStanding()

    local fake_mob_json_data = {
      gid = gid,
      height = 32,
      --id = 10,
      name = text_str,
      rotation = is_player_standing and 0 or 90,
      type = "mob",
      visible = true,
      width = 32,
      x = math.random(stage_boundry_x_left, stage_boundry_x_right - spawn_offset),  -- for whatever reason the left_boundry doesn't need a spawn offset
      y = math.random(stage_boundry_y_top + spawn_offset, stage_boundry_y_bottom - spawn_offset),
      properties = {
        isAnimated = true,
      },
    }

    local mob = Object:new(fake_mob_json_data, room, Mob_layer)
    mob.player = player -- this attaches our player code methods and vars to our sprite object for mob

    Mob_layer:addObject(mob)

    local border = 4
    local font_size = 9
    local above_mob_x, above_mob_y = fake_mob_json_data.x + 16, fake_mob_json_data.y - (is_player_standing and 24 or -12) - border*2 - font_size

    local name_data = {
      --id = 3,
      name = text_str,
      rotation = 0,
      type = "name",
      visible = is_player_standing,
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
      visible = is_player_standing,
      x = above_mob_x,
      y = above_mob_y,
    }

    local name_bkgr = Object:new(rect_data, room, Name_bkgr_layer)
    Name_bkgr_layer:addObject(name_bkgr)  
  end

  local visual = berry.createVisual( room )
  room_height, room_width = visual.contentHeight, visual.contentWidth

  --berry.buildPhysical( room )  This is used for physics... no need 

  -- the sprite must be loaded first via berry.createVisual before we can extend the objects
  room.extensions = "scenes.objects."
  room:extendObjects( "mob", "terminal", "apc", "generator", "transmitter", "door", "barricade", "search_area")  -- animations, movement, death?, etc.

  -- preparing to spawn our building equipment/sprites
  local map, y, x = main_player:getMap(), main_player:getPos() 
  local building = map[y][x]:isBuilding() and main_player:isStaged('inside') and map[y][x]

  if building then
    -- display our machines
    local building_has_power = building:isPowered()
    local machines = building:getEquipment()

    for machine_name, _ in pairs(machines) do
      local machine = room:getObjectWithName(machine_name).sprite
      machine:install()
      if building_has_power then machine:setPower('on') end
    end

    -- display our door
    local door_list = room:getObjectsWithName('door')  
    local is_door_present = building:isPresent('door')
    for _, door_obj in ipairs(door_list) do
      door = door_obj.sprite
      door:setVisual(is_door_present)

      -- right now there are no door damaged sprite states
      -- also make sure to set isAnimated for sprite object to true
      --if is_door_present then door:setSprite(hp_state) end
    end

    -- display our barricades
    local barricade_list = room:getObjectsWithName('barricade')
    local is_cade_present = building:isPresent('barricade')
    for _, barricade_obj in ipairs(barricade_list) do
      barricade = barricade_obj.sprite
      barricade:setVisual(is_cade_present)
      if is_cade_present then barricade:setSprite(building.barricade:getState()) end
    end

  end

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

      -- this is a super hacky way to fix our hardcoded offset to use scale properly
      hardcoded_offset = hardcoded_offset * (1 - scale)
      stage_boundry_y_top = stage_boundry_y_top - hardcoded_offset
      stage_boundry_y_bottom = stage_boundry_y_bottom + hardcoded_offset        
    elseif "down" == name and scale > min_scale then
      room:scale(-0.25)

      -- this is a super hacky way to fix our hardcoded offset to use scale properly
      hardcoded_offset = hardcoded_offset * (1 + scale)
      stage_boundry_y_top = stage_boundry_y_top - hardcoded_offset
      stage_boundry_y_bottom = stage_boundry_y_bottom + hardcoded_offset 
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
        local scale_x, scale_y = room:getScale()

        local left_boundry, right_boundry = -1 * 0, (-1 * room_width * scale_x) + phone_screen_width
        local top_boundry, bottom_boundry = -1 * 0, (-1 * room_height * scale_y ) + phone_screen_height

        -- this is the correct boundry for the room_section for inside
        --local left_boundry, right_boundry = -1 * stage_boundry_x_left * scale_x, (-1 * stage_boundry_x_right * scale_x) + phone_screen_width
        --local top_boundry, bottom_boundry = -1 * stage_boundry_y_top * scale_y, (-1 * stage_boundry_y_bottom * scale_y) + phone_screen_height

        platformTouched.x = (x_pos > left_boundry and math.min(x_pos, left_boundry)) or (x_pos < right_boundry and math.max(x_pos, right_boundry)) or x_pos 
        platformTouched.y = (y_pos > top_boundry and math.min(y_pos, top_boundry)) or (y_pos < bottom_boundry and math.max(y_pos, bottom_boundry)) or y_pos
    elseif event.phase == "ended" or event.phase == "cancelled"  then
        -- here the focus is removed from the last position
        display.getCurrentStage():setFocus( nil )
    end
    return true
end
 
local function mobMovement()
  local mob_list = room:getObjectsWithType('mob')
  for _, mob in ipairs(mob_list) do
    if mob.player:isStanding() then
      local dir = math.random(1, 4)   
      mob.sprite:travel(dir)
    end
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

        local delay = math.random(2500, 5000)
        room_timer = timer.performWithDelay( delay, mobMovement, -1)    

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
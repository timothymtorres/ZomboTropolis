-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

--[[ ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if (event.limitReached) then
        if ( event.direction == "up" ) then print( "Reached top limit" )
        elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "left" ) then print( "Reached left limit" )
        elseif ( event.direction == "right" ) then print( "Reached right limit" )
        end
    end

    return true
end
--]]

local width, height = display.contentWidth, display.contentHeight -- 320x480
local widget = require('widget')

local offset, thickness = 45, 3 
local pop_font_size = 10
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local grid_3x3_map, player_bar, location_group
  local drawLocation, updateLocation
  local drawPlayerBar, updatePlayerBar
  local drawMap, updateMap
  
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.   
    
  -- Player Bar  (Name/HP/IP/AP data)
  local player_bar_h, player_bar_w = 12, height/3 + offset
  
  function drawPlayerBar()
    player_bar = display.newGroup()
    local background_bar = display.newRect(player_bar_w-offset, player_bar_h*0.5 + thickness, player_bar_w, player_bar_h)
    background_bar.strokeWidth = thickness
    background_bar:setFillColor( 0.5 )
    background_bar:setStrokeColor( 1, 0, 0 )
    player_bar:insert(background_bar)

    local username, mob_type = main_player:getUsername(), main_player:getMobType()
    local hp, max_hp = main_player:getStat('hp'), main_player:getStat('hp', 'max')
    local ap, max_ap = main_player:getStat('ap'), main_player:getStat('ap', 'max')
    local xp, max_xp = main_player:getStat('xp'), main_player:getStat('xp', 'max')
    --local ip, max_ip = main_player:getIP(), main_player:getMaxIP()

    local player_text = display.newText( username..' - AP ['..ap..'/'..max_ap..'] HP ['..hp..'/'..max_hp..'] - XP ['..xp..'/'..max_xp..']', player_bar_w-offset, player_bar_h*0.5 + thickness, native.systemFontBold, 10 )
    player_text:setFillColor( 0, 0, 0 )
    player_bar:insert(player_text)
    
    sceneGroup:insert(player_bar)
  end

  function updatePlayerBar()
    player_bar:removeSelf()
    player_bar = nil
    drawPlayerBar()
  end


  local total_h = player_bar_h + thickness*2

  -- Tile Grid   (N/NE/E/SE/S/SW/W/NW, buttons, sprites) 
  local tile_grid_h, tile_grid_w = height/3 + offset, player_bar_w
  local tile_grid_x, tile_grid_y = tile_grid_w-offset, tile_grid_h*0.5 + thickness + total_h
  local grid_square = tile_grid_w/3
  local coord_offset_x, coord_offset_y = 0, -1*(grid_square*0.40)
  local population_text_offset_x, population_text_offset_y = 0, grid_square*0.40
  
  -- delete this when images are inserted
  local tile_colors = {
    hospital = {1, 0, 0},
    street = {0, 0, 0},
  }
 
  local gridButtonEvent = function(event)
    if ("ended" == event.phase ) then
      local dir = event.target.id
      main_player:perform('move', dir)
      updateMap()
      updatePlayerBar()
      updateLocation()
      print('Button was pressed and released')
    end
  end
  
  local centerButtonEvent = function(event)
    if ("ended" == event.phase ) then
      -- event.target.id is one of the following - enter/exit
      main_player:perform(event.target.id)
      updateMap()
      updatePlayerBar()
      updateLocation()
      print('Button was pressed and released')
    end
  end 
  
  local function countPlayerMobs(location_tile, setting, player_mob_type)
    local zombies = location_tile:countPlayers('zombie', setting)
    local humans = location_tile:countPlayers('human', setting)
    local corpses = location_tile:countCorpses(setting)
    -- We need to remove our main player from our count
    if player_mob_type == 'zombie' then zombies = zombies - 1 
    elseif player_mob_type == 'human' then humans = humans - 1
    end
    return zombies, humans, corpses
  end
  
  local function getPopulationStr(location_tile, setting, player_mob_type)
    local str
    local zombie_n, human_n, corpse_n = countPlayerMobs(location_tile, setting, player_mob_type)
    local zombies, humans, corpses = zombie_n > 0, human_n > 0, corpse_n > 0
    if zombies or humans or corpses then
      str = (zombies and 'Zx'..zombie_n or '')
      str = str..(zombies and humans and ' ' or '')..(humans and 'Hx'..human_n or '')
      str = str..(humans and corpses and ' ' or '')..(corpses and 'Cx'..corpse_n or '')
    else str = ''  
    end
    return str
  end  
 
  function drawMap()
    grid_3x3_map = display.newGroup()    
    local map, y, x = main_player:getMap(), main_player:getPos()   
    local coordinate
    local pop_text, population_str
    local player_staged = main_player:getStage()
    
    if map[y][x]:isBuilding() then
      local label, id 
      
      -- also this might need to be updated for barricade levels?   
      if main_player:isStaged('inside') then 
        label = 'Exit'
        id = 'exit'
      elseif main_player:isStaged('outside') then 
        label = 'Enter'
        id = 'enter'
      end
    
      local center_grid_button = widget.newButton
      {
          x = tile_grid_x,
          y = tile_grid_y,
          id = id,
          label = label,
          onEvent = centerButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }    
      grid_3x3_map:insert(center_grid_button) 
      coordinate = '[' .. x .. ', ' .. y .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x + coord_offset_x, tile_grid_y + coord_offset_y, native.systemFontBold, 8)   
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y][x], player_staged, main_player:getMobType())
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + population_text_offset_x, tile_grid_y + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)  
      elseif player_staged == 'inside' then
        population_str = getPopulationStr(map[y][x], player_staged, main_player:getMobType())
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + population_text_offset_x, tile_grid_y + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)          
      end
    end 
    
  --  local N_image = display.newRect(grid_3x3_map, tile_grid_x, tile_grid_y-grid_square, grid_square, grid_square)
  --  N_image:setFillColor(unpack(tile_colors[current_map[y-1][x]:getClassName()]))
    if map[y-1] and map[y-1][x] then
      local N_grid_button = widget.newButton
      {
          x = tile_grid_x,
          y = tile_grid_y-grid_square,
          id = 1,
          label = "N",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }    
      grid_3x3_map:insert(N_grid_button)  
      coordinate = '[' .. x .. ', ' .. y-1 .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x + coord_offset_x, tile_grid_y-grid_square + coord_offset_y, native.systemFontBold, 8)   
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y-1][x], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + population_text_offset_x, tile_grid_y-grid_square + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)
      end
    end
    
    if map[y-1] and map[y-1][x+1] then
      local NE_grid_button = widget.newButton
      {
          x = tile_grid_x+grid_square,
          y = tile_grid_y-grid_square,
          id = 2,
          label = "NE",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }     
      grid_3x3_map:insert(NE_grid_button)    
      coordinate = '['.. x+1 .. ', ' .. y-1 .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x + grid_square + coord_offset_x, tile_grid_y - grid_square + coord_offset_y, native.systemFontBold, 8) 
      
      if player_staged == 'outside' then  
        population_str = getPopulationStr(map[y-1][x+1], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + grid_square + population_text_offset_x, tile_grid_y-grid_square + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)
      end
    end
    
    if map[y] and map[y][x+1] then
      local E_grid_button = widget.newButton
      {
          x = tile_grid_x+grid_square,
          y = tile_grid_y,
          id = 3,
          label = "E",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }      
      grid_3x3_map:insert(E_grid_button)     
      coordinate = '['.. x+1 .. ', ' .. y .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x + grid_square + coord_offset_x, tile_grid_y + coord_offset_y, native.systemFontBold, 8)    
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y][x+1], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + grid_square + population_text_offset_x, tile_grid_y + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)  
      end
    end
    
    if map[y+1] and map[y+1][x+1] then
      local SE_grid_button = widget.newButton
      {
          x = tile_grid_x+grid_square,
          y = tile_grid_y+grid_square,
          id = 4,
          label = "SE",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }  
      grid_3x3_map:insert(SE_grid_button)    
      coordinate = '['.. x+1 .. ', ' .. y+1 .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x + grid_square + coord_offset_x, tile_grid_y + grid_square + coord_offset_y, native.systemFontBold, 8)
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y+1][x+1], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + grid_square + population_text_offset_x, tile_grid_y + grid_square + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)    
      end
    end
    
    if map[y+1] and map[y+1][x] then
      local S_grid_button = widget.newButton
      {
          x = tile_grid_x,
          y = tile_grid_y+grid_square,
          id = 5,
          label = "S",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }
      grid_3x3_map:insert(S_grid_button)      
      coordinate = '['.. x .. ', ' .. y+1 .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x + coord_offset_x, tile_grid_y + grid_square + coord_offset_y, native.systemFontBold, 8)  
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y+1][x], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x + population_text_offset_x, tile_grid_y + grid_square + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1) 
      end
    end
    
    if map[y+1] and map[y+1][x-1] then
      local SW_grid_button = widget.newButton
      {
          x = tile_grid_x-grid_square,
          y = tile_grid_y+grid_square,
          id = 6,
          label = "SW",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }      
      grid_3x3_map:insert(SW_grid_button)
      coordinate = '['.. x-1 .. ', ' .. y+1 .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x - grid_square + coord_offset_x, tile_grid_y + grid_square + coord_offset_y, native.systemFontBold, 8)  
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y+1][x-1], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x - grid_square + population_text_offset_x, tile_grid_y +grid_square + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)  
      end
    end
    
    if map[y] and map[y][x-1] then
      local W_grid_button = widget.newButton
      {
          x = tile_grid_x-grid_square,
          y = tile_grid_y,
          id = 7,
          label = "W",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }      
      grid_3x3_map:insert(W_grid_button)
      coordinate = '['.. x-1 .. ', ' .. y .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x - grid_square + coord_offset_x, tile_grid_y + coord_offset_y, native.systemFontBold, 8) 
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y][x-1], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x - grid_square + population_text_offset_x, tile_grid_y + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)  
      end
    end
    
    if map[y-1] and map[y-1][x-1] then
      local NW_grid_button = widget.newButton
      {
          x = tile_grid_x-grid_square,
          y = tile_grid_y-grid_square,
          id = 8,
          label = "NW",
          onEvent = gridButtonEvent,
          shape = 'rect',
          width = grid_square,
          height = grid_square,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }     
      grid_3x3_map:insert(NW_grid_button)                
      coordinate = '['.. x-1 .. ', ' .. y-1 .. ']'
      display.newText(grid_3x3_map, coordinate, tile_grid_x - grid_square + coord_offset_x, tile_grid_y - grid_square + coord_offset_y, native.systemFontBold, 8) 
      
      if player_staged == 'outside' then
        population_str = getPopulationStr(map[y-1][x-1], 'outside')
        pop_text = display.newText(grid_3x3_map, population_str, tile_grid_x - grid_square + population_text_offset_x, tile_grid_y-grid_square + population_text_offset_y, native.systemFont, pop_font_size)
        pop_text:setFillColor(0, 1, 0, 1)   
      end
    end
    
    -- add our map to the scene
    sceneGroup:insert(grid_3x3_map)  
  end

  function updateMap()
    grid_3x3_map:removeSelf()
    grid_3x3_map = nil
    drawMap()
  end
  
  
  total_h = total_h + tile_grid_h + thickness*2 
  
  function drawLocation()
    location_group = display.newGroup()
        
    -- Location Bar  (Building info?  Suburb?  Town?)
    local location_bar_h, location_bar_w = 12, player_bar_w
    local location_bar = display.newRect(location_group, location_bar_w-offset, location_bar_h*0.5 + thickness + total_h, location_bar_w, location_bar_h)
    location_bar.strokeWidth = thickness
    location_bar:setFillColor(0.5)
    location_bar:setStrokeColor(0, 1, 0)  
    location_group:insert(location_bar)
    
    local location_msg = (not main_player:isStanding() and 'You are DEAD.') or 'You are a '..main_player:getMobType()..'.'
    local location_text = display.newText(location_group, location_msg, location_bar_w-offset, total_h +  location_bar_h*0.5 + thickness, native.systemFontBold, 10 )
    location_text:setFillColor( 0, 0, 0 )  
  --sceneGroup:insert(location_text)
    
    local total_h = total_h + location_bar_h + thickness*2
    
    sceneGroup:insert(location_group)
  end
  
  

  
  function updateLocation()
    location_group:removeSelf()
    location_group = nil
    drawLocation()
  end  
  
  -- DRAWS OUR PLAYER BAR
  drawPlayerBar()
  -- DRAWS OUR PLAYER BAR  

  -- DRAWS OUR COORDS ON MAP
  drawMap()
  -- DRAWS OUR COORDS ON MAP
  
  -- DRAWS OUR LOCATION DESC AND LOCATION BAR
  drawLocation()
  -- DRAWS OUR LOCATION DESC AND LOCATION BAR
  
  return sceneGroup
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
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
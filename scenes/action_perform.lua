-----------------------------------------------------------------------------------------
--
-- action_perform.lua
--
-----------------------------------------------------------------------------------------


local composer = require( "composer" )
local scene = composer.newScene()
local widget = require('widget')

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

-- 52 is default tabbar height
local width, height = display.contentWidth, display.contentHeight - 52

local container_w, container_h = 280, 150
local container_xtra_w, container_xtra_h = 0, 0
local container_xtra 

local extra_widget_sizes = {
  attack = {width=296, height=222},  
  gesture = {width=296, height=222},
  drag_prey = {width=296, height=222},
  armor = {width=296, height=222},
}

local button_w, button_h, divider = 110, 40, 15
local action_text
local listener = {}

local cancelButtonEvent = function(event)
  if ('ended' == event.phase) then
    print('Button was pressed and released')
    if active_timer then timer.cancel(active_timer) end    
    composer.hideOverlay('fade', 400)
  end
end

local speak_msg 
local targets, weapons, wheel, armor_list
local action_params 

local function getActionText(action)
  local p_tile = main_player:getTile()
  local str
  
  if action == 'search' then
    local setting = (p_tile:isBuilding() and main_player:getStage()) or ''
    str = 'Search '..setting..' the '..p_tile:getName()..' '..p_tile:getClassName()..'?'
  elseif action == 'attack' then 
    local selections = wheel:getValues()  -- {selections[i].value, selections[i].index} [1]=targets, [2]=weapons
    local weapon, target = weapons[selections[2].index].weapon, targets[selections[1].index]
    local weapon_name, target_name = selections[2].value, selections[1].value
    local condition = (not weapon:isOrganic() and '{'..weapon:getCondition()..'}') or ''   
    str = 'Attack '..target_name..' ('..targets[selections[1].index]:getStat('hp')..'hp) using '..weapon_name..'?\n'..'['..weapon:getDice(main_player)..']   ('..weapon:getToHit(main_player, target)..'% to-hit)   '..condition     
  elseif action == 'speak' then
    -- need to get input from native.textfield()
    str = 'blah blah blah.. testing this shiz'
    speak_msg = str
    --[[
    local selections = wheel:getValues()
    str = ': "'..speak_msg..'"'
    if targets[selections[1].value] == 'all' then
      str = 'Say'..str..'?'
    else
      local target = targets[selections[1].index]
      local target_name = selections[1].value
      str = 'Whisper to '..target_name..str..'?'
    end
    --]]
  elseif action == 'barricade' then
    str = 'Barricade the '.. p_tile:getName() .. ' ' .. p_tile:getClassName() .. '?'
  elseif action == 'groan' then
    str = 'Emit groan?'
  elseif action == 'gesture' or action == 'drag_prey' then
    local selections = wheel:getValues()  -- {selections[i].value, selections[i].index} [1]=targets, [2]=weapons
    local target_name = selections[1].value
    if action == 'gesture' then str = 'Gesture towards '..target_name..'?'         
    elseif action == 'drag_prey' then str = 'Drag '..target_name..' out of the builiding?' 
    end
  elseif action == 'armor' then
    local selections = wheel:getValues()
    local armor_name = selections[1].value
    str = 'Form '..armor_name..' armor layer on body?'     
  else
    str = 'Perform '..action..'?'
  end
  return str
end

local function getActionParams(action)
  local params = {}
  if action == 'search' then  -- no params for search?  unless you want... player?  prolly?
  elseif action == 'attack' then 
    local selections = wheel:getValues()  -- {selections[i].value, selections[i].index} [1]=targets, [2]=weapons
    -- we want the index, fuck the value... ;P
    local weapon, target = weapons[selections[2].index].weapon, targets[selections[1].index]
    local inventory_ID = weapons[selections[2].index].inventory_ID   
    params = {target, weapon, inventory_ID}
  elseif action == 'gesture' or action == 'drag_prey' then
    local selections = wheel:getValues()
    local target = targets[selections[1].index]  -- this looks bugged?  targets[selections]?  targets?!
    params = {target}
  elseif action == 'armor' then
    local selections = wheel:getValues()
    local armor = armor_list[selections[1].index]
    params = {armor}
  elseif action == 'speak' then
    --[[
    local selections = wheel:getValues()  -- {selections[i].value, selections[i].index}
    local target = targets[selections[1].index]
    local speak_msg = 'testing this shit out'
    params = {target, speak_msg}
    --]]
    params = {speak_msg}
  elseif action == 'barricade' then
    local inventory_ID = action_params.inv_id
    params = {inventory_ID}
  end
  return params
end

local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}

local function getGestureWheel()
  targets = main_player:getTargets('gesture')
  local target_names = {}
  
  for i in ipairs(targets) do
    if type(targets[i]) == 'number' then
      target_names[#target_names+1] = compass[targets[i]]
    else
      local target_class = targets[i]:getClassName()
      if target_class == 'player' then
        target_names[#target_names+1] = targets[i]:getUsername()
      elseif target_class == 'equipment' then
        target_names[#target_names+1] = targets[i]:getClassName()
      else -- building class
        target_names[#target_names+1] = targets[i]:getName()..' '..targets[i]:getClassName()
      end
    end
  end
  
  local columnData = {
    {align='center', startIndex=1, labels=target_names},
  }

  local pick_wheel = widget.newPickerWheel{top=-1*(container_xtra_h*0.5), left=-1*(container_xtra_w*0.5)-15, columns=columnData, columnColor={0.2,0.2,0.2,1}}
  
  return pick_wheel  
end

local function getDragPreyWheel()
  targets = main_player:getTargets()
  local target_names = {}
  
  for i in ipairs(targets) do
    local target_class = targets[i]:getClassName()
    if target_class == 'player' then
      target_names[#target_names+1] = targets[i]:getUsername()
    end
  end
  
  local columnData = {
    {align='center', startIndex=1, labels=target_names},
  }

  local pick_wheel = widget.newPickerWheel{top=-1*(container_xtra_h*0.5), left=-1*(container_xtra_w*0.5)-15, columns=columnData, columnColor={0.2,0.2,0.2,1}}
  
  return pick_wheel  
end

local function getOrganicArmorWheel()
  armor_list = main_player.armor:getAvailableArmors()
  print()
  print('1ST LOOP')
  for k,v in pairs(armor_list) do print(k,v) end
print(table.inspect(armor_list))  
  for armor_type, _ in pairs(armor_list) do
    armor_list[#armor_list+1] = armor_type
    print(armor_type, _)
  end
  print()
  print('2ND LOOP')
  for k,v in pairs(armor_list) do print(k,v) end
  
  local columnData = {
    {align='center', startIndex=1, labels=armor_list},
  }

  local pick_wheel = widget.newPickerWheel{top=-1*(container_xtra_h*0.5), left=-1*(container_xtra_w*0.5)-15, columns=columnData, columnColor={0.2,0.2,0.2,1}}
  
  return pick_wheel   
end

local function getAttackWheel()
  targets, weapons = main_player:getTargets(), main_player:getWeapons()
  local target_names, weapon_names = {}, {}
  
  for i in ipairs(targets) do
--print('targets[i]', targets[i])
    local target_class = targets[i]:getClassName()
    if target_class == 'player' then
      target_names[#target_names+1] = targets[i]:getUsername()
    elseif target_class == 'equipment' then
      target_names[#target_names+1] = targets[i]:getClassName()
    else -- building class
      target_names[#target_names+1] = targets[i]:getClassName()
    end
  end
  
  for i in ipairs(weapons) do 
    local weapon = weapons[i].weapon
    -- probably need to add dice odds/dice strs/weapon condition
    weapon_names[#weapon_names+1] = weapon:getClassName()
  end
  
  local columnData = {
    {align='center', width=140, startIndex=1, labels=target_names},
    {align='center', width=140, startIndex=1, labels=weapon_names},
  }

  local pick_wheel = widget.newPickerWheel{top=-1*(container_xtra_h*0.5), left=-1*(container_xtra_w*0.5)-15, columns=columnData, columnColor={0.2,0.2,0.2,1}}
  
  return pick_wheel
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   --local parent = event.parent
   local params = event.params
   action_params = event.params
   local action = event.params.id
   
   container_xtra_w = extra_widget_sizes[action] and extra_widget_sizes[action].width or 0
   container_xtra_h = extra_widget_sizes[action] and extra_widget_sizes[action].height or 0
   
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local bar_h = 30        
    local container = display.newContainer( container_w, container_h + bar_h)
    -- TAB BAR HEIGHT = 60  (so 480-60 /2)
    container:translate( width*0.5, height*0.5 + bar_h*0.5 - container_xtra_h*0.5) -- center the container

    container_h = container_h - bar_h*0.5

    container_h = container_h
    local background = display.newRect(0, 0, container_w, container_h)
    background:setFillColor(0.1, 0.1, 0.1, 0.70)
    container:insert(background)
    
    local top_background_bar = display.newRect(0, -1*(container_h/2 + bar_h*0.5), container_w, bar_h) 
    top_background_bar:setFillColor(0.2, 0.2, 0.8, 0.70)
    container:insert(top_background_bar)
    
    local action_cost = display.newText{
      text = 'Perform Action For: '..params.cost..' AP', 
      x = 0,
      y = -1*(container_h/2 + bar_h*0.375), 
      font = native.systemFont, 
      fontSize = 14,
    }
    action_cost:setFillColor(1, 0, 0, 1)
    container:insert(action_cost)
    
    local performButtonEvent = function(event)
      if ('ended' == event.phase) then
        if active_timer then timer.cancel(active_timer) end
        
        print('')
        print('getting action params:')
        for k,v in pairs(getActionParams(action)) do print(k,v) end
        
        main_player:takeAction(action, unpack(getActionParams(action)))
        composer.hideOverlay('fade', 400)       
        composer.gotoScene('scenes.action')
        print('Button was pressed and released')
      end
    end

    local perform_button = widget.newButton
      {
          left = -1*(button_w + divider),
          top = container_h/7,
      --  id = ,
          label = 'PERFORM',
          onEvent = performButtonEvent,
          shape = 'rect',
          width = button_w,
          height = button_h,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }  
    container:insert(perform_button) -- insert and center text

    local cancel_button = widget.newButton
      {
          left = divider,
          top = container_h/7,
      --  id = ,
          label = 'CANCEL',
          onEvent = cancelButtonEvent,
          shape = 'rect',
          width = button_w,
          height = button_h,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }  
    container:insert(cancel_button) -- insert and center text   

    if action == 'attack' or action == 'gesture' or action == 'drag_prey' or action == 'armor' then
      container_xtra = display.newContainer(container_xtra_w, container_xtra_h)
      container_xtra:translate( width*0.5, height - (container_h)) -- center the container   
      
      local function redoActionText()
          action_text:removeSelf()
          action_text = nil
          
          action_text = display.newText{
            text = getActionText(action),
            width = container_w - 10, 
            x = 5,
            y = -40,
            font = native.systemFont,
            fontSize = 18,
            align = 'center',
          }
          action_text:setFillColor(1, 1, 1, 1)
          container:insert(action_text)      
      end
 
      wheel = (action == 'attack' and getAttackWheel()) or (action == 'gesture' and getGestureWheel()) or (action == 'drag_prey' and getDragPreyWheel()) or (action == 'armor' and getOrganicArmorWheel())
      
      function listener:timer( event )
        -- this prevents multiple timers from running by stopping the previous active timer if present
        if active_timer and (tostring(active_timer) ~= tostring(event.source)) then 
          timer.cancel(active_timer) 
        end
        
        active_timer = event.source  -- active_timer needs to be a global!
        redoActionText()        
      end  
      
      local function wheelTouchListner( event )
          if event.phase == "began" then
              print( "You touched the object!")
              timer.performWithDelay(500, listener, 20)
          end
      end

      local wheel_hitbox = display.newRect(0, 0, 320, 222 )  
      wheel_hitbox.isVisible, wheel_hitbox.isHitTestable = false, true
      wheel_hitbox:addEventListener( "touch", wheelTouchListner )      
      
      
      container_xtra:insert(wheel)
      container_xtra:insert(wheel_hitbox) -- it's not visible
    end
    
    action_text = display.newText{
      text = getActionText(action),
      width = container_w - 10, 
      x = 5,
      y = -40,
      font = native.systemFont,
      fontSize = 18,
      align = 'center',
    }
    action_text:setFillColor(1, 1, 1, 1)
    container:insert(action_text)    
   
    sceneGroup:insert(container)
    if container_xtra then sceneGroup:insert(container_xtra) end
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
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

local extra_widget_sizes = {width=296, height=222}

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

local targets, wheel
local item, inv_id 

local function getActionText(action)
  local str
  
  -- need to get syringe stats (condition, accuracy, etc.)
  -- need to make sure correct params are being passed to action text (ie. the wheel values)
  -- syringe is not weapon, convert into item and get condition
  
  
  local selections = wheel:getValues()  -- {selections[i].value, selections[i].index} [1]=targets, [2]=weapons
  local target_name = selections[1].value
  --local weapon_name, target_name = selections[2].value, selections[1].value    
  local condition = '{'..item:getCondition()..'}' or ''       
  
  str = 'Inject '..target_name..' ('..targets[selections[1].index]:getStat('hp')..'hp) using syringe?'

  --\n('..item:getToHit(main_player, target)..'% to-hit)   '..condition        

  return str
end

local function getActionParams(action)
  local params = {}
  local selections = wheel:getValues()
  local target = targets[selections[1].index]
  params = {inv_id, target}  
--[[
  elseif action == 'barricade' then
    local inventory_ID = action_params.inv_id
    params = {inventory_ID}
  end
--]]
  return params
end

local function getWheel()
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

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   --local parent = event.parent
   local params = event.params
   local action = event.params.id
   inv_id = event.params.inv_id
   item = main_player.inventory:lookup(event.params.inv_id)
   
   container_xtra_w = extra_widget_sizes and extra_widget_sizes.width or 0
   container_xtra_h = extra_widget_sizes and extra_widget_sizes.height or 0
   
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
    
    local performButtonEvent = function(event_button)
      if ('ended' == event_button.phase) then
        if active_timer then timer.cancel(active_timer) end
        
        print('')
        local test = {unpack(getActionParams(action))}
--for k,v in pairs(event) do print(k,v) end
--for k,v in pairs(event.params) do print(k,v) end
        print('getting action params BEFORE test:')
        for i,v in ipairs(getActionParams(test)) do print(i,v) end
        

        print('inv_id for params is:', event.params.inv_id)
        test[#test+1] = event.params.inv_id
        print('getting action params AFTER test:')
        for i,v in ipairs(getActionParams(test)) do print(i,v) end
        
        main_player:takeAction(action, unpack(getActionParams(test)))
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

    wheel = getWheel()
    
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
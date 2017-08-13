-----------------------------------------------------------------------------------------
--
-- acid.lua
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
local cancel_button = require('scenes.action.button.cancel_button')
local perform_button = require('scenes.action.button.perform_button')

-- 52 is default tabbar height
local width, height = display.contentWidth, display.contentHeight - 52 --320, 428

local top_container_w, top_container_h = math.floor(width*0.875 + 0.5), math.floor(height*0.35 + 0.5)
local bottom_container_w, bottom_container_h = math.floor(width*0.925 + 0.5), math.floor(height*0.518 + 0.5)

local divider = 15
local action_text
local listener = {}

local targets, wheel
local action_params = {}

local function getActionText(action)
  local str
  
  local selections = wheel:getValues()  -- {selections[i].value, selections[i].index} [1]=targets, [2]=weapons
  local target_name = selections[1].value
  str = 'Spray acid at '..target_name..' ('..targets[selections[1].index]:getStat('hp')..'hp)?'     
  return str
end

local performButtonEvent = function(event)
  if ('ended' == event.phase) then
    print('Perform button was pressed and released')    
    if active_timer then timer.cancel(active_timer) end
    
    -- our wheel stuff
    local selections = wheel:getValues()
    action_params[#action_params + 1] = targets[selections[1].index] --target    
    -- wheel stuff finished
    
    main_player:takeAction(unpack(action_params))
    composer.gotoScene('scenes.action')
  end
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

  local pick_wheel = widget.newPickerWheel{top=-1*(bottom_container_h*0.5), left=-1*(bottom_container_w*0.5)-15, columns=columnData, columnColor={0.2,0.2,0.2,1}}
  
  return pick_wheel  
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   --local parent = event.parent
   local params = event.params
   local action = event.params.id
   
   action_params[#action_params + 1] = action
   
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    -------------------------------
    -------------------------------
    -- T O P   C O N T A I N E R --
    -------------------------------
    -------------------------------
    
    local bar_h = 30        
    local top_container = display.newContainer( top_container_w, top_container_h + bar_h)  
    top_container:translate( width*0.5, height*0.5 + bar_h*0.5 - bottom_container_h*0.5) -- center the container
    top_container_h = top_container_h - bar_h*0.5  -- center the container along the y-axis?!?

    local background = display.newRect(0, 0, top_container_w, top_container_h)
    background:setFillColor(0.1, 0.1, 0.1, 0.70)
    top_container:insert(background)
    
    local top_background_bar = display.newRect(0, -1*(top_container_h/2 + bar_h*0.5), top_container_w, bar_h) 
    top_background_bar:setFillColor(0.2, 0.2, 0.8, 0.70)
    top_container:insert(top_background_bar)
    
    local action_cost = display.newText{
      text = 'Perform Action For: '..params.cost..' AP', 
      x = 0,
      y = -1*(top_container_h/2 + bar_h*0.375), 
      font = native.systemFont, 
      fontSize = 14,
    }
    action_cost:setFillColor(1, 0, 0, 1)
    top_container:insert(action_cost)
    
    --------------------
    -- PERFORM BUTTON --
    --------------------
    perform_button.top, perform_button.left = top_container_h/7, -1*(perform_button.width + divider)   
    perform_button.onEvent = performButtonEvent
    perform_button = widget.newButton(perform_button)
    top_container:insert(perform_button) 
    
    -------------------
    -- CANCEL BUTTON --
    -------------------
    cancel_button.top, cancel_button.left = top_container_h/7, divider    
    cancel_button = widget.newButton(cancel_button) 
    top_container:insert(cancel_button) 





    -------------------------------------
    -------------------------------------
    -- B O T T O M   C O N T A I N E R --
    -------------------------------------
    -------------------------------------


    local bottom_container = display.newContainer(bottom_container_w, bottom_container_h)
    bottom_container:translate( width*0.5, height - (top_container_h)) -- center the container   
    
    local function redoActionText()
        action_text:removeSelf()
        action_text = nil
        
        action_text = display.newText{
          text = getActionText(action),
          width = top_container_w - 10, 
          x = 5,
          y = -40,
          font = native.systemFont,
          fontSize = 18,
          align = 'center',
        }
        action_text:setFillColor(1, 1, 1, 1)
        top_container:insert(action_text)      
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
    
    
    bottom_container:insert(wheel)
    bottom_container:insert(wheel_hitbox) -- it's not visible
    
    action_text = display.newText{
      text = getActionText(action),
      width = top_container_w - 10, 
      x = 5,
      y = -40,
      font = native.systemFont,
      fontSize = 18,
      align = 'center',
    }
    action_text:setFillColor(1, 1, 1, 1)
    top_container:insert(action_text)    
   
    sceneGroup:insert(top_container)
    sceneGroup:insert(bottom_container)
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
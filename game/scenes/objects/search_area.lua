local lume = require('code.libs.lume')

local MOVEMENT_DELAY = 7
local ANIMATION_DELAY = 1500
local FIRST_SEARCH_DELAY = 1500
local SEARCH_DELAY = ANIMATION_DELAY

local function Plugin(search_area)   
  search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register
  search_area.isVisible = true
  search_area.timer_ID = nil

  local function spawn_item(mob)
    local result = main_player:perform('search')
    local item_name = result[3] and string.lower(tostring(result[3])) or 'junk'

print('WE FOUND '..item_name)

    local item = search_area.map:addSprite("Item", item_name, mob.x, mob.y - 22)

    local SHRINK_SCALE = 0.30
    local shrink_params = {
      time=ANIMATION_DELAY,
      transition=easing.inOutExpo,--easing.inExpo,
      x=mob.x + 45,
      y=mob.y - 35,
      rotation = mob.rotation + 160,
      xScale=SHRINK_SCALE,
      yScale=SHRINK_SCALE,
      onComplete=function() 
        item:removeSelf()
        mob:setIdle(true)
      end,
    }

    if item_name == 'junk' then
      shrink_params.x = mob.x + 45
     -- shrink_params.transition = 
    end

    transition.to( item, shrink_params)
  end

  function search_area.search(event)
    if main_player:canPerform('search') then
      local mob = search_area.map:getObjects({name=tostring(main_player)})
      local distance = lume.distance(mob.x, mob.y, search_area.x, search_area.y)
      mob:setIdle(false)

      local movement_params = {
        time=distance * MOVEMENT_DELAY, 
        x=search_area.x, 
        y=search_area.y,
        onComplete=spawn_item,
      }
      transition.to(mob, movement_params)
    else
      -- make error sound
    end 
  end

  function search_area.timer(event) search_area.search(event) end

  function search_area.touch(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})
    local time_delay

      if ( event.phase == "began" ) then
          display.getCurrentStage():setFocus( event.target ) --'event.target' is the touched object
print('Event.phase = began, search_area.timer_ID is about to be set')

          if not search_area.timer_ID then

        -- we need a way to continously search but before we do that
        -- we need to check if the player has moved to the search area
        -- beforehand?  I'm stumped... gah.

            search_area.timer_ID = timer.performWithDelay(SEARCH_DELAY, search_area, 0)
          else
            -- should we return true here?  maybe this avoids other event.phase from being triggered?
          end
      elseif (event.phase == "moved") then
print('Event.phase = "moved", canceling search timer, mob:setIdle(true)')
        timer.cancel(search_area.timer_ID)

      elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
          display.getCurrentStage():setFocus( nil )  --setting focus to 'nil' removes the focus
          timer.cancel(search_area.timer_ID)
          search_area.timer_ID = nil  -- is this neccessary?
print('Event.phase = "ended/cancelled", canceling search timer, mob:setIdle(true)')

      end
    return true
  end

  function search_area.tap(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})
    if ( event.numTaps == 2 ) then 
print('search_area.tap = 2, mob:setIdle(false)')
      search_area.search(event)

    end
  end

  -- only let a human click on search areas that they are in
  if main_player:isStaged(search_area.name) and main_player:isMobType('human') then
    search_area:addEventListener("tap", search_area.tap) 
    search_area:addEventListener("touch", search_area.touch)
  end

  return search_area
end

return Plugin
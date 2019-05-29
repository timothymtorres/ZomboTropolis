local lume = require('code.libs.lume')

local MOVEMENT_DELAY = 7
local SEARCH_DELAY = 1500
local TOUCH_DELAY = 1000

local function Plugin(search_area)   
  search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register
  search_area.isVisible = true
  search_area.timer_ID = nil

  local function search()
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    local result = main_player:perform('search')
    local item_name = result[3] and string.lower(tostring(result[3])) or 'junk'

print('WE FOUND '..item_name)

    local item = search_area.map:addSprite("Item", item_name, mob.x, mob.y - 22)

    local SHRINK_SCALE = 0.30
    local shrink_options = {
      time=SEARCH_DELAY,
      transition=easing.inOutExpo,
      x=mob.x,
      y=mob.y,
      xScale=SHRINK_SCALE,
      yScale=SHRINK_SCALE,
      onComplete=function() 
        item:removeSelf()
        if not mob:isActivity('searching') then mob:moveToLastPosition() end
      end,
    }

    if item_name == 'junk' then
      shrink_options.x = mob.x + 45
      shrink_options.y = mob.y - 35
      shrink_options.rotation = mob.rotation + 160 
    end

    transition.to( item, shrink_options)
  end

  function search_area.touch(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if event.phase == "began" and mob.isBodyActive then
      display.getCurrentStage():setFocus(event.target)

      if mob.player:canPerform('search') then
        local touch_options = {
          delay=TOUCH_DELAY,
          onComplete=function()
            search()
            mob.timer_ID = timer.performWithDelay(SEARCH_DELAY, search, 0)
          end,
        }
        mob.transition_ID = mob:moveTo(search_area, touch_options)
        mob:setActivity('searching')
      else
        -- make error sound
      end
    elseif mob:isActivity('searching') then
      if event.phase ~= "moved" then display.getCurrentStage():setFocus(nil) end

      if mob.timer_ID then 
        timer.cancel(mob.timer_ID)
        mob.timer_ID = nil
      end

      if mob.transition_ID then
        transition.cancel(mob.transition_ID)
        mob.transition_ID = nil
      end

      mob:resetActivity()
    end
    return true
  end

  function search_area.tap(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if ( event.numTaps == 2 ) and mob.isBodyActive then
      if mob.player:canPerform('search') then
        local tap_options = {onComplete=search}
        mob:moveTo(search_area, tap_options)
      else
        -- make error sound
      end
    end
  end

  -- only let a standing human click on search areas that they are in
  if main_player:isStaged(search_area.name) and main_player:isMobType('human') 
  and main_player:isStanding() then
    search_area:addEventListener("tap", search_area.tap) 
    search_area:addEventListener("touch", search_area.touch)
  end

  return search_area
end

return Plugin
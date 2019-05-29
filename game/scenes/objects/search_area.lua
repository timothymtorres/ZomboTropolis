local SEARCH_DELAY = 1500
local TOUCH_DELAY = 1000

local function Plugin(search_area)   
  search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register
  search_area.isVisible = true

  local function search()
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if mob.player:canPerform('search') then
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
          if not mob:isTouch('searching') then mob:moveToLastPosition() end
        end,
      }

      if item_name == 'junk' then -- toss aside overhead
        shrink_options.x = mob.x + 45
        shrink_options.y = mob.y - 35
        shrink_options.rotation = mob.rotation + 160 
      end

      transition.to(item, shrink_options)
    else
      -- make error sound
      mob:moveToLastPosition()       
    end
  end

  function search_area.touch(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if event.phase == "began" and mob.isBodyActive then
      display.getCurrentStage():setFocus(event.target)
      local touch_options = {
        delay=TOUCH_DELAY,
        onComplete=function()
          search()
          mob.timer_ID = timer.performWithDelay(SEARCH_DELAY, search, 0)
        end,
      }
      mob:setTouch('searching')
      mob:moveTo(search_area, touch_options)
    elseif mob:isTouch('searching') then 
      if event.phase ~= "began" then 
        mob:cancelAction() 
        display.getCurrentStage():setFocus(nil) 
      end
    end

    if event.phase == "ended" or event.phase == "cancelled" then 
      --display.getCurrentStage():setFocus(nil) 
    end

    return true
  end

  function search_area.tap(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if ( event.numTaps == 2 ) and mob.isBodyActive then
      local tap_options = {onComplete=search}
      mob:moveTo(search_area, tap_options)
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
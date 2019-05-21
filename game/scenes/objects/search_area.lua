
--local composer = require( "composer" )
--local item_effect = require('scenes.objects.item_effect')

local MOVEMENT_DELAY = 1000
local ANIMATION_DELAY = 1500
local FIRST_SEARCH_DELAY = 1500
local SEARCH_DELAY = ANIMATION_DELAY

local function Plugin(search_area)   
  search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register
  search_area.isVisible = true
  search_area.timer_ID = nil

  local function spawn_item(mob)
    local result = main_player:perform('search')
    local is_item_found = result[3]
    local item = is_item_found and string.lower(tostring(result[3])) or 'junk'

print('WE FOUND '..item)

    item = search_area.map:addSprite("Item", item, mob.x, mob.y - 22)

    local SHRINK_SCALE = 0.30
    local shrink_params = {
      time=ANIMATION_DELAY,
      transition=easing.inOutExpo,--easing.inExpo,
      x=mob.x + 45,
      y=mob.y - 35,
      rotation = mob.rotation + 160,
      xScale=SHRINK_SCALE,
      yScale=SHRINK_SCALE,
      onComplete=item.removeSelf,
    }

    if not is_item_found then -- the item is junk
      shrink_params.x = mob.x + 45
     -- shrink_params.transition = 
    end

    transition.to( item, shrink_params)
  end

  function search_area.search(event)
    if main_player:canPerform('search') then
      local mob = search_area.map:getObjects({name=tostring(main_player)})

      local movement_params = {
        time=MOVEMENT_DELAY, 
        x=search_area.x, 
        y=search_area.y,
        onComplete=spawn_item,
      }
      transition.to(mob, movement_params)

      -- mob_sprite:setStationary(true)
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
print('touch event has began')

          if not search_area.timer_ID then
print('search_area.search_timer is about to be set')

        -- we need a way to continously search but before we do that
        -- we need to check if the player has moved to the search area
        -- beforehand?  I'm stumped... gah.

            search_area.timer_ID = timer.performWithDelay(SEARCH_DELAY, search_area, 0)
          else
            -- should we return true here?  maybe this avoids other event.phase from being triggered?
          end
      elseif (event.phase == "moved") then
print('canceling search timer')
        timer.cancel(search_area.timer_ID)
        mob:setIdle(false)
--[[
        if not search_area.unfreeze_timer then
          local time_delay = (mob_sprite:isStationary() and 0 or MAX_MOVEMENT_DELAY) + ANIMATION_DELAY
          search_area.unfreeze_timer = timer.performWithDelay(time_delay, unfreezeMobSprite)
        end
--]]
      elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
          display.getCurrentStage():setFocus( nil )  --setting focus to 'nil' removes the focus
          timer.cancel(search_area.timer_ID)
          search_area.timer_ID = nil  -- is this neccessary?

--[[
          if not search_area.unfreeze_timer then
            local time_delay = (mob_sprite:isStationary() and 0 or MAX_MOVEMENT_DELAY) + ANIMATION_DELAY
          search_area.unfreeze_timer = timer.performWithDelay(time_delay, unfreezeMobSprite)
        end
--]]
      end
    return true
  end

  function search_area.tap(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})
    if ( event.numTaps == 2 ) then 
      mob:setIdle(false)
      search_area.search(event) 

--[[
      if not search_area.unfreeze_timer then
        local time_delay = (mob_sprite:isStationary() and 0 or MAX_MOVEMENT_DELAY) + ANIMATION_DELAY
        search_area.unfreeze_timer = timer.performWithDelay(time_delay, unfreezeMobSprite)
      end
--]]
    end
  end

  -- only let a human click on search areas that they are in
  if main_player:isStaged(search_area.name) and main_player:isMobType('human') then
    search_area:addEventListener("touch", search_area.touch)
    search_area:addEventListener("tap", search_area.tap)    
  end

--[[

  local function getMobSprite(player)
    local location = search_area.map
    local mob_layer = location:getObjectLayer('Mob')
    local mob_obj = mob_layer:getObject(player:getUsername())
    return mob_obj:getVisual()
  end

  local function unfreezeMobSprite()
    local mob_sprite = getMobSprite(main_player)
      mob_sprite:setStationary(false)
    search_area.unfreeze_timer = nil
  end

--]]
  return search_area
end

return Plugin
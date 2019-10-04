local lume = require('code.libs.lume')
local tilesets = require('scenes.functions.mob_tilesets')
local clothing = require('code.player.clothing')

local function createMob(player, location)
  local username = player:getUsername()
  local is_player_standing = player:isStanding()

  local cosmetics = player.cosmetics --clothing:generateRandom(player:getMobType())

--[[
  local mob_data = {
    gid = location:getAnimationGID(animation),
    height = 32,
    width = 32,
    name = username,
    type = "mob",
    isAnimated = true,
  }
--]]

  --local mob = location:addObject(mob_data)
  --mob:rotate( (is_player_standing and 0) or 90)
  --mob.x, mob.y = 0, 0

  local layer = location:getLayer(is_player_standing and "Mob" or "Corpse")
  local group = display.newGroup()
  layer:insert(group)

  -- used by berry to extend our group
  group.name, group.type = username, 'mob'
  group.player = player

  --group.group:insert( mob )


  -- create our name/background displays on top of mob
  local border = 3
  local standing_offset = is_player_standing and 28 or 22
  local font_size = 9

  local name_options = {
    text = group.name,
    font = native.systemFont,
    fontSize = font_size,
    align = 'center',
    x = 0,
    y = 0 - standing_offset,
  }

  local name = display.newText(name_options)

  local x, y = name.x, name.y
  local w, h = name.contentWidth + border, font_size + border*2 
  local corner = h/4

  local name_background = display.newRoundedRect(x, y, w, h, corner)
  name_background:setFillColor(0.15, 0.15, 0.15, 0.65)

  group:insert(1, name_background)
  group:insert(2, name)

  for _, mob_section in ipairs(clothing.draw_order) do
    local image = cosmetics[mob_section]
    if image then
      group:insert( display.newSprite(tilesets[image].sheet, tilesets[image]) )
    end
    -- eyes should just change color.... and be setup default? like body
    -- if image == color then
    -- change setFillColor of images listed
  end

--[[
----------- TESTING PURPOSES ---------------------------------------
  local group_boundaries = display.newRect(0, 0, group.contentWidth, group.contentHeight)
print('mob content bounds', group.contentWidth, group.contentHeight)
  group_boundaries:setFillColor(0.15, 0.15, 0.15, 0.25)
  group:insert(group_boundaries)
----------- TESTING PURPOSES ---------------------------------------
--]]

  location:extend("mob")

  if group.player:isStanding() then
    local starting_direction = "walk-" .. lume.randomchoice({'north', 'east', 'south', 'west'}) 
    group:setAnimation(starting_direction)

    local name = group.player:getUsername()
    local font_size = 9

    -- only apply physics to standing mobs
    local mobFilter = { categoryBits=2, maskBits=1 } 
    local rectShape = { -16,-16, -16,16, 16,16, 16,-16  }
    local physics_properties = {shape= rectShape, bounce = 1, filter=mobFilter}
    physics.addBody(group, physics_properties )
    group.isFixedRotation = true

    group.collision = function( self, event )
      if ( event.phase == "ended" ) then
        local vx, vy = self:getLinearVelocity()
        local direction 

        if vy < 0 then direction = "north"
        elseif vx > 0 then direction = "east"
        elseif vy > 0 then direction = "south"
        elseif vx < 0 then direction = "west"
        end

        if direction then 
          self:setAnimation("walk-"..direction)
          self:playAnimation() 
        else -- sometimes colliding with wall results in no velocity 
          self:pauseAnimation()
        end
      end
    end

    group:addEventListener("collision", group)

  elseif not group.player:isStanding() then 
    --consider removing the group name/background 
    group:setAnimation("fall")
  end

  local total_time = math.random(1250, 1700)
  group.movement_timer = timer.performWithDelay( total_time, group, -1)

  return group
end

return createMob
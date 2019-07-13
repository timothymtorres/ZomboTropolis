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

  local snap_w = 96
  local snap_h = 96
  local layer = location:getLayer(is_player_standing and "Mob" or "Corpse")
  local snap = display.newGroup()
  layer:insert(snap)

  -- used by berry to extend our snapshot
  snap.name, snap.type = username, 'mob'
  snap.player = player

  --snap.group:insert( mob )


  -- create our name/background displays on top of mob
  local border = 3
  local standing_offset = is_player_standing and 28 or 22
  local font_size = 9

  local name_options = {
    text = snap.name,
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

  snap:insert(1, name_background)
  snap:insert(2, name)

print('CREATING MOB COSMETICS')
for k,v in pairs(tilesets) do print(k,v) end

  for _, mob_section in ipairs(clothing.draw_order) do
    local image = cosmetics[mob_section]
print(image)
    if image then
      snap:insert( display.newSprite(tilesets[image].sheet, tilesets[image]) )
    end
    -- eyes should just change color.... and be setup default? like body
    -- if image == color then
    -- change setFillColor of images listed
  end

  location:extend("mob")

  if snap.player:isStanding() then
    local starting_direction = "walk-" .. lume.randomchoice({'north', 'east', 'south', 'west'}) 
    snap:setAnimation(starting_direction)

    local name = snap.player:getUsername()
    local font_size = 9

    -- only apply physics to standing mobs
    local mobFilter = { categoryBits=2, maskBits=1 } 
    local rectShape = { -16,-16, -16,16, 16,16, 16,-16  }
    local physics_properties = {shape= rectShape, bounce = 1, filter=mobFilter}
    physics.addBody(snap, physics_properties )
    snap.isFixedRotation = true

    snap.collision = function( self, event )
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

    snap:addEventListener("collision", snap)

  elseif not snap.player:isStanding() then 
    --consider removing the snap name/background 
    snap:setAnimation("fall")
  end

  local total_time = math.random(1250, 1700)
  snap.movement_timer = timer.performWithDelay( total_time, snap, -1)

  return snap
end

return createMob
--[[----------------------------------------------------------------
  
  +------+
  | ZONE |
  +------+
  
  Used to determine which locations to broadcast event.
  
  zone = {
    type = self/pair/stage/tile/area
    stage = inside/outside/nil    
    tile = map[y][x]/nil
    range = num/nil
    player = player_INST (requires type to be 'self' or 'pair')
    target = target_INST (requires type to be 'pair')
  }

  zone.type notes:
    self - broadcast to the player causing the event (player)
    pair - broadcast to the players involved in the event (player & target)
   stage - broadcast to the players [inside/outside] of tile (note requires zone.type.tile)
    tile - broadcast to all the players in the tile (everyone on tile)
   range - broadcast to each tile in [num] radius from tile source (everyone in range)
--]]----------------------------------------------------------------

local setupZone = {}
local zone

function setupZone.move(player, dir)
  zone.type = 'self'
end

function setupZone.attack(player, target, weapon, inv_ID)
  zone.player = player
  if target:getClassName() == 'player' then 
    zone.type = 'pair'
    zone.target = target
  else 
    zone.type = 'self' 
  end  
end

function setupZone.enter(player)
  zone.type = 'self'  
end

function setupZone.exit(player)
  zone.type = 'self'  
end

---------------------------------------
---------------------------------------
--              HUMAN                --
---------------------------------------
---------------------------------------

function setupZone.search(player)
  zone.type = 'self'  
end

function setupZone.discard(player, inv_ID)
  zone.type = 'self'  
end

function setupZone.barricade(player)
  zone.type = 'self'  
end

function setupZone.speak(player, message) -- , target)
  zone.player = player
  zone.type = 'stage'
  zone.stage = player:getStage()
  zone.tile = player:getTile()  
end

function setupZone.syringe(player, inv_ID, target)
  zone.player = player
  zone.type = 'pair'
  zone.target = target
end

function setupZone.leather(player, inv_ID)
  zone.type = 'self'
end

---------------------------------------
---------------------------------------
--             ZOMBIE                --
---------------------------------------
---------------------------------------


function setupZone.respawn(player) 
  zone.type = 'stage'
  zone.stage = player:getStage()
  zone.tile = player:getTile()
  zone.player = player
end

local GROAN_MAX_RANGE = 6
local GROAN_DENOMINATOR = 3

function setupZone.groan(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  local groan_range = math.floor(human_n/GROAN_DENOMINATOR + 0.5)
  zone.player = player  
  zone.type = 'area'
  zone.tile = player:getTile()
  zone.range = math.min(groan_range, GROAN_MAX_RANGE) 
end

function setupZone.gesture(player)
  zone.player = player  
  zone.type = 'stage'
  zone.stage = player:getStage()
  zone.tile = player:getTile()
end

function setupZone.drag_prey(player, target)
  zone.player = player
  zone.target = target
  zone.type = 'tile'
  zone.tile = player:getTile()
end

function setupZone.feed(player)
  zone.player = player
  zone.type = 'stage'
  zone.stage = player:getStage()
  zone.tile = player:getTile()
end

function setupZone.armor(player)
  zone.type = 'self'
end

function setupZone.track(player)
  zone.player = player
  zone.type = 'stage'
  zone.stage = player:getStage()
  zone.tile = player:getTile()
end

function setupZone.acid(player, target)
  zone.player = player
  zone.type = 'pair'
  zone.target = target 
end

---------------------------------------
---------------------------------------
--         JUST A DIVIDER            --
---------------------------------------
---------------------------------------

local function getZone(action, player, ...) 
  zone = {}
  setupZone[action](player, ...)
  if zone.type == 'self' then zone.player = player end
  return zone
end

return getZone
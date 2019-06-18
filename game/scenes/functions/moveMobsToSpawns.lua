local lume = require('code.libs.lume')
local MOVEMENT_DELAY = 500

-- map is the display map, tile is the code map, and stage is inside/outside
function moveMobsToSpawns(map, tile, stage)
  -- setup spawn locations
  local defender_spawns = { 
    map:getObjects( {name=stage, type='defender'} ) 
  }
  local attacker_spawns = { 
    map:getObjects( {name=stage, type='attacker'} ) 
  }

  local attacker = tile:getAttacker(stage)
  local defender = tile:getDefender(stage)

  -- enable physics walls that seperates attacker/defenders 
  local dividers = {
    map:getObjects( {name=stage, type='seperator'} )
  }
  for _, divider in ipairs(dividers) do divider:toggle(true) end

  local mobs = {
    map:getObjects( {type='mob'} )
  }

  for _, mob in ipairs(mobs) do
    if mob.player:isStanding() then
      local spawns           
      if mob.player:isMobType(attacker) then spawns = attacker_spawns  
      elseif mob.player:isMobType(defender) then spawns = defender_spawns
      end

      local spawn = lume.randomchoice(spawns)
      movement_options = {
        delay = MOVEMENT_DELAY,
        onComplete = function() 
          mob:resumePhysics()
          mob:resetLastPosition()
        end,
      }

      mob:moveTo(spawn, movement_options)
    end
  end

  -- profit?  reeee!  :P 
end

return moveMobsToSpawns
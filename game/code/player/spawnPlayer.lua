local Zombie = require('code.player.zombie.zombie')
local Human = require('code.player.human.human')

-- mob_type, username, and cosmetics should all be optional
-- map is required?  y/x is required?
function spawnPlayer(mob_type, username, map, y, x)
  local player 

  if mob_type == 'zombie' then player = Zombie:new(username, map, y, x)
  elseif mob_type == 'human' then player = Human:new(username, map, y, x)
  end

  return player
end

return spawnPlayer
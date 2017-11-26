local class = require('code.libs.middleclass')

local entangle = class('entangle')

function entangle:initialize()
  self.grapple, self.impale = false, false  
end

function entangle:remove()
  local tangled_player = self.grapple
  if tangled_player then
    self.grapple, self.impale = false, false
    tangled_player.condition.entangle.grapple, tangled_player.condition.entangle.impale = false, false
  end
end

function entangle:isActive()
  return (self.grapple and true) or false
end

function entangle:isImpaleActive() return self.impale end

-- Below are functions to be called from module itself, not player.condition.entangle

function entangle.isTangledTogether(player_a, player_b)
  local grapple_a, grapple_b = player_a.condition.entangle.grapple, player_b.condition.entangle.grapple
  return grapple_a == player_b and grapple_b == player_a
end

function entangle.add(player_a, player_b, impale_bonus)
  player_a.condition.entangle.grapple, player_b.condition.entangle.grapple = player_b, player_a
  player_a.condition.entangle.impale = player_a.condition.entangle.impale or impale_bonus
end

return entangle
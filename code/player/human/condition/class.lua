local class = require('code.libs.middleclass')
local infection = require('code.player.human.condition.infection')
local entangle = require('code.player.human.condition.entangle')
local tracking = require('code.player.human.condition.tracking')

-- poison|infection  confusion|blindness|sickness
-- burn|delimbed|decayed|beheaded|maimed

local condition = class('condition')

function condition:initialize(player)
  --[[
  self.infection = infection:new()
  self.entangle = entangle:new()
  self.tracking = tracking:new(player)
  --]]
end

function condition:isActive(effect)  
  return self[effect]:isActive()
end

local condition_list = {
  human = {'infection'},
  zombie = {'burn', 'decay'},
  -- tracking:elapse() is used ONLY during server ticks, not during players actions
}

function condition:elapse(player, ap)
  local mob_type = player:getMobType()
  for _, status in ipairs(condition_list[mob_type]) do
    self[status]:elapse(player, ap)
  end
end

return condition
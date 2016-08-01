local class = require('code.libs.middleclass')
local poison = require('code.player.condition.poison')
local infection = require('code.player.condition.infection')
local burn = require('code.player.condition.burn')
local decay = require('code.player.condition.decay')
local entangle = require('code.player.condition.entangle')
local tracking = require('code.player.condition.tracking')

-- poison|infection  confusion|blindness|sickness
-- burn|delimbed|decayed|beheaded|maimed

local condition = class('condition')

function condition:initialize(player)
  if player:isMobType('human') then
    -- insert status conditions?
    self.poison = poison:new()
    self.infection = infection:new()
  elseif player:isMobType('zombie') then
    self.burn = burn:new()
    self.decay = decay:new()
  end
  
  self.entangle = entangle:new()
  self.tracking = tracking:new()
end

function condition:isActive(effect)  
  return self[effect]:isActive()
end

local condition_list = {
  human = {'poison', 'infection'},
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
local class =                     require('code.libs.middleclass')

local StatusEffect = class('StatusEffect')

StatusEffect.zombie = {'entangle', 'track', 'maime', 'burn'}
StatusEffect.human =  {'entangle', 'track', 'maime', 'infection'}


function StatusEffect:initialize(player)
  self.player = player
end

function StatusEffect:add(effect, ...) self[effect] = Condition[effect]:new(...) end

function StatusEffect:remove(effect) self[effect] = nil end

function StatusEffect:isActive(effect) return self[effect] end

function StatusEffect:elapse(ap)
  local mob_type = self.player:getMobType()
  for _, effect in ipairs(self[mob_type]) do
    if self[effect] then self[effect]:elapse(player, ap) end
  end
end

return StatusEffect
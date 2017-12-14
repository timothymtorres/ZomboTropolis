local class = require('code.libs.middleclass')
local zombie_effects = require('code.player.zombie.status_effect.effects')
local human_effects = require('code.player.human.status_effect.effects')

local StatusEffect = class('StatusEffect')

StatusEffect.zombie = zombie_effects
StatusEffect.human =  human_effects

function StatusEffect:initialize(player)
  self.player = player
end

function StatusEffect:add(effect, ...) 
  local mob_type = self.player:getMobType()
  self[effect] = StatusEffect[mob_type][effect]:new(self.player, ...)
end

function StatusEffect:remove(effect) self[effect] = nil end

function StatusEffect:isActive(effect) return self[effect] end

function StatusEffect:elapse(ap)
  local mob_type = self.player:getMobType()
  for _, effect_class in ipairs(StatusEffect[mob_type]) do
  	local effect = string.lower(effect_class.name)    -- Because the class is capitalized, we have to hack it lowercase
    if self[effect] then self[effect.name]:elapse(player, ap) end
  end
end

return StatusEffect
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
  local Effect = effect:sub(1,1):upper()..effect:sub(2) -- capitalize effect
  self[effect] = StatusEffect[mob_type][Effect]:new(self.player, ...)
end

function StatusEffect:remove(effect) 
	if self[effect].remove then self[effect]:remove() end
  self[effect] = nil 
end

function StatusEffect:isActive(effect) return self[effect] end

function StatusEffect:elapse(ap)
  local mob_type = self.player:getMobType()
  for _, Effect in ipairs(StatusEffect[mob_type]) do
  	local effect = string.lower(Effect.name)    -- lowercase the class name
    if self[effect] and self[effect].elapse then self[effect]:elapse(player, ap) end
  end
end

return StatusEffect
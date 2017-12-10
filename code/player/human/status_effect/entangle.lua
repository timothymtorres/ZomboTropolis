local class = require('code.libs.middleclass')

local Entangle = class('Entangle')

function Entangle:initialize(player, target)
  self.player = player
  self.tangled_player = target

  target.status_effect:add('entangle', player)
end

function Entangle:getTangledPlayer() return self.tangled_player end

function Entangle:remove()
  local target = self.tangled_player -- mob tangled to player
  local player = self.player

  target.status_effect:remove('entangle')
  player.status_effect:remove('entangle')  
end

return Entangle
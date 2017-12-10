local class = require('code.libs.middleclass')

local entangle = class('entangle')

function entangle:initialize(player)
  self.player = player
  self.grapple = false  
end

function entangle:remove()
  local tangled_player = self.grapple
  if tangled_player then
    self.grapple = false
    tangled_player.condition.entangle.grapple = false
  end
end

function entangle:isActive()
  return (self.grapple and true) or false
end

function entangle:add(target)
  self.grapple = target
  target.condition.entangle.grapple = self.player
end

return entangle
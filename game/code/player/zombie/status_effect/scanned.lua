local class = require('code.libs.middleclass')

local Scanned = class('Scanned')

function Scanned:initialize(player)
  self.player = player
  local map = player:getMap()
  map.terminal_network:add(player)
end

function Scanned:remove()
  local map = self.player:getMap()
  map.terminal_network:remove(self.player)
end

return Scanned
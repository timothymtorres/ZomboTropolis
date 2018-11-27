local Map = require('code.location.map')
local Items = require('code.item.items')  -- for testing item generation in main.lua
local Zombie = require('code.player.zombie.zombie')
local Human = require('code.player.human.human')

local dummy = {}
city = Map:new(40)
local y, x = 20, 5   --19,34

main_player = Zombie:new(nil, city, y, x)
alt_player = Human:new(nil, city, y, x)

for i=1, 100 do
  dummy[i] = Zombie:new(nil, city, y, x)
  dummy[i].stats:update('hp', -100)
end

p_tile = alt_player:getTile()

p_tile.barricade.potential_hp = 28 
p_tile.barricade.hp = 20
p_tile.barricade:updateHP(1)

p_tile:install('generator', 4)
p_tile:install('transmitter', 4)
p_tile:install('terminal', 4)
p_tile.equipment.generator:refuel()
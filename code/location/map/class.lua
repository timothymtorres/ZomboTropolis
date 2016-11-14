local class = require('code.libs.middleclass')
-- local suburb = require('suburb')
local tile =         require('code.location.tile.class')
local building =     require('code.location.building.class')
local b_list =       require('code.location.building.list')

local map = class('map')

-- make sure to set this up properly!
local tile_type = 'hospital'

function map:initialize(size)
  self.humans = 0
  self.zombies = 0
  self.dead = 0

  local size = size or 1
  
  for y=1, size do
    self[y] = {}
    for x=1, size do
            
      self[y][x] = building[tile_type]:new(self, y, x, '[insert name]')
    end
  end
end

function map:getInside(y, x) return self[y][x].inside_players or false end 
 
function map:getOutside(y, x) return self[y][x].outside_players end

function map:getTile(y, x) return self[y][x] end

function map:isBuilding(y, x) return self[y][x].inside_players and true or false end

function map:get3x3(y, x)
  local list = {}
  list[#list+1] = self[y][x]
  list[#list+1] = self[y][x+1]
  list[#list+1] = self[y][x-1]  
  list[#list+1] = self[y+1] and self[y+1][x] or nil
  list[#list+1] = self[y+1] and self[y+1][x+1] or nil
  list[#list+1] = self[y+1] and self[y+1][x-1] or nil
  list[#list+1] = self[y-1] and self[y-1][x] or nil
  list[#list+1] = self[y-1] and self[y-1][x+1] or nil
  list[#list+1] = self[y-1] and self[y-1][x-1] or nil
  return list
end

return map
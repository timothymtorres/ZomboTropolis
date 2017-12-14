local class = require('code.libs.middleclass')
local Tile = require('code.location.tile.tile')
-- local suburb = require('suburb')

local Map = class('Map')

-- make sure to set this up properly!
local tile_type = 'Hospital'

function Map:initialize(size)
  self.humans = 0
  self.zombies = 0
  self.dead = 0

  local size = size or 1
  
  for y=1, size do
    self[y] = {}
    for x=1, size do
            
      self[y][x] = Tile[tile_type]:new(self, y, x, '[insert name]')
    end
  end
end

function Map:getInside(y, x) return self[y][x].inside_players or false end 
 
function Map:getOutside(y, x) return self[y][x].outside_players end

function Map:getTile(y, x) return self[y][x] end

function Map:isBuilding(y, x) return self[y][x].inside_players and true or false end

function Map:get3x3(y, x)
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

return Map
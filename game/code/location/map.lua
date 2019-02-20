local class = require('code.libs.middleclass')
local Tiles = require('code.location.tile.tiles')
local TerminalNetwork = require('code.location.terminal_network')
local berry = require( 'code.libs.berry' )
-- local suburb = require('suburb')

local Map = class('Map')

-- we sure we ONLY CREATE map once and make it a global and pass it around from file to file
local filename = "graphics/map/world.json"
local world = berry:new( filename, "graphics/map" )

local tile_offset = world.background_tile_offset -- this is how many tiles surround the world in all directions (background)
local world_width = world.dim.width
local layer = world:getLayer("Location ID")
local tileset_gid = world.tilesets["Tile ID"].firstgid

function Map:initialize(size)
  self.humans = 0
  self.zombies = 0
  self.dead = 0
  self.terminal_network = TerminalNetwork:new(size)

  local size = size or 1
  
  for y=1, size do
    self[y] = {}
    for x=1, size do
      local tile_pos = x + ((y - 1) * world_width)
      local tile_gid = layer.data[tile_pos] + 1  -- need to add a + 1 to count from 1 instead of zero
      local tile_not_exist = tile_gid == 1 
      local tile_id

      if tile_not_exist then 
        tile_id = 1  -- default to first id (which is land right now)
      else 
        tile_id = tile_gid - tileset_gid 
      end

--print(tile_layer.data.data[tile_pos], tileset_gid, tile_id)

      self[y][x] = Tiles[tile_id]:new(self, y, x, '[insert name]')
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
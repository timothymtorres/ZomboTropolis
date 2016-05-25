local class = require('code.libs.middleclass')
local t_list = require('code.location.tile.list')
local b_list = require('code.location.building.list')
--local building = require('code.location.building.class')
local item = require('code.item.class')
local lookupItem = require('code.item.search')
local dice = require('code.libs.rl-dice.dice')

local tile = class('tile')
--local building = class(building, tile)

function tile:initialize(map, y, x, name)
  self.y, self.x = y, x
  self.outside_players = {}
  self.name = name
  self.map_zone = map
end

function tile:insert(player) self.outside_players[player] = player end

function tile:remove(player) self.outside_players[player] = nil end

function tile:listen(speaker, message) --, setting)
  for _, player in pairs(self.outside_players) do player:listen(speaker, message) end
  if self:isBuilding() then
    for _, player in pairs(self.outside_players) do player:listen(speaker, message) end
  end
  
  --[[  add this later for the whisper feature
  if setting == 'outside' or setting == nil then
    for _, player in pairs(self.outside_players) do player:listen(speaker, message) end
  elseif setting == 'inside' then
    for _, player in pairs(self.outside_players) do player:listen(speaker, message) end
  end
  --]]
end

function tile:check(player, setting)
  local attendance
  if setting == 'outside' or setting == nil then attendance = self.outside_players[player]
  elseif setting == 'inside' and self:isBuilding() then attendance = self.inside_players[player] 
  end  
  return (attendance and true) or false
end

function tile:countPlayers(mob_type, setting)
  local players
  
  if setting == 'outside' then players = self.outside_players 
  elseif setting == 'inside' then players = self.inside_players
  else error('player setting count wrong')
  end
  
  local count = 0
  for player in pairs(players) do
    if (mob_type == 'all' or player:isMobType(mob_type) ) and player:isStanding() then 
      count = count + 1
    end
  end
  return count
end

function tile:countCorpses(setting)
  local players 
  if setting == 'outside' then players = self.outside_players
  elseif setting == 'inside' then players = self.inside_players 
  else error('player setting count bodies wrong')  
  end
  
  local count = 0
  for player in pairs(players) do
    if not player:isStanding() then count = count + 1 end
  end
  return count
end

function tile:getClass() return self.class end

function tile:getClassName() return tostring(self.class) end

function tile:getName() return self.name end

function tile:getMap() return self.map_zone end

function tile:getPos() return self.y, self.x end

function tile:getState()  -- update later for ruins
  local state
  if self:isBuilding() and self:isPowered() then 
    state = 'powered'
  else 
    state = 'unpowered' 
  end
  return state
end

function tile:getDesc(setting)
  local str, desc
  
  if not setting or setting == 'external' then
    desc = self.external_desc
    
    if not self:isBuilding() then  -- no building external desc
      str = 'You are at '..self:getName()..'.'
    else -- outside building external desc
      local adjective, color = (desc.adjective and ' '..desc.adjective) or '', (desc.color and ' '..desc.color) or ''
      local material = ' '..desc.material..' building'
      local details, surroundings = (desc.details and ' with '..desc.details) or '', (desc.surroundings and ' '..desc.surroundings) or ''
      str = 'You are standing outside the '..self:getName()..' '..self:getClassName()..', a'..adjective..color..material..details..surroundings..'.'   
    end
  elseif setting == 'internal' and self:isBuilding() then
    str = 'You are standing inside the '..self:getName() 
    
    if self:isDescPresent('powered_desc') and self:isPowered() then -- inside building powered desc
      desc = self.powered_desc
      if desc:sub(1, 3) == '...' then str = str..','
      else str = str..'. ' end
    elseif self:isDescPresent('internal_desc') then     -- inside building unpowered desc
      desc = self.internal_desc
      if desc:sub(1, 3) == '...' then str = str..','
      else str = str..'. ' end  
    else
      desc = ''
    end
    
    str = str..desc..'.'    
  end

  return str
end

--function tile:getTileType() return self.tile_type end

function tile:getSearchOdds(setting) return (setting and self.search_odds[setting]) or self.search_odds.outside end

function tile:getPlayers(setting) 
  local players
  if setting == 'inside' then 
    players = self.inside_players
  elseif not setting or setting == 'outside' then
    players = self.outside_players
  elseif setting == 'all' then
    players = {}
    for k,v in pairs(self.inside_players) do players[k] = v end
    for k,v in pairs(self.outside_players) do players[k] = v end
  end
  return players 
end

function tile:isBuilding() return self.inside_players and true or false end

function tile:isClass(tile_class) return self:getClassName() == tile_class end

local function select_item(list)
  local chance, total = math.random(), 0

  for item, odds in pairs(list) do
    total = total + odds
    if chance <= total then return item end
  end
end

function tile:search(setting)
  local odds = self:getSearchOdds(setting)
print('odds are:', odds)
print('setting is:', setting)
  local search_success = dice.chance(odds)
  
  if not search_success then return false end
  
  local items = self.item_chance 
  local item_type = select_item(items)
  local location_state = self:getState()
print('tile:search - ', item_type)
print('location_state - ', location_state)
  local item_INST = item[item_type]:new(location_state) 
  
-- DO WE NEED THIS?!
--local item = lookupItem(item_name)   -- do we need item[#ID] or item class?
  
  return item_INST
end


function tile:dataToClass(...) -- this should be a middleclass function (fix later)
  local combined_lists = {...}
  for _, list in ipairs(combined_lists) do
    for obj in pairs(list) do
      self[obj] = class(obj, self)
      self[obj].initialize = function(self_subclass, location_condition)
        self.initialize(self_subclass, location_condition)
      end
      for field, data in pairs(list[obj]) do self[obj][field] = data end
    end
  end
end

-- turn our list of tiles into tile class
tile:dataToClass(t_list)

return tile
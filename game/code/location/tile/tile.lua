local class = require('code.libs.middleclass')
local Items = require('code.item.items')
local broadcastEvent = require('code.server.event')

local Tile = class('Tile')

local OUTSIDE_SEARCH_ODDS = .50

Tile.search_chance = {outside=OUTSIDE_SEARCH_ODDS}
Tile.item_chance = {}
Tile.item_chance.outside = {
  -- WEAPONS =  00.1%
  Knife = .001,

  -- MISC   =  09.9%
  Newspaper = .099,

  -- EQUIPMENT =  90%
  Barricade = .90,
}

function Tile:initialize(map, y, x, name)
  self.y, self.x = y, x
  self.outside_players = {}
  self.name = name
  self.map_zone = map
end

Tile.broadcastEvent = broadcastEvent.tile

function Tile:insert(player) self.outside_players[player] = true end

function Tile:remove(player) self.outside_players[player] = nil end

function Tile:check(player, setting)
  local attendance
  if setting == 'outside' or setting == nil then attendance = self.outside_players[player]
  elseif setting == 'inside' and self:isBuilding() then attendance = self.inside_players[player] 
  end  
  return (attendance and true) or false
end

function Tile:countPlayers(mob_type, setting, filter)
  local players
  
  if setting == 'outside' then players = self.outside_players 
  elseif setting == 'inside' then players = self.inside_players
  else error('player setting count wrong')
  end
  
  local count = 0
  for player in pairs(players) do
    if (mob_type == 'all' or player:isMobType(mob_type) ) and player:isStanding() and not player.status_effect:isActive('hide') then 
      if filter and filter == 'wounded' then 
        if player.stats:get('vitality') ~= 4 then count = count + 1 end
      else     
        count = count + 1
      end
    end
  end
  return count
end

function Tile:countCorpses(setting)
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

function Tile:getMap() return self.map_zone end

function Tile:getPos() return self.y, self.x end

function Tile:getIntegrity()
  if self:isBuilding() then return self.integrity:getState()
  else return 'intact'
  end
end

function Tile:getPlayers(setting, filter) 
  local players
  if setting == 'inside' then 
    players = self.inside_players
  elseif setting == 'outside' then
    players = self.outside_players
  elseif not setting then -- get all players
    players = {}
    if self.inside_players then 
      for player in pairs(self.inside_players) do players[player] = true end
    end
    for player in pairs(self.outside_players) do players[player] = true end
  end

  if filter then
    for player in pairs(players) do
      if not player.status_effect:isActive(filter) then players[player] = nil end
    end
  end

  return next(players) and players or nil 
end

function Tile:getCorpses(setting)
  local corpses, players = {}

  if setting == 'outside' then players = self.outside_players
  elseif setting == 'inside' then players = self.inside_players 
  else error('Tile:getCorpses setting arg not present')  
  end
  
  for player in pairs(players) do
    if not player:isStanding() then corpses[#corpses+1] = player end
  end  
  
  return next(corpses) and corpses or nil 
end

function Tile:isIntegrity(setting)
  if self:isBuilding() then return self.integrity:getState() == setting 
  else return 'intact' == setting 
  end
end

function Tile:isBuilding() return self.inside_players and true or false end

local modifier = {
  building_condition = {ruined = -0.90, ransacked = -0.20, intact = 0.00},
  search_lighting = {flashlight = 0.05, generator = 0.10, power_plant = 0.20},  
  looting_skill = 0.05,
}

function Tile:getSearchOdds(player, setting, integrity_status, was_flashlight_used) 
print(self)
print(table.inspect(self, {depth=2}))
print('-----------')
print(table.inspect(self.search_odds))

  local search_chance = (setting and self.search_odds[setting]) or self.search_odds.outside 
  
  local condition_bonus = modifier.building_condition[integrity_status]
  local skill_bonus, lighting_bonus = 0, 0 
  
  --if integrity_status == 'intact' and self:isPowered('with power plant') then    
  if self:isPowered() then  -- isPowered() only checks for powered generator currently
    lighting_bonus = modifier.search_lighting.generator
  elseif was_flashlight_used then
    lighting_bonus = modifier.search_lighting.flashlight
  end
    
  skill_bonus = player.skills:check('looting') and modifier.looting_skill or 0
  
  local modifier_sum = condition_bonus + skill_bonus + lighting_bonus
  return search_chance + (search_chance * modifier_sum)
end

local function select_item(list)
  local chance, total = math.random(), 0

  for item_str, odds in pairs(list) do
    total = total + odds
    if chance <= total then return item_str end
  end
end

function Tile:search(player, setting, was_flashlight_used)
  local integrity_state = self:getIntegrity()  
  
  local odds = self:getSearchOdds(player, setting, integrity_state, was_flashlight_used)
  local search_success = odds >= math.random()
  
  if not search_success then return false end

  local hidden_players = self:getPlayers(setting, 'hide')

  if hidden_players then
    return next(hidden_players) -- probably should shuffle and randomly select player instead of using next()
  else
    local tile_item_list = self.item_chance[setting] 
    local selected_item_type = select_item(tile_item_list)
    
    local item = Items[selected_item_type]:new(integrity_state) 
    return item
  end
end

function Tile:__tostring() return self.name..' '..self.class.name end

return Tile
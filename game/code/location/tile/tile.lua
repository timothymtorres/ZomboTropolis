local class = require('code.libs.middleclass')
local Server = require('code.server.server')
local Items = require('code.item.items')
local broadcastEvent = require('code.server.event')
local lume = require('code.libs.lume')
local sqlite3 = require('sqlite3')

local Tile = class('Tile')

function Tile:initialize(map, x, y, z, name)
  self.x, self.y, self.z = x, y, z
  self.outside_players = {}
  self.name = name
  self.map = map

  -- initialize our sqlite data
  local path = system.pathForFile("code/server/data.db")
  local db = sqlite3.open(path)
  local tile_sql = db:prepare[[
    INSERT INTO location(tile_id, map, x, y, z, name)
    VALUES ($tile_id, $map, $x, $y, $z, $name);
  ]]

  tile_sql:bind_values(self.ID, map, x, y, z, name)
  tile_sql:step()
  tile_sql:finalize()
end

Tile.broadcastEvent = broadcastEvent.tile

function Tile:insert(player) self.outside_players[player] = true end

function Tile:remove(player) self.outside_players[player] = nil end

function Tile:check(player, stage)
  local attendance
  if stage == 'outside' or stage == nil then attendance = self.outside_players[player]
  elseif stage == 'inside' and self:isBuilding() then attendance = self.inside_players[player]
  end
  return (attendance and true) or false
end

function Tile:countPlayers(mob_type, stage, filter)
  local players

  if stage == 'outside' then players = self.outside_players
  elseif stage == 'inside' then players = self.inside_players
  else error('player stage count wrong')
  end

  local count = 0
  for player in pairs(players) do
    if (mob_type == 'all' or player:isMobType(mob_type) ) and player:isStanding() and not player.status_effect:isActive('hide') then
      if filter and filter == 'wounded' then -- this filter is for scent_blood to see wounded survivors in buildings from outside
        local biosuit_resistance = player.armor:isPresent() and player.armor:getProtection('bio') or 0
        local biosuit_hide_wound = biosuit_resistance >= 1
        if player.stats:get('vitality') ~= 4 and not biosuit_hide_wound then count = count + 1 end
      else
        count = count + 1
      end
    end
  end
  return count
end

function Tile:countCorpses(stage)
  local players
  if stage == 'outside' then players = self.outside_players
  elseif stage == 'inside' then players = self.inside_players
  else error('player stage count bodies wrong')
  end

  local count = 0
  for player in pairs(players) do
    if not player:isStanding() then count = count + 1 end
  end
  return count
end

function Tile:getMap() return Server:getMap(self.map) end

function Tile:getPos() return self.x, self.y, self.z end

function Tile:getIntegrity(stage)
  if self:isBuilding() and stage == 'inside' then return self.integrity:getState()
  else return 'intact'
  end
end

function Tile:getPlayers(stage, filter)
  local players = {}

  if stage == 'inside' then
    for player in pairs(self.inside_players) do players[player] = true end
  elseif stage == 'outside' then
    for player in pairs(self.outside_players) do players[player] = true end
  elseif not stage then -- get all players
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

function Tile:getCorpses(stage)
  local corpses, players = {}

  if stage == 'outside' then players = self.outside_players
  elseif stage == 'inside' then players = self.inside_players
  else error('Tile:getCorpses stage arg not present')
  end

  for player in pairs(players) do
    if not player:isStanding() then corpses[#corpses+1] = player end
  end

  return next(corpses) and corpses or nil
end

function Tile:isIntegrity(setting, stage)
  if self:isBuilding() and stage == 'inside' then return self.integrity:getState() == setting
  else return 'intact' == setting
  end
end

function Tile:isBuilding() return self.inside_players and true or false end

local modifier = {
  building_condition = {ruined = -0.90, ransacked = -0.20, intact = 0.00},
  search_lighting = {flashlight = 0.05, generator = 0.10, power_plant = 0.20},
  looting_skill = 0.05,
}

function Tile:getSearchOdds(player, stage, integrity_status, was_flashlight_used)
  local search_chance = (stage and self.search_odds[stage]) or self.search_odds.outside

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

function Tile:search(player, stage, was_flashlight_used)
  local integrity_state = self:getIntegrity(stage)

  local odds = self:getSearchOdds(player, stage, integrity_state, was_flashlight_used)
  local search_success = odds >= math.random()

  if not search_success then return false end

  local hidden_players = self:getPlayers(stage, 'hide')

  if hidden_players then
    return next(hidden_players) -- probably should shuffle and randomly select player instead of using next()
  else
    local item_list = self.item_chance[stage]
    local item_type = lume.weightedchoice(item_list)

    if stage == 'outside' then -- all items outside are usually ruined
      integrity_state = 'ruined'

      if item_type == 'Barricade' then -- except barricades
        integrity_state = 'worn'

        if (self.class.name == 'Junkyard' or self.class.name == 'Carpark') then
          integrity_state = 'pristine' -- barricades found in junkyards/carpool get a bonus and are usually pristine
        end
      end
    end

    local item = Items[item_type]:new(integrity_state)
    return item
  end
end

function Tile:isContested(stage)
  local is_zombies_present = self:countPlayers('zombie', stage) > 0
  local is_humans_present = self:countPlayers('human', stage) > 0
  return is_zombies_present and is_humans_present
end

-- humans are always attackers unless inside an unruined building
function Tile:getAttacker(stage)
  local is_inside_building = self:isBuilding() and stage == 'inside'
  local is_ruined = is_inside_building and self.integrity:isState('ruined')
  return (not is_ruined and 'zombie') or 'human'
end

-- zombies are usually defending except for unruined buildings
function Tile:getDefender(stage)
  local is_inside_building = self:isBuilding() and stage == 'inside'
  local is_ruined = is_inside_building and self.integrity:isState('ruined')
  return (not is_ruined and 'human') or 'zombie'
end

function Tile:__tostring()
  return self.name and (self.name..' '..self.class.name) or self.class.name
end

return Tile

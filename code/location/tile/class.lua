local class =           require('code.libs.middleclass')
local Item =            require('code.item.item')
local broadcastEvent =  require('code.server.event')

local TileBase = class('TileBase')

function TileBase:initialize(map, y, x, name)
  self.y, self.x = y, x
  self.outside_players = {}
  self.name = name
  self.map_zone = map
end

TileBase.broadcastEvent = broadcastEvent.tile

function TileBase:insert(player) self.outside_players[player] = player end

function TileBase:remove(player) self.outside_players[player] = nil end

function TileBase:listen(speaker, message) --, setting)
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

function TileBase:check(player, setting)
  local attendance
  if setting == 'outside' or setting == nil then attendance = self.outside_players[player]
  elseif setting == 'inside' and self:isBuilding() then attendance = self.inside_players[player] 
  end  
  return (attendance and true) or false
end

function TileBase:countPlayers(mob_type, setting)
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

function TileBase:countCorpses(setting)
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

function TileBase:getClass() return self.class end

function TileBase:getClassName() return tostring(self.class) end

function TileBase:getName() return self.name or '' end

function TileBase:getMap() return self.map_zone end

function TileBase:getPos() return self.y, self.x end

function TileBase:getIntegrityState()
  if self:isBuilding() then return self.integrity:getState()
  else return 'intact'
  end
end

function TileBase:getDesc(setting)
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

function TileBase:getPlayers(setting) 
  local players
  if setting == 'inside' then 
    players = self.inside_players
  elseif setting == 'outside' then
    players = self.outside_players
  elseif not setting then -- get all players
    players = {}
    if self.inside_players then 
      for k,v in pairs(self.inside_players) do players[k] = v end
    end
    for k,v in pairs(self.outside_players) do players[k] = v end
  end
  return players 
end

function TileBase:isBuilding() return self.inside_players and true or false end

function TileBase:isClass(tile_class) return self:getClassName() == tile_class end

local modifier = {
  building_condition = {ruined = -0.90, ransacked = -0.20, intact = 0.00},
  search_lighting = {flashlight = 0.05, generator = 0.10, power_plant = 0.20},  
  looting_skill = 0.05,
}

function TileBase:getSearchOdds(player, setting, integrity_status, was_flashlight_used) 
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

function TileBase:search(player, setting, was_flashlight_used)
  local integrity_state = self:getIntegrityState()  
  
  local odds = self:getSearchOdds(player, setting, integrity_state, was_flashlight_used)
  local search_success = odds >= math.random()
  
  if not search_success then return false end

  local tile_item_list = self.item_chance[setting] 
  local selected_item_type = select_item(tile_item_list)
  
  local item = Item[selected_item_type]:new(integrity_state) 
  return item
end

function TileBase:__tostring() return self:getName()..' '..self:getClassName() end

function TileBase:dataToClass(...) -- this should be a middleclass function (fix later)
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

-- turn our list of TileBases into TileBase class
TileBase:dataToClass(t_list)

return TileBase
local class =                   require('code.libs.middleclass')
local action_list =             require('code.player.action.list')
local enzyme_list =             require('code.player.enzyme_list')
local perform =                 require('code.player.action.perform')
local catalogAvailableActions = require('code.player.action.catalog')
local skills =                  require('code.player.skills.class')
local condition =               require('code.player.condition.class')
--local organic_armor =           require('code.player.armor.organic_class')
local Claw, Bite = unpack(require('code.player.organic_weaponry'))
local Player =                  require('code.player.player')

local Zombie = class('Zombie', Player)

local default_EP = 50

function Zombie:initialize(username, mob_type, map_zone, y, x) --add account name
  Player:initialize(username, mob_type, map_zone, y, x)

  self.ep = default_EP
  --self.abilities = abilities:new(self)
  self.skills = skills:new(self)
  self.condition = condition:new(self)
  
  map_zone[y][x]:insert(self)
  --self.armor = organic_armor:new(self)
end

function Zombie:killed() -- cause_of_death arg not needed yet?
  self.hp, self.health_state = 0, {basic=4, advanced=8}  -- reset our hp stats to zero
  self.condition = condition:new(self)
  -- Reset other things?  Like tracking?  Armor? etc.
end

function Zombie:starve()
  -- need to retain all info for the player to see next time they log in
  self:permadeath()   -- deletes zombie instance
end

function Zombie:revive()
  self:updateStat('hp', self:getStat('hp', 'max') ) 
end

--[[
---  TAKE [X]
--]]

function Zombie:perform(action, ...) 
  
end

--[[
--  GET [X]
--]]

function Zombie:getCost(stat, action)
  local mob_type = self:getMobType()
  local action_data = (stat == 'ap' and action_list[mob_type][action]) or (stat == 'ep' and enzyme_list[action])
  local cost = action_data.cost    
  
  if action_data.modifier then -- Modifies cost of action based off of skills
    for skill, modifier in pairs(action_data.modifier) do cost = (self.skills:check(skill) and cost + modifier) or cost end
  end  
  return cost
end

-- client-side functions
function Zombie:getActions(category) return catalogAvailableActions[category](self) end

function Zombie:getWeapons() return {{weapon=Claw}, {weapon=Bite}} end  

function Zombie:getTargets(mode)
  local targets = {}
  
  local p_tile, setting = self:getTile(), self:getStage()
  local all_players = p_tile:getPlayers(setting) -- we need to filter so that it's only humans
  
  for player in pairs(all_players) do 
    if player:isStanding() and player ~= self then targets[#targets+1] = player end
  end 
  
  if p_tile:isBuilding() then
    --[[  Add this at a later time
    if p_tile:isFortified() then targets[#targets+1] = p_tile:getBarrier() end  -- is this right?  (do I need a class instead?)
    if p_tile:isPresent('equipment') then
      for _, machine in ipairs(p_tile:getEquipment()) do targets[#targets+1] = machine end
    end 
    --]]
  end
  
  if mode == 'gesture' then
    local map_zone = self:getMap()
    local y, x = self:getPos()
    for _,tile in ipairs(map_zone:get3x3(y, x)) do targets[#targets+1] = tile end
    local dir = {1, 2, 3, 4, 5, 6, 7, 8}
    for _, direction in ipairs(dir) do targets[#targets+1] = direction end
  end
  
  return targets
end

--[[
-- METAMETHODS
--]]

function Zombie:__tostring() 
  -- if self:isMobType('zombie') then return 'a zombie' 
  return self:getUsername() 
end

return Zombie
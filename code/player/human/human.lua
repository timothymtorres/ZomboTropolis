local class =                   require('code.libs.middleclass')
local action_list =             require('code.player.action.list')
local perform =                 require('code.player.action.perform')
local catalogAvailableActions = require('code.player.action.catalog')
local skills =                  require('code.player.skills.class')
local inventory =               require('code.player.inventory')
local condition =               require('code.player.condition.class')
--local item_armor =              require('code.player.armor.item_class')
local Fist = unpack(require('code.player.organic_weaponry'))
local Player =                  require('code.player.player')

local Human = class('Human', Player)

local default_IP= 0

--Accounts[new_ID] = Human:new(n, t)

function Human:initialize(username, mob_type, map_zone, y, x) --add account name
  Player:initialize(username, mob_type, map_zone, y, x)

  self.ip = default_IP
  self.inventory = inventory:new(self)  -- zombies don't need inventory...
  self.skills = skills:new(self)
  self.condition = condition:new(self)
  
  map_zone[y][x]:insert(self)
  
  --self.armor = item_armor:new(self)
end

function Human:killed()
  -- we need to create a carcass for zombies to feed on, then afterwards create a new Zombie instance from the carcass?
  -- But we need to retain all info for the player to see next time they log in, (so they can witness their gory death)
  self:permadeath()   -- deletes human instance
end

--[[
---  TAKE [X]
--]]

function Human:takeAction(task, ...) perform(task, self, unpack({...})) end

--[[
--  GET [X]
--]]

function Human:getCost(stat, action)
  local mob_type = self:getMobType()
  local action_data = (stat == 'ap' and action_list[mob_type][action]) or (stat == 'ep' and enzyme_list[action])
  local cost = action_data.cost    
  
  if action_data.modifier then -- Modifies cost of action based off of skills
    for skill, modifier in pairs(action_data.modifier) do cost = (self.skills:check(skill) and cost + modifier) or cost end
  end  
  return cost
end

-- client-side functions
function Human:getActions(category) return catalogAvailableActions[category](self) end

function Human:getWeapons()
  local list = {}
  
  if self:isMobType('human') then
    for inv_ID, item in ipairs(self.inventory) do
      if item:isWeapon() then
        list[#list+1] = {weapon=item, inventory_ID=inv_ID}        
      end  
    end
    list[#list+1] = {weapon=Fist} -- organic           
  elseif self:isMobType('zombie') then
    list[#list+1] = {weapon=Claw} -- organic
    list[#list+1] = {weapon=Bite} -- organic
  end
  return list
end  

function Human:getTargets(mode)
  local targets = {}
  
  local p_tile, setting = self:getTile(), self:getStage()
  local all_players = p_tile:getPlayers(setting)
  
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

function Human:__tostring() 
  -- if self:isMobType('zombie') then return 'a zombie' 
  return self:getUsername() 
end

return Human
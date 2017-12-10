local class =                   require('code.libs.middleclass')
local skills =                  require('code.player.skills')
local inventory =               require('code.player.human.inventory')
local condition =               require('code.player.human.condition.class')
--local item_armor =              require('code.player.armor.item_class')
local Fist =                    require('code.player.human.organic_weaponry')
local human_skill_list =        require('code.player.human.skill_list')
local human_action_list =       require('code.player.human.action.action')
local Player =                  require('code.player.player')

local Human = class('Human', Player)

Human.action_list = human_action_list

local default_IP= 0

--Accounts[new_ID] = Human:new(n, t)

function Human:initialize(username, map_zone, y, x) --add account name
  Player:initialize(username, map_zone, y, x)

  self.ip = default_IP
  self.inventory = inventory:new(self)
  self.skills = skills:new(human_skill_list)
  self.condition = condition:new(self)
  
  map_zone[y][x]:insert(self)
  
  --self.armor = item_armor:new(self)
end

function Human:killed()
  -- Corpse:new()   ???
  -- we need to create a carcass for zombies to feed on, then afterwards create a new Zombie instance from the carcass? (pass useful human data as args to corpse)
  -- But we need to retain all info for the player to see next time they log in, (so they can witness their gory death)
  self:permadeath()   -- deletes human instance
end

--[[
---  TAKE [X]
--]]

-- client-side functions

function Human:getWeapons()
  local list = {{weapon=Fist}} -- organic   

  for inv_ID, item in ipairs(self.inventory) do
    if item:isWeapon() then list[#list+1] = {weapon=item, inventory_ID=inv_ID} end  
  end          
  return list
end  

function Human:getTargets(mode)
  local targets = {}
  
  local p_tile, setting = self:getTile(), self:getStage()
  local all_players = p_tile:getPlayers(setting) -- maybe get only zombie targets instead of all?
  
  for player in pairs(all_players) do 
    if player:isStanding() and player ~= self then targets[#targets+1] = player end 
  end 
  
  return targets
end

return Human
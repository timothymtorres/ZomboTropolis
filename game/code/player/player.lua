local class = require('code.libs.middleclass')
local Log = require('code.player.log')
local StatusEffect = require('code.player.status_effect.status_effect')
local broadcastEvent = require('code.server.event')
local catalogAvailableActions = require('code.player.catalog')
local chanceToHit = require('code.player.chanceToHit')
local Equipment = require('code.player.equipment')
local Stats = require('code.player.stats')

local Player = class('Player')

Player.broadcastEvent = broadcastEvent.player
Player.getActions = catalogAvailableActions 
Player.chanceToHit = chanceToHit

--Accounts[new_ID] = Player:new(n, t)

function Player:initialize(map_zone, y, x) --add account name
  self.map_zone = map_zone
  self.y, self.x = y, x
  self.ID = self  
  self.stats = Stats:new(self)
  self.log = Log:new()
  self.status_effect = StatusEffect:new(self)
  self.equipment = Equipment:new(self)

  map_zone[y][x]:insert(self,'inside')  -- remove 'inside' argument later (for testing purposes)
end

function Player:basicCriteria(action_str, ...)
  assert(self.class.action_list[action_str], 'Action cannot be performed by mob')  -- possibly remove this later   
  local ap = self.stats:get('ap')
  local AP_cost = self:getCost('ap', action_str, ...)
  assert(AP_cost, 'action has no ap_cost?')  -- remove this assertion once all actions have been added (will be unneccsary)
  assert(ap >= AP_cost, 'not enough ap for action')
  assert(self:isStanding() or (action_str == 'respawn' and self:isMobType('zombie')), 'Must be standing for action')
end

function Player:canPerform(action_str, ...)
  local ap_verification, ap_error_msg = pcall(self.basicCriteria, self, action_str, ...)
  local action = self.class.action_list[action_str]  
  local verification, error_msg

  if action.client_criteria then verification, error_msg = pcall(action.client_criteria, self, ...)
  else verification = true
  end

  return (ap_verification and verification)
end

function Player:perform(action_str, ...) 
  local ap_verification, ap_error_msg = pcall(self.basicCriteria, self, action_str, ...)
  local action = self.class.action_list[action_str]
  local verification, error_msg

  if action.server_criteria then verification, error_msg = pcall(action.server_criteria, self, ...)
  else verification = true
  end

  local AP_cost, event

  if ap_verification and verification then
    AP_cost = self:getCost('ap', action_str)
    event = action.activate(self, ...)

    self.status_effect:elapse(AP_cost)   
    self.stats:update('ap', -1*AP_cost)
    self.stats:update('xp', AP_cost)
  else -- Houston, we have a problem!
    self.log:insert(ap_error_msg or error_msg)
  end
  --self.stats:update('IP', 1)  -- IP connection hits?  Hmmmm?

  -- why were we returning AP_cost?!?  Hmm.... no idea...
  return event --AP_cost  
end

function Player:permadeath() end -- run code to remove player instance from map

--[[
-- IS [X]
--]]

function Player:isMobType(mob) return string.lower(self.class.name) == mob end

function Player:isStanding() return self.stats:get('hp') > 0 end

function Player:isStaged(setting)  --  isStaged('inside')  or isStaged('outside') 
  local map_zone, y, x = self:getMap(), self:getPos()  
  local tile = map_zone[y][x]
  return tile:check(self, setting)
end

function Player:isSameLocation(target) return (self:getStage() == target:getStage()) and (self:getTile() == target:getTile()) end

function Player:isTangledTogether(target)
  if not self.status_condition:isActive('entangle') or not target.status_condition:isActive('entangle') then return false end

  local mob_tangled_to_player = self.status_condition.entangle:getTangledPlayer() 
  local mob_tangled_to_target = target.status_condition.entangle:getTangledPlayer()

  return mob_tangled_to_player == target and mob_tangled_to_target == self
end

function Player:isHPVisible() return player.skills:check('smell_blood_adv') or player.skills:check('diagnosis_adv') end

function Player:isLocationContested()
  local stage = self:getStage()
  local location = self:getLocation()
  return location:isContested(stage)
end

--[[
--  GET [X]
--]]

function Player:getPos()  return self.y, self.x end

function Player:getMap() return self.map_zone end

function Player:getLocation() return self.map_zone[self.y][self.x] end

function Player:getMobType() return string.lower(self.class.name) end

function Player:getCost(stat, action_str, ID)  -- remove stat from this (it was to differenate between ap/ep a while back)
  local action_data

  if action_str == 'item' then            action_data = self.inventory:getItem(ID)
  elseif action_str == 'equipment' then --action_data =
  elseif action_str == 'ability' then   --action_data =
  else                                    action_data = self.class.action_list[action_str] 
  end

  local cost = action_data[stat].cost
  
  if action_data[stat].modifier then -- Modifies cost of action based off of skills
    for skill, modifier in pairs(action_data[stat].modifier) do cost = (self.skills:check(skill) and cost + modifier) or cost end
  end  
  return cost
end

function Player:getUsername() return self.username end

function Player:getStage() return (self:isStaged('inside') and 'inside') or (self:isStaged('outside') and 'outside') end

function Player:getTile()
  local map_zone = self:getMap()
  local y,x = self:getPos() 
  return map_zone:getTile(y, x)
end

-- this function is used to count zombies, humans, and corpses inside/outside a 3x3 range 
-- zombies with the smell_blood/smell_blood_adv skills get bonus data
function Player:count3x3()
  local map = self.map_zone
  local y,x = self.y, self.x
  local tile_list = map:get3x3(y, x)
  local tile_counts = {}
  local is_staged_outside = self:isStaged('outside')

  for _, tile in ipairs(tile_list) do
    tile_counts[#tile_counts + 1] = {}
    tile_counts[#tile_counts].outside = {humans=0, zombies=0, corpses=0}
    if tile:isBuilding() then tile_counts[#tile_counts].inside = {humans=0, zombies=0, corpses=0} end
  end

  if is_staged_outside then
    for _, tile in ipairs(tile_list) do 
      if tile:isBuilding() and self.skills:check('smell_blood') then 
      end
    end
  else 
    for _, tile in ipairs(tile_list) do
      if self.skills:check('smell_blood') then
        tile_counts.outside.zombies = tile:countPlayers('zombie', 'outside')
        tile_counts.outside.corpses = tile:countCorpses('outside') 
        if self.skills:check('smell_blood_adv') then tile_counts.outside.humans = tile:countPlayers('human', 'outside', 'wounded') end
      end     

    end      
  end

  for i, tile in ipairs(tile_list) do  -- i==1 is the tile the player is located
    if self:isStaged('outside') then
      tile_counts.outside.zombies = tile:countPlayers('zombie', 'outside')
      tile_counts.outside.humans = tile:countPlayers('human', 'outside')
      tile_counts.outside.corpses = tile:countCorpses('outside')      

      if tile:isBuilding() and self.skills:check('smell_blood') then
        tile_counts.inside.zombies = tile:countPlayers('zombie', 'inside')
        tile_counts.inside.corpses = tile:countCorpses('inside')      
        if self.skills:check('smell_blood_adv') then tile_counts.inside.humans = tile:countPlayers('human', 'inside', 'wounded') end
      end
    elseif self:isStaged('inside') then
      if self.skills:check('smell_blood') then
        tile_counts.outside.zombies = tile:countPlayers('zombie', 'outside')
        tile_counts.outside.corpses = tile:countCorpses('outside') 
        if self.skills:check('smell_blood_adv') then 
          tile_counts.outside.humans = tile:countPlayers('human', 'outside', 'wounded') 
          if tile:isBuilding() then tile_counts.inside.humans = tile:countPlayers('human', 'inside', 'wounded') end
        end
      end
    end
  end

  return tile_counts
end

--[[
-- UPDATE [X]
--]]

function Player:updatePos(y, x) self.y, self.x = y, x end

--[[
-- METAMETHODS
--]]

function Player:__tostring() 
  -- if self:isMobType('zombie') then return 'a zombie' 
  return self:getUsername() 
end

return Player
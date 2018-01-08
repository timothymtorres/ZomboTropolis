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

function Player:initialize(username, map_zone, y, x) --add account name
  self.username = username
  self.map_zone = map_zone
  self.y, self.x = y, x
  self.ID = self  
  self.stats = Stats:new(player)
  self.log = Log:new()
  self.status_effect = StatusEffect:new(self)
  self.equipment = Equipment:new(self)

  map_zone[y][x]:insert(self)
end

local function basicCriteria(player, action_str, ...)
  assert(player.class.action_list[action_str], 'Action cannot be performed by mob')  -- possibly remove this later   
  local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action_str, ...)
  assert(AP_cost, 'action has no ap_cost?')  -- remove this assertion once all actions have been added (will be unneccsary)
  assert(ap >= AP_cost, 'not enough ap for action')
  assert(player:isStanding() or (action_str == 'respawn' and player:isMobType('zombie')), 'Must be standing for action')
end

function Player:perform(action_str, ...) 
  local ap_verification, ap_error_msg = pcall(basicCriteria, self, action_str, ...)
  local action = self.class.action_list[action_str]  
  local verification, error_msg = pcall(action.server_criteria, self, ...)

  if ap_verification and verification then
    local ap, AP_cost = self:getStat('ap'), self:getCost('ap', action_str)
    action.activate(self, ...)

    self.status_effect:elapse(AP_cost)   
    self:updateStat('ap', -1*AP_cost)
    self:updateStat('xp', AP_cost)

    if self:isMobType('zombie') then self.hunger:elapse(AP_cost) end -- bit of a hack to put this in here...
  else -- Houston, we have a problem!
    self.log:insert(ap_error_msg or error_msg)
  end
  
  --self:updateStat('IP', 1)  -- IP connection hits?  Hmmmm?
end

function Player:permadeath() end -- run code to remove player instance from map

--[[
-- IS [X]
--]]

function Player:isMobType(mob) return string.lower(self.class.name) == mob end

function Player:isStanding() return self:getStat('hp') > 0 end

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


--[[
--  GET [X]
--]]

function Player:getPos()  return self.y, self.x end

function Player:getMap() return self.map_zone end

function Player:getMobType() return string.lower(self.class.name) end

function Player:getCost(stat, action_str, ID)  -- remove stat from this (it was to differenate between ap/ep a while back)
  local action_data

  if action_str == 'item' then            action_data = self.inventory:lookup(ID)
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
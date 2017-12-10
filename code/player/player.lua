local class =                   require('code.libs.middleclass')
local combat =                  require('code.player.combat')
local Log =                     require('code.player.log')
local StatusEffect =            require('code.player.status_effect')
local broadcastEvent =          require('code.server.event')
local catalogAvailableActions = require('code.player.catalog')

local Player = class('Player')

Player.broadcastEvent = broadcastEvent.player
Player.getActions = catalogAvailableActions 

local default =     {hp=50, ep=50, ip= 0, xp=   0, ap=50}
local default_max = {hp=50, ep=50, ip=50, xp=1000, ap=50}
local skill_bonus = {hp=10, ep=10, ip=10, xp=   0, ap=0}
local bonus_flag_name = {hp='hp_bonus', ip='ip_bonus', ep='ep_bonus', ap=false, xp=false}

--Accounts[new_ID] = Player:new(n, t)

function Player:initialize(username, map_zone, y, x) --add account name
  self.username = username
  self.map_zone = map_zone
  self.y, self.x = y, x
  self.hp, self.xp, self.ap = default.hp, default.xp, default.ap
  self.health_state = {basic=4, advanced=8}
  self.ID = self  
  self.log = Log:new()
  self.status_effect = StatusEffect:new(self)

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
  local ap_verification, ap_error_msg = pcall(basicCriteria, self, ...)
  local action = self.class.action_list[action_str]  
  local verification, error_msg = pcall(action.server_criteria, self, ...)

  if ap_verification and verification and class_verification then
    local ap, AP_cost = self:getStat('ap'), self:getCost('ap', action_str)
    action:activate(self, ...)

    self.status_condition:elapse(AP_cost)   
    self:updateStat('ap', -1*AP_cost)
    self:updateStat('xp', AP_cost)
  else -- Houston, we have a problem!
    self.log:insert(ap_error_msg or class_error_msg or error_msg)
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


local health_state_desc = {
  basic = {'dying', 'wounded', 'scratched', 'full'}, -- 4 states
  advanced = {'dying', 'critical', 'very wounded', 'wounded', 'injuried', 'slightly injuried', 'scratched', 'full'}, -- 8 states
}

function Player:getHealthState(setting)
  local status = self.health_state[setting]
  return health_state_desc[status] 
end

function Player:getCost(stat, action_str, ID)
  local action_data

  if action_str == 'item' then            action_data = self.inventory:lookup(ID)
  elseif action_str == 'equipment' then --action_data =
  elseif action_str == 'ability' then   --action_data =
  else                                    action_data = self.class.action_list[action_str] 
  end

  local cost = action_data[stat].cost
  
  if action_data[stat].modifier then -- Modifies cost of action based off of skills
    for skill, modifier in pairs(action_data[stat].modifier) do cost = (player.skills:check(skill) and cost + modifier) or cost end
  end  
  return cost
end

function Player:getStat(stat, setting)
  if not setting then 
    return self[stat] -- current stat amount
  elseif setting == 'max' then  -- current stat maximum
    if stat ~= 'ap' then
      local bonus_skill_name = bonus_flag_name[stat]
      local bonus_skill_purchased = (bonus_skill_name and self.skills:check(bonus_skill_name)) or false
      return default_max[stat] + (bonus_skill_purchased and skill_bonus[stat] or 0)
    else  -- there is no ap_bonus skill
      return default_max[stat]
    end
  elseif setting == 'default' then -- default starting stat amount
    return default[stat]
  elseif setting == 'bonus' then -- stat's bonus skill amount
    local bonus_skill_name = bonus_flag_name[stat]
    return (bonus_skill_name and skill_bonus[stat]) or 0
  end
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

function Player:updateStat(stat, num)
  local stat_max = self:getStat(stat, 'max')
  self[stat] = math.min(self[stat] + num, stat_max)
  
  if stat == 'hp' then
    if self.hp <= 0 then 
      self.hp = 0
      self:killed()
    else
      -- we add self.hp+1 so that if health_percent == 100% that it puts it slightly over and math.ceil rounds it to the 'full' state 
      local health_percent = self.hp+1/stat_max 
      self.health_basic = math.ceil(health_percent/(1/3))
      self.health_advanced = math.ceil(health_percent/(1/7)) 
    end  
  end
end

--[[
-- METAMETHODS
--]]

function Player:__tostring() 
  -- if self:isMobType('zombie') then return 'a zombie' 
  return self:getUsername() 
end

return Player
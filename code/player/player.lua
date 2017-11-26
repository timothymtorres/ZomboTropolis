local class =                   require('code.libs.middleclass')
local combat =                  require('code.player.combat')
--local perform =                 require('code.player.action.perform')
--local catalogAvailableActions = require('code.player.action.catalog')
local log =                     require('code.player.log.class')
local broadcastEvent =          require('code.server.event')

local Player = class('Player')

local default =     {hp=50, ep=50, ip= 0, xp=   0, ap=50}
local default_max = {hp=50, ep=50, ip=50, xp=1000, ap=50}
local skill_bonus = {hp=10, ep=10, ip=10, xp=   0, ap=0}
local bonus_flag_name = {hp='hp_bonus', ip='ip_bonus', ep='ep_bonus', ap=false, xp=false}

--Accounts[new_ID] = Player:new(n, t)

function Player:initialize(username, mob_type, map_zone, y, x) --add account name
  self.username = username
  self.mob_type = mob_type
  self.map_zone = map_zone
  self.y, self.x = y, x
  self.health_state = {basic=4, advanced=8}
  self.ID = self  
  self.log = log:new()

  map_zone[y][x]:insert(self)
end

-- broadcastEvent whenever player performs an action for others to see
Player.broadcastEvent = broadcastEvent.player

function Player:killed(cause_of_death) 
--[[ scenarios
#1 - human  killed (turns into zombie)  [reset skills, xp, sp]
#2 - zombie killed (decay)              [delete] 
#3 - zombie killed (regular death)      [nothing]
--]]

  self.hp, self.health_state = 0, {basic=4, advanced=8}  -- reset our hp stats to zero

  if self:isMobType('human') then
    self.hp, self.health_state = 0, {basic=4, advanced=8}
    self:updateMobType('zombie')
    self.skills, self.xp = skills:new(self), default.xp        
    self.condition = condition:new(self)
  --elseif cause_of_death == 'syringe' then    cause decay?
  --elseif cause_of_death == 'burns' then     cause decay?
  end
  
  if cause_of_death == 'decay' then self = nil
  else self.carcass:killed(self)
  end  
end

function Player:respawn()
  self:updateStat('hp', self:getStat('hp', 'max') ) 
end

--[[
---  TAKE [X]
--]]

function Player:takeAction(task, ...) perform(task, self, unpack({...})) end

--[[
-- IS [X]
--]]

function Player:isMobType(mob) return self.mob_type == mob end

function Player:isStanding() return self:getStat('hp') > 0 end

function Player:isStaged(setting)  --  isStaged('inside')  or isStaged('outside') 
  local map_zone, y, x = self:getMap(), self:getPos()  
  local tile = map_zone[y][x]
  return tile:check(self, setting)
end

function Player:isSameLocation(target) return (self:getStage() == target:getStage()) and (self:getTile() == target:getTile()) end

--[[
--  GET [X]
--]]

function Player:getID() return self.ID end

function Player:getPos()  return self.y, self.x end

function Player:getMap() return self.map_zone end

function Player:getMobType() return self.mob_type end


local health_state_desc = {
  basic = {'dying', 'wounded', 'scratched', 'full'}, -- 4 states
  advanced = {'dying', 'critical', 'very wounded', 'wounded', 'injuried', 'slightly injuried', 'scratched', 'full'}, -- 8 states
}

function Player:getHealthState(setting)
  local status = self.health_state[setting]
  return health_state_desc[status] 
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

function Player:getClass() return self.class end

function Player:getClassName() return tostring(self.class) end

function Player:getUsername() return self.username end

--function Player:getAccountName() return self.account_name end

function Player:getStage() return (self:isStaged('inside') and 'inside') or (self:isStaged('outside') and 'outside') end

function Player:getTile()
  local map_zone = self:getMap()
  local y,x = self:getPos() 
  return map_zone:getTile(y, x)
end

function Player:getCost(stat, action)
  local mob_type = self:getMobType()
  local action_data = (stat == 'ap' and action_list[mob_type][action]) or (stat == 'ep' and enzyme_list[action])
  local cost = action_data.cost    
  
  if action_data.modifier then -- Modifies cost of action based off of skills
    for skill, modifier in pairs(action_data.modifier) do cost = (self.skills:check(skill) and cost + modifier) or cost end
  end  
  return cost
end

-- client-side functions
function Player:getActions(category) return catalogAvailableActions[category](self) end

--[[
-- UPDATE [X]
--]]

function Player:updateMobType(mob_class) self.mob_type = mob_class end

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
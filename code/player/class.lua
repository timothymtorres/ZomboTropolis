local class =                   require('code.libs.middleclass')
local combat =                  require('code.player.combat')
local action_list =             require('code.player.action.list')
local enzyme_list =             require('code.player.enzyme_list')
local perform =                 require('code.player.action.perform')
local catalogAvailableActions = require('code.player.action.catalog')
local skills =                  require('code.player.skills.class')
local inventory =               require('code.player.inventory')
local log =                     require('code.player.log.class')
local condition =               require('code.player.condition.class')
local carcass =                 require('code.player.carcass')
local organic_armor =           require('code.player.armor.organic_class')
local item_armor =              require('code.player.armor.item_class')
local Fist, Claw, Bite = unpack(require('code.player.organic_weaponry'))
local Map =                     require('code.location.map')
local broadcastEvent =          require('code.server.event')

local player = class('player')

local default =     {hp=50, ep=50, ip= 0, xp=   0, ap=50}
local default_max = {hp=50, ep=50, ip=50, xp=1000, ap=50}
local skill_bonus = {hp=10, ep=10, ip=10, xp=   0, ap=0}
local bonus_flag_name = {hp='hp_bonus', ip='ip_bonus', ep='ep_bonus', ap=false, xp=false}

--Accounts[new_ID] = player:new(n, t)

function player:initialize(username, mob_type, map_zone, y, x) --add account name
  self.username = username
  self.map_zone = map_zone
  self.y, self.x = y, x
  self.xp, self.hp, self.ap, self.ip, self.ep = default.xp, default.hp, default.ap, default.ip, default.ep
  self.health_state = {basic=4, advanced=8}
  self.ID = self
  self.mob_type = mob_type -- zombie or human  
  self.log = log:new()
  self.inventory = inventory:new(self)  -- zombies don't need inventory...
  self.skills = skills:new(self)
  self.condition = condition:new(self)
  self.carcass = carcass:new(self)
  
  map_zone[y][x]:insert(self)
  
  if mob_type == 'human' then self.armor = item_armor:new(self)
  elseif mob_type == 'zombie' then self.armor = organic_armor:new(self)
  end
end

-- broadcastEvent whenever player performs an action for others to see
player.broadcastEvent = broadcastEvent.player

function player:killed(cause_of_death) 
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

function player:respawn()
  self:updateStat('hp', self:getStat('hp', 'max') ) 
end

function player:listen(speaker, message)
print(self:getUsername()..':listen()', speaker:getUsername()..': "'..message..'"')
  -- when we setup our event system
  -- self.eventlog:insert(speaker, message) 
end

--[[
---  TAKE [X]
--]]

function player:takeAction(task, ...) perform(task, self, unpack({...})) end

--[[
-- IS [X]
--]]

function player:isMobType(mob) return self.mob_type == mob end

function player:isStanding() return self:getStat('hp') > 0 end

function player:isStaged(setting)  --  isStaged('inside')  or isStaged('outside') 
  local map_zone, y, x = self:getMap(), self:getPos()  
  local tile = map_zone[y][x]
  return tile:check(self, setting)
end

function player:isSameLocation(target) return (player:getStage() == target:getStage()) and (player:getTile() == target:getTile()) end

--[[
--  GET [X]
--]]

function player:getID() return self.ID end

function player:getPos()  return self.y, self.x end

function player:getMap() return self.map_zone end

function player:getMobType() return self.mob_type end


local health_state_desc = {
  basic = {'dying', 'wounded', 'scratched', 'full'}, -- 4 states
  advanced = {'dying', 'critical', 'very wounded', 'wounded', 'injuried', 'slightly injuried', 'scratched', 'full'}, -- 8 states
}

function player:getHealthState(setting)
  local status = self.health_state[setting]
  return health_state_desc[status] 
end

function player:getStat(stat, setting)
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

function player:getClass() return self.class end

function player:getClassName() return tostring(self.class) end

function player:getUsername() return self.username end

--function player:getAccountName() return self.account_name end

function player:getStage() return (self:isStaged('inside') and 'inside') or (self:isStaged('outside') and 'outside') end

function player:getTile()
  local map_zone = self:getMap()
  local y,x = self:getPos() 
  return map_zone:getTile(y, x)
end

function player:getCost(stat, action)
  local mob_type = self:getMobType()
  local action_data = (stat == 'ap' and action_list[mob_type][action]) or (stat == 'ep' and enzyme_list[action])
  local cost = action_data.cost    
  
  if action_data.modifier then -- Modifies cost of action based off of skills
    for skill, modifier in pairs(action_data.modifier) do cost = (self.skills:check(skill) and cost + modifier) or cost end
  end  
  return cost
end

-- client-side functions
function player:getActions(category) return catalogAvailableActions[category](self) end

function player:getWeapons()
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

function player:getTargets(mode)
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
-- UPDATE [X]
--]]

function player:updateMobType(mob_class) self.mob_type = mob_class end

function player:updatePos(y, x) self.y, self.x = y, x end

function player:updateStat(stat, num)
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

function player:__tostring() 
  -- if self:isMobType('zombie') then return 'a zombie' 
  return self:getUsername() 
end

return player
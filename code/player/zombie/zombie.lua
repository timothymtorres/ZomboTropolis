local class = require('code.libs.middleclass')
local Skills = require('code.player.skills')
local Hunger = require('code.player.zombie.hunger')
--local organic_armor = require('code.player.armor.organic_class')
local Claw, Bite = unpack(require('code.player.zombie.organic_weaponry'))
local zombie_skill_list = require('code.player.zombie.skill_list')
local zombie_action_list = require('code.player.zombie.action.action')
local Player = require('code.player.player')

local Zombie = class('Zombie', Player)

Zombie.action_list = zombie_action_list

local default_EP = 50

function Zombie:initialize(username, map_zone, y, x) --add account name
  Player:initialize(username, map_zone, y, x)

  self.ep = default_EP
  --self.abilities = abilities:new(self)
  self.skills = Skills:new(zombie_skill_list)
  self.hunger = Hunger:new(self)
  
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
  -- need to update all status_effects so other players are untangled, not tracked, etc.
  self:permadeath()   -- deletes zombie instance
end

function Zombie:revive()
  self:updateStat('hp', self:getStat('hp', 'max') ) 
end

--[[
--  GET [X]
--]]

-- client-side functions
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

return Zombie
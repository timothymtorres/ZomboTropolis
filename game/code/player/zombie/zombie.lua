local class = require('code.libs.middleclass')
local Skills = require('code.player.skills')
local Hunger = require('code.player.zombie.hunger')
local Claw, Bite = unpack(require('code.player.zombie.organic_weaponry'))
local Network = require('code.player.zombie.network')
local zombie_skill_list = require('code.player.zombie.skill_list')
local zombie_action_list = require('code.player.zombie.action.actions')
local Player = require('code.player.player')
local names = require('code.player.names.names')

local Zombie = class('Zombie', Player)

Zombie.action_list = zombie_action_list

function Zombie:initialize(...) --add account name 
  self.skills = Skills:new(zombie_skill_list)
  self.hunger = Hunger:new(self)
  self.network = Network:new(self)

  Player.initialize(self, ...)  
end

function Zombie:perform(action_str, ...) 
  local AP_cost = Player.perform(self, action_str, ...)
  self.hunger:elapse(AP_cost)
  if self.status_effect:isActive('scanned') then self.status_effect:remove('scanned') end
end

function Zombie:killed() -- cause_of_death arg not needed yet?
  self.hp, self.health_state = 0, {basic=4, advanced=8}  -- reset our hp stats to zero
  self.condition = condition:new(self)
  -- Reset other things?  Like tracking?  Armor? etc.

  -- if zombie is at full hunger and dies it should be permadeath
  -- self:permadeath()
end

function Zombie:starve()
  -- need to retain all info for the player to see next time they log in
  -- need to update all status_effects so other players are untangled, not tracked, etc.
  self:permadeath()   -- deletes zombie instance
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
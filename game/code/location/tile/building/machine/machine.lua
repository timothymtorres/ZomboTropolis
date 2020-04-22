local class = require('code.libs.middleclass')
string.replace = require('code.libs.replace')

local Machine = class('Machine')
local MAX_HP = 8

function Machine:initialize(building, condition) 
  self.hp = MAX_HP
  self.building = building
  self.condition = condition
end

function Machine:destroy()
  local building = self.building
  local machine = tostring(self)
  building.equipment[machine] = nil

  -- update building stuff... (ie. power out if generator)

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local public_msg = 'The {machine} is destroyed!'
  
  local names = {machine=machine}
  public_msg = public_msg:replace(names)
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'machine', message}
  local settings = {stage='inside'}
  
  building:broadcastEvent(public_msg, event, settings) 
end

function Machine:updateHP(num)
  self.hp = math.min(math.max(self.hp + num, 0), max_hp) 
  if self.hp == 0 then self:destroy() end  
end

function Machine:updateDurability()
  local failed_durability_test = math.random(self.DURABILITY) <= 1

  if failed_durability_test then 
    local condition = item:updateCondition(-1) 
    if condition == 0 then self:destroy() end
  end
end

function Machine:updateCondition(num)
  self.condition = math.max(math.min(self.condition + num, 4), 0)
  return self.condition
end

function Machine:getHP() return self.hp end

function Machine:isDamaged() return self.hp ~= MAX_HP end

function Machine:isConditionVisible(player) return player.skills:check(self.CLASS_CATEGORY) end

function Machine:getCondition() return self.condition end

local condition_states = {[1]='ruined', [2]='worn', [3]='average', [4]='pristine'}

function Machine:getConditionStr() return condition_states[self.condition] end

function Machine:__tostring() return string.lower(self.class.name) end

--[[
  self.generator = 0        -- 1 bit {exist}, 3 bit {08hp}, 4 bit {fuel} 
  self.transmitter = 0      -- 1 bit {exist}, 3 bit {08hp}, 10 bit {radio freq}
  self.terminal = 0         -- 1 bit {exist}, 3 bit {08hp},   
--]]

return Machine
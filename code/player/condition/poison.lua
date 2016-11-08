local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local poison = class('poison')

local MAX_UNITS, MAX_DAMAGE_TICK = 63, 15
local MAX_DURATION, MAX_DURATION_COUNT = 15, 15
--poison = duration, damage_LV, frequency

function poison:initialize()
  self.units = 0
  self.next_damage_tick = 0
  self.duration_remaining = 0
  self.duration_count = 0
end

--[[ NOT NECCESSARY?!?
function poison:reset()
  self.next_damage_tick = 0
  self.duration_count = 0
end
--]]

function poison:isActive()
  return (self.units > 0 and self.duration_remaining > 0)
end

function poison:add(duration, amount)
  duration, amount = dice.roll(duration), dice.roll(amount)
  self.units = math.min(self.units + amount, MAX_UNITS)
  self.duration_remaining = duration
end

local poison_data = {
  dice = {
    damage = {'1d3', '1d4', '2d2', '2d3', '2d4', '3d3', '3d4', '4d3', '4d4'},
    absorption = {'1d1', '1d1', '1d2', '1d2', '1d3', '1d4', '1d5+1', '1d7+3', '1d10+5'},
  },
  -- POISON LEVELS (determined by total units in bloodstream)
  
  [1] = 11, -- [01-11 units] (+11 range)
  [2] = 21, -- [12-21 units] (+10 range)
  [3] = 30, -- [21-30 units] (+9 range)
  [4] = 38, -- [31-38 units] (+8 range)
  [5] = 45, -- [39-45 units] (+7 range)
  [6] = 51, -- [46-51 units] (+6 range)
  [7] = 56, -- [52-56 units] (+5 range)
  [8] = 60, -- [57-60 units] (+4 range)
  [9] = 63, -- [60-63 units] (+3 range)  
  
--[[  
  [1] =  3, -- [01-03 units] (+3 range)
  [2] =  7, -- [04-07 units] (+4 range)
  [3] = 12, -- [08-12 units] (+5 range)
  [4] = 18, -- [13-18 units] (+6 range)
  [5] = 25, -- [19-25 units] (+7 range)
  [6] = 33, -- [26-33 units] (+8 range)
  [7] = 42, -- [34-42 units] (+9 range)
  [8] = 52, -- [43-52 units] (+10 range)
  [9] = 63, -- [53-63 units] (+11 range)
--]]  
  -- POISON LEVELS
}

function poison:damage()
  for poison_LV, poison_amount in ipairs(poison_data) do
    if self.units <= poison_amount then
      local damage_roll = poison_data.dice.damage[poison_LV]
      return dice.roll(damage_roll)
    end
  end
end

function poison:rollDamageFrequency() 
  local frequency_roll = dice.roll('1d'..(self.duration_count+1)..'-1')
  return frequency_roll
end

function poison:absorbIntoBloodstream()
  local absorption_roll 
  for poison_LV, poison_amount in ipairs(poison_data) do
    if self.units <= poison_amount then
      absorption_roll = dice.roll(poison_data.dice.absorption[poison_LV])
      break
    end
  end 
  self.units = math.max(self.units - absorption_roll, 0)   
end

function poison:elapse(player, time)
  if not self:isActive() then
    return
  end
  
print()
print('BEFORE', 'Poison units:'..self.units, 'Poison duration:'..self.duration_remaining)  
  while time > 0 do
    if self.duration_remaining > 0 then 
      if self.next_damage_tick == 0 then -- time to take damage      
        local total_damage = self:damage()
        local hp_loss = -1*total_damage
        player:updateStat('hp', hp_loss)
print('You feel the poison in your veins', 'You lose '..hp_loss..'hp') 
        self.duration_count = self.duration_count + 1
        self.duration_remaining = self.duration_remaining - 1
        
        if self.duration_remaining == 0 then self.duration_count = 0
print('POISON DAMAGE FINISHED')
        else self.next_damage_tick = self:rollDamageFrequency()
        end
      else
        self.next_damage_tick = self.next_damage_tick - 1
      end
    end
    
    if self.units > 0 then
      self:absorbIntoBloodstream()
    end  
    time = time - 1
print('Next damage tick - '..self.next_damage_tick)
print('AFTER', 'Poison units:'..self.units, 'Poison duration:'..self.duration_remaining)  
print()
  end
end

return poison
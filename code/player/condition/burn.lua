local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local burn = class('burn')

local MAX_UNITS, MAX_DAMAGE_TICK = 63, 15

function burn:initialize()
  self.units = 0
  self.on_fire = false
end

--[[ NOT NECCESSARY?!?
function burn:reset()
  self.next_damage_tick = 0
  self.duration_count = 0
end
--]]

function burn:isActive()
  return self.on_fire
end

function burn:add(fuel, combustion_source)
  fuel = dice.roll(fuel)
  self.units = math.min(self.units + fuel, MAX_UNITS)
  self.on_fire = combustion_source or false
end

local burn_data = {
  dice = {
    damage = {'1d2', '1d3', '1d4', '1d5', '1d6', '2d3', '2d3+1', '2d4+1', '2d5+1'},
    absorption = {'1d4', '1d5', '1d6', '2d3', '2d4', '2d4+1', '2d5+1', '3d4+1', '3d4+2'},
  },
  -- BURN LEVELS (determined by total units in bloodstream)
  [1] = 11, -- [01-11 units] (+11 range)
  [2] = 21, -- [12-21 units] (+10 range)
  [3] = 30, -- [21-30 units] (+9 range)
  [4] = 38, -- [31-38 units] (+8 range)
  [5] = 45, -- [39-45 units] (+7 range)
  [6] = 51, -- [46-51 units] (+6 range)
  [7] = 56, -- [52-56 units] (+5 range)
  [8] = 60, -- [57-60 units] (+4 range)
  [9] = 63, -- [60-63 units] (+3 range)  
  -- BURN LEVELS
}

function burn:damage()
  for burn_LV, burn_amount in ipairs(burn_data) do
    if self.units <= burn_amount then
      local damage_roll = burn_data.dice.damage[burn_LV]
      return dice.roll(damage_roll)
    end
  end
end

function burn:consumeFuel()
  local absorption_roll 
  for burn_LV, burn_amount in ipairs(burn_data) do
    if self.units <= burn_amount then      
      absorption_roll = dice.roll(burn_data.dice.absorption[burn_LV])
      break
    end
  end 
  self.units = math.max(self.units - absorption_roll, 0)   
end

function burn:elapse(player, time)
  if not self:isActive() then
    return 
  end  
  
  while time > 0 do     
    local total_damage = self:damage()
    local hp_loss = -1*total_damage
    player:updateStat('hp', hp_loss)
print('You burn in agony!', 'You lose '..hp_loss..'hp') 
    
    if self.units == 0 then
      self.on_fire = false
      return
      print('BURN DAMAGE FINISHED')
    end
    self:consumeFuel()
    
    time = time - 1
  end
print('AFTER', 'burn units:'..self.units)  
print()
end

return burn
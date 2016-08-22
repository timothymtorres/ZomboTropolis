local class = require('code.libs.middleclass')
local dice = require('code.libs.rl-dice.dice')
local barrier = require('code.location.building.barrier.class')

local barricade = class('barricade', barrier)
local DEFAULT_HP, DEFAULT_POTENTIAL_HP = 0, 15
local MIN_POTENTIAL_HP = 15
local MAX_HP = 63

local fortification_status = {
  {desc = 'secured',            range =  0},  --   0
  {desc = 'loose',              range =  6},  --   1-06 [6]
  {desc = 'light',              range = 13},  --   7-13 [7]
  {desc = 'regular',            range = 21},  --  14-21 [8]
  {desc = 'strong',             range = 30},  --  22-30 [9]
  {desc = 'very strong',        range = 40},  --  31-40 [10]
  {desc = 'heavily',            range = 51},  --  41-51 [11]
  {desc = 'extremely heavily',  range = 63},  --  52-63 [12]
}

local room_available = {
  {desc = 'no',        range = 0},             --    0
  {desc = 'little',    range = 4},             --   1-04
  {desc = 'some',      range = 8},             --   5-08
  {desc = 'plenty',    range = 63},            --   7-63
}

function barricade:initialize(type)
  barrier.initialize(self) 
  self.hp = DEFAULT_HP
  self.potential_hp = DEFAULT_POTENTIAL_HP
  
  self.hp_desc = fortification_status[1].desc
  self.potential_hp_desc = room_available[4].desc
end  

barricade.max_hp = MAX_HP

function barricade:getDesc() return self.hp_desc, self.potential_hp_desc end

function barricade:updateHP(num) 
  self.hp = math.min( math.max(self.hp+num, 0), self.potential_hp) 
  -- if damage done to barricade, need to subtract it from potential_hp as well (default_potential_hp is the lowest it can go)
  if num < 0 then self.potential_hp = math.max(self.potential_hp - num, MIN_POTENTIAL_HP) end 
  self:updateDesc()
end

function barricade:isDestroyed() return self.hp == 0 end

function barricade:roomForFortification() return self.potential_hp > self.hp end

local reinforce_potential_params = {
  {margin =    12, range = 26}, --         9-26 [17]
  {margin =     9, range = 40}, --        27-40 [14]
  {margin =     6, range = 52}, --        41-52 [12]
  {margin =     3, range = 63}, --        53-63 [11]  
}

local MIN_HP_TO_REINFORCE = 9

function barricade:canReinforce()
 
--[[----  REASONING FOR REINFORCE LIMITS/RANGES --------
    In order to reinforce three critera needs to be met:
      #1 - You need a minimum amount of barricades already established.  (Cannot reinforce an empty room)
      #2 - You cannot surpass the MAX_HP limit.                          (Ran out of room for barricades)
      #3 - You need a reasonable gap between potential_hp and current_hp (As you add more barricades, you can reinforce more, but as you reach the MAX_HP limit you can reinforce less and less)
--]]----------------------------------------------------
  
  local margin 
  for i,potential in ipairs(reinforce_potential_params) do
    if potential.range[i] >= self.hp then
      margin = potential.margin
      break
    end
  end
    
  local hp_gap = self.potential_hp - self.hp
  
  local has_room_to_reinforce = margin >= hp_gap  -- is the gap between the potential/current_hp within reinforce margin
  local is_reinforce_maxxed = self.potential_hp == MAX_HP -- have we hit the max ceiling for MAX_HP yet
  local has_min_cades_to_reinforce = self.hp >= MIN_HP_TO_REINFORCE -- cannot reinforce without enough cades present
  
  if has_room_to_reinforce and not is_reinforce_maxxed and has_min_cades_to_reinforce then return true
  else return false
  end
end

local reinforce_params = {
  {dice =   '2d4', range = 18}, --        16-18 [3]
  {dice =   '2d3', range = 23}, --        19-23 [5]
  {dice =   '1d5', range = 30}, --        24-30 [7]
  {dice =   '1d3', range = 39}, --        31-39 [9]
  {dice = '1d3-1', range = 48}, --        40-48 [9]
  {dice = '1d5-3', range = 55}, --        49-55 [7]
  {dice = '2d3-5', range = 60}, --        56-60 [5]  
  {dice = '2d4-7', range = 63}, --        63-61 [3]
}

function barricade:reinforce()
  local dice_str  
  for i,reinforce in ipairs(reinforce_params) do
    if reinforce.range[i] >= self.hp then
      dice_str = reinforce.dice
      break
    end
  end  
  
  local reinforce_dice = dice:new(dice_str, 0)
  local roll_result = reinforce_dice.roll()
  if roll_result > 0 then
    self.potential_hp = math.min(self.potential_hp + roll_result, MAX_HP) 
    self:updateDesc()
  else -- reinforce action failed (roll == 0)
    -- we should probably return something to notify if the reinforce action failed (ie. rolled a 0)
  end
end

function barricade:updateDesc()
  for i, fort in ipairs(fortification_status) do
    if fort.range >= self.hp then
      self.hp_desc = fort.desc
      break
    end
  end    
  
  local hp_gap = self.potential_hp - self.hp
  
  for i, room in ipairs(room_available) do
    if room.range >= hp_gap then
      self.potential_hp_desc = room.desc
      break
    end
  end
end

function barricade:canPlayerFortify(player)
  local regular_cade_value, v_strong_cade_value = fortification_status[4].range, fortification_status[6].range
  local cade_past_regular = self.hp <= regular_cade_value
  local cade_past_v_strong = self.hp <= v_strong_cade_value
  
  if cade_past_v_strong then return player.skills:check('barricade_adv')  -- can barricade all
  elseif cade_past_regular then return player.skills:check('barricade')   -- can barricade up to very strong
  else return true end                                                    -- can barricade up to regular
end

local bypass_skill_bonus, zombie_multiplier = 5, 20

function barricade:fortifyAttempt(player, zombie_n, human_n)  -- this code will be implemented later, probably needs chance tweaks
  local zombie_blockade_value = (zombie_multiplier*zombie_n) - human_n
  local skill_bonus = (player.skills:check('barricade') and bypass_skill_bonus) or 0
  local skill_bonus_adv = (player.skills:check('barricade_adv') and bypass_skill_bonus) or 0
  local bypass_chance = 5 + skill_bonus + skill_bonus_adv
  
  return zombie_blockade_value <= dice.roll(zombie_blockade_value + bypass_chance)
end

local cade_dice = {'1d3-1^-1', '1d3^-1', '1d3', '1d3^+1'} -- Averages [1.1, 1.5, 2, 2.5]

function barricade:fortify(player, cade_condition)
  local dice_str = cade_dice[cade_condition]
  local barricade_dice = dice:new(dice_str)
  if player.skills:check('barricade') then barricade_dice = barricade_dice / 1 end
  if player.skills:check('barricade_adv') then barricade_dice = barricade_dice ^ 1 end
  
  self:updateHP(barricade_dice.roll())
end

return barricade
local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')
local Barrier = require('code.location.tile.building.barrier')

local Barricade = class('Barricade', Barrier)
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
  {desc = 'heavy',              range = 51},  --  41-51 [11]
  {desc = 'extremely heavy',    range = 63},  --  52-63 [12]
}

local room_available = {
  {desc = 'no',        range = 0},             --    0
  {desc = 'little',    range = 4},             --   1-04
  {desc = 'some',      range = 8},             --   5-08
  {desc = 'plenty',    range = 63},            --   7-63
}

function Barricade:initialize()
  Barrier.initialize(self) 
  self.hp = DEFAULT_HP
  self.potential_hp = DEFAULT_POTENTIAL_HP
  
  self.hp_desc = fortification_status[1].desc
  self.potential_hp_desc = room_available[4].desc
end  

Barricade.max_hp = MAX_HP

function Barricade:getDesc() return self.hp_desc, self.potential_hp_desc end

function Barricade:updateHP(num) 
  self.hp = math.min( math.max(self.hp+num, 0), self.potential_hp) 
  -- if damage done to barricade, need to subtract it from potential_hp as well (default_potential_hp is the lowest it can go)
  if num < 0 then self.potential_hp = math.max(self.potential_hp - num, MIN_POTENTIAL_HP) end 
  self:updateDesc()
end

function Barricade:roomForFortification() return self.potential_hp > self.hp end

local reinforce_potential_params = {
  {margin =    12, range = 26}, --         9-26 [17]
  {margin =     9, range = 40}, --        27-40 [14]
  {margin =     6, range = 52}, --        41-52 [12]
  {margin =     3, range = 63}, --        53-63 [11]  
}

local MIN_HP_TO_REINFORCE = 9

function Barricade:canReinforce()
 
--[[----  REASONING FOR REINFORCE LIMITS/RANGES --------
    In order to reinforce three critera needs to be met:
      #1 - You need a minimum amount of barricades already established.  (Cannot reinforce an empty room)
      #2 - You cannot surpass the MAX_HP limit.                          (Ran out of room for barricades)
      #3 - You need a reasonable gap between potential_hp and current_hp (As you add more barricades, you can reinforce more, but as you reach the MAX_HP limit you can reinforce less and less)
--]]----------------------------------------------------
  
  local margin 
  for _, potential in ipairs(reinforce_potential_params) do
    if potential.range >= self.hp then
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

function Barricade:reinforceAttempt()
  local dice_str
  for i, reinforce in ipairs(reinforce_params) do
    if reinforce.range >= self.hp then
      dice_str = reinforce.dice
      break
    end
  end  
  
  local reinforce_dice = dice:new(dice_str, 0)
  local potential_hp_roll = reinforce_dice:roll()
  local building_was_reinforced = potential_hp_roll > 0
  local potential_hp = potential_hp_roll > 0 and potential_hp_roll or nil
  
  return building_was_reinforced, potential_hp
end

function Barricade:reinforce(potential_hp)
  self.potential_hp = math.min(self.potential_hp + potential_hp, MAX_HP) 
  self:updateDesc()
end

function Barricade:updateDesc()
  for _, fort in ipairs(fortification_status) do
    if fort.range >= self.hp then
      self.hp_desc = fort.desc
      break
    end
  end    
  
  local hp_gap = self.potential_hp - self.hp
  
  for _, room in ipairs(room_available) do
    if room.range >= hp_gap then
      self.potential_hp_desc = room.desc
      break
    end
  end
end

function Barricade:canPlayerFortify(player)
  local regular_cade_value, v_strong_cade_value = fortification_status[4].range, fortification_status[6].range
  local cade_past_regular = self.hp >= regular_cade_value
  local cade_past_v_strong = self.hp >= v_strong_cade_value
  
  if cade_past_v_strong then return player.skills:check('barricade_adv')  -- can barricade all
  elseif cade_past_regular then return player.skills:check('barricade')   -- can barricade up to very strong
  else return true end                                                    -- can barricade up to regular
end

local num_humans_to_nullify_zombie = 10  -- this might be too high? 
local ransack_blockade_bonus = 1
local skill_bypass_bonus = 1
local default_bypass_n = 2

function Barricade:didZombiesIntervene(player)  -- make brute zombie count as x2 for blockade_n
  local p_tile = player:getTile()
  local zombie_n = p_tile:countPlayers('zombie', 'inside')
  local human_n = p_tile:countPlayers('human', 'inside')
  
  local nullfied_zombies = math.floor(human_n/num_humans_to_nullify_zombie)
  local blockade_n = zombie_n - 1 - nullfied_zombies  -- the -1 is to prevent single zombies from blocking an entrance by themselves
  
  local integrity_state = p_tile:getIntegrity()
  if integrity_state == 'ransacked' then blockade_n = blockade_n + ransack_blockade_bonus end
  
  if blockade_n <= 0 then return false end -- not high enough chance at blocking to do a roll
  
  local skill_bonus = (player.skills:check('barricade') and skill_bypass_bonus) or 0
  local skill_bonus_adv = (player.skills:check('barricade_adv') and skill_bypass_bonus) or 0
  local skill_bypass_n = skill_bonus + skill_bonus_adv
  
  return blockade_n >= dice.roll(default_bypass_n + skill_bypass_n + blockade_n)  -- blockade < dice.roll(1d2 / skill / blockade)
end

local cade_dice = {'1d3-1^-1', '1d3^-1', '1d3', '1d3^+1'} -- Averages [1.1, 1.5, 2, 2.5]

function Barricade:fortify(player, cade_condition)
  local dice_str = cade_dice[cade_condition]
  local barricade_dice = dice:new(dice_str)
  if player.skills:check('barricade') then barricade_dice = barricade_dice / 1 end
  if player.skills:check('barricade_adv') then barricade_dice = barricade_dice ^ 1 end
  
  self:updateHP(barricade_dice:roll())
end

return Barricade
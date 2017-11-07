local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')

-------------------------------------------------------------------

local FAK = class('FAK', ItemBase)

FAK.static = {
  FULL_NAME = 'first aid kit',
  WEIGHT = 8,
  DURABILITY = 0,
  CATEGORY = 'research',
}

function FAK.server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert((player:getStage() == target:getStage()) and (player:getTile() == target:getTile()), 'Target is out of range')
  assert(not target:isMaxHP(), 'Target has full health')
  assert(target:isMobType('human'), 'Target must be a human')     
end

function FAK.activate(player, condition, target)
  local FAK_dice = dice:new(medical.FAK:getDice())
  local tile = player:getTile()  
 
  if player.skills:check('healing') and tile:isBuilding() and tile:isPowered() and player:isStaged('inside') then
    FAK_dice = FAK_dice*1
--print('powered confirmed')
--print(tile:getClassName(), tile:getName(), tile:getTileType() )
    if player.skills:check('major_healing') and tile:isClass('hospital') then 
      FAK_dice = FAK_dice*1 
--print('hosptial confirmed')
    end
  end
  
  if player.skills:check('major_healing') then 
    FAK_dice = FAK_dice^1
    FAK_dice = FAK_dice..'^^'
  end
  
  local hp_gained = FAK_dice:roll()
  target:updateHP(hp_gained)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You heal {target} with a first aid kit.'
  local target_msg = '{player} heals you with a first aid kit.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)  
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'FAK', player, target}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

-------------------------------------------------------------------

local Bandage = class('Bandage', ItemBase)

Bandage.static = {
  FULL_NAME = 'bandage',
  WEIGHT = 3,
  DURABILITY = 0,
  CATEGORY = 'research',
}

function Bandage.server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert((player:getStage() == target:getStage()) and (player:getTile() == target:getTile()), 'Target is out of range')
  assert(not target:isMaxHP(), 'Target has full health')
  assert(target:isMobType('human'), 'Target must be a human')    
end

function Bandage.activate(player, condition, target)
  local bandage_dice = dice:new(medical.bandage:getDice())  
  local tile = player:getTile()
 
  if tile:isBuilding() and tile:isPowered() and player:isStaged('inside') then bandage_dice = bandage_dice+1 end
 
  if player.skills:check('healing') then 
    bandage_dice = bandage_dice+1
    if player.skills:check('minor_healing') then 
      bandage_dice = bandage_dice+1     
      bandage_dice = bandage_dice^1    
    end
  end  
  
  local hp_gained = bandage_dice:roll()
  target:updateHP(hp_gained)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You heal {target} with a bandage.'
  local target_msg = '{player} heals you with a bandage.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)   
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'bandage', player, target}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  

  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)   
end

-------------------------------------------------------------------

local Syringe = class('Syringe', ItemBase)

Syringe.static = {
  FULL_NAME = 'syringe',
  WEIGHT = 5,
  DURABILITY = 0,
  CATEGORY = 'research',  
}

function Syringe.client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby')  
end

function Syringe.server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert((player:getStage() == target:getStage()) and (player:getTile() == target:getTile()), 'Target is out of range')
  assert(target:isMobType('zombie'), 'Target must be a zombie')
end

local syringe_hp_ranges = {3, 6, 9, 12}
local antidote_skill_modifier = {none = 'ruined', syringe = 'ransacked', syringe_adv = 'intact'}
local syringe_salvage_chance = 5  -- 1/5 chance of saving a syringe that failed to create an antidote on inject due to not weak enough target

function Syringe.activate(player, condition, target)
  local syringe = medical.syringe
  local inject_chance = syringe:getAccuracy()
  if player.skills:check('syringe') then
    inject_chance = inject_chance + 0.15
    if player.skills:check("syringe_adv") then
      inject_chance = inject_chance + 0.20
    end
  end
  
  local inject_success = inject_chance >= math.random()
  local target_weak_enough = syringe_hp_ranges[condition] >= target:getStat('hp') 
  local syringe_salvage_successful

  if inject_success and target_weak_enough then  -- the syringe will create a antidote
    target:killed()
    
    local skill_modifier = (player.skills:check('syringe_adv') and antidote_skill_modifier.syringe_adv) or (player.skills:check('syringe') and antidote_skill_modifier.syringe) or antidote_skill_modifier.none
    local antidote = item.antidote:new(skill_modifier)
    player.inventory:insert(antidote)
  elseif inject_success then
    syringe_salvage_successful = player.skills:check('syringe_adv') and dice.roll(syringe_salvage_chance) == 1  
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg, target_msg   
  
  if inject_success and target_weak_enough then
    self_msg =   'You inject {target} with your syringe and an antidote is created.'
    target_msg = '{player} injects you with their syringe killing you in the process.'    
  elseif inject_success then
    self_msg =   'You inject {target} with your syringe but it is too strong and resists.' .. (syringe_salvage_successful and '' or ' Your syringe is destroyed.')
    target_msg = '{player} injects you with their syringe but you resist.'       
  else 
    self_msg =   'You attempt to inject {target} with your syringe and fail.'
    target_msg = '{player} attempted to inject you with their syringe.'  
  end
  
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)    
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'syringe', player, target, inject_success, target_weak_enough, syringe_salvage_successful}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

-------------------------------------------------------------------

local Vaccine = class('Vaccine', ItemBase)

Vaccine.static = {
  FULL_NAME = 'antibodies',
  WEIGHT = 5,
  DURABILITY = 0,
  CATEGORY = 'research',
}

function Vaccine.server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert((player:getStage() == target:getStage()) and (player:getTile() == target:getTile()), 'Target is out of range')
  assert(target:isMobType('human'), 'Target must be a human')    
end

function Vaccine.activate(player, condition, target)
  local antibodies = medical.antibodies
  local antibodies_dice = dice:new(medical.antibodies:getDice())
  
  antibodies_dice = antibodies_dice + (condition*100)
  --if player.skills:check('') then        Should we utilize a skill that affects antibodies?
  
  local immunity_gained = antibodies_dice:roll()
  target.condition.infection:addImmunity(immunity_gained)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You inject {target} with a vaccine.'
  local target_msg = '{player} injects you with a vaccine.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)  
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'vaccine', player, target}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

-------------------------------------------------------------------

local Antidote = class('Antidote', ItemBase)

Antidote.static = {
  FULL_NAME = 'antidote',
  WEIGHT = 5,
  DURABILITY = 1,
  CATEGORY = 'research',
}

function Antidote.server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert((player:getStage() == target:getStage()) and (player:getTile() == target:getTile()), 'Target is out of range')
  assert(target:isMobType('human'), 'Target must be a human')  
end

function Antidote.activate(player, condition, target)
  target.condition.infection:remove()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You inject {target} with an antidote.'
  local target_msg = '{player} injects you with an antidote.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player) 
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'antidote', player, target}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)   
end

return {FAK, Bandage, Syringe, Vaccine, Antidote}
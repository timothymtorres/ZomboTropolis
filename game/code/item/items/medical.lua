local dice = require('code.libs.dice')
string.replace = require('code.libs.replace')

local Medical = {}
-------------------------------------------------------------------

local FAK = {}
Medical.FAK = FAK

FAK.medical = {DICE = '1d5'}

function FAK:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(not target:isMaxHP(), 'Target has full health')
  assert(target:isMobType('human'), 'Target must be a human')     
end

function FAK:activate(player, target)
  local FAK_dice = dice:new(self.medical.DICE)
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
  target:update('hp', hp_gained)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You heal {target} with a first aid kit.'
  local target_msg = '{player} heals you with a first aid kit.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'FAK', player, target}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

-------------------------------------------------------------------

local Bandage = {}
Medical.Bandage = Bandage

Bandage.medical = {DICE = '1d3'}

function Bandage:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(not target:isMaxHP(), 'Target has full health')
  assert(target:isMobType('human'), 'Target must be a human')    
end

function Bandage:activate(player, target)
  local bandage_dice = dice:new(self.medical.DICE)
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
  target:update('hp', hp_gained)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You heal {target} with a bandage.'
  local target_msg = '{player} heals you with a bandage.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)   
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  

  local event = {'bandage', player, target}  
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)   
end

-------------------------------------------------------------------

local Syringe = {}
Medical.Syringe = Syringe

Syringe.medical = {ACCURACY = 0.99999} --0.05

function Syringe:client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby')  
end

function Syringe:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(target:isMobType('zombie'), 'Target must be a zombie')
end

local syringe_hp_ranges = {3, 6, 9, 12}
local antidote_skill_modifier = {none = 'ruined', gadget = 'ransacked', syringe = 'intact'}
local syringe_salvage_chance = 5  -- 1/5 chance of saving a syringe that failed to create an antidote on inject due to not weak enough target

function Syringe:activate(player, target)
  local inject_chance = self.medical.ACCURACY
  local syringe_hp_threshold = syringe_hp_ranges[self.condition]

  if player.skills:check('gadget') then
    inject_chance = inject_chance + 0.15
    syringe_hp_threshold = syringe_hp_threshold + 3
    if player.skills:check("syringe") then
      inject_chance = inject_chance + 0.20
      syringe_hp_threshold = syringe_hp_threshold + 3
    end
  end
  
  local inject_success = inject_chance >= math.random()
  local target_weak_enough = syringe_hp_threshold >= target.stats:get('hp') 
  local syringe_salvage_successful

  if inject_success and target_weak_enough then  -- the syringe will create a antidote
    target:killed()
    
    local skill_modifier = (player.skills:check('syringe') and antidote_skill_modifier.syringe_adv) or (player.skills:check('gadget') and antidote_skill_modifier.gadget) or antidote_skill_modifier.none
    local antidote = item.antidote:new(skill_modifier)
    player.inventory:insert(antidote)
  elseif inject_success then
    syringe_salvage_successful = player.skills:check('syringe') and dice.roll(syringe_salvage_chance) == 1  
  else
    syringe_salvage_successful = true
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
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'syringe', player, target, inject_success, target_weak_enough, syringe_salvage_successful}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  

  return syringe_salvage_successful -- not sure if there is a better way to deal with returning the result (needed for the item:updateDurability() code) [only used by syringes and barricades]
end

-------------------------------------------------------------------

local Vaccine = {}
Medical.Vaccine = Vaccine

Vaccine.medical = {DICE = '10d10'}

function Vaccine:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(target:isMobType('human'), 'Target must be a human')    
end

function Vaccine:activate(player, target)
  local vaccine_dice = dice:new(self.medical.DICE)
  
  vaccine_dice = vaccine_dice + (self.condition*100)
  --if player.skills:check('') then        Should we utilize a skill that affects antibodies?
  
  local immunity_gained = vaccine_dice:roll()
  if not target.status_effect:isActive('immunity') then 
    target.status_effect:new('immunity', immunity_gained)
  else
    target.status_effect.immunity:add(immunity_gained)
  end

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You inject {target} with a vaccine.'
  local target_msg = '{player} injects you with a vaccine.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'vaccine', player, target}   
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

-------------------------------------------------------------------

local Antidote = {}
Medical.Antidote = Antidote

function Antidote:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(target:isMobType('human'), 'Target must be a human')  
end

function Antidote:activate(player, target)
  if target.status_effect:isActive('infection') then 
    target.status_effect.infection:remove()
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You inject {target} with an antidote.'
  local target_msg = '{player} injects you with an antidote.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player) 
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'antidote', player, target}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)   
end

-------------------------------------------------------------------

local Scanner = {}
Medical.Scanner = Scanner

Scanner.medical = {ACCURACY = 0.10}

function Scanner:client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby')  
end

function Scanner:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(target:isMobType('zombie'), 'Target must be a zombie')
  assert(not target.status_effect:isActive('scanned'), 'Target has already been scanned')
end

function Scanner:activate(player, target)
  local scan_chance = self.medical.ACCURACY
  if player.skills:check('gadget') then scan_chance = scan_chance + 0.15 end
  if player.skills:check("scanner") then scan_chance = scan_chance + 0.20 end
  
  local scan_success = scan_chance >= math.random()

  if scan_success then target.status_effect:add('scanned', target) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg, target_msg   
  
  if scan_success then
    self_msg =   'You scan {target} with your scanner.'
    target_msg = '{player} scans you.'       
  else 
    self_msg =   'You attempt to scan {target} and fail.'
    target_msg = '{player} attempted to scan you.'  
  end
  
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)    
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'scanner', player, target, scan_success}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

return Medical
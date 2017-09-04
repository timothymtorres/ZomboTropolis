local dice = require('code.libs.dice')
local medical = require('code.item.medical.class')
local item = require('code.item.class')
local broadcastEvent = require('code.server.event')

local activate = {}

--[[
--- MEDICAL
--]]

function activate.FAK(player, condition, target)
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
  -- target:event trigger
  print('You heal with the first aid kit for '..hp_gained..' hp.')
end

function activate.bandage(player, condition, target)
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
  -- target:event trigger
  print('You heal with '..bandage:getName()..' for '..hp_gained..' hp.')
end

function activate.antibodies(player, condition, target)
  local antibodies = medical.antibodies
  local antibodies_dice = dice:new(medical.antibodies:getDice())
  
  antibodies_dice = antibodies_dice + (condition*100)
  --if player.skills:check('') then        Should we utilize a skill that affects antibodies?
  
  local immunity_gained = antibodies_dice:roll()
  target.condition.infection:addImmunity(immunity_gained)
  --target:event trigger
  print('You give antibodies to '..target:getUsername()..' for '..immunity_gained..' ticks.')
end

function activate.antidote(player, condition, target)
  target.condition.infection:remove()
  print('You use the antidote on '..target:getUsername())
end

local syringe_hp_ranges = {3, 6, 9, 12}
local antidote_skill_modifier = {none = 'ruined', syringe = 'ransacked', syringe_adv = 'intact'}
local syringe_salvage_chance = 5  -- 1/5 chance of saving a syringe that failed to create an antidote on inject due to not weak enough target

function activate.syringe(player, condition, target)
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

  if inject_success then
    if target_weak_enough then  -- the syringe will create a antidote
      target:killed()
      -- target:event trigger
      
      local skill_modifier = (player.skills:check('syringe_adv') and antidote_skill_modifier.syringe_adv) or (player.skills:check('syringe') and antidote_skill_modifier.syringe) or antidote_skill_modifier.none
      local antidote = item.antidote:new(skill_modifier)
      player.inventory:insert(antidote)
      broadcastEvent(player, 'You inject a zombie with your syringe and an antidote is created.')
      broadcastEvent(target, player:getUsername()..' injects you with their syringe killing you in the process.')
    else
      syringe_salvage_successful = player.skills:check('syringe_adv') and dice.roll(syringe_salvage_chance) == 1
      broadcastEvent(player, 'You inject a zombie with your syringe but it is too strong and resists.' .. (syringe_salvage_successful and '' or ' Your syringe is destroyed.')
      broadcastEvent(target, player:getUsername()..' injects you with their syringe but you resist.'        
    end
  else -- syringe missed
    broadcastEvent(player, 'You attempt to inject a zombie with your syringe and fail.')
    broadcastEvent(target, player:getUsername()..' attempted to inject you with their syringe.'     
  end
  
  --return {inject_success, target_weak_enough, syringe_salvage_successful} 
end

--[[
--- WEAPONS
--]]

function activate.flare(player, condition)
  -- target:event trigger
  -- condition range = [0] = 6x6, [1] = 9x9, [2] = 12x12, [3] = 15x15
end

--[[
--- GADGETS
--]]

function activate.radio(player, condition, old_freq, new_freq)
  player.inventory:updateRadio(player, 'remove', old_freq, condition)
  player.inventory:updateRadio(player, 'insert', new_freq, condition)
end

function activate.cellphone(player, condition)

end

function activate.sampler(player, condition, target)

end

local GPS_basic_chance, GPS_advanced_chance = 0.15, 0.20

function activate.GPS(player, condition)
  local GPS_chance = (player.skils:check('gadgets') and GPS_advanced_chance) or GPS_basic_chance
  local free_movement_success = GPS_chance >= math.random()
  if free_movement_success then  -- the GPS has a chance to avoid wasting ap on movement
    player:updateStat('ap', 1) -- this is pretty much a hack (if a player's ap is 50 then they will NOT receive the ap)
  end 
  return {free_movement_success}
end

function activate.loudspeaker(player, condition, message)
  if condition == 3 then
    --event 3x3 inside/outside
  elseif condition == 2 then
    --event 3x3 if outside, inside/outside
  elseif condition == 1 then
    --event inside/outside
  end
  
  -- do event - broadcast to all tiles of large building
end

--[[
--- EQUIPMENT
--]]

function activate.barricade(player, condition)
  local building_tile = player:getTile()
  local did_zombies_interfere = building_tile.barricade:didZombiesIntervene(player)
  
  if not did_zombies_interfere then 
    building_tile.barricade:fortify(player, condition) 
    broadcastEvent(player, 'You fortify the building with a barricade.')
  else
    broadcastEvent(player, 'You start to fortify the building, but a zombie lurches towards you.')
  end
  
  --return {did_zombies_interfere}    
end

function activate.fuel(player, condition)
  local building_tile = player:getTile()
  building_tile.generator:refuel()
end

function activate.generator(player, condition)
  local building_tile = player:getTile()
  building_tile:insert('generator', condition)
end

function activate.transmitter(player, condition)
  local building_tile = player:getTile()
  building_tile:insert('transmitter', condition)
end

function activate.terminal(player, condition)
  local building_tile = player:getTile()
  building_tile:insert('terminal', condition)
end

local toolbox_dice = {'3d2-2', '3d2-1', '3d2', '3d2+1'}

function activate.toolbox(player, condition)
  local repair_dice = dice:new(toolbox_dice[condition])
  if player.skills:check('repair') then repair_dice = repair_dice / 1 end
  if player.skills:check('repair_adv') then repair_dice = repair_dice ^ 3 end
  
  local building = player:getTile()
  building.integrity:updateHP(repair_dice:roll() )
  local integrity_state = building.integrity:getState()
  
  local broadcast_settings = {
    stage='inside', 
    exclude={player:getUsername()=true},
  }
  
  broadcastEvent(player, 'You repair the building' .. (integrity_state == 'intact' and 'completely.' or '.'))  
  broadcastEvent(building, player:getUsername()..' repairs the building' .. (integrity_state == 'intact' and 'completely.' or '.'), broadcast_settings)
  
  --return {integrity_state}
end

--[[
--- JUNK
--]]

local book_xp_dice = {'1d3', '1d5', '1d7', '1d10'}

function activate.book(player, condition)
  local xp_dice_str = book_xp_dice[condition-1]
  local book_dice = dice:new(xp_dice_str)
  local tile = player:getTile()
 
  if tile:isBuilding() and tile:isPowered() and player:isStaged('inside') then book_dice = book_dice^1 end  
  local gained_xp = book_dice:roll()
  player:updateXP(gained_xp)
end

function activate.newspaper(player, condition)
  -- event trigger
end

function activate.bottle(player, condition)
  player:updateHP(1)
end

--[[
--- ARMOR
--]]

function activate.leather(player, condition)
  player.armor:equip('leather', condition)
  broadcastEvent(player, 'You equip a leather jacket.')    
end

function activate.firesuit(player, condition)
  player.armor:equip('firesuit', condition)
  broadcastEvent(player, 'You equip a firesuit.')    
end

return activate
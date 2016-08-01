local dice = require('code.libs.rl-dice.dice')
local lookupMedical = require('code.item.medical.search')
local flags = require('code.player.skills.flags')

local activate = {}

--[[
--- MEDICAL
--]]

function activate.FAK(player, target, condition)
  local FAK = lookupMedical('FAK')
  local FAK_dice = dice:new(FAK:getDice())
  local tile = player:getTile()  
 
  if player.skills:check(flags.recovery) and tile:isBuilding() and tile:isPowered() and player:isStaged('inside') then
    FAK_dice = FAK_dice*1
--print('powered confirmed')
--print(tile:getClassName(), tile:getName(), tile:getTileType() )
    if player.skills:check(flags.major_healing) and tile:isClass('hospital') then 
      FAK_dice = FAK_dice*1 
--print('hosptial confirmed')
    end
  end
  
  if player.skills:check(flags.major_healing_adv) then 
    FAK_dice = FAK_dice^1
    FAK_dice = FAK_dice..'^^'
  end  
  
  local heal_rolls, hp_gained = dice.roll(FAK_dice), 0
  for _, heal in ipairs(heal_rolls) do hp_gained = hp_gained + heal end
  target:updateHP(hp_gained)
  -- target:event trigger
  print('You heal with '..FAK:getName()..' for '..hp_gained..' hp.')
end

function activate.bandage(player, target, condition)
  local bandage = lookupMedical('bandage')
  local bandage_dice = dice:new(bandage:getDice())  
 
  if player.skills:check(flags.recovery) then 
    bandage_dice = bandage_dice+1
    if player.skills:check(flags.minor_healing) then 
      bandage_dice = bandage_dice+1
      if player.skills:check(flags.major_healing_adv) then 
        bandage_dice = bandage_dice^1
        bandage_dice = bandage_dice+1
      end        
    end
  end  
  
  local heal_rolls, hp_gained = dice.roll(bandage_dice), 0
  for _, heal in ipairs(heal_rolls) do hp_gained = hp_gained + heal end
  target:updateHP(hp_gained)
  -- target:event trigger
  print('You heal with '..bandage:getName()..' for '..hp_gained..' hp.')
end

function activate.antidote(player, target, condition)
  local antidote = lookupMedical('antidote')
  local cure_chance = antidote:getAccuracy()  
  -- modify chance based on skills?
  
  local cure_success = dice.chance(cure_chance)
  -- target:updateStatusEffects?
  -- target:event trigger
  if cure_success then
    print('You cure with the '..antidote:getName()..'.')
  else
    print('You fail to cure with the '..antidote:getName()..'.')
  end
end  

function activate.syringe(player, target, condition)
  local syringe = lookupMedical('syringe')
  local inject_chance = syringe:getAccuracy()
  -- modify chance based on skills?
  
  local inject_success = dice.chance(inject_chance)
  target:killed('syringe')
  -- target:event trigger
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

function activate.radio(player, old_freq, new_freq, condition)
  player.inventory:updateRadio(player, 'remove', old_freq, condition)
  player.inventory:updateRadio(player, 'insert', new_freq, condition)
end

function activate.cellphone(player, condition)

end

function activate.sampler(player, target, condition)

end

function activate.GPS(player, condition)

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

--[[
--- JUNK
--]]

local book_xp_dice = {'1d3', '1d5', '1d7', '1d10'}

function activate.book(player, condition)
  local xp_dice_str = book_xp_dice[condition-1]
  local book_dice = dice:new(xp_dice_str)
  if player.skills:check(flags.bookworm) then book_dice = book_dice^1 end
  if player:isStaged('inside') and player:getSpotCondition() == 'powered' then book_dice = book_dice/2 end 
  local gained_xp = book_dice:rollAndTotal()
  player:updateXP(gained_xp)
end

function activate.newspaper(player, condition)
  -- event trigger
end

function activate.bottle(player, condition)
  player:updateHP(1)
end

return activate
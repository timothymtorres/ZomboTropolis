local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')
local organic_armor = require('code.player.zombie.organic_armor')

-------------------------------------------------------------------

local drag_prey = {}

function drag_prey.client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local human_n = p_tile:countPlayers('human', setting)
  assert(setting == 'inside', 'Must be inside building to drag prey')  
  assert(human_n > 0, 'Must have humans nearby to drag')
  --assert(p_tile:isOpen(), 'Building must have an open exit to drag prey')  
end

function drag_prey.server_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local human_n = p_tile:countPlayers('human', setting)
  assert(setting == 'inside', 'Must be inside building to drag prey')  
  assert(human_n > 0, 'Must have humans nearby to drag')
  --assert(p_tile:isOpen(), 'Building must have an open exit to drag prey')
end

local DRAG_PREY_HEALTH_THRESHOLD = 13

function drag_prey.activate(player, target)
  local has_been_dragged = DRAG_PREY_HEALTH_THRESHOLD >= target.stats:get('hp')
  
  if has_been_dragged then
    local y, x = player:getPos()
    local map = player:getMap()
    map[y][x]:remove(player, 'inside')
    map[y][x]:insert(player, 'outside') 
    
    map[y][x]:remove(target, 'inside')
    map[y][x]:insert(target, 'outside')    
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg, target_msg, msg
  
  if has_been_dragged then
    self_msg =   'You drag {target} outside.'
    target_msg = 'A zombie drags you outside.'
    msg =        'A zombie drags {target} outside.'  
  else
    self_msg =   'You attempt to drag {target} outside but are unsuccessful.'    
  end
  
  self_msg = self_msg:replace(target)
  msg =   msg and msg:replace(target)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  

  local event = {'drag_prey', player, target, has_been_dragged}  

  if has_been_dragged then
    local tile = player:getTile()    
    local settings = {exclude={}}  
    settings.exclude[player], settings.exclude[target] = true, true
    tile:broadcastEvent(msg, event, settings)
  else
    player.log:insert(self_msg, event)    
  end
end

-------------------------------------------------------------------

local armor = {}

function armor:client_criteria(player)
  assert(player.skills:check('armor'), 'Must have "armor" skill to create armor')

  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  assert(corpses, 'No available corpses to eat')
  
  local edible_corpse_present 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')  
end

function armor:server_criteria(player, armor_type)
  assert(player.skills:check('armor'), 'Must have "armor" skill to create armor')
  assert(not armor_type or player.skills:check('armor_adv'), 'Must have "armor_adv" skill to select armor')  

  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  assert(corpses, 'No available corpses to eat')
  
  local edible_corpse_present 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')  
end

function armor:activate(player, armor_type)
  local corpses = p_tile:getCorpses(player:getStage())
  local target
  local lowest_scavenger_num = 4
  
  -- finds the corpse with the lowest number of scavengers (fresh meat) 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      local corpse_scavenger_num = #corpse.carcass.carnivour_list
      if lowest_scavenger_num > corpse_scavenger_num then
        target = corpse
        lowest_scavenger_num = corpse_scavenger_num 
      end
    end
  end

  local nutrition_LV = target.carcass:devour(player)
  local armor_dice = dice:new('1d'..nutrition_LV)

  if player.skills:check('armor_adv') then armor_dice = armor_dice ^ 1 end
  local condition = armor_dice:roll()

  local Armor = armor_type or organic_armor[math.random(1, #organic_armor)]
  player.equipment:add('armor', Armor:new(condition))
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You mutate a corpse and gain a {armor}.'
  msg = msg:replace(self) -- This should work? Needs to be tested

--[[  Planning on redoing the armor code so these msgs will probably change  
  if armor_type == 'scale' then
    msg[1] = 'Your skin shapeshifts into hard scales that are resistant to bladed weapons.'  
  elseif armor_type == 'blubber' then
    msg[1] = 'Your body shapeshifts into a blubbery mass that is skilled at absorbing blunt weapon impacts.'
  elseif armor_type == 'gel' then
    msg[1] = 'Your body oozes goo out of various pores that is effective at absorbing heat.'
  elseif armor_type == 'sticky' then
    msg[1] = 'Your body secretes slime causing the various armor layers to become more resillent.'
  elseif armor_type == 'stretch' then
    msg[1] = 'Your skin becomes loose and rubbery causing projectiles to slow as they make contact.'
  end
--]]  

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'armor', player}  
  player.log:insert(msg, event)  
end

-------------------------------------------------------------------

return {drag_prey, armor}
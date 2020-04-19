local combat = require('code.player.combat')
local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')

local human_basic_actions = {}
-------------------------------------------------------------------

local function getNewPos(y, x, dir)
--[[
  +-------+
  ||8|1|2||
  ||7| |3||
  ||6|5|4||
  +-------+
--]]

  local dir_y, dir_x
  if dir == 1 then dir_x = x dir_y = y-1
  elseif dir == 2 then dir_x = x + 1 dir_y = y - 1
  elseif dir == 3 then dir_x = x + 1 dir_y = y
  elseif dir == 4 then dir_x = x + 1 dir_y = y + 1
  elseif dir == 5 then dir_x = x     dir_y = y + 1
  elseif dir == 6 then dir_x = x - 1 dir_y = y + 1
  elseif dir == 7 then dir_x = x - 1 dir_y = y
  elseif dir == 8 then dir_x = x - 1 dir_y = y - 1
  end
  return dir_y, dir_x
end

human_basic_actions.move = {}
local move = human_basic_actions.move

function move.server_criteria(player, dir)
  assert(dir, 'Cannot move without direction')  
  local y, x = player:getPos()
  local map = player:getMap()
  local dir_y, dir_x = getNewPos(y, x, dir)
  local outside_map = dir_y > #map or dir_y < 1 or dir_x > #map or dir_x < 1
  assert(not outside_map, 'Cannot move outside the quarantine')
end

local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}
local GPS_basic_chance, GPS_advanced_chance = 0.15, 0.20

function move.activate(player, dir)
  local y, x = player:getPos() 
  local map = player:getMap()
  local dir_y, dir_x = getNewPos(y, x, dir)
  local GPS, GPS_usage, GPS_condition

  if player:isStaged('inside') then
    map[y][x]:remove(player, 'inside')
    if map:isBuilding(dir_y, dir_x) and player.skills:check('roof_travel') then
      map[dir_y][dir_x]:insert(player, 'inside')    
    else
      map[dir_y][dir_x]:insert(player, 'outside')
    end
  else  -- player is outside
    GPS = player.inventory:searchForItem('GPS')
    if GPS then -- the GPS has a chance to avoid wasting ap on movement      
      local GPS_chance = (player.skils:check('gadgets') and GPS_advanced_chance) or GPS_basic_chance
      local GPS_usage = GPS_chance >= math.random()
      
      -- this is pretty much a hack (if a player's ap is 50 then they will NOT receive the ap)
      if GPS_usage then player.stats:update('ap', 1) end
      GPS_condition = player.inventory:updateDurability(GPS) 
    end
    
    map[y][x]:remove(player)
    map[dir_y][dir_x]:insert(player)
  end
  
  player:updatePos(dir_y, dir_x)  
 
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------

  local GPS_str = GPS_usage and 'using a GPS'
  local self_msg = 'You travel {dir} {with_GPS}.'
  local names = {dir=compass[dir], with_GPS=GPS_str}
  self_msg = self_msg:replace(names)

  if GPS_condition == 0 then 
    self_msg = self_msg..'Your '..tostring(GPS)..' is destroyed!'
  elseif GPS_condition and GPS:isConditionVisible(player) then 
    self_msg = self_msg..'Your '..tostring(GPS)..' degrades to a '..GPS:getConditionState()..' state.'
  end  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'move', player, dir, GPS_usage}    
  player.log:insert(self_msg, event)  
end

-------------------------------------------------------------------

human_basic_actions.attack = {}
local attack = human_basic_actions.attack

function attack.client_criteria(player)
  local player_targets, building_targets  
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1  -- subtract one from total b/c player on tile 
  
  if player_n > 0 then player_targets = true end
  if p_tile:isBuilding() then
    if p_tile:isFortified() then building_targets = true end
    if p_tile:isPresent('equipment') then building_targets = true end
  end
  assert(player_targets or building_targets, 'No available targets to attack')
end

function attack.server_criteria(player, target, weapon, inv_pos)
  local organic_weapon = weapon:isOrganic()

  if organic_weapon then 
    assert(organic_weapon == player:getMobType(), 'Cannot use this attack')
    assert(not inv_pos, "Organic weapon shouldn't be in inventory")
  else -- Weapon is NOT organic
    assert(weapon and inv_pos, 'Weapon not selected properly')
    assert(player.inventory:isPresent(inv_pos), 'Weapon missing from inventory')    
    
    local inv_item = player.inventory:getItem(inv_pos) 
    assert(inv_item == weapon, "Inventory item doesn't match weapon")    
  end

  -- need to check if target actually exists in player database... aka - target:isPresent()?!
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target has moved out of range')
end

function attack.activate(player, target, weapon, inv_ID)
  local target_class = target:getClassName()
  local attack, damage, critical = combat(player, target, weapon)
  local armor_condition, condition
  local armor

  if attack then 
    if target.equipment:isPresent('armor') and not weapon:isHarmless() then
      armor = target.equipment.armor
      local damage_type = weapon:getDamageType()
      local resistance = armor:getProtection(damage_type)
      damage = damage - resistance    
      -- do we need to add a desc if resistance is working?  (ie absorbing damage in battle log?)
      
      local retailation_damage = armor:getProtection('damage_melee_attacker')
      local is_melee_attack = weapon:getStyle() == 'melee'
      if is_melee_attack and retailation_damage > 0 then
        local retailation_hp_loss = -1*dice.roll(retailation_damage)
        player.stats:update('hp', retailation_hp_loss)
        -- insert some type of event?
      end
      
      local degrade_multiplier = 1 -- change this if we want a special weapon to degrade armor
      armor_condition = armor:updateArmorDurability(degrade_multiplier)
      if armor_condiiton == 0 then target.equipment:remove('armor') end
    end
    
    if target.skills:check('track') then
      target.condition.tracking:addScent(player)
    end
    
    local hp_loss = -1*damage
    target.stats:update('hp', hp_loss)
  
    if weapon:hasStatusEffect(player) then -- use this code for burn?  maime?
      local effect = weapon:getStatusEffect(player)
      target.status_effect:add(effect, player)
    end     
    
    if not weapon:isOrganic() then condition = player.inventory:updateDurability(weapon) end
  else -- attack missed
    if weapon:getStyle() == 'ranged' then condition = player.inventory:updateDurability(weapon) end -- ranged weapons lose durability even when they miss
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
      
  local self_msg = 'You attack {target} with your {weapon}' ..(
                                          (critical and   ' and score a critical hit!') or 
                                          (not attack and ' and miss.') or '.')
  local target_msg = 'You are attacked by {player} with their {weapon}'..(
                                                      (critical and   ' and they score a critical hit!') or 
                                                      (not attack and ' and they miss.') or '.')
  local msg = '{player} attacks {target} with their {weapon}'..(
                                              (critical and ' and they score a critical hit!') or 
                                            (not attack and ' and they miss.') or '.')                                                             
                                                            
  local names = {player=player, target=target, weapon=weapon}
  self_msg =     self_msg:replace(names)
  target_msg = target_msg:replace(names)
  msg =               msg:replace(names)

  if condition == 0 then
    self_msg = self_msg..'Your '..tostring(weapon)..' is destroyed!'
  elseif condition and weapon:isConditionVisible(player) then 
    self_msg = self_msg..'Your '..tostring(weapon)..' degrades to a '..weapon:getConditionState()..' state.'
  end

  if armor_condition == 0 then 
    self_msg = self_msg..'Their '..tostring(armor)..' is destroyed!'
    target_msg = target_msg..'Your '..tostring(armor)..' is destroyed!'
  --elseif armor_condition and armor:isConditionVisible(target) then    (should organic armor condition be visible to zombies?)
  --  target_msg = target_msg..'Your '..tostring(armor)..' degrades to a '..armor:getConditionState()..' state.'
  end

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  -------------------------------------------- 

  local event = {'attack', player, target, weapon, attack, damage, critical}  -- maybe remove damage from event list?  -- also add condition/single_use/item_destruction to this list?

  local settings = {stage=player:getStage(), exclude={}}
  settings.exclude[player], settings.exclude[target] = true, true

  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)
  
  local tile = player:getTile()
  tile:broadcastEvent(msg, event, settings)  
end

-------------------------------------------------------------------

human_basic_actions.enter = {}
local enter = human_basic_actions.enter

function enter.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to enter')
  assert(player:isStaged('outside'), 'Player must be outside building to enter')
end

function enter.activate(player)
  local y, x = player:getPos()
  local map = player:getMap()
  map[y][x]:remove(player, 'outside')
  map[y][x]:insert(player, 'inside')
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You enter the {building}.'
  msg = msg:replace(map[y][x])
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'enter', player, map[y][x]}  
  player.log:insert(msg, event)
end

-------------------------------------------------------------------

human_basic_actions.exit = {}
local exit = human_basic_actions.exit

function exit.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to exit')
  assert(player:isStaged('inside'), 'Player must be inside building to exit')
end

function exit.activate(player)
  local y, x = player:getPos()
  local map = player:getMap()
  map[y][x]:remove(player, 'inside')
  map[y][x]:insert(player, 'outside')

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You exit the {building}.'
  msg = msg:replace(map[y][x])
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'exit', player, map[y][x]}  
  player.log:insert(msg, event)  
end

return human_basic_actions
local combat =            require('code.player.combat')
local entangle =          require('code.player.condition.entangle') -- there should be a better way to add this code to player condition effects...
local equipmentActivate = require('code.location.building.equipment.operation.activate')
local enzyme_list =       require('code.player.enzyme_list')
local dice =              require('code.libs.dice')

local Item =              require('code.item.item')
--local Skill =     		  require('code.player.skills.skill')  Dunno how we are going to do this?

local broadcastEvent =    require('code.server.event')
string.replace =          require('code.libs.replace')

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

local move = {name='move'}

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

function move.outcome(player, dir)
  local y, x = player:getPos() 
  local map = player:getMap()
  local dir_y, dir_x = getNewPos(y, x, dir)
  local GPS_usage

  if player:isStaged('inside') then
    map[y][x]:remove(player, 'inside')
    if map:isBuilding(dir_y, dir_x) and player.skills:check('roof_travel') then
      map[dir_y][dir_x]:insert(player, 'inside')    
    else
      map[dir_y][dir_x]:insert(player, 'outside')
    end
  else  -- player is outside
    local inventory_has_GPS, inv_ID = player.inventory:search('GPS')
    if inventory_has_GPS then -- the GPS has a chance to avoid wasting ap on movement      
      local GPS_chance = (player.skils:check('gadgets') and GPS_advanced_chance) or GPS_basic_chance
      local GPS_usage = GPS_chance >= math.random()
      
      -- this is pretty much a hack (if a player's ap is 50 then they will NOT receive the ap)
      if GPS_usage then player:updateStat('ap', 1) end
      
      local GPS = player.inventory:lookup(inv_ID)
      if GPS:failDurabilityCheck(player) then GPS:updateCondition(-1, player, inv_ID) end  
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
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'move', player, dir, GPS_usage}    
  player.log:insert(self_msg, event)  
end

-------------------------------------------------------------------

local attack = {name='attack'}

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

function attack.server_criteria(player, target, weapon, inv_ID)
-- Weapon/Inventory checks [start]
  local organic_weapon = weapon:isOrganic()

  if organic_weapon then 
    assert(organic_weapon == player:getMobType(), 'Cannot use this attack')
    assert(not inv_ID, "Organic weapon shouldn't be in inventory")
    if weapon:isSkillRequired() then
      local weapon_skill_present = player.skills:check(weapon:getSkillRequired())
      assert(weapon_skill_present, 'Cannot use this attack without required skill')
    end
  else -- Weapon is NOT organic
    assert(player:isMobType('human'), 'Must be human to attack with items')
    assert(weapon and inv_ID, 'Weapon not selected properly')
    assert(player.inventory:check(inv_ID), 'Weapon missing from inventory')    
    
    local inv_item = player.inventory:lookup(inv_ID) 
    assert(inv_item:getFlag() == weapon:getFlag(), "Inventory item doesn't match weapon")    
  end
-- Weapon/Inventory checks [finish]
  
  local p_tile = player:getTile()
  local target_class = target:getClassName()
--print('target_class', target_class, target)

  if target_class == 'player' then
    -- need to check if target actually exists in player database... aka - target:isPresent()?!
    assert(target:isStanding(), 'Target has been killed')
    local t_tile = target:getTile()
    assert(p_tile == t_tile and player:getStage() == target:getStage(), 'Target has moved out of range')
  elseif target_class == 'equipment' then
    assert(p_tile:isBuilding(), 'No building present to target equipment for attack')
    assert(player:isStaged('inside'), 'Player must be inside building to attack equipment')
    assert(weapon:getObjectDamage('equipment'), 'Selected weapon unable to attack equipment')
    assert(p_tile[target_class]:isPresent(), 'Equipment target does not exist in building')     
  else -- target_class == 'building' then
    assert(p_tile:isBuilding(), 'No building near player to attack')
    assert(weapon:getObjectDamage('barricade'), 'Selected weapon cannot attack barricade') -- fix this later (check for door too!)
    assert(p_tile:isFortified(), 'No barricade or door on building to attack')
  end
end

local ARMOR_DAMAGE_MOD = 2.5

function attack.outcome(player, target, weapon, inv_ID)
  local target_class = target:getClassName()
  local attack, damage, critical = combat(player, target, weapon)
  local caused_infection  
  
  if attack then 
    if target_class == 'player' then
      if target.armor:isPresent() and not weapon:isHarmless() then
        local damage_type = weapon:getDamageType()
        local resistance = target.armor:getProtection(damage_type)
        damage = damage - resistance    
        -- do we need to add a desc if resistance is working?  (ie absorbing damage in battle log?)
        
        local retailation_damage = target.armor:getProtection('damage_melee_attacker')
        local is_melee_attack = weapon:getStyle() == 'melee'
        if is_melee_attack and retailation_damage > 0 then
          local retailation_hp_loss = -1*dice.roll(retailation_damage)
          player:updateStat('hp', retailation_hp_loss)
          -- insert some type of event?
        end
        
        local degrade_chance = math.floor(damage/ARMOR_DAMAGE_MOD) + 1  -- might wanna change this later?  Damage affects degrade chance?       
        if target.armor:failDurabilityCheck(degrade_chance) then target.armor:degrade(target) end
      end
      
      local zombie = (player:isMobType('zombie') and player) or (target:isMobType('zombie') and target)
      local human = (player:isMobType('human') and player) or (target:isMobType('human') and target)
      
      if zombie.skills:check('track') then
        zombie.condition.tracking:addScent(human)
      end
    --elseif target_class == 'building' then
    --elseif target_class == 'barricade' then
    --elseif target_class == equipment?
    end
    
    local hp_loss = -1*damage
    target:updateStat('hp', hp_loss)
  
    if weapon:hasConditionEffect(player) then
      local effect, duration, bonus_effect = weapon:getConditionEffect(player) --, condition)   for later?
      if effect == 'entangle' then
        local impale_bonus = bonus_effect and critical
        entangle.add(player, target, impale_bonus)
      elseif effect == 'infection' then
        -- infection_adv skill makes bites auto infect, infection skill requires a zombie to be entagled with the target to infect with bite
        if player.skills:check('infection_adv') or (player.skills:check('infection') and entangle.isTangledTogether(player, target)) then
          if not target.condition.infection:isImmune() and not target.condition.infection:isActive() then  --target cannot be immune or infection already active
            target.condition.infection:add() 
            caused_infection = true          
          end
        end         
      else -- normal effect process
        target.condition[effect]:add(duration, bonus_effect)
      end
    end     
    
    if player:isMobType('human') and not weapon:isOrganic() then
      local item = player.inventory:lookup(inv_ID)
      if item:isSingleUse() then player.inventory:remove(inv_ID) -- no need to do a durability check
      elseif item:failDurabilityCheck(player) then item:updateCondition(-1, player, inv_ID)
      end
    end
  else
    if player:isMobType('zombie') and player.skills:check('grapple') then 
      player.condition.entangle:remove() 
    elseif player:isMobType('human') and weapon:getStyle() == 'ranged' then
      local item = player.inventory:lookup(inv_ID)
      if item:isSingleUse() then player.inventory:remove(inv_ID) -- no need to do a durability check
      elseif item:failDurabilityCheck(player) then item:updateCondition(-1, player, inv_ID)
      end
    end
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

  -- infection message to the ZOMBIE only!  (human isn't notified until incubation wears off)
  if caused_infection then self_msg = self_msg .. '  They become infected.' end
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  -------------------------------------------- 

  local event = {'attack', player, target, weapon, attack, damage, critical, caused_infection}  -- maybe remove damage from event list?  

  local settings = {stage=player:getStage(), exclude={}}
  settings.exclude[player], settings.exclude[target] = true, true

  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)
  
  local tile = player:getTile()
  tile:broadcastEvent(msg, event, settings)  
end

-------------------------------------------------------------------

local enter = {name='enter'}

function enter.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to enter')
  assert(player:isStaged('outside'), 'Player must be outside building to enter')
end

function enter.outcome(player)
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

local exit = {name='exit'}

function exit.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to exit')
  assert(player:isStaged('inside'), 'Player must be inside building to exit')
end

function exit.outcome(player)
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


--[[    
function check.default(player, action)
  if check[action] then check[action](player) end
end

function criteria.default(action, player, ...)
  if criteria[action] then criteria[action](player, ...) end
end

function default.outcome(action, player, ...)
  return outcome[action](player, ...)
end
--]]

return {move, attack, enter, exit}
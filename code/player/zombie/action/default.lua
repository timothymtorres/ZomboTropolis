local combat =            require('code.player.combat')
local dice =              require('code.libs.dice')
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

local move = {name='move', ap={cost=2, modifier={sprint = -1}}}

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

  if player:isStaged('inside') then
    map[y][x]:remove(player, 'inside')
    map[dir_y][dir_x]:insert(player, 'outside')
  else  -- player is outside  
    map[y][x]:remove(player)
    map[dir_y][dir_x]:insert(player)
  end
  
  player:updatePos(dir_y, dir_x)  
 
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------

  local self_msg = 'You travel {dir}.'
  local names = {dir=compass[dir]}
  self_msg = self_msg:replace(names)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'move', player, dir}    
  player.log:insert(self_msg, event)  
end

-------------------------------------------------------------------

local attack = {name='attack', ap={cost=1}}

function attack.client_criteria(player)
  local player_targets, building_targets  
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1  -- subtract one from total b/c player on tile (filter out other zombies)
  
  if player_n > 0 then player_targets = true end
  if p_tile:isBuilding() then
    if p_tile:isFortified() then building_targets = true end
    if p_tile:isPresent('equipment') then building_targets = true end
  end
  assert(player_targets or building_targets, 'No available targets to attack')
end

function attack.server_criteria(player, target, weapon)
--[[ this code is unused (I may possibly add acid/special attacks for zombies later that requires a skill to unlock) 
  if weapon:isSkillRequired() then
    local weapon_skill_present = player.skills:check(weapon:getSkillRequired())
    assert(weapon_skill_present, 'Cannot use this attack without required skill')
  end 
--]] 
  
  local p_tile = player:getTile()
  local target_class = target:getName()
--print('target_class', target_class, target)

  if target_class == 'player' then
    -- need to check if target actually exists in player database... aka - target:isPresent()?!
    assert(target:isStanding(), 'Target has been killed')
    assert(player:isSameLocation(target), 'Target has moved out of range')
  elseif target_class == 'equipment' then
    assert(p_tile:isBuilding(), 'No building present to target equipment for attack')
    assert(player:isStaged('inside'), 'Player must be inside building to attack equipment')
    assert(weapon:getObjectDamage('equipment'), 'Selected weapon unable to attack equipment')
    assert(p_tile[target_class]:isPresent(), 'Equipment target does not exist in building')     
  elseif target_class == 'building' then
    assert(p_tile:isBuilding(), 'No building near player to attack')
    assert(weapon:getObjectDamage('barricade'), 'Selected weapon cannot attack barricade') -- fix this later (check for door too!)
    assert(p_tile:isFortified(), 'No barricade or door on building to attack')
  end
end

local ARMOR_DAMAGE_MOD = 2.5

function attack.activate(player, target, weapon)
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
      
      if player.skills:check('track') then
        player.status_effect.tracking:addScent(target)
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
        --local impale_bonus = bonus_effect and critical
        player.status_effect.entangle:add(player, target)
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
  else -- attack missed
    if player.skills:check('grapple') then player.status_effect.entangle:remove() end
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

local enter = {name='enter', ap={cost=1}}

function enter.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to enter')
  assert(player:isStaged('outside'), 'Player must be outside building to enter')
end

function enter.activate(player)
  local y, x = player:getPos()
  local map = player:getMap()
  -- make sure there are no fortifications and buildings door is open
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

local exit = {name='exit', ap={cost=1}}

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

return {move, attack, enter, exit}
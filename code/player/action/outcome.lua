local map =               require('code.location.map.class')
local combat =            require('code.player.combat')
local entangle =          require('code.player.condition.entangle')
local itemActivate =      require('code.item.use.activate')
local equipmentActivate = require('code.location.building.equipment.operation.activate')
local skillActivate =     require('code.player.skills.activate')
local enzyme_list =       require('code.player.enzyme_list')
local dice =              require('code.libs.dice')
local item =              require('code.item.class')
local broadcastEvent =    require('code.server.event')

Outcome = {}

local function getNewPos(y, x, dir)
--[[--DIR LAYOUT
  +-------------+
  || 8 | 1 | 2 ||
  || 7 |   | 3 ||
  || 6 | 5 | 4 ||
  +-------------+
--]]--DIR LAYOUT

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


local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}

function Outcome.move(player, dir)
  local y, x = player:getPos() 
  local map = player:getMap()
  local dir_y, dir_x = getNewPos(y, x, dir)
  local GPS_usage

  if player:isStaged('inside') then
    map[y][x]:remove(player, 'inside')
    if player:isMobType('human') and map:isBuilding(dir_y, dir_x) and player.skills:check('roof_travel') then
      map[dir_y][dir_x]:insert(player, 'inside')    
    else
      map[dir_y][dir_x]:insert(player, 'outside')
    end
  else  -- player is outside
    if player:isMobType('human') then
      local inventory_has_GPS, inv_ID = player.inventory:search('GPS')
      if inventory_has_GPS then 
        GPS_usage = Outcome.item('GPS', player, inv_ID) 
      end
    end
    
    map[y][x]:remove(player)
    map[dir_y][dir_x]:insert(player)
  end
  
  player:updatePos(dir_y, dir_x)    
  broadcastEvent(player, 'You travel ' .. compass[dir] .. (GPS_usage and ' using a GPS' or '') .. '.')
  
  -- return {GPS_usage}
end

local ARMOR_DAMAGE_MOD = 2.5

function Outcome.attack(player, target, weapon, inv_ID)
  local target_class = target:getClassName()
  local attack, damage, critical = combat(player, target, weapon)
  
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
            -- should probably add an infection message to the ZOMBIE only!  A human shouldn't be notfied immediately until damage is taken
            -- also should probably look at refactoring the msg system for player.log to make this easier           
          end
        end         
      else -- normal effect process
        target.condition[effect]:add(duration, bonus_effect)
      end
    end     
    
    if player:isMobType('human') and not weapon:isOrganic() then
      local item_INST = player.inventory:lookup(inv_ID)
      if item_INST:isSingleUse() then player.inventory:remove(inv_ID) -- no need to do a durability check
      elseif item_INST:failDurabilityCheck(player) then item_INST:updateCondition(-1, player, inv_ID)
      end
    end
  else
    if player:isMobType('zombie') and player.skills:check('grapple') then 
      player.condition.entangle:remove() 
    elseif player:isMobType('human') and weapon:getStyle() == 'ranged' then
      local item_INST = player.inventory:lookup(inv_ID)
      if item_INST:isSingleUse() then player.inventory:remove(inv_ID) -- no need to do a durability check
      elseif item_INST:failDurabilityCheck(player) then item_INST:updateCondition(-1, player, inv_ID)
      end
    end
  end

    broadcastEvent(player, 
      'You attack ' .. target:getUsername() .. ' with your ' .. weapon:getClassName() .. 
      (attack and critical and ' and score a critical hit!') or (not attack and ' and miss.') or '.'
    )
    broadcastEvent(target, 
      'You are attacked by ' .. target:getUsername() .. ' with their ' .. weapon:getClassName() .. 
      (attack and critical and ' and they score a critical hit!') or (not attack and ' and they miss.') or '.'
    )  
  
  --return {attack, damage, critical}  
end

function Outcome.search(player)
  local p_tile = player:getTile()
  local item, flashlight
  
  local player_has_flashlight, inv_ID = player.inventory:search('flashlight')
  local player_inside_unpowered_building = not p_tile:isPowered() and player:isStaged('inside')
  
  item = p_tile:search(player, player:getStage(), player_has_flashlight)
  
  if player_has_flashlight and player_inside_unpowered_building then -- flashlight is only used when building has no power
    local flashlight_INST = player.inventory:lookup(inv_ID)
    if flashlight_INST:failDurabilityCheck(player) then flashlight_INST:updateCondition(-1, player, inv_ID) end
  end
  
  if item then player.inventory:insert(item) end
  
  broadcastEvent(player, 
    'You search ' .. (flashlight and 'with a flashlight ' or ' ') .. 'and find ' .. 
    (item and ('a ' .. item:getClassName() ) or 'nothing') .. '.'
  )
  
  -- return {item, player_has_flashlight}
end

function Outcome.discard(player, inv_ID)
  local item = player.inventory:lookup(inv_ID)
  player:remove(inv_ID)
  broadcastEvent(player, 'You discard a '..item:getClassName()..'.')
  --return {item}
end

function Outcome.speak(player, message, target)
  local tile = player:getTile()
  
  if target then -- whisper to target only
    broadcastEvent(target, player:getUsername()..' said: "'..message..'"'  
    broadcastEvent(player, 'You whispered to '..target:getUsername()..':  "'..message..'"')
    broadcastEvent(tile, player:getUsername()..' whispers to '..target:getUsername(), {stage=player:getStage(), exclude={player:getUsername()=true, target:getUsername()=true})
  else -- say outloud to everyone
    broadcastEvent(player, 'You said:  "'..message..'"')  
    broadcastEvent(tile, player:getUsername()..' said:  "'..message..'"', {stage=player:getStage(), exclude={player:getUsername()=true, target:getUsername()=true})
  end
end

function Outcome.reinforce(player)
  local p_tile = player:getTile()
  local building_was_reinforced, potential_hp = p_tile.barricade:reinforceAttempt()
  local did_zombies_interfere = p_tile.barricade:didZombiesIntervene(player)
  
  if building_was_reinforced and not did_zombies_interfere then 
    p_tile.barricade:reinforce(potential_hp) 
    broadcastEvent(player, 'You reinforce the building making room for fortifications.')
  elseif did_zombies_interfere then
    broadcastEvent(player, 'You start to reinforce the building but a zombie lurches towards you.')    
  elseif not building_was_reinforced then
    broadcastEvent(player, 'You attempt to reinforce the building but fail.') -- should we do something with potential hp?
  end
  
  --return {did_zombies_interfere, building_was_reinforced, potential_hp}
end

function Outcome.enter(player)
  local y, x = player:getPos()
  local map = player:getMap()
  map[y][x]:remove(player, 'outside')
  map[y][x]:insert(player, 'inside')
  broadcastEvent(player, 'You enter the '..map[y][x]:getName()..' '..map[y][x]:getClassName()..'.')  
  
  --return {map[y][x]}
end

function Outcome.exit(player)
  local y, x = player:getPos()
  local map = player:getMap()
  map[y][x]:remove(player, 'inside')
  map[y][x]:insert(player, 'outside')
  broadcastEvent(player, 'You exit the '..map[y][x]:getName()..' '..map[y][x]:getClassName()..'.')  

  --return {map[y][x]}
end

function Outcome.respawn(player) 
  player:respawn() 
  
  if player:isMobType('zombie') then
    if player.skills:check('hivemind') then broadcastEvent(player, 'You animate to life quickly and stand.')
    else broadcastEvent(player, 'You reanimate to life and struggle to stand.') 
    end
  end
  broadcastEvent(player:getTile(), 'A nearby corpse rises to life.', {stage=player:getStage(), exclude={player:getUsername()=true}})      
end

function Outcome.ransack(player)
  local ransack_dice = dice:new('2d3')
  if player.skills:check('ransack') then ransack_dice = ransack_dice / 1 end
  if player.skills:check('ruin') then ransack_dice = ransack_dice ^ 4 end
  
  local building = player:getTile()
  building.integrity:updateHP(-1 * ransack_dice:roll() )
  local integrity_state = building.integrity:getState()
  return {integrity_state}
end

local corpse_effects = { 
  -- First come, first serve! (less xp and decay loss as corpse becomes more devoured)
  xp = {'1d10+5', '1d9+3', '1d7+2', '1d5+1', '1d3',
    digestion = {'1d18+12', '1d16+8', '1d12+6', '1d8+4', '1d4+2'},
  },  
  decay = {'1d200+300', '1d200+250', '1d200+200', '1d200+150', '1d200+100',
    digestion = {'1d400+600', '1d400+500', '1d400+400', '1d400+300', '1d400+200'},
  },
}

function Outcome.feed(player) 
  local p_tile, p_stage = player:getTile(), player:getStage()
  local tile_player_group = p_tile:getPlayers(p_stage)
  local target
  local lowest_scavenger_num = 5
  
  -- finds the corpse with the lowest number of scavengers (fresh meat) 
  for tile_player in pairs(tile_player_group) do
    local corpse_scavenger_num = #tile_player.carcass.carnivour_list
    if not tile_player:isStanding() and tile_player.carcass:edible(player) and lowest_scavenger_num > corpse_scavenger_num then
      target = tile_player
      lowest_scavenger_num = corpse_scavenger_num 
    end
  end
  
  local nutrition_lvl = target.carcass:devour(player)
  local xp_gained, decay_loss
  if player.skills:check('digestion') then 
    xp_gained = corpse_effects.xp.digestion[nutrition_lvl]
    decay_loss = corpse_effects.decay.digestion[nutrition_lvl]
  else
    xp_gained = corpse_effects.xp[nutrition_lvl]
    decay_loss = corpse_effects.decay[nutrition_lvl]
  end
  
  xp_gained, decay_loss = dice.roll(xp_gained), dice.roll(decay_loss)
    
  player:updateStat('xp', xp_gained)
  player.condition.decay:add(-1*decay_loss)
  
  broadcastEvent(player, 'You feed on a corpse.')
  broadcastEvent(player:getTile(), 'A zombie feeds on a corpse.', {stage=player:getStage(), exclude={player:getUsername()=true}})  
end

function Outcome.default(action, player, ...)
  return Outcome[action](player, ...)
end

function Outcome.item(item_name, player, inv_ID, target)
  local item_INST = player.inventory:lookup(inv_ID)
  local item_condition = item_INST:getCondition()
  local result = itemActivate[item_name](player, item_condition, target) 
  
  if item_INST:isSingleUse() and not item_name == 'syringe' and not item_name == 'barricade' then 
    player.inventory:remove(inv_ID) 
  elseif item_name == 'syringe' then -- syringes are a special case
    local antidote_was_created, syringe_was_salvaged = result[2], result[3]
    if antidote_was_created or not syringe_was_salvaged then player.inventory:remove(inv_ID) end
  elseif item_name == 'barricade' then -- barricades are also a special case
    local did_zombies_interfere = result[1]
    if not did_zombies_interfere then player.inventory:remove(inv_ID) end
  elseif item_INST:failDurabilityCheck(player) then item_INST:updateCondition(-1, player, inv_ID) 
  end
  return result
end

function Outcome.equipment(equipment, player, operation, ...)  -- condition degrade on use?
  return equipmentActivate[equipment](player, operation, ...) --unpack({...}))
end

function Outcome.skill(skill, player, target)
  if enzyme_list[skill] then
    local cost = player:getCost('ep', skill)
    player:updateStat('ep', cost)
  end    
  return skillActivate[skill](player, target)  
end

return Outcome
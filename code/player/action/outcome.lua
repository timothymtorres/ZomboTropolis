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
string.replace =          require('code.libs.replace')

local outcome = {}

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
local GPS_basic_chance, GPS_advanced_chance = 0.15, 0.20

function outcome.move(player, dir)
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
      if inventory_has_GPS then -- the GPS has a chance to avoid wasting ap on movement
        
        -- need to include code here to durability check GPS and degrade condition
        
        local GPS_chance = (player.skils:check('gadgets') and GPS_advanced_chance) or GPS_basic_chance
        local GPS_usage = GPS_chance >= math.random()
        
        -- this is pretty much a hack (if a player's ap is 50 then they will NOT receive the ap)
        if GPS_usage then player:updateStat('ap', 1) end
        --GPS_usage = outcome.item('GPS', player, inv_ID) -- Item.GPS:activate(GPS, player, inv_ID)
      end
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
  -------------   E V E N T   ----------------
  --------------------------------------------

  local event = {'move', player, dir, GPS_usage}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(self_msg, event)  
end

local ARMOR_DAMAGE_MOD = 2.5

function outcome.attack(player, target, weapon, inv_ID)
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

  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'attack', player, target, weapon, attack, damage, critical}  -- maybe remove damage from event list?  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  -------------------------------------------- 

  local settings = {stage=player:getStage(), exclude={}}
  settings.exclude[player], settings.exclude[target] = true, true

  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)
  
  local tile = player:getTile()
  tile:broadcastEvent(msg, event, settings)  
end

function outcome.search(player)
  local p_tile = player:getTile()
  local item, flashlight
  
  local player_has_flashlight, inv_ID = player.inventory:search('flashlight')
  local player_inside_unpowered_building = not p_tile:isPowered() and player:isStaged('inside')
  
  item = p_tile:search(player, player:getStage(), player_has_flashlight)
  
  if player_has_flashlight and player_inside_unpowered_building then -- flashlight is only used when building has no power
    flashlight = true
    local flashlight_INST = player.inventory:lookup(inv_ID)
    if flashlight_INST:failDurabilityCheck(player) then flashlight_INST:updateCondition(-1, player, inv_ID) end
  end
  
  if item then player.inventory:insert(item) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
   
  local msg = 'You search {with_flashlight} and find {item}.'
  local names = {
    with_flashlight = flashlight and 'with a flashlight' or '',
    item = item and 'a '..item or 'nothing', 
  }
  msg = msg:replace(names)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------  
  
  local event = {'search', player, item, flashlight}   
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------     
  
  player.log:insert(msg, event)
end

function outcome.discard(player, inv_ID)
  local item = player.inventory:lookup(inv_ID)
  player:remove(inv_ID)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
    
  local msg = 'You discard a {item}.'
  msg = msg:replace(item:getClassName())    
    
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
    
  local event = {'discard', player, inv_ID}    
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------   
  
  player.log:insert(msg, event)
end

function outcome.speak(player, message, target)  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local whispered_msg, self_msg, public_msg
  
  if target then -- whisper to target only
    whispered_msg = '{player} whispered: "{msg}"'
    self_msg =      'You whispered to {target}: "{msg}"'
    public_msg =    '{player} whispers to {target}.'
  else           -- say outloud to everyone
    self_msg =      'You said: "{msg}"'
    public_msg =    '{player} said: "{msg}"'
  end
  
  local names = {player=player, target=target, msg=message}
  whispered_msg = whispered_msg and whispered_msg:replace(names)
  self_msg =                             self_msg:replace(names)
  public_msg =                         public_msg:replace(names)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
    
  local event = {'speak', player, message, target}      
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  -------------------------------------------- 
  
  local settings = {stage=player:getStage(), exclude={}}
  settings.exclude[player], settings.exclude[target] = true, true  
  
  if target then
    player.log:insert(self_msg, event)
    target.log:insert(whispered_msg, event)
    event[3] = nil -- other players should not hear message
    
    local tile = player:getTile()
    tile:broadcastEvent(public_msg, event, settings)    
  else
    player:broadcastEvent(public_msg, self_msg, event)     
  end
end

function outcome.reinforce(player)
  local p_tile = player:getTile()
  local building_was_reinforced, potential_hp = p_tile.barricade:reinforceAttempt()
  local did_zombies_interfere = p_tile.barricade:didZombiesIntervene(player)
  
  if building_was_reinforced and not did_zombies_interfere then p_tile.barricade:reinforce(potential_hp) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
    
  local self_msg, msg
  
  if building_was_reinforced and not did_zombies_interfere then 
    self_msg, msg = 'You reinforce the building making room for fortifications.', '{player} reinforces the building making room for fortifications.'
  elseif did_zombies_interfere then
    self_msg, msg = 'You start to reinforce the building but a zombie lurches towards you.', '{player} starts to reinforce the building but is interrupted by a zombie.'    
  elseif not building_was_reinforced then
    self_msg, msg = 'You attempt to reinforce the building but fail.', '{player} attempts to reinforce the building but fails.'
  end    
  
  msg = msg:replace(player)
    
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
    
  local event = {'reinforce', player, did_zombies_interfere, building_was_reinforced, potential_hp} -- should we do something with potential hp?    
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------   
  
  player:broadcastEvent(msg, self_msg, event)  
end

function outcome.enter(player)
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
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'enter', player, map[y][x]}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  player.log:insert(msg, event)
end

function outcome.exit(player)
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
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'exit', player, map[y][x]}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  player.log:insert(msg, event)  
end

function outcome.respawn(player) 
  player:respawn()  
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'A nearby corpse rises to life'
  local self_msg = player.skills:check('hivemind') and 'You animate to life quickly and stand.' or 'You reanimate to life and struggle to stand.'  
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'respawn', player}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)    
end

function outcome.ransack(player)
  local ransack_dice = dice:new('2d3')
  if player.skills:check('ransack') then ransack_dice = ransack_dice / 1 end
  if player.skills:check('ruin') then ransack_dice = ransack_dice ^ 4 end
  
  local building = player:getTile()
  building.integrity:updateHP(-1 * ransack_dice:roll() )
  local integrity_state = building.integrity:getState()
  local building_was_ransacked = integrity_state == 'ransacked'  --local building_was_ruined = integrity_state == 'ruined'
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg =      'A zombie {destruction} the building.'
  local self_msg = 'You {destruction} the building.'  
  local destruction_type = building_was_ransacked and 'ransack' or 'ruin'
  
  self_msg = self_msg:replace(destruction_type)
  msg =           msg:replace(destruction_type..'s')
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'ransack', player, integrity_state}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)  
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

function outcome.feed(player) 
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
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg, self_msg = 'A zombie feeds on a corpse.', 'You feed on a corpse.'
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'feed', player}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  player:broadcastEvent(msg, self_msg, event)   
end

function outcome.default(action, player, ...)
  return outcome[action](player, ...)
end

function outcome.item(item_name, player, inv_ID, target)
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

function outcome.equipment(equipment, player, operation, ...)  -- condition degrade on use?
  return equipmentActivate[equipment](player, operation, ...) --unpack({...}))
end

function outcome.skill(skill, player, target)
  if enzyme_list[skill] then
    local cost = player:getCost('ep', skill)
    player:updateStat('ep', cost)
  end    
  return skillActivate[skill](player, target)  
end

return outcome
--[[
local lookupItem =    require('code.item.search')
local lookupWeapon=   require('code.item.weapon.search')
--]]
local map =               require('code.location.map.class')
local combat =            require('code.player.combat')
local entangle =          require('code.player.condition.entangle')
local itemActivate =      require('code.item.use.activate')
local equipmentActivate = require('code.location.building.equipment.operation.activate')
local skillActivate =     require('code.player.skills.activate')
local enzyme_list =       require('code.player.enzyme_list')
local dice =              require('code.libs.rl-dice.dice')

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

function Outcome.move(player, dir)
  local y, x = player:getPos() 
  local map = player:getMap()
  local dir_y, dir_x = getNewPos(y, x, dir)

  if player:isStaged('inside') then
    map[y][x]:remove(player, 'inside')
    if player:isMobType('human') and map:isBuilding(dir_y, dir_x) and player.skills:check('roof_travel') then
      map[dir_y][dir_x]:insert(player, 'inside')    
    else
      map[dir_y][dir_x]:insert(player, 'outside')
    end
  else
    map[y][x]:remove(player)
    map[dir_y][dir_x]:insert(player)
  end
  
  player:updatePos(dir_y, dir_x)
  return {dir}
end

local ARMOR_DAMAGE_MOD = 2.5

function Outcome.attack(player, target, weapon)
  local target_class = target:getClassName()
  local attack, damage, critical = combat(player, target, weapon)
  
  if attack then 
    if target_class == 'player' then -- what about barricades? buildings? equipment?
      if target.armor:isPresent() then  -- what if weapon is harmless?
        local damage_type = weapon:getDamageType()
        local resistance = target.armor:getProtection(damage_type)
        damage = damage - resistance
        
        local degrade_chance = math.floor(damage/ARMOR_DAMAGE_MOD) + 1
        local armor_is_damaged = target.armor:passDgygynkurabilityCheck(degrade_chance)        
        -- do we need to add a desc if resistance is working?  (ie absorbing damage in battle log?)
        
        local retailation_damage = target.armor:getProtection('damage_melee_attacker')
        local is_melee_attack = weapon:getStyle() == 'melee'
        if is_melee_attack and retailation_damage > 0 then
          local retailation_hp_loss = -1*dice:rollAndTotal(retailation_damage)
          player:updateStat('hp', retailation_hp_loss)
          -- insert some type of event?
        end
      end
      
      local zombie = (player:isMobType('zombie') and player) or (target:isMobType('zombie') and player)
      local human = (player:isMobType('human') and player) or (target:isMobType('human') and player)
      
      if zombie.skills:check('track') then
        zombie.condition.tracking:addScent(human)
      end
    end
    
    local hp_loss = -1*damage
    target:updateStat('hp', hp_loss)
  
    if weapon:hasConditionEffect(player) then
      local effect, duration, bonus_effect = weapon:getConditionEffect(player) --, condition)   for later?
      if effect == 'entangle' then
        local impale_bonus = bonus_effect and critical
        entangle.add(player, target, impale_bonus)
      else -- normal effect process
        target.condition[effect]:add(duration, bonus_effect)
      end
    end     
  else
    if player:isMobType('zombie') and player.skills:check('grapple') then
      player.condition.entangle:remove()
    end
  end  
  return {attack, damage, critical}
end

function Outcome.search(player)
--print('map_zone Outcome.search()', map_zone)
  local p_tile = player:getTile()
  local item = p_tile:search(player, player:getStage())
print('item:', item)
  if item then
    print('item found')
    player.inventory:insert(item)
    print('no item discovered')
  end
  return {item}
end

function Outcome.discard(player, inv_ID)
  local item = player.inventory:lookup(inv_ID)
  player:remove(inv_ID)
  return {item}
end

function Outcome.barricade(player)
  local building = player:getBuilding()
  local result = building:barricade()
  if result then
    print('barricaded building')
  else
    print('failed barricade')
  end
end

function Outcome.speak(player, message) -- , target)
  local tile = player:getTile()
  tile:listen(player, message, player:getStage()) 
end

function Outcome.enter(player)
  local y, x = player:getPos()
  local map = player:getMap()
  map[y][x]:remove(player, 'outside')
  map[y][x]:insert(player, 'inside')
  return {map[y][x]}
end

function Outcome.exit(player)
  local y, x = player:getPos()
  local map = player:getMap()
  map[y][x]:remove(player, 'inside')
  map[y][x]:insert(player, 'outside')
  return {map[y][x]}
end

function Outcome.respawn(player) player:respawn() end

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
  
  xp_gained, decay_loss = dice.rollAndTotal(xp_gained), dice.rollAndTotal(decay_loss)
    
  player:updateStat('xp', xp_gained)
  player.condition.decay:add(-1*decay_loss)
end

function Outcome.default(action, player, ...)
  return Outcome[action](player, ...)
end

function Outcome.item(item, player, target, inv_ID)
  local item = lookupItem(item)
  local item_name = item:getName()
--print('item_name Outcome.item', item_name)
  -- condition degrade on use?
  -- CONVERT INV_ID INTO CONDITION!!!
  return itemActivate[item_name](player, target, inv_ID) 
  -- degrade item
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
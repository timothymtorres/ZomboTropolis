local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')

-------------------------------------------------------------------

local ruin = {name='ruin', ap={cost=5, modifier={ruin = -1, ruin_adv = -2}}}

function ruin.client_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to ransack')
  assert(player:isStaged('inside'), 'Player must be inside building to ransack')

  assert(player.skills:check('ruin'), 'Must have "ruin" skill to use ability')  -- remove this later when abilities implement required_skill


  -- integrity code
  assert(p_building.integrity:isState('intact'), 'Cannot repair building that has full integrity')  
  if p_building.integrity:isState('ruined') then
    local n_zombies = p_building:countPlayers('zombie', 'inside')    
    assert(player.skills:check('renovate'), 'Must have "renovate" skill to repair ruins')
    assert(n_zombies == 0, 'Cannot repair building with zombies present')     
  end

  local n_humans = p_tile:countPlayers('human', 'inside')

  local integrity_hp = p_tile.integrity:getHP()
  assert(integrity_hp >= 0, 'Cannot ruin building that is already ruined')
  assert(integrity_hp == 0 and n_humans == 0, 'Cannot ruin building with humans present')
end

ruin.server_criteria = ruin.client_criteria

function ruin.activate(player)
  local building = player:getTile()
  building.integrity:updateHP(-1)
  local integrity_state = building.integrity:getState()
  local building_was_ransacked = integrity_state == 'ransacked'
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg =      'A zombie {destruction} the building.'
  local self_msg = 'You {destruction} the building.'  
  local destruction_type = building_was_ransacked and 'ransack' or 'ruin'
  
  self_msg = self_msg:replace(destruction_type)
  msg =           msg:replace(destruction_type..'s')
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'ruin', player, integrity_state}  
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

local acid = {name='acid', ap={cost=1}}

function acid.client_criteria(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to use acid')  
end

function acid.server_criteria(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to use acid')  
end

local ACID = {
  DEFAULT =   {CHANCE = 0.15, DICE = '1d2'},
  CORRODE =   {CHANCE = 0.20, DICE = '1d3'},
  ACID_ADV =  {CHANCE = 0.30, DICE = '1d4'},
}

function acid.activate(player, target) 
  local n_items = #target.inventory
  local acid_resistance = target.armor:isPresent() and target.armor:getProtection('acid') or 0
  local target_acid_immune = acid_resistance == 4
  
  local acid_type = (player.skills:check('acid_adv') and 'ACID_ADV') or (player.skills:check('corrode') and 'CORRODE') or 'DEFAULT'
  local to_hit_chance = ACID[acid_type].CHANCE
  local acid_successful = to_hit_chance >= math.random()
  
  local destroyed_items, damaged_items = {}, {}
    
  if acid_successful and not target_acid_immune and n_items > 0 then    
    local acid_dice = dice:new(ACID[acid_type].DICE, 0) - acid_resistance
    for inv_pos=n_items, 1, -1 do  -- count backwards due to table.remove being used in item:updateCondition
      local item = target.inventory:getItem(inv_pos)
      local acid_damage = acid_dice:roll()      
      
      -- firesuits are immune from acid
      if item:getClassName() ~= 'firesuit' and acid_damage > 0 then 

        local condition = target.inventory:updateDurability(item, -1*acid_damage)

        if condition == 0  or item:isSingleUse() then 
          destroyed_items[#destroyed_items + 1] = item -- item was destroyed
        else
          damaged_items[#damaged_items + 1] = item -- item was damaged  
        end        
      end 
    end
  end 
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg, target_msg 
  
  if acid_successful and target_acid_immune then
    self_msg =   'You spray {target} with acid but it has no effect.'
    target_msg = 'A zombie sprays you with acid but your inventory is protected by a firesuit.'
  elseif acid_successful and n_items == 0 then
    self_msg =   'You spray {target} with acid but they have no equipment.'
    target_msg = 'A zombie sprays you with acid but you have no items in your inventory.'  
  elseif acid_successful then
    self_msg =   'You spray {target} with acid.'
    target_msg = 'A zombie sprays you with acid.'
  else
    self_msg =   'You attempt to spray {target} with acid but are unsuccessful.'
    target_msg = 'A zombie attempts to spray acid at you but is unsuccessful.'
  end  
  
  self_msg = self_msg:replace(target)
  
  for _, damaged_item in ipairs(damaged_items) do
    self_msg = self_msg..'  The '..tostring(damaged_item)..' was damaged.'
    if damaged_item:isConditionVisible(target) then
      target_msg = target_msg..'  Your '..tostring(damaged_item)..' degrades to a '..damaged_item:getConditionState()..' state.'
    else
      target_msg = target_msg..'  Your '..tostring(damaged_item)..' was damaged.'
    end
  end
  
  for _, destroyed_item in ipairs(destroyed_items) do
    self_msg = self_msg..'  The '..tostring(destroyed_item)..' was destroyed!'
    target_msg = target_msg..'  Your '..tostring(destroyed_item)..' was destroyed!'
  end  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'acid', player, target, acid_successful, target_acid_immune}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

-------------------------------------------------------------------

return {ruin, acid}
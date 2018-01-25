local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')
local dice = require('code.libs.dice')

-------------------------------------------------------------------

local Fuel = class('Fuel', Item)

Fuel.FULL_NAME = 'fuel tank'
Fuel.WEIGHT = 10
Fuel.DURABILITY = 0
Fuel.CATEGORY = 'engineering'
Fuel.ap = {cost = 1}

function Fuel:client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to refuel')
  assert(p_tile.generator:isPresent(), 'Missing nearby generator to refuel')
end

Fuel.server_criteria = Fuel.client_criteria

function Fuel:activate(player)
  local building_tile = player:getTile()
  building_tile.generator:refuel()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You refuel the generator.'
  local msg =      '{player} refuels the generator.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'fuel', player}    
  player:broadcastEvent(msg, self_msg, event)     
end

-------------------------------------------------------------------

local Barricade = class('Barricade', Item)

Barricade.FULL_NAME = 'barricade'
Barricade.WEIGHT = 7
Barricade.DURABILITY = 0
Barricade.CATEGORY = 'engineering'
Barricade.ap = {cost = 1}

function Barricade:client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to barricade')
  assert(p_tile.barricade:roomForFortification(), 'There is no room available for fortifications')
  assert(p_tile.barricade:canPlayerFortify(player), 'Unable to make stronger fortification without required skills')  
  assert(not p_tile.integrity:isState('ruined'), 'Unable to make fortifications in a ruined building')
end

Barricade.server_criteria = Barricade.client_criteria

function Barricade:activate(player)
  local building_tile = player:getTile()
  local did_zombies_interfere = building_tile.barricade:didZombiesIntervene(player)
  
  if not did_zombies_interfere then building_tile.barricade:fortify(player, self.condition) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = not did_zombies_interfere and 'You fortify the building with a barricade.' or 'You start to fortify the building, but a zombie lurches towards you.'
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'barricade', player, did_zombies_interfere}    
  player.log:insert(msg, event)   

  return did_zombies_interefere -- not sure if there is a better way to deal with returning the result (needed for the item:updateDurability() code) [only used by syringes and barricades]
end

-------------------------------------------------------------------

local Toolbox = class('Toolbox', Item)

Toolbox.FULL_NAME = 'toolbox'
Toolbox.WEIGHT = 15
Toolbox.DURABILITY = 1
Toolbox.CATEGORY = 'engineering'
Toolbox.ap = {cost = 5, modifier = {repair = -1, repair_adv = -2}}

function Toolbox:client_criteria(player)
  local p_building = player:getTile()  
  assert(p_building:isBuilding(), 'No building nearby to repair')
  assert(player:isStaged('inside'), 'Must be inside building to repair')  

  local is_integrity_repairable = p_building.integrity:canRepair(player)
  local is_machine_repairable = p_building:isPresent('damaged machines')
  local is_door_repairable = p_building:isPresent('damaged door')

  local is_repair_available = is_integrity_repairable or is_machine_repairable or is_door_repairable
  assert(is_repair_available, 'Nothing available to repair')
end

function Toolbox.server_criteria(player, target)
  local p_building = player:getTile()  
  assert(p_building:isBuilding(), 'No building nearby to repair')
  assert(player:isStaged('inside'), 'Must be inside building to repair')  

  if target:isInstanceOf('Building') then
    --assert(p_building.integrity:canRepair(player), 'Unable to repair building')  Disabling this so we can narrow down the reason
    assert(not p_building.integrity:isState('intact'), 'Cannot repair building that has full integrity')  
    if p_building.integrity:isState('ruined') then
      local n_zombies = p_building:countPlayers('zombie', 'inside')    
      assert(player.skills:check('renovate'), 'Must have "renovate" skill to repair ruins')
      assert(n_zombies == 0, 'Cannot repair building with zombies present')     
    end    
  elseif target:isInstanceOf('Door') then
    assert(p_building:isPresent('damaged door'), 'No damaged door to repair')
  elseif target:isInstanceOf('Machine') then
    assert(target:isDamaged()), 'No damaged machines are present to repair')    
  end
--]]
end

function Toolbox:activate(player, target)
  local building = player:getTile()

  if target:isInstanceOf('Building') then building.integrity:updateHP(1) -- maybe instead of target = building_INST, make target = building.integrity instance?
  elseif target:isInstanceOf('Door') then building.door:updateHP(2)
  elseif target:isInstanceOf('Machine') then target:updateHP(2) -- pretty sure this won't work properly
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You repair the {target} {is_finished}.'
  local msg =      '{player} repairs the {target} {is_finished}.'
  local names = {player=player, target=target, is_finished=(target:isInstanceOf('Building') and building.integrity:isState('intact')) and 'completely' or ''}
  self_msg = self_msg:replace(names)
  msg =           msg:replace(names)   
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'toolbox', target}    
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

return {Fuel, Barricade, Toolbox}
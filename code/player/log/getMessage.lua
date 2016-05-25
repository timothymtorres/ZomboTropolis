local error_list = require('code.error.list')
local getTimeStamp = require('code.player.log.getTimeStamp')

--[[----------------------------------------------
  POV in below functions stands for Point-of-View and is used to determine which msg to narrate the action by.
  {
    [1] = first-person -  (ie. 'You killed John Doe with a crowbar')
    [2] = second-person - (ie. 'John Doe kills you with a crowbar')
    [3] = third-person -  (ie. 'John Doe kills Jane Doe with a crowbar')
  }
  
  **Note every action has a POV
--]]-----------------------------------------------

local description = {}
local msg = {}

function description.error(error_ID)
  msg = error_list[error_ID]
end

--[[--DIR/COMPASS LAYOUT
  +-------------+
  || 8 | 1 | 2 ||
  || 7 |   | 3 ||
  || 6 | 5 | 4 ||
  +-------------+
--]]--DIR/COMPASS LAYOUT
local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}

function description.move(player, dir)
  msg[1] = 'You travel '..compass[dir]..'.'
end

function description.search(player, item)
  if item then msg[1] = 'You search and find a '..item:getClassName()..'.'
  else msg[1] = 'You search and find nothing.'
  end
end

function description.attack(player, target, weapon, attack, damage, critical)
  local attack_msg = attack and 'succeed.' or 'miss.'
  local critical_msg = critical and 'score a critical hit!' or ''
  local end_msg = (attack and critical and critical_msg) or attack_msg
  msg[1] = 'You attack '..target:getUsername()..' with your '..weapon:getClassName()..' and '..end_msg
  msg[2] = 'You are attacked by '..target:getUsername()..' with their '..weapon:getClassName()..' and they '..end_msg
end

function description.discard(player, item)
  msg[1] = 'You discard a '..item..'.'
end

function description.barricade(player, result)

end

function description.enter(player, building)
  msg[1] = 'You enter the '..building:getName()..' '..building:getClassName()..'.'
end

function description.exit(player, building)
  msg[1] = 'You exit the '..building:getName()..' '..building:getClassName()..'.'
end

function description.respawn(player)
  if player:isMobType('zombie') then
print('player is zombie')
    if player.skills:check('resurrection') then
      msg[1] = 'You animate to life quickly and stand.'
    else
      msg[1] = 'You reanimate to life and struggle to stand.' 
    end
  end
  msg[3] = 'A nearby corpse rises to life.'    
end

local groan_description = {'disappointed', 'bored', 'pleased', 'satisfied', 'excited', 'very excited'}

function description.groan(player, y, x, range)
  
  if player:isMobType('human') then
    msg[3] = 'You hear a groan in the distance.'
  elseif player:isMobType('zombie') then
    msg[1] = 'You emit a '..groan_description[range]..' groan.'
    msg[3] = 'You hear a '..groan_description[range]..' groan'
    
    local player_y, player_x = player:getPos()
    local y_dist, x_dist = player_y - y, player_x - x
    if y_dist == 0 and x_dist == 0 then msg[3] = msg[3]..' at your current location.' end
    
    if y_dist > 0 then msg[3] = msg[3]..math.abs(y_dist)..' South'
    elseif y_dist < 0 then msg[3] = msg[3]..math.abs(y_dist)..' North'
    end
  
    if x_dist > 0 then msg[3] = msg[3]..math.abs(x_dist)..' East'
    elseif x_dist < 0 then msg[3] = msg[3]..math.abs(x_dist)..' West'
    end
    
    msg[3] = msg[3]..'.'
  end
end

function description.gesture(player, target)
  for k,v in pairs(target) do print(k,v) end
  local object
  if type(target) == 'number' then object = compass[target]
  elseif target:getClassName() == 'player' then object = target:getUsername()
  else object = 'the '..target:getName()..' '..target:getClassName() -- must be building
  end
  
  msg[1] = 'You gesture towards '..object..'.'
  msg[3] = 'A zombie gestures towards '..object..'.'
end

function description.drag_prey(player, target, drag_successful)
  if drag_successful then
    msg[1] = 'You drag '..target:getUsername()..' outside.'
    msg[3] = 'A zombie drags you outside.'
  else
    msg[1] = 'You attempt to drag '..target:getUsername()..' outside but are unsuccessful.'
  end
end

function description.feed(player)
  msg[1] = 'You feed on a corpse.'
  msg[3] = 'A zombie feeds on a corpse.'
end

function description.armor(player, armor_type)
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
end

function description.speak(player, message)
  msg[1] = 'You said:  "'..message..'"'
  msg[3] = player:getUsername()..' said: "'..message..'"'
end

---------------------------------------
---------------------------------------
--         JUST A DIVIDER            --
---------------------------------------
---------------------------------------

local function getMessage(event)
  local date, point_of_view, action, params = event.date, event.POV, event.action, event.params
  msg = {}
  -- add results to end of params table
  description[action](unpack(params))
  local str = (action == 'error' and msg) or msg[point_of_view]  
  local text = getTimeStamp(date)..' - '..str
  return text
end

return getMessage
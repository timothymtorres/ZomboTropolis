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

---------------------------------------
---------------------------------------
--             ZOMBIE                --
---------------------------------------
---------------------------------------

function description.drag_prey(player, target, drag_successful)
  if drag_successful then
    msg[1] = 'You drag '..target:getUsername()..' outside.'
    msg[2] = 'A zombie drags you outside.'
    msg[3] = 'A zombie drags '..target:getUsername()..' outside.'
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

local tracking_description = {
  advanced = {'very far away', 'far away', 'in the distance', 'in the area', 'in a nearby area', 'close', 'very close', 'here'},
  basic = {'far away', 'in the distance', 'in the area', 'close'},
}

function description.track(player, prey, prey_range_indexs)
  msg[1] = 'You sniff the air for prey.'
  msg[3] = 'A zombie smells the air for prey.'
    
  if prey then
    local has_advanced_tracking = player.skills:check('track_adv')  
    for i, target in ipairs(prey) do
      local description = has_advanced_tracking and tracking_description.advanced or tracking_description.basic
      local index = prey_range_indexs[i]
      msg[1] = msg[1]..'\n'..target:getUsername()..' is '..description[index]..'.'
    end
  else
    msg[1] = msg[1] .. 'There are no humans you are currently tracking.'
  end  
end

function description.speak(player, message)
  msg[1] = 'You said:  "'..message..'"'
  msg[3] = player:getUsername()..' said: "'..message..'"'
end

function description.acid(player, target, acid_successful, acid_immunity)
  if acid_successful and acid_immunity then
    msg[1] = 'You spray '..target:getUsername()..' with acid but it has no effect.'
    msg[2] = 'A zombie sprays you with acid but your inventory is protected by a firesuit.'
  elseif acid_successful then
    msg[1] = 'You spray '..target:getUsername()..' with acid.'
    msg[2] = 'A zombie sprays you with acid.'
  else
    msg[1] = 'You attempt to spray '..target:getUsername()..' with acid but are unsuccessful.'
    msg[2] = 'A zombie attempts to spray acid at you but is unsuccessful.'
  end
end

function description.ransack(player, integrity_state)
  if integrity_state == 'ransacked' then
    msg[1] = 'You ransack the building.'
    msg[3] = 'A zombie ransacks the building.'
  elseif integrity_state == 'ruined' then
    msg[1] = 'You ruin the building.'
    msg[3] = 'A zombie ruins the building.'
  end
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
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
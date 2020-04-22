local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')

local zombie_advanced_actions = {}
-------------------------------------------------------------------

local respawn = {}
zombie_advanced_actions.respawn = respawn

local respawn_settings = {
  MIN_HP = 20,
  MAX_HP = 50,
  ap_to_hp = {default = 5, resurrection = 10} -- ap cost varies
}

function respawn.client_criteria(player) 
  assert(not player:isStanding(), 'Must be dead for action')

  local has_resurrection = player.skills:check('resurrection') 
  local conversion_rate = respawn_settings.ap_to_hp[has_resurrection and 'resurrection' or 'default'] 

  local ap = player.stats:get('ap') 
  local ap_to_stand = respawn_settings.MIN_HP/conversion_rate
  assert(ap >= ap_to_stand, 'Not enough ap to respawn')
end  

function respawn.server_criteria(player, spent_ap) 
  assert(not player:isStanding(), 'You are already standing') 

  local has_resurrection = player.skills:check('resurrection') 
  local conversion_rate = respawn_settings.ap_to_hp[has_resurrection and 'resurrection' or 'default'] 

  local ap = player.stats:get('ap')
  local ap_to_stand = respawn_settings.MIN_HP/conversion_rate
  assert(spent_ap >= ap_to_stand, 'Not enough ap to respawn')
  assert(ap >= spent_ap, 'Ap spent to respawn exceeds current ap limit')

  local max_ap_spending_limit = respawn_settings.MAX_HP/conversion_rate
  assert(max_ap_spending_limit >= spent_ap, 'Ap spent to respawn exceeds hp limit bounds')
end

function respawn.activate(player, spent_ap) 
  local has_resurrection = player.skills:check('resurrection') 
  local conversion_rate = respawn_settings.ap_to_hp[has_resurrection and 'resurrection' or 'default'] 
  local hp_gained = conversion_rate*spent_ap + player.stats:getBonus('hp')

  player.stats:update('hp', hp_gained)
  player.stats:update('ap', -1*spent_ap)

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'A nearby corpse rises to life'
  local self_msg = player.skills:check('resurrection') and 'You animate to life quickly and stand.' or 'You reanimate to life and struggle to stand.'  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'respawn', player}  
  player:broadcastEvent(msg, self_msg, event)    
end

-------------------------------------------------------------------

local feed = {}
zombie_advanced_actions.feed = feed

function feed.client_criteria(player)
  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  assert(corpses, 'No available corpses to eat')
  
  local edible_corpse_present 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')   
end

function feed.server_criteria(player)
  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  assert(corpses, 'No available corpses to eat')
  
  local edible_corpse_present 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')  
end

local corpse_effects = { 
  -- First come, first serve! (less xp and decay loss as corpse becomes more devoured)
  xp = {'1d10+5', '1d9+3', '1d7+2', '1d5+1'},
  satiation = {'1d400+600', '1d400+500', '1d400+400', '1d400+300'},
  description = {'very fresh', 'fresh', 'old', 'very old'},
  hp_gain = {default = 15, rejuvenate = 30},
}

function feed.activate(player) 
  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  local target
  local lowest_scavenger_num = 4
  
  -- finds the corpse with the lowest number of scavengers (fresh meat) 
  for corpse in pairs(corpses) do

    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      local corpse_scavenger_num = #corpse.carcass.carnivour_list
      if lowest_scavenger_num > corpse_scavenger_num then
        target = corpse
        lowest_scavenger_num = corpse_scavenger_num 
      end
    end
  end
  
  local nutrition = target.carcass:devour(player)
  local xp, satiation = corpse_effects.xp[nutrition], corpse_effects.satiation[nutrition]
  local hp_gained = corpse_effects.hp_gain[player.skills:check('rejuvenate') and 'rejuvenate' or 'default']

  player.stats:update('xp', dice.roll(xp))
  player.hunger:update(-1*dice.roll(satiation)) 
  player.stats:update('hp', hp_gained)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg, self_msg = 'A zombie feeds on a corpse.', 'You feed on a [description] corpse.'
  self_msg = self_msg:replace(corpse_effects.description[nutrition])

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'feed', player}  
  player:broadcastEvent(msg, self_msg, event)   
end

-------------------------------------------------------------------

return zombie_advanced_actions
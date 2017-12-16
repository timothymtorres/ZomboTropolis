local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')
local abilities = require('code.player.zombie.ability.abilities')
string.replace = require('code.libs.replace')

-------------------------------------------------------------------

local respawn = {name='respawn', ap={cost=10, modifier={hivemind = -5}}}

function respawn.client_criteria(player) assert(not player:isStanding(), 'Must be dead for action') end  

function respawn.server_criteria(player) assert(not player:isStanding(), 'You are already standing') end

function respawn.activate(player) 
  player:respawn()  
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'A nearby corpse rises to life'
  local self_msg = player.skills:check('hivemind') and 'You animate to life quickly and stand.' or 'You reanimate to life and struggle to stand.'  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'respawn', player}  
  player:broadcastEvent(msg, self_msg, event)    
end

-------------------------------------------------------------------

local feed = {name='feed', ap={cost=1}}

function feed.client_criteria(player)
  local p_tile, p_stage = player:getTile(), player:getStage()
  local corpse_n = p_tile:countCorpses(p_stage)
  assert(corpse_n > 0, 'No available corpses to eat')
  
  local edible_corpse_present 
  local tile_player_group = p_tile:getPlayers(p_stage)
  for tile_player in pairs(tile_player_group) do
    if not tile_player:isStanding() and tile_player:isMobType('human') and tile_player.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')   
end

function feed.server_criteria(player)
  local p_tile, p_stage = player:getTile(), player:getStage()
  local corpse_n = p_tile:countCorpses(p_stage)
  assert(corpse_n > 0, 'No available corpses to eat')
  
  local edible_corpse_present 
  local tile_player_group = p_tile:getPlayers(p_stage)
  for tile_player in pairs(tile_player_group) do
    if not tile_player:isStanding() and tile_player:isMobType('human') and tile_player.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')
end

local corpse_effects = { 
  -- First come, first serve! (less xp and decay loss as corpse becomes more devoured)
  xp = {'1d10+5', '1d9+3', '1d7+2', '1d5+1', '1d3'},
  satiation = {'1d400+600', '1d400+500', '1d400+400', '1d400+300', '1d400+200'},
  description = {'very fresh', 'fresh', '', 'old', 'very old'}
}

function feed.activate(player) 
  local p_tile, p_stage = player:getTile(), player:getStage()
  local tile_player_group = p_tile:getPlayers(p_stage)
  local target
  local lowest_scavenger_num = 5
  
  -- finds the corpse with the lowest number of scavengers (fresh meat) 
  for tile_player in pairs(tile_player_group) do

    if not tile_player:isStanding() and tile_player:isMobType('human') and tile_player.carcass:edible(player) then
      local corpse_scavenger_num = #tile_player.carcass.carnivour_list
      if lowest_scavenger_num > corpse_scavenger_num then
        target = tile_player
        lowest_scavenger_num = corpse_scavenger_num 
      end
    end
  end
  
  local nutrition = target.carcass:devour(player)
  local xp, satiation = corpse_effects.xp[nutrition], corpse_effects.satiation[nutrition]
    
  player:updateStat('xp', dice.roll(xp))
  player.hunger:update(-1*dice.roll(satiation)) 
  
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

local ability = {name='ability'}

-- I'm pretty sure we can skip having ability client_critera here?  Client_critera will be called via composer scenes in UI code.
function ability.client_criteria(name, player) --, target)
  local skill = abilities[name].REQUIRED_SKILL
  assert(player.skills:check(skill), 'Must have required skill to use ability')
  --[[  Decide if we want enzyme code later...
  if enzyme_list[name] then
    local cost, ep = player:getCost('ep', name), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
  end
  --]]
  if abilities[name].client_criteria then abilities[name].client_criteria(player) end
end

function ability.server_criteria(name, player, ...)
  local skill = abilities[name].REQUIRED_SKILL
  assert(player.skills:check(skill), 'Must have required skill to use ability')
  --[[  Decide if we want enzyme code later...
  if enzyme_list[name] then
    local cost, ep = player:getCost('ep', name), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
  end
  --]]
  if abilities[name].server_criteria then abilities[name].server_criteria(player, ...) end
end

function ability.activate(name, player, target)
  --[[
  if enzyme_list[name] then
    local cost = player:getCost('ep', name)
    player:updateStat('ep', cost)
  end 
  --]]   
  abilities[name].activate(player, target)
end

return {respawn, feed, ability}
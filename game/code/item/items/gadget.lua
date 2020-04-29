local Gadget = {}
local Item = require('code.item.item')

-------------------------------------------------------------------

local Radio = {}
Gadget.Radio = Radio 

function Radio:initialize(condition_setting)
  Item.initialize(self, condition_setting)
  self.channel = math.random(1, 1024)
  self.power = false
end

function Radio:togglePower(player, setting)
  if setting == true then player.network:add(self.channel, self)
  elseif setting == false then player.network:remove(self.channel)
  end
  self.power = setting
end

function Radio:retune(player, channel)
  if self.power == true then
    player.network:remove(self.channel)
    player.network:add(channel, self)
  end
  self.channel = channel
end

function Radio:server_criteria(player, setting)
  assert(setting, 'Must have selected a radio setting')
  if type(setting) == 'number' then 
    assert(setting > 0 and setting <= 1024, 'Radio frequency is out of range')
    assert(not player.network:check(setting), 'You already have a radio set to this channel')
  elseif type(setting) == 'boolean' then
    assert(self.power ~= setting, 'New radio power setting is identical to current state')
    if setting == true then
      assert(not player.network:check(self.channel), 'You already have a radio set to this channel')  
    end
  --elseif type(setting) == 'string' then  (handheld radios cannot transmit...)
  else
    assert(false, 'Radio setting type is incorrect')
  end
end

function Radio:activate(player, setting)
  if type(setting) == 'number' then self:retune(player, setting)
  elseif type(setting) == 'boolean' then self:togglePower(player, setting)
  --elseif type(setting) == 'string' then (handheld radios cannot transmit....)
  end
end

-------------------------------------------------------------------

local GPS = {}
Gadget.GPS = GPS

---------------------------------------------------------------------

local Flashlight = {}
Gadget.Flashlight = Flashlight

---------------------------------------------------------------------

local Pheromone = {}
Gadget.Pheromone = Pheromone

function Pheromone:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target is out of range')
  assert(target:isMobType('human'), 'Target must be a human')  
end

function Pheromone:activate(player, setting)
  if player.status_effect:isActive('track') then
    player.status_effect.track:scentRemoval(self.condition)
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg =   'You spray {target} with pheromones.'
  local target_msg = '{player} sprays you with pheromones.'
  self_msg =     self_msg:replace(target)
  target_msg = target_msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'pheromone', player, target}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event) 
end

---------------------------------------------------------------------

local Flare = {}
Gadget.Flare = Flare

function Flare:client_criteria(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

function Flare:server_criteria(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

local flare_ranges = {6, 9, 12, 15}

function Flare:activate(player)
  local y, x = player:getPos()
  local tile = player:getTile()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  -- Groan point of orgin
  local self_msg =   'You fire a flare into the sky.'
  local nearby_msg = '{player} fires a flare into the sky.'
  local msg =        'A flare was fired {pos}.'
  
  local words = {player=player, pos='{'..y..', '..x..'}'}
  nearby_msg = nearby_msg:replace(words)
  msg =               msg:replace(words)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'flare', player} -- (y, x, range) include this later?  We can use sound effects when this event is triggered based on distances

  player:broadcastEvent(nearby_msg, self_msg, event)
  
  local settings = {stage='inside', exclude={}} -- broadcast to players on the same tile that are inside  
  tile:broadcastEvent(msg, event, settings) 
  
  settings.stage = nil
  settings.range = flare_ranges[self.condition]
  settings.exclude[tile] = true
  tile:broadcastEvent(msg, event, settings)     -- broadcast using a range and exclude the tile
end

-------------------------------------------------------------------

--[[
gadget.cellphone.full_name = 'cellphone'
gadget.cellphone.weight = 2
gadget.cellphone.durability = 200

gadget.loudspeaker.full_name = 'loudspeaker'
gadget.loudspeaker.weight = 1

gadget.binoculars.full_name = 'binoculars'
gadget.binoculars.weight = 2

--function activate.cellphone(player, condition) end

function criteria.cellphone(player)
  -- check if phone towers functional
  -- need light?
  -- need battery
end

function activate.loudspeaker(player, condition, message)
  if condition == 3 then
    --event 3x3 inside/outside
  elseif condition == 2 then
    --event 3x3 if outside, inside/outside
  elseif condition == 1 then
    --event inside/outside
  end
  
  -- do event - broadcast to all tiles of large building
end

function check.cellphone(player) end -- check if phone towers functional/need light/need battery
--]]

return Gadget
local class = require('code.libs.middleclass')
local Item = require('code.item.item')

-------------------------------------------------------------------

local Radio = class('Radio', Item)

Radio.FULL_NAME = 'portable radio'
Radio.WEIGHT = 3
Radio.DURABILITY = 100
Radio.CATEGORY = 'research'
Radio.MASTER_SKILL = 'gadget'
Radio.ap = {cost = 1}

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

local GPS = class('GPS', Item)

GPS.FULL_NAME = 'global position system'
GPS.WEIGHT = 2
GPS.DURABILITY = 50
GPS.CATEGORY = 'research'
GPS.MASTER_SKILL = 'gadget'


---------------------------------------------------------------------

local Flashlight = class('Flashlight', Item)

Flashlight.FULL_NAME = 'flashlight'
Flashlight.WEIGHT = 4
Flashlight.DURABILITY = 100
Flashlight.CATEGORY = 'research'
Flashlight.MASTER_SKILL = 'gadget'

---------------------------------------------------------------------

local Pheromone = class('Pheromone', Item)

Pheromone.FULL_NAME = 'pheromone spray'
Pheromone.WEIGHT = 4
Pheromone.DURABILITY = 0
Pheromone.CATEGORY = 'research'
Pheromone.MASTER_SKILL = 'gadget'

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

return {Radio, GPS, Flashlight, Pheromone}
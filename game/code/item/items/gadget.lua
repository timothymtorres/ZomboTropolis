local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local Frequency = require('code.server.network.frequency')

-------------------------------------------------------------------

local Radio = class('Radio', Item)

Radio.FULL_NAME = 'portable radio'
Radio.WEIGHT = 3
Radio.DURABILITY = 100
Radio.CATEGORY = 'research'
Radio.ap = {cost = 1}

function Radio:initialize(condition_setting)
  Item.initialize(self, condition_setting)
  self.freq = math.random(1, 1024)
  self.power = false
end

function Radio:server_criteria(player, setting)
  local freq 

  assert(setting, 'Must have selected a setting')
  if type(setting) == 'number' then 
    assert(setting > 0 and setting <= 1024, 'Radio frequency is out of range')
    freq = setting 
  elseif type(setting) == 'boolean' then
    freq = self.freq
    assert(self.power == setting, 'New radio power setting is identical to current state')
  else
    assert(false, 'Radio setting type is incorrect')
  end

  if setting ~= false then
    assert(not Frequency:check(freq, player), 'You already have a radio set to this frequency')
  end
end

function Radio:activate(player, setting)
  if type(setting) == 'number' then
    if self.power == true then
      Frequency:remove(self.freq, player)
      Frequency:add(setting, player)
    end
    self.freq = setting
  elseif type(setting) == 'boolean' then
    if setting == true then Frequency:add(self.freq, player)
    elseif setting == false then Frequency:remove(self.freq, player)
    end
    self.power = setting
  end
end

-------------------------------------------------------------------

local GPS = class('GPS', Item)

GPS.FULL_NAME = 'global position system'
GPS.WEIGHT = 2
GPS.DURABILITY = 50
GPS.CATEGORY = 'research'

---------------------------------------------------------------------

local Flashlight = class('Flashlight', Item)

Flashlight.FULL_NAME = 'flashlight'
Flashlight.WEIGHT = 4
Flashlight.DURABILITY = 100
Flashlight.CATEGORY = 'research'

---------------------------------------------------------------------

local Sampler = class('Sampler', Item)

Sampler.FULL_NAME = 'lab sampler'
Sampler.WEIGHT = 4
Sampler.DURABILITY = 20
Sampler.CATEGORY = 'research'

function Sampler:client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby') 
end

function Sampler:server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')  
  assert(target:isZombie(), 'Target must be a zombie')
  assert(player:isSameLocation(target), 'Target is out of range')  
end

function Sampler:activate(player, target) end

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

return {Radio, GPS, Flashlight, Sampler}
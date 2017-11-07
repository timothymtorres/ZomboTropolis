local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')

local Radio = class('Radio', ItemBase)

Radio.static = {
  FULL_NAME = 'portable radio',
  WEIGHT = 3,
  DURABILITY = 100,
  CATEGORY = 'research'
}

--function Radio.client_criteria(player) end --needs batteries/need light

-- this needs to be redone
function Radio.server_criteria(player, freq) 
  assert(freq > 0 and freq <= 1024, 'Radio frequency is out of range')  
end

-- this needs to be redone
function Radio.activate(player, condition, old_freq, new_freq)
  player.inventory:updateRadio(player, 'remove', old_freq, condition)
  player.inventory:updateRadio(player, 'insert', new_freq, condition)
end

-------------------------------------------------------------------

local GPS = class('GPS', ItemBase)

GPS.static = {
  FULL_NAME = 'global position system',
  WEIGHT = 2,
  DURABILITY = 50,
  CATEGORY = 'research'
}

---------------------------------------------------------------------

local Flashlight = class('Flashlight', ItemBase)

Flashlight.static = {
  FULL_NAME = 'flashlight',
  WEIGHT = 4,
  DURABILITY = 100,
  CATEGORY = 'research'
}

---------------------------------------------------------------------

local Sampler = class('Sampler', ItemBase)

Sampler.static = {
  FULL_NAME = 'lab sampler',
  WEIGHT = 4,
  DURABILITY = 20,
  CATEGORY = 'research'
}

function Sampler.client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby') 
end

function Sampler.server_criteria(player, target)
  assert(target:isStanding(), 'Target has been killed')  
  assert(target:isZombie(), 'Target must be a zombie')
  assert(targetInRange(player, target), 'Target is out of range')  
end

function Sampler.activate(player, condition, target) end

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
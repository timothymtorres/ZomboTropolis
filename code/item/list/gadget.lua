local gadget = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'research'
  durability = num (average # of uses before the item wears out)
--]]

gadget.radio = {}
gadget.radio.full_name = 'portable radio'
gadget.radio.weight = 3
gadget.radio.durability = 100

gadget.GPS = {}  -- GPS for humans should have a small chance to grant a free AP for movement
gadget.GPS.full_name = 'global position system'
gadget.GPS.weight = 2
gadget.GPS.durability = 50 

--[[
gadget.cellphone = {}
gadget.cellphone.full_name = 'cellphone'
gadget.cellphone.weight = 2
gadget.cellphone.durability = 200

gadget.sampler = {}
gadget.sampler.full_name = 'lab sampler'
gadget.sampler.weight = 4


gadget.loudspeaker = {}
gadget.loudspeaker.full_name = 'loudspeaker'
gadget.loudspeaker.weight = 1


gadget.binoculars = {}
gadget.binoculars.full_name = 'binoculars'
gadget.binoculars.weight = 2
--]]

gadget.flashlight = {}
gadget.flashlight.full_name = 'flashlight'
gadget.flashlight.weight = 4
gadget.flashlight.durability = 100


for item in pairs(gadget) do gadget[item].class_category = 'research' end

return gadget
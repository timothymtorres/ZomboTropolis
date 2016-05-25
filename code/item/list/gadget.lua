local gadget = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'research'
  condition_omitted = nil/true  (if omitted, item has no condition levels)  
  special = nil/4/16  (bit_flags for special) [radio_freq, ammo, color, battery_life, etc.] 
--]]

gadget.radio = {}
gadget.radio.full_name = 'portable radio'
gadget.radio.weight = 3

gadget.GPS = {}
gadget.GPS.full_name = 'global position system'
gadget.GPS.weight = 2

gadget.cellphone = {}
gadget.cellphone.full_name = 'cellphone'
gadget.cellphone.weight = 2

gadget.sampler = {}
gadget.sampler.full_name = 'lab sampler'
gadget.sampler.weight = 4

gadget.loudspeaker = {}
gadget.loudspeaker.full_name = 'loudspeaker'
gadget.loudspeaker.weight = 1

--[[  used for searching?  give search bonus?!
gadget.flashlight = {}
gadget.flashlight.full_name = 'flashlight'
gadget.flashlight.weight = 4
--]]

for item in pairs(gadget) do gadget[item].class_category = 'research' end

return gadget
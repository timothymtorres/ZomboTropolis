local medical = {}

--[[
  {
    full_name = 'insert name'
    
    *optional*
    
    dice = '?d?'
    accuracy = 0.00 (base chance to hit)    
    one_use = true/nil (is disposed of after one use)
  } 
--]]

--[[
---  HEALING
--]]

medical.FAK = {}
medical.FAK.full_name = 'first aid kit'
medical.FAK.dice = '1d5'
medical.FAK.one_use = true

medical.bandage = {}
medical.bandage.full_name = 'bandage'
medical.bandage.dice = '1d3'
medical.bandage.one_use = true

--[[
--- INSTRUMENT
--]]

medical.syringe = {}
medical.syringe.full_name = 'syringe'
medical.syringe.accuracy = 0.25
medical.syringe.one_use = true

return medical
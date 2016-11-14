local medical = {}

--[[
  {
    full_name = 'insert name'
    group = {  
      healing (medkit/bandage)
      drugs (pills/antidote)
      misc. (special)
    }
    
    *optional*
    
    dice = '?d?'
    accuracy = 0.00 (base chance to hit)    
    organic = human/zombie/nil (results in default weapon choice, since weapon is attached to body)
    one_use = true/nil (is disposed of after one use)
  } 
--]]

--[[
---  HEALING
--]]

medical.FAK = {}
medical.FAK.full_name = 'first aid kit'
medical.FAK.group = {'healing', 'medkit'}
medical.FAK.dice = '1d5'
medical.FAK.one_use = true

medical.bandage = {}
medical.bandage.full_name = 'bandage'
medical.bandage.group = {'healing', 'bandage'}
medical.bandage.dice = '1d3'
medical.bandage.one_use = true

medical.herb = {}
medical.herb.full_name = 'herb'
medical.herb.group = {'healing', 'herb'}
medical.herb.dice = '1d2'
medical.herb.one_use = true

--[[
---  DRUGS
--]]

medical.antidote = {}
medical.antidote.full_name = 'antidote'
medical.antidote.group = {'drugs', 'antidote'}
medical.antidote.accuracy = 0.50
medical.antidote.one_use = true

--[[
--- INSTRUMENT
--]]

medical.syringe = {}
medical.syringe.full_name = 'syringe'
medical.syringe.group = {'instrument', 'syringe'}
medical.syringe.accuracy = 0.25
medical.syringe.one_use = true

return medical
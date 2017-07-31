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
    durability = 0/1/+num    [0 = one use, 1 = one usage each time, +num = 1/num chance of usage]    
  } 
--]]

--[[
---  HEALING
--]]

medical.FAK = {}
medical.FAK.full_name = 'first aid kit'
medical.FAK.group = {'healing', 'medkit'}
medical.FAK.dice = '1d5'
medical.FAK.durability = 0

medical.bandage = {}
medical.bandage.full_name = 'bandage'
medical.bandage.group = {'healing', 'bandage'}
medical.bandage.dice = '1d3'
medical.bandage.durability = 0

medical.herb = {}
medical.herb.full_name = 'herb'
medical.herb.group = {'healing', 'herb'}
medical.herb.dice = '1d2'
medical.herb.durability = 0

--[[
---  DRUGS
--]]

medical.antibodies = {}
medical.antibodies.full_name = 'antibodies'
medical.antibodies.group = {} -- skills invovled?
medical.antibodies.dice = '10d10'
medical.antibodies.durability = 0

medical.antidote = {}
medical.antidote.full_name = 'antidote'
medical.antidote.group = {}
medical.antidote.durability = 1
--medical.antidote.accuracy = 0.50

--[[
--- INSTRUMENT
--]]

medical.syringe = {}
medical.syringe.full_name = 'syringe'
medical.syringe.group = {'instrument', 'syringe'}
medical.syringe.accuracy = 0.99999 --0.05
medical.syringe.durability = 0

return medical
local IsMedical = {}

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

function IsMedical:getAccuracy() return self.medical.ACCURACY end

function IsMedical:getDice() return self.medical.DICE end
  
--function IsMedical:getGroup() return self.group end 
  
return IsMedical  
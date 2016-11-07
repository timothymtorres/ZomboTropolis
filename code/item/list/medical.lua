local medical = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  designated_weapon = true/nil
  class_category = 'medical'/'research'
  one_use = true
--]]

medical.FAK = {}
medical.FAK.full_name = 'first aid kit'
medical.FAK.weight = 8
medical.FAK.class_category = 'medical'

medical.bandage = {}
medical.bandage.full_name = 'bandage'
medical.bandage.weight = 3
medical.bandage.class_category = 'medical'

medical.antidote = {}
medical.antidote.full_name = 'vial of antidote'
medical.antidote.weight = 1
medical.antidote.class_category = 'medical'

medical.syringe = {}
medical.syringe.full_name = 'revival syringe'
medical.syringe.weight = 5
medical.syringe.designated_weapon = true
medical.syringe.class_category = 'research'

for item in pairs(medical) do 
  medical[item].one_use = true
end

return medical
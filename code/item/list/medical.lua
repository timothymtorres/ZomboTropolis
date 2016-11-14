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

medical.bandage = {}
medical.bandage.full_name = 'bandage'
medical.bandage.weight = 3

medical.syringe = {}
medical.syringe.full_name = 'syringe'
medical.syringe.weight = 5

for item in pairs(medical) do 
  medical[item].one_use = true
  medical[item].class_category = 'research'
end

return medical
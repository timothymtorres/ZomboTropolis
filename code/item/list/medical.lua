local medical = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  designated_weapon = true/nil
  class_category = 'medical'/'research'
  durability = 0/1/+num    [0 = one use, 1 = one usage each time, +num = 1/num chance of usage]
--]]

medical.FAK = {}
medical.FAK.full_name = 'first aid kit'
medical.FAK.weight = 8
medical.FAK.durability = 0

medical.bandage = {}
medical.bandage.full_name = 'bandage'
medical.bandage.weight = 3
medical.bandage.durability = 0

medical.syringe = {}
medical.syringe.full_name = 'syringe'
medical.syringe.weight = 5
medical.syringe.durability = 0

medical.antibodies = {}
medical.antibodies.full_name = 'antibodies'
medical.antibodies.weight = 5
medical.antibodies.durability = 0

medical.antidote = {}
medical.antidote.full_name = 'antidote'
medical.antidote.weight = 5
medical.antidote.durability = 1

for item in pairs(medical) do 
  medical[item].class_category = 'research'
end

return medical
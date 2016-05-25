local barricade = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'engineering'
  condition_omitted = nil/true  (if omitted, item has no condition levels)
  special = nil/4/16  (bit_flags for special)  [radio_freq, ammo, color, battery_life, etc.] 
--]]

barricade.small = {}
barricade.small.full_name = 'small barricade'
barricade.small.size = 1
barricade.small.weight = 2
barricade.small.condition_omitted = true

barricade.medium = {}
barricade.medium.full_name = 'medium barricade'
barricade.medium.size = 2
barricade.medium.weight = 5
barricade.medium.condition_omitted = true

barricade.large = {}
barricade.large.full_name = 'large barricade'
barricade.large.size = 3
barricade.large.weight = 9
barricade.large.condition_omitted = true

barricade.heavy = {}
barricade.heavy.full_name = 'heavy barricade'
barricade.heavy.size = 4
barricade.heavy.weight = 14
barricade.heavy.condition_omitted = true

for item in pairs(barricade) do barricade[item].class_category = 'engineering' end

return barricade
local junk = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'research'
  condition_omitted = nil/true  (if omitted, item has no condition levels)  
  special = nil/4/16  (bit_flags for special) [radio_freq, ammo, color, battery_life, etc.]  
--]]

junk.book = {}
junk.book.full_name = 'book'
junk.book.weight = 2
junk.book.class_category = 'research'

junk.bottle = {}
junk.bottle.full_name = 'bottle'
junk.bottle.weight = 1
junk.bottle.class_category = 'junk'

junk.newspaper = {}
junk.newspaper.full_name = 'newspaper'
junk.newspaper.weight = 1
junk.newspaper.class_category = 'junk'
junk.newspaper.condition_omitted = true

return junk
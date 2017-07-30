local junk = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'research'
  durability = 0/1/+num    [0 = one use, 1 = one usage each time, +num = 1/num chance of usage]
--]]

junk.book = {}
junk.book.full_name = 'book'
junk.book.weight = 2
junk.book.class_category = 'research'
junk.book.durability = 0

junk.bottle = {}
junk.bottle.full_name = 'bottle'
junk.bottle.weight = 1
junk.bottle.class_category = 'junk'
junk.bottle.durability = 0

junk.newspaper = {}
junk.newspaper.full_name = 'newspaper'
junk.newspaper.weight = 1
junk.newspaper.class_category = 'junk'
junk.newspaper.durability = 0

return junk
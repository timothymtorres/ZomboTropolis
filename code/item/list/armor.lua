local armor = {}

--[[
  full_name = 'insert name'
  durability = num  (average # of attacks it takes to wear armor out) 
  resistance = {
    condition = {protection=num},
  }  
  
  ** As condition becomes worse armor starts to lose resistance (with the exception of a few armors)
--]]

armor.leather = {}
armor.leather.full_name = 'leather jacket'
armor.leather.durability = 32
armor.leather.resistance = {
  [0] = {blunt=1},
  [1] = {blunt=1},
  [2] = {blunt=1},
  [3] = {blunt=1},
}

armor.firesuit = {}
armor.firesuit.full_name = 'firesuit'
armor.firesuit.durability = 4
armor.firesuit.resistance = {
  [0] = {acid=1},
  [1] = {acid=2},
  [2] = {acid=3},
  [3] = {acid=4},
}

return armor
local armor = {}

--[[
  full_name = 'insert name'
  resistance = bullet/pierce/blunt/scorch/damage_melee_attacker/nil
  durability = num  (average # of attacks it takes to wear armor out) 
  required_skill = 'skill name'
--]]

armor.scale = {}
armor.scale.full_name = 'scale'
armor.scale.resistance = 'pierce'
armor.scale.durability = 16
armor.scale.required_skill = 'armor'

armor.blubber = {}
armor.blubber.full_name = 'blubber'
armor.blubber.resistance = 'blunt'  -- dampens impact energy
armor.blubber.durability = 16
armor.blubber.required_skill = 'armor'

armor.stretch = {}
armor.stretch.full_name = 'stretch'
armor.stretch.resistance = 'bullet' 
armor.stretch.durability = 8
armor.stretch.required_skill = 'ranged_armor'

armor.gel = {}
armor.gel.full_name = 'gel'
armor.gel.resistance = 'scorch'
armor.gel.durability = 16
armor.gel.required_skill = 'liquid_armor'

armor.sticky = {}
armor.sticky.full_name = 'sticky'
armor.sticky.resistance = nil -- sticky armor lacks resistance but greatly improves durability
armor.sticky.durability = 32
armor.sticky.required_skill = 'liquid_armor'

armor.bone = {}
armor.bone.full_name = 'bone'
armor.bone.resistance = 'damage_melee_attacker'
armor.bone.durability = 8
armor.bone.required_skill = 'pain_armor'

return armor
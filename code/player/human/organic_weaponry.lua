local class =          require('code.libs.middleclass')
local IsWeapon =       require('code.item.mixin.is_weapon')

local Fist = class('Fist'):include(IsWeapon)

Fist.FULL_NAME = 'fist'

Fist.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'hand'},
  DICE = '1d1',
  ACCURACY = 0.20,
  CRITICAL = 0.05,
  ORGANIC = 'human',
  MASTER_SKILL = 'martial_arts_adv',
}

function Fist:__tostring() return tostring(self.class) end

-------------------------------------------------------------------

return Fist
local groan, gesture, hivemind = unpack(require('code.player.zombie.ability.general'))
local drag_prey, armor = unpack(require('code.player.zombie.ability.brute'))
local ruin, acid = unpack(require('code.player.zombie.ability.hive'))
local mark_prey, track, hide = unpack(require('code.player.zombie.ability.hunter'))

local abilities = {
  -- GENERAL
  groan, gesture, hivemind
  -- BRUTE
  drag_prey, armor,
  -- HIVE
  ruin, acid,
  -- HUNTER
  mark_prey, track, hide,
}

for _, ability in ipairs(abilities) do
  abilities[ability.name] = ability
end

return abilities
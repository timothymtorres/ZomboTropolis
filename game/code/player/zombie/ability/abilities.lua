local drag_prey, groan, gesture, armor, ransack, mark_prey, track, hide, acid = unpack(require('code.player.zombie.ability.generic'))

local abilities = {
  -- GENERAL
  groan, gesture,
  -- BRUTE
  armor, drag_prey,
  -- HIVE
  acid, ransack,
  -- HUNTER
  track, mark_prey, hide,
}

for _, ability in ipairs(abilities) do
  abilities[ability.name] = ability
end

return abilities
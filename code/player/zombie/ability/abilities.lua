local drag_prey, groan, gesture, armor, ransack, mark_prey, track, acid = unpack(require('code.player.zombie.ability.generic'))

local abilities = {
  -- GENERAL
  groan, gesture,
  -- BRUTE
  armor, drag_prey,
  -- HIVE
  acid, ransack,
  -- HUNTER
  track, mark_prey,
}

for _, ability in ipairs(abilities) do
  abilities[ability.name] = ability
end

return abilities
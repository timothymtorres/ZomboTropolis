local drag_prey, groan, gesture, armor, ransack, mark_prey, track, acid = unpack(require('code.player.zombie.ability.generic'))

local ability = {
  -- GENERAL
  groan, gesture,
  -- BRUTE
  armor, drag_prey,
  -- HIVE
  acid, ransack,
  -- HUNTER
  track, mark_prey,
}

for _, ability_tbl in ipairs(ability) do
  ability[ability_tbl.name] = ability_tbl
end

return ability
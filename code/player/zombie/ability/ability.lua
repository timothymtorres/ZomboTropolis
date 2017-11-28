local move, attack, enter, exit =                          unpack(require('code.player.action.default'))
local ability = {
  -- GENERAL
  -- BRUTE
  -- HIVE
  -- HUNTER
}

for _, ability_tbl in ipairs(ability) do
  ability[ability_tbl.name] = ability_tbl
end

return ability
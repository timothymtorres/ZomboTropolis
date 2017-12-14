local move, attack, enter, exit = unpack(require('code.player.zombie.action.basic'))
local respawn, ransack, feed, ability = unpack(require('code.player.zombie.action.advanced'))

local action = {
  -- DEFAULT
  move, attack, enter, exit,
  -- ZOMBIE
  respawn, feed, ability,
}

for _, action_tbl in ipairs(action) do
  action[action_tbl.name] = action_tbl
end

return action
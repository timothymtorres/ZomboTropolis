local move, attack, enter, exit = unpack(require('code.player.zombie.action.basic'))
local respawn, ransack, feed, ability = unpack(require('code.player.zombie.action.advanced'))

local actions = {
  -- DEFAULT
  move, attack, enter, exit,
  -- ZOMBIE
  respawn, feed, ability,
}

for _, action in ipairs(actions) do
  actions[action.name] = action
end

return actions
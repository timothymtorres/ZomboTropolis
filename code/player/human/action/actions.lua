local move, attack, enter, exit = unpack(require('code.player.human.action.basic'))
local search, discard, speak, reinforce, item, equipment = unpack(require('code.player.human.action.advanced'))

local actions = {
  -- DEFAULT
  move, attack, enter, exit,
  -- HUMAN
  search, discard, speak, reinforce, item, equipment,
}

for _, action in ipairs(actions) do
  actions[action.name] = action
end

return actions
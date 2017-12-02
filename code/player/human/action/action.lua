local move, attack, enter, exit =                          unpack(require('code.player.action.default'))
local search, discard, speak, reinforce, item, equipment = unpack(require('code.player.action.human'))

local action = {
  -- DEFAULT
  move, attack, enter, exit,
  -- HUMAN
  search, discard, speak, reinforce, item, equipment,
}

for _, action_tbl in ipairs(action) do
  action[action_tbl.name] = action_tbl
end

return action
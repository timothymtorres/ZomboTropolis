local Entangle = require('code.player.status_effect.entangle')
local Infection = require('code.player.human.status_effect.infection')
local Immunity = require('code.player.human.status_effect.immunity')
local Track = require('code.player.human.status_effect.track')

local effects = {Entangle, Infection, Immunity, Track, Maim}

for _, Class in ipairs(effects) do
  effects[Class.name] = Class
end

return effects
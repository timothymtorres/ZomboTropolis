local class = require('code.libs.middleclass')

local TerminalNetwork = class('TerminalNetwork')

function TerminalNetwork:initialize(size)
  --[[  Do something like this for suburbs?
  for i=1, #suburbs do
    self[suburb] = {scanned_zombies = 0, total_xp_levels = 0}
  end
  --]]

  for y=1, size do
    self[y] = {}
    for x=1, size do
      self[y][x] = {scanned_zombies = 0, total_xp_levels = 0}
    end
  end
end

function TerminalNetwork:add(zombie)
  local y, x = zombie:getPos()
  self[y][x].scanned_zombies = self[y][x].scanned_zombies + 1
  self[y][x].total_xp_levels = self[y][x].total_xp_levels + zombie.skills:countFlags('skills')
end

function TerminalNetwork:remove(zombie)
  local y, x = zombie:getPos()
  self[y][x].scanned_zombies = self[y][x].scanned_zombies - 1
  self[y][x].total_xp_levels = self[y][x].total_xp_levels - zombie.skills:countFlags('skills')
end

return TerminalNetwork
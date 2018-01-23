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

function TerminalNetwork:access(terminal, human)
  
  local zombies_num, zombies_levels, zombies_pos 

  -- if ISP for suburb is powered then
  zombies_num = 0 --{suburb_1 = 27, suburb_2 = 37, etc. etc.}

  if human.skills:check('gadget') then 
    zombies_levels = 0 -- {suburb_1 =27, etc. etc.}
    if human.skills:check('terminal') then 
      zombies_pos = {1, 2, 3, 4, 5}
    end
  end

  return zombies_num, zombies_levels, zombies_pos
end

return TerminalNetwork
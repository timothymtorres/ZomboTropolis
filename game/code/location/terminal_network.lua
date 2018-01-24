local class = require('code.libs.middleclass')

local TerminalNetwork = class('TerminalNetwork')

--[[
Instead of showing every zombie on the map, each tile should have a variable that is
63 x 2 = 0-126 (6 bits)
For every 1 value for the 6 bits = 2 zombies

When mapping out the zombie positions, make an array of tiles that have zombies true/false.
This should narrow down the data being sent as a lot of tiles won't have scanned zombies.
Then send the zombie #'s.
--]]

function TerminalNetwork:initialize(size)
  --[[  Do something like this for suburbs?
  for i=1, #suburbs do
    self[suburb] = {scanned_zombies = 0, total_xp_levels = 0}
  end
  --]]
  self.scanned_zombies = 0
  self.total_xp_levels = 0

  for y=1, size do
    self[y] = {}
    for x=1, size do
      self[y][x] = {scanned_zombies = 0, total_xp_levels = 0}
    end
  end
end

function TerminalNetwork:add(zombie)
  local y, x = zombie:getPos()
  local xp_level = zombie.skills:countFlags('skills')
  self[y][x].scanned_zombies = self[y][x].scanned_zombies + 1
  self[y][x].total_xp_levels = self[y][x].total_xp_levels + xp_level

  self.scanned_zombies = self.scanned_zombies + 1
  self.total_xp_levels = self.total_xp_levels + xp_level
end

function TerminalNetwork:remove(zombie)
  local y, x = zombie:getPos()
  local xp_level = zombie.skills:countFlags('skills')
  self[y][x].scanned_zombies = self[y][x].scanned_zombies - 1
  self[y][x].total_xp_levels = self[y][x].total_xp_levels - xp_level

  self.scanned_zombies = self.scanned_zombies - 1
  self.total_xp_levels = self.total_xp_levels - xp_level  
end

local GADGET_SKILL_REDUCTION = 0.25
local TERMINAL_SKILL_REDUCTION = 0.50
local terminal_condition_mod = {1.00, 0.80, 0.65, 0.50}

function TerminalNetwork:access(terminal, human)
  local zombies_num, zombies_levels, zombies_pos 
  local skill_reduction = (human.skills:check('gadget') and GADGET_SKILL_REDUCTION or 0) +
                          (human.skills:check('terminal') and TERMINAL_SKILL_REDUCTION or 0)
  local error_of_margin = terminal_condition_mod[terminal:getCondition()] 
  error_of_margin = error_of_margin - error_of_margin*skill_reduction
  local margin = 1 + (math.random(-1*error_of_margin*100, error_of_margin*100)*0.01)

  -- if ISP for suburb is powered then
  zombies_num = math.floor(margin*self.scanned_zombies) --{suburb_1 = 27, suburb_2 = 37, etc. etc.}

  if human.skills:check('gadget') then 
    zombies_levels = math.floor(margin*self.total_xp_levels)
    if human.skills:check('terminal') then 
      zombies_pos = {} -- should only send Suburb maps
    end
  end

  return zombies_num, zombies_levels, zombies_pos
end

return TerminalNetwork
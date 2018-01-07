local class = require('code.libs.middleclass')

local Track = class('Track')

function Track:initialize(player) 
  self.player = player
  self.trackers = {}
end

function Track:addTracker(hunter) self.trackers[hunter] = true end

function Track:removeTracker(hunter) 
  self.trackers[hunter] = nil 
  if not next(self.trackers) then self.player.status_effect:remove('track') end
end

local PHEROMONES_TIME_REMOVAL = {50, 150, 250, 350}  -- TRACKING_TIME [150-250] VS TRACKING_ADV_TIME [200-350]

function Track:scentRemoval(condition) -- used for scent removal item
  local time = PHEROMONES_TIME_REMOVAL[condition]
  for hunter in pairs(self.trackers) do hunter.track:removeScent(self.player, time) end
end  

return Track
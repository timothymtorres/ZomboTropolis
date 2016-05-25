local class = require('code.libs.middleclass')
local b_list = require('code.location.building.list')
--local lookupItem = require('code.search.item')
local tile = require('code.location.tile.class')
local equipment = require('code.location.building.equipment.class')
local generator = require('code.location.building.equipment.generator.class')
local transmitter = require('code.location.building.equipment.transmitter.class')
local terminal = require('code.location.building.equipment.terminal.class')
local door = require('code.location.building.barrier.door.class')
local barricade = require('code.location.building.barrier.barricade.class')
local buildDesc = require('code.location.building.buildDesc')

local building = class('building', tile)

function building:initialize(map, y, x, name)
  tile.initialize(self, map, y, x, name)  
  self.inside_players = {}

  self.external_desc, self.internal_desc, self.powered_desc = buildDesc(tostring(self.class))
  
  self.door        = door:new(self)
  self.barricade   = barricade:new(self)
  
  self.generator   = generator:new(self)
  self.transmitter = transmitter:new(self)
  self.terminal    = terminal:new(self)  
end

function building:insert(player, setting) 
  if setting == 'inside' then self.inside_players[player] = player 
  elseif setting == 'outside' or setting == nil then self.outside_players[player] = player
  end
end

function building:remove(player, setting) 
  if setting == 'inside' then self.inside_players[player] = nil  
  elseif setting == 'outside' or setting == nil then self.outside_players[player] = nil 
  end
end

function building:install(equipment_type, condition) self[equipment_type]:install(condition) end

function building:barricade(size) self.barricade:updateHP(size) end

function building:blackout()
  -- 3x3 area do blackout event on tile(s)
end

function building:getBarrier() return (self.barricade:getHP() > 0 and 'barricade') or (self.door:getHP() > 0 and 'door') end  -- should this be a class?

function building:getEquipment()
  local machines = {}
  for machine in pairs(equipment.subclasses) do 
    if self[machine]:isPresent() then machines[#machines+1] = tostring(machine) end  -- should this be a class?
  end
  return machines
end

-- function building:getPos() return (NO NEED?)

function building:isPresent(setting)
  if setting == 'equipment' then
    for machine, i in pairs(equipment.subclasses) do
      if self[tostring(machine)]:isPresent() then return true end
    end
    return false 
  elseif setting == 'powered equipment' then
    return self:isPresent('equipment') and self:isPowered()
  else -- individual equipment
    local machine = setting
    return self[machine]:isPresent()
  end
end

-- function building:isOccupied()  great way to check for people inside when ruining

function building:isFortified() return self.barricade:getHP() > 0 and self.door:getHP() > 0 end

function building:isPowered() return self.generator:isActive() end

function building:isOpen() return self.barricade:isDestroyed() and (self.door:isOpen() or self.door:isDestroyed()) 
end

-- do we need this?!
function building:isDescPresent(desc_type) return (self[desc_type] and #self[desc_type] > 0) or false end

function building:updateHP(num) 
  if self:getBarrier() == 'barricade' then 
    self.barricade:updateHP(num) 
  else -- self:getBarrier() == 'door'
    self.door:updateHP(num) 
  end
end

function building:dataToClass(...) -- this should be a middleclass function (fix later)
  local combined_lists = {...}
  for _, list in ipairs(combined_lists) do
    for obj in pairs(list) do
      self[obj] = class(obj, self)
    --[  by removing this the initialize function is now defaulted to building.initialize
      self[obj].initialize = function(self_subclass, map, y, x, building_name)
        self.initialize(self_subclass, map, y, x, building_name)
      end
    --]]  
      for field, data in pairs(list[obj]) do self[obj][field] = data end
    end
  end
end

-- turn our list of buildings into building class
building:dataToClass(b_list)

return building
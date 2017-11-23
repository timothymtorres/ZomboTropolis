local class = require('code.libs.middleclass')
local TileBase = require('code.location.tile.tile_base')
local equipment = require('code.location.building.equipment.class')
local generator = require('code.location.building.equipment.generator.class')
local transmitter = require('code.location.building.equipment.transmitter.class')
local terminal = require('code.location.building.equipment.terminal.class')
local door = require('code.location.building.barrier.door.class')
local barricade = require('code.location.building.barrier.barricade.class')
local integrity = require('code.location.building.integrity.class')

local Building = class('Building', TileBase)

--[[
  FULL_NAME = 'insert name'
  BUILDING_TYPE = residential/government/industrial/commercial/generic
  door_missing = true/nil
  search_odds = {internal = num, external = num}/nil  
  item_chance = {item = .00 chance}
--]]

--[[-----------  SEARCH ODDS  ------------ 

mall = 60%
PD, FD, hospital = 50%
factory = 30-40%
library/school = 20%
home = 10%

--]]-----------  SEARCH ODDS  ------------

local OUTSIDE_SEARCH_ODDS, INSIDE_SEARCH_ODDS = .50, .15

Building.BUILDING_TYPE = 'generic'
Building.search_odds = {OUTSIDE = OUTSIDE_SEARCH_ODDS, INSIDE = INSIDE_SEARCH_ODDS}
Building.item_chance = {
  outside = {
    -- WEAPONS =  00.1%
    Knife = .001,

    -- MISC   =  09.9%
    Newspaper = .099,

    -- EQUIPMENT =  90%
    Barricade = .90,  
  },  
  inside =  {
   -- MEDICAL =  15%
          FAK = .05,
      Bandage = .10,

   -- WEAPONS =  30%
       Pistol = .03,
      Shotgun = .02,
          Bat = .15,
        Knife = .10,

      -- MISC =  40%
    Newspaper = .10,
         Book = .15,
       Bottle = .15,

      -- GEAR =  15%
        Radio = .05,
        Phone = .10, 
  }
}

function Building:initialize(map, y, x, name)
  TileBase.initialize(self, map, y, x, name)  
  self.inside_players = {}
  
  self.door        = door:new(self)
  self.barricade   = barricade:new(self)
  self.integrity   = integrity:new(self) 
  
  self.generator   = generator:new(self)
  self.transmitter = transmitter:new(self)
  self.terminal    = terminal:new(self) 
end

function Building:insert(player, setting) 
  if setting == 'inside' then self.inside_players[player] = player 
  elseif setting == 'outside' or setting == nil then self.outside_players[player] = player
  end
end

function Building:remove(player, setting) 
  if setting == 'inside' then self.inside_players[player] = nil  
  elseif setting == 'outside' or setting == nil then self.outside_players[player] = nil 
  end
end

function Building:install(equipment_type, condition) self[equipment_type]:install(condition) end

function Building:blackout()
  -- 3x3 area do blackout event on tile(s)
end

function Building:getBarrier() return (self.barricade:getHP() > 0 and 'barricade') or (self.door:getHP() > 0 and 'door') end  -- should this be a class?

function Building:getBarrierDesc() 
  local cade_str, space_str = self.barricade:getDesc()
  local door_str = self.door:getDesc()
  
  local no_cades_exist = (cade_str == 'secured')
  local is_entrance_open = no_cades_exist and (door_str == 'destroyed' or self.door:isOpen())
  local is_door_damaged = door_str ~= 'undamaged'
  
  cade_str = (is_entrance_open and 'left wide open') or cade_str
  door_str = (is_door_damaged and 'is '..door_str..' and ') or ''
  
  local door_desc = 'The building door '..door_str
  
  local cade_desc = (cade_str == 'left wide open' or cade_str == 'secured' and 'has been '..cade_str..'. ') or 'has a '..cade_str..' barricade. '
  local space_desc = 'There is '..space_str..' room available for fortifications.'
  
  return door_desc..cade_desc..space_desc
end

function Building:getEquipment()
  local machines = {}
  for machine in pairs(equipment.subclasses) do 
    if self[machine]:isPresent() then machines[#machines+1] = tostring(machine) end  -- should this be a class?
  end
  return machines
end

-- function Building:getPos() return (NO NEED?)

function Building:isPresent(setting)
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

-- function Building:isOccupied(mob_type)  great way to check for people inside when ruining

function Building:isFortified() return self.barricade:getHP() > 0 and self.door:getHP() > 0 end

function Building:isPowered() return self.generator:isActive() end

function Building:isOpen() return self.barricade:isDestroyed() and (self.door:isOpen() or self.door:isDestroyed()) end

-- do we need this?!
function Building:isDescPresent(desc_type) return (self[desc_type] and #self[desc_type] > 0) or false end

function Building:updateHP(num) 
  if self:getBarrier() == 'barricade' then 
    self.barricade:updateHP(num) 
  else -- self:getBarrier() == 'door'
    self.door:updateHP(num) 
  end
end

return Building
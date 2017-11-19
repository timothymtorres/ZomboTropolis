local class = require('code.libs.middleclass')
local TileBase = require('code.location.tile.tile_base')
local equipment = require('code.location.building.equipment.class')
local generator = require('code.location.building.equipment.generator.class')
local transmitter = require('code.location.building.equipment.transmitter.class')
local terminal = require('code.location.building.equipment.terminal.class')
local door = require('code.location.building.barrier.door.class')
local barricade = require('code.location.building.barrier.barricade.class')
local integrity = require('code.location.building.integrity.class')
local buildDesc = require('code.location.building.buildDesc')

local Building = class('Building', TileBase)

-- This needs to be removed eventually
Building.external_desc = {
  odds = {adjective = .25, color = .50, details = .25, surroundings = .25},
  stories = {'three story', 'four story', 'five story'},
  adjective = {'narrow', 'tall', 'straight', 'curved', 'twisted', 'crooked', 'fire-scorched', 'burnt', 'scorched'},
  color = {'grey', 'yellow', 'white', 'vanilla', 'blue'}, 
  colored_material = {concrete = true, wooden = true, stone = true, slab = true, marble = true},
  material = {'glass', 'red-brick', 'concrete', 'wooden', 'slab', 'stone', 'steel', 'metal', 'metal and glass', 'ivory', 'marble'},
  details = {'revovling doors', 'boarded up windows', 'dusty windows', 'rounded windows', 'broken and dusty windows', 'broken windows', 'glass windows', 'tinted windows'},
  surroundings = {'surrounded by wrecked cars', 'surrounded by a metal fence', 'surrounded by trees', 'covered in vines', 'covered in moss', 'surrounded by a wooden fence'},
}

-- external desc works as follows
-- You are standing outside the [building title], a [story] [adjective] [color] [material] [details] [surroundings].

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
  tile.initialize(self, map, y, x, name)  
  self.inside_players = {}

  self.external_desc, self.internal_desc, self.powered_desc = buildDesc(tostring(self.class))
  
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
local class = require('code.libs.middleclass')
local Tile = require('code.location.tile.tile')
local Machines = require('code.location.tile.building.machine.machines')
local Door = require('code.location.tile.building.door')
local Barricade = require('code.location.tile.building.barricade')
local Integrity = require('code.location.tile.building.integrity')

local Building = class('Building', Tile)

--[[
  FULL_NAME = 'insert name'
  BUILDING_TYPE = residential/government/industrial/commercial/generic
  door_missing = true/nil
  search_odds = {outside = num, inside = num}/nil  
  item_chance = {item = .00 chance}
--]]

function Building:initialize(map, y, x, name)
  Tile.initialize(self, map, y, x, name)  
  self.inside_players = {}
  
  self.door        = Door:new(self)
  self.barricade   = Barricade:new(self)
  self.integrity   = Integrity:new(self)

  self.equipment   = {}
end

function Building:insert(player, setting) 
  if setting == 'inside' then self.inside_players[player] = true 
  elseif setting == 'outside' or setting == nil then self.outside_players[player] = true
  end
end

function Building:remove(player, setting) 
  if setting == 'inside' then self.inside_players[player] = nil  
  elseif setting == 'outside' or setting == nil then self.outside_players[player] = nil 
  end
end

function Building:install(machine, condition) 
  self.equipment[machine] = Machines[machine]:new(self, condition)
end

function Building:blackout()  -- change method name to setPower?
  -- 3x3 area do blackout event on tile(s)
end

function Building:getBarrier() return (self.barricade:getHP() > 0 and 'barricade') or (self.door:getHP() > 0 and 'door') end  -- should this return a class?

function Building:getEquipment() return self.equipment end

function Building:getMachine(machine) return self.equipment[machine] end

-- function Building:getPos() return (NO NEED?)

function Building:isPresent(setting)
  if setting == 'machines' then
    if next(self.equipment) then return true else return false end    
  elseif setting == 'door' then
    return self.door and self.door:isPresent() or false
  elseif setting == 'damaged door' then -- pretty sure this is redundant
    return (self.door and self.door:isDamaged()) or false
  elseif setting == 'barricade' then
    return self.barricade and self.barricade:isPresent() or false
  else -- individual machine
    local machine = setting
    return self.equipment[machine] and true or false
  end
--[[
  Pretty sure these settings are redundant, but I will hang on to them just in case...

  elseif setting == 'powered machines' then return self:isPresent('machines') and self:isPowered()
  elseif setting == 'damaged machines' then
    for _, machine in pairs(self.equipment) do if machine:isDamaged() then return true end end
    return false  
--]]
end

-- function Building:isOccupied(mob_type)  great way to check for people inside when ruining

function Building:isFortified() return self.barricade:getHP() > 0 and self.door:getHP() > 0 end

function Building:isPowered() return self.equipment.generator and self.equipment.generator:isActive() end

function Building:isOpen() return self.barricade:isDestroyed() and (self.door:isOpen() or self.door:isDestroyed()) end

function Building:updateHP(num) 
  if self:getBarrier() == 'barricade' then 
    self.barricade:updateHP(num) 
  else -- self:getBarrier() == 'door'
    self.door:updateHP(num) 
  end
end

return Building
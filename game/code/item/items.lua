local Crowbar, Bat, Sledge, Knife, Katanna = unpack(require('code.item.items.melee_weaponry'))
local Pistol, Magnum, Shotgun, Rifle, Flare, Molotov = unpack(require('code.item.items.ranged_weaponry'))
local FAK, Bandage, Syringe, Vaccine, Antidote, Scanner = unpack(require('code.item.items.medical'))
local Generator, Transmitter, Terminal = unpack(require('code.item.items.machinery'))
local Fuel, Barricade, Toolbox = unpack(require('code.item.items.tools'))
local Radio, GPS, Flashlight, Sampler = unpack(require('code.item.items.gadget'))
local Book, Bottle, Newspaper = unpack(require('code.item.items.junk'))
local Magazine, Shell, Clip, Quiver = unpack(require('code.item.items.ammo'))
local Leather, Kevlar, Riotsuit, Firesuit, Biosuit = unpack(require('code.item.items.armor'))

local Items = {
  -- MELEE_WEAPONRY
  Crowbar, Bat, Sledge, Knife, Katanna,
  -- RANGED_WEAPONRY
  Pistol, Magnum, Shotgun, Rifle, Flare, Molotov,
  -- MEDICAL
  FAK, Bandage, Syringe, Vaccine, Antidote, Scanner,
  -- MACHINERY
  Generator, Transmitter, Terminal,
  -- TOOLS
  Fuel, Barricade, Toolbox,
  -- GADGET
  Radio, GPS, Flashlight, --'cellphone', 'sampler'
  -- JUNK
  Book, Bottle, Newspaper,
  -- AMMO
  Magazine, Shell, Clip, Quiver,
  -- ARMOR
  Leather, Kevlar, Riotsuit, Firesuit, Biosuit,
}

for _, Class in ipairs(Items) do 
  Items[Class.name] = Class 
end

return Items
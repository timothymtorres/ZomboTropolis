local Crowbar, Bat, Sledge, Knife, Katanna =                       unpack(require('code.item.melee_weaponry'))
local Pistol, Magnum, Shotgun, Rifle, Flare, Molotov =             unpack(require('code.item.ranged_weaponry'))
local FAK, Bandage, Syringe, Vaccine, Antidote =                   unpack(require('code.item.medical'))
local Generator, Transmitter, Terminal, Fuel, Barricade, Toolbox = unpack(require('code.item.equipment'))
local Radio, GPS, Flashlight, Sampler =                            unpack(require('code.item.gadget'))
local Book, Bottle, Newspaper =                                    unpack(require('code.item.junk'))
local Magazine, Shell, Clip, Quiver =                              unpack(require('code.item.ammo'))
local Leather, Firesuit =                                          unpack(require('code.item.armor'))

local Item = {
  -- WEAPONRY
  Crowbar, Bat, Sledge, Knife, Katanna, Pistol, Magnum, Shotgun, Rifle, Flare, Molotov, 
  -- MEDICAL
  FAK, Bandage, Syringe, Vaccine, Antidote, 
  -- EQUIPMENT
  Generator, Transmitter, Terminal, Fuel, Barricade, Toolbox,
  -- GADGET
  Radio, GPS, Flashlight, Sampler, --'cellphone', 'sampler'
  -- JUNK
  Book, Bottle, Newspaper,
  -- AMMO
  Magazine, Shell, Clip, Quiver,
  -- ARMOR
  Leather, Firesuit,
}

for _, Class in ipairs(Item) do 
  Item[Class.name] = Class 
end

return Item
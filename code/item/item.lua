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

function Item.server_criteria(name, player, inv_ID, ...)
  assert(inv_ID, 'Missing inventory ID for item')
  assert(player.inventory:check(inv_ID), 'Item not in inventory')  
  
  local itemObj = player.inventory:lookup(inv_ID)
  assert(name == itemObj:getClassName(), "Item in inventory doesn't match one being used")
end

function Item.activate(name, player, inv_ID, target)
  local itemObj = player.inventory:lookup(inv_ID)
  local result = itemObj:activate(player, target) 
  
  if itemObj:isSingleUse() and not name == 'syringe' and not name == 'barricade' then 
    player.inventory:remove(inv_ID) 
  elseif name == 'syringe' then -- syringes are a special case
    local antidote_was_created, syringe_was_salvaged = result[2], result[3]
    if antidote_was_created or not syringe_was_salvaged then player.inventory:remove(inv_ID) end
  elseif name == 'barricade' then -- barricades are also a special case
    local did_zombies_interfere = result[1]
    if not did_zombies_interfere then player.inventory:remove(inv_ID) end
  elseif itemObj:failDurabilityCheck(player) then 
    local condition = itemObj:updateCondition(-1, player, inv_ID)
    if condition <= 0 then -- item is destroyed
      player.log:append('Your '..tostring(itemObj)..' is destroyed!')
    elseif itemObj:isConditionVisible(player) then
      player.log:append('Your '..tostring(itemObj)..' degrades to a '..itemObj:getConditionState()..' state.')  
    end    
  end
  --return result (pretty sure we don't need to return the result anymore)
end

return Item
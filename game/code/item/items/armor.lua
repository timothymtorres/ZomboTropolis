local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')

local Armor = {}

-------------------------------------------------------------------

local Leather = {}
Armor.Leather = Leather

-------------------------------------------------------------------

local Kevlar = {}
Armor.Kevlar = Kevlar

-------------------------------------------------------------------

local Riotsuit = {}
Armor.Riotsuit = Riotsuit

-------------------------------------------------------------------

local Firesuit = {}
Armor.Firesuit = Firesuit

-------------------------------------------------------------------

local Biosuit = {}
Armor.Biosuit = Biosuit

--[[ Biosuit armor has no resistance but grants special effects. 

1. Hides the player from being detected by outside zombies
2. Hides the players HP status from other mobs (not yet implemented)
3. Immune to tracking from hunter zombies
4. Immune to infections from bite attacks

The biosuit effects are dependent on the condition of the armor.  To have an 
effect active it must use the following critera:

Biosuit Condition >= Effect Level

Thus a biosuit at condition 4 (pristine) will have all effects active.  Likewise
a biosuit at condition 2 (worn) will only have effect 1 & 2 active. --]]

--------------------------------------------------------------------

-------------------------------------------------------------------

function armor_activate(player)
  if player.equipment:isActive('armor') then -- remove old armor and put into inventory 
    local old_armor = player.equipment.armor
    player.inventory:insert(old_armor) 
  end
  player.equipment:add('armor', self)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You equip a {armor}.'
  msg = msg:replace(self) -- This should work? Needs to be tested

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'armor', player}
  player.log:insert(msg, event)
end

-- attach activate code to each armor
for armor in pairs(Armor) do
  Armor[armor].activate = armor_activate
end


return Armor
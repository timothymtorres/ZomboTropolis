local class = require('code.libs.middleclass')
local organic_armor_list = require('code.player.armor.organic_list')
local armor = require('code.player.armor.class')

local organic_armor = class('organic_armor', armor)

function organic_armor:initialize(player) 
  armor.initialize(self, player)
  self.layers = {}
  self.player = player
end

local LAYER_STACKING_MULTIPLYER = {0, 1/8, 2/8, 4/8}

local function calculateDurability(layers)
  local mean = 0
  for _, armor_type in ipairs(layers) do
    local stack = layers[armor_type]
    local multiplyer = 1 + LAYER_STACKING_MULTIPLYER[stack]
    mean = mean + (organic_armor_list[armor_type].durability * multiplyer)
  end
  return math.floor(mean/#layers + 0.5) -- returns a rounded integer
end

-- PER LEVEL OF ARMOR
local organic_resistance_values = {bullet=2, blunt=1, pierce=1, scorch=1, damage_melee_attacker=1}

function organic_armor:equip(armor_name)
  self.protection = self.protection or {}
  
  local resistance = organic_armor_list[armor_name].resistance
  if resistance then
    local value = organic_resistance_values[resistance]
    self.protection[resistance] = (self.protection[resistance] or 0) + value
  end
  
  self.layers[#self.layers+1] = armor_name
  self.layers[armor_name] = (self.layers[armor_name] or 0) + 1
  
  self.durability = calculateDurability(self.layers)
end

function organic_armor:degrade()
  local armor_name = self.layers[#self.layers]
  local resistance = organic_armor_list[armor_name].resistance
  
  if resistance then
    self.protection[resistance] = self.protection[resistance] - organic_resistance_values[resistance] 
  end
    
  self.layers[#self.layers] = nil      
  self.layers[armor_name] = self.layers[armor_name] - 1
  
  if #self.layers == 0 then  -- armor is destroyed
    local player = self.player
    player.armor = organic_armor:new(player)
    return -- something??
  else
    self.durability = calculateDurability(self.layers)
  end
end

local MAX_ORGANIC_LAYERS = 4

function organic_armor:hasRoomForLayer() return MAX_ORGANIC_LAYERS > #self.layers end

function organic_armor:getAvailableArmors() 
  local list = {}
  for armor_type in pairs(organic_armor_list) do 
    local skill = organic_armor_list[armor_type].required_skill
    local cost, ep = self.player:getCost('ep', armor_type), self.player:getStat('ep')    
    list[armor_type] = (self.player.skills:check(skill) and ep >= cost) or nil
    print(armor_type, list[armor_type])
  end
  
  print()
  print('THIS IS OUR ARMOR LIST')
  for k,v in pairs(list) do print(k,v) end
  
  return list
end

return organic_armor
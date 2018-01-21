local IsArmor = {}

function IsArmor:updateArmorDurability(degrade_multiplier)  -- god this method name is horrible, think of something better
  local failed_durability_test = self:failDurabilityCheck(player, degrade_multiplier)
  local condition 
 
  if failed_durability_test then condition = self:updateCondition(-1) end

  return condition
end

function IsArmor:getProtection(damage_type)
  local resistance, condition = self.armor.RESISTANCE, self.condition
  return (resistance[condition] and resistance[condition][damage_type]) or resistance[damage_type] or 0 
end

return IsArmor
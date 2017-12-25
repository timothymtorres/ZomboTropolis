local IsArmor = {}

function IsArmor:getProtection(damage_type)
  local resistance, condition = self.armor.resistance, self.condition
  return (resistance[condition] and resistance[condition][damage_type]) or resistance[damage_type] or 0 
end

return IsArmor
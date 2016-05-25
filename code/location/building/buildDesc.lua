local b_list = require('code.location.building.list')
local dice = require('code.libs.rl-dice.dice')

local function buildDesc(building_class)
  local external_desc, internal_desc, powered_desc
  
  local odds = b_list.external_desc.odds
  local e_desc = b_list.external_desc
  local material = e_desc.material[math.random(1, #e_desc.material)]
  
  external_desc = {
    adjective = dice.chance(odds.adjective) and e_desc.adjective[math.random(1, #e_desc.adjective)] or false,
    color = e_desc.colored_material[material] and dice.chance(odds.color) and e_desc.color[math.random(1, #e_desc.color)] or false,
    material = material,
    details = dice.chance(odds.details) and e_desc.details[math.random(1, #e_desc.details)] or false,
    surroundings = dice.chance(odds.surroundings) and e_desc.surroundings[math.random(1, #e_desc.surroundings)] or false,
  }
  
  local i_desc = b_list[building_class].internal_desc
  if i_desc then internal_desc = i_desc[math.random(1, #i_desc.selection_range or #i_desc)] end
  
  local p_desc = b_list[building_class].powered_desc
  if p_desc then powered_desc = p_desc[math.random(1, #p_desc.selection_range or #p_desc)] end  
  
  return external_desc, internal_desc, powered_desc
end

return buildDesc
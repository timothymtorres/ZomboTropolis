local function lookupFlags(skill_list, skills)
  local array = {}
  for _, category in ipairs(skill_list.order.category) do array[category] = {} end
  
  for _, skill in ipairs(skills) do
    local array_category = array[skill_list[skill].category]
    array_category[#array_category+1] = skill_list.flag[skill] 
  end
  return array
end

local function combineFlags(skill_list, requirements)
  local list = lookupFlags(skill_list, requirements)
  for _, category in ipairs(skill_list.order.category) do 
    list[category] = (next(list[category]) and bor(unpack(list[category]))) or 0 
  end
  return list
end

local function fillData(skill_list)
  for skill_tree in pairs(skill_list.info) do 
    for skill, data in pairs(skill_list.info[skill_tree]) do 
      skill_list[skill] = data
      skill_list[skill].category = skill_tree              
    end
  end
  return skill_list
end

local function fillRequirements(skill_list)
  for skill_tree in pairs(skill_list.info) do 
    for skill, data in pairs(skill_list.info[skill_tree]) do                 
      local class_criteria = (not (skill_tree == 'general' or skill_tree == 'classes') and skill_tree) or nil
      local skills_criteria = skill_list[skill].requires and table.copy(skill_list[skill].requires)
      
      skill_list[skill].requires = skill_list[skill].requires or {}
      skill_list[skill].requires[#skill_list[skill].requires+1] = class_criteria        
      
      local requirements = skill_list[skill].requires
      if next(requirements) then
        skill_list[skill].required_flags = combineFlags(skill_list, requirements)
      else
        skill_list[skill].required_flags = {}
        for _, category in ipairs(skill_list.order.category) do
          skill_list[skill].required_flags[category] = 0
        end
      end
      skill_list[skill].required_class = class_criteria
      skill_list[skill].required_skills = skills_criteria
    end 
  end
  return skill_list
end

function fillSkillList(skill_list)
  skill_list = fillData(skill_list)
  skill_list = fillRequirements(skill_list)

  skill_list:getRequirement = function(skill, category) 
    if category == 'skills' then return self[skill].required_skills
    elseif category == 'class' then return self[skill].required_class
    else return self[skill].requires  -- return all requirements
    end  
  end

  skill_list:getRequiredFlags = function(skill) return self[skill].required_flags end
  skill_list:getFlag =          function(skill) return self.flag[skill] end
  skill_list:getCategory =      function(skill) return self[skill].category end
  skill_list:isClass =          function(skill) return self[skill].category == 'classes' end

  return skill_list
end

return fillSkillList
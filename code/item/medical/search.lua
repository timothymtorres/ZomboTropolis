local medical = require('code.item.medical.class')

local medical_list = {medical.FAK, medical.bandage, medical.antidote}

for ID, obj in ipairs(medical_list) do
  medical_list[obj:getName()] = ID 
  obj.medical_ID = ID
end

local function lookupMedical(obj)
  local med
  if type(obj) == 'string' then 
    local ID = medical_list[obj]
    med = medical_list[ID]
  elseif type(obj) == 'number' then
    local ID = obj
    med = medical_list[ID]
  else
    error('item medical_lookup invalid')
  end
  return med
end

--for i,v in ipairs(medical_list) do print(k,v) end

return lookupMedical
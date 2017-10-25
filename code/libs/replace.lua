local pattern = ' {(.-)}'
local gsub = string.gsub

local replacement_tbl

local indexToStringSort = function(s)  -- converts index in replacement_tbl to string based on whether it is an object, nil, or string already  
  local temp_str    
  
  if replacement_tbl[s] and replacement_tbl[s].class then temp_str = tostring(replacement_tbl[s])
  elseif type(replacement_tbl[s]) == 'string' then temp_str = replacement_tbl[s]
  elseif type(replacement_tbl[s]) == 'nil' then temp_str = ''
  end

  return temp_str == '' and temp_str or ' '..temp_str 
end

-- This function replaces '{}' patterns in a string with a replacment string
local replace = function(str, replacement)
  if type(replacement) == 'string' then
    return gsub(str, pattern, replacement == '' and '' or ' '..replacement)  
  elseif type(replacement) == 'table' then
    if replacement.class then -- this is just a single class object
      return gsub(str, pattern, tostring(replacement))
    else -- just a regular table (with either strings or class objects inside)
      replacement_tbl = replacement
      return gsub(str, pattern, indexToStringSort)
    end
  end
end

return replace
local pattern = ' {(.-)}'
local gsub = string.gsub

-- This function replaces '{}' patterns in a string with a replacment string
local replace = function(str, repl)
  if type(repl) == 'string' then
    return gsub(str, pattern, ' '..repl)  
  elseif type(repl) == 'table' then
    return gsub(str, pattern, function(s) return repl[s] and ' '..repl[s] or '' end)
  end
end

return replace
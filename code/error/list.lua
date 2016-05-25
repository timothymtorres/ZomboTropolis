local error_list = {}

for ID, msg in ipairs(error_list) do
  error_list[msg] = ID
end

return error_list 
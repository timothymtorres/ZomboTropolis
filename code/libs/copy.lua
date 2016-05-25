local function copy(tbl)
  local copy = {}
  for orig_key, orig_value in pairs(tbl) do copy[orig_key] = orig_value end
  return copy
end

return copy
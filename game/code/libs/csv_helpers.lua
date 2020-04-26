local csv = require('code.libs.csv')
local lume = require('code.libs.lume')

local csv_helpers = {}

-- this will take a header like "Full Name" and convert it into "FULL_NAME"
local function headerToConstant(header)
  header = string.gsub(header, '%s+', '_')  -- replace all spaces with _
  return string.upper(header) -- all caps
end

-- this function takes raw string CSV data and processes it into lua types
-- that can be used with the middleclass library
function csv_helpers.convertToLua(path)  
  local classes, headers = csv.parse(path, {headerFunc=headerToConstant} )

  -- need to properly cleanup the data
  for class_i, data in ipairs(classes) do
    for constant, value in pairs(data) do
      if value == "" then -- remove empty data
        data[constant] = nil
      elseif value == "TRUE" then -- convert into boolean
        data[constant] = true
      elseif value == "FALSE" then 
        data[constant] = false
      elseif type(tonumber(value)) == 'number' then -- convert into number
        data[constant] = tonumber(value)
      elseif type(value) == 'string' and string.find(value, '({.*})') then
        if string.find(value, '=') then -- convert into dictionary table
          local string_table = string.gsub(value, '/', ',')
          data[constant] = lume.deserialize(string_table)
        else -- convert into a regular array 
          local _, _, string_array = string.find(value, '{(.*)}')
          data[constant] = lume.split(string_array, "/")
        end        
      else
        data[constant] = value
      end
    end
  end

  return classes
end

function csv_helpers.convertArmor(path)
  local armor_csv, headers = csv.parse(path)
  local armors = {}

  local num_conditions = 4 -- we have 4 different conditions so skip by this amount
  for i=1, #armor_tables, num_conditions do
    local name, ID = armor_csv[i].NAME, armor_csv[i].ID
    local armor = {RESISTANCE={}}

    for ii=1, header in ipairs(headers) do
      if ii <= 4 then -- copy the first 4 default fields of data (name/id/durability/organic)
        local value = armor_csv[i][header] 
        armor[header] = tonumber(value) or value
      elseif header ~= 'CONDITION' then -- copy the rest of the data to the resistance table (except condition)
        armor.RESISTANCE[header] = tonumber(value)
      end
    end

    armors[name] = armor
    armors[ID] = armor

    return armors 
end

function csv_helpers.convertItemDrops(path) 
  local locations = {}

  local items_csv = csv.parse(path, {headers=false})
  local total_locations = #items_csv[2]

  for location_i=2, total_locations do
    local location = items_csv[2][location_i]

    local chance = items_csv[1][location_i] 
    chance = string.match(chance, '%d+') -- remove the % from the string
    chance = tonumber(chance) * 0.01 -- convert str to num and move the decimal to correct position 

    local capture_inside_parenthesis = '%((.+)%)' -- this captures the "inside" or "outside" string
    local _, _, stage = string.find(location, capture_inside_parenthesis)
    local is_building = stage and true or false  -- if no capture then just a tile
    stage = stage or 'outside'  -- tiles default to outside
    
    local capture_all_parenthesis = '%(.+%)'
    if is_building then
      location = string.gsub(location, capture_all_parenthesis, '') -- trim "(outside)" or "(inside)" from string
      location = lume.trim(location) -- trim whitespace from location
    end

    locations[location] = locations[location] or {search_odds={}, item_chance={}}
    locations[location].search_odds[stage] = chance
    locations[location].item_chance[stage] = {}

    for item_i=3, #items_csv do
      local item = string.gsub(items_csv[item_i][1], '%s+', '_') -- replace spaces in strings with _
      local item_weight = tonumber(items_csv[item_i][location_i])
      locations[location].item_chance[stage][item] = item_weight
    end
  end

  return locations
end

--[[
-- import outside items into location
local outside_items_path = system.pathForFile("spreadsheet/outside-items.csv", system.ResourceDirectory) 
local outside_items = csv_helpers.convertItemDrops(outside_items_path)

for location, item_drop in pairs(outside_items) do
  Tiles[location].search_odds.outside = item_drop.search_odds
  Tiles[location].item_chance.outside = item_drop.item_chance
end

-- import inside items into location
local inside_items_path = system.pathForFile("spreadsheet/inside-items.csv", system.ResourceDirectory) 
local inside_items = csv_helpers.convertItemDrops(inside_items_path)

for location, item_drop in pairs(inside_items) do
  Tiles[location].search_odds.inside = item_drop.search_odds
  Tiles[location].item_chance.inside = item_drop.item_chance
end
--]]

return csv_helpers
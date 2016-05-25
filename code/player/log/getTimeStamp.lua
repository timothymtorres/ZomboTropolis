local second = 1
local minute = second*60
local hour = minute*60
local day = hour*24
local week = day*7
local month = week*4
local year = month*12

local function getTimeStamp(date)  -- time in seconds
  local time_passed = os.difftime(os.time(), date)
  local num, unit 
  
  if minute > time_passed then       num, unit = second, 'second'
  elseif hour > time_passed then     num, unit = minute, 'minute'
  elseif day > time_passed then      num, unit = hour, 'hour'
  elseif week > time_passed then     num, unit = day, 'day'
  elseif month > time_passed then    num, unit = week, 'week'
  elseif year > time_passed then     num, unit = month, 'month'
  else                               num, unit = year, 'year'
  end
  
  local amount = math.floor(time_passed/num)
  local suffix = amount > 1 and 's' or ''  -- plural or singular
  return '('..amount..' '..unit..suffix..' ago)'
end

return getTimeStamp
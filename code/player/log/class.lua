local class = require('code.libs.middleclass')
local getMessage = require('code.player.log.getMessage')

local log = class('log')

function log:initiallize() 
  -- need to save data to client?
end

function log:event(date, action, params, POV)
  local event = {
    date = date,
    action = action,
    params = params,
    POV = POV,
  }
  
  self:insert(event)
end

function log:insert(event)
  self[#self+1] = event
end

function log:reset()
  for i=1, #self do self[i] = nil end
end

function log:read()
  local list = {}
  for _, event in ipairs(self) do  -- sort this by day
    local date = os.date('%x', event.date)
    local index
    if #list == 0 then index = 1
    else index = (date == os.date('%x', list[#list].date) and #list) or #list+1 
    end
    list[index] = list[index] or {date=event.date, collapsed=true, events={}} 
    local event_tbl = list[index].events
    event_tbl[#event_tbl+1] = getMessage(event) 
  end
  return list
end

return log
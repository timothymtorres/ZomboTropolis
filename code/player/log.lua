local class = require('code.libs.middleclass')
local getTimeStamp = require('code.player.getTimeStamp')

local Log = class('Log')

function Log:initiallize() 
  -- need to save data to client?
end

function Log:insert(msg, event, date)
  date = date or os.time()    
  
  self[#self+1] = {
    msg = msg,
    event = event,
    date = date,
  }
end

function Log:append(msg)
  self[#self].msg = self[#self].msg..'  '..msg
end

function Log:reset()
  for i=1, #self do self[i] = nil end
end

function Log:read()
  local list = {}
  for _, event in ipairs(self) do  -- sort this by day
    local date = os.date('%x', event.date)
    local index
    if #list == 0 then index = 1
    else index = (date == os.date('%x', list[#list].date) and #list) or #list+1 
    end
    list[index] = list[index] or {date=event.date, collapsed=true, events={}} 
    local event_tbl = list[index].events
    event_tbl[#event_tbl+1] = event.msg..' '..getTimeStamp(event.date) 
  end
  return list
end

return Log
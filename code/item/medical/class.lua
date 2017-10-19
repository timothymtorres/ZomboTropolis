local class = require('code.libs.middleclass')
local item = require('code.item.class')
local m_list = require('code.item.medical.list')

local medical = class('medical', item)

function medical:initialize() end

function medical:isOrganic() return self.organic or false end

function medical:getID() return self.medical_ID end

function medical:getName() return self.name end

function medical:getClass() return self.class end

function medical:getClassName() return tostring(self.class) end

function medical:getAccuracy() return self.accuracy end

function medical:getDice() return self.dice end
  
function medical:getGroup() return self.group end 

function medical:__tostring() return self:getClassName() end

function medical:dataToClass(...) -- this should be a middleclass function (fix later)
  local combined_lists = {...}
  for _, list in ipairs(combined_lists) do
    for obj in pairs(list) do
      self[obj] = class(obj, self)
      self[obj].initialize = function(self_subclass)
        self.initialize(self_subclass)
      end
      for field, data in pairs(list[obj]) do self[obj][field] = data end
    end
  end
end

-- turn our list of weaponry into medical class
medical:dataToClass(m_list)
  
return medical  
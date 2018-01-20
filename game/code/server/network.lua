local class = require('code.libs.middleclass')

local ServerNetwork = class('ServerNetwork')

function ServerNetwork:initialize() 
  self.zombie = {}
  for channel=1, 16 do self.zombie[channel] = {} end  -- zombies only have a limited # of channels

  self.human = {}
  for channel=1, 1024 do self.human[channel] = {} end
end

local function getMob(listener)
 	if listener:isInstanceOf('player') then return listener:getMobType()
	else listener:isInstanceOf('building') return 'human' -- transmitters only apply to human channels 
	end
end

function ServerNetwork:insert(listener, channel)
	local mob = getMob(listener)
	self[mob][channel][listener] = listener -- probably need to set this to a weak table	
end

function ServerNetwork:remove(listener, channel)
	local mob = getMob(listener)
	self[mob][channel][listener] = nil
end

function ServerNetwork:transmit(speaker, channel, message)
  local event, settings = {'network', speaker, channel}, {stage='inside'}
  local mob = getMob(speaker)
  local msg = tostring(speaker)..' ('..channel..'): '..message -- in UD the speaker is omitted from the broadcasted msg

  for listener in pairs(self[mob][channel]) do 
  	-- tostring(listener) == 'building' is probably broken
  	if tostring(listener) == 'building' then listener:broadcastEvent(msg, event, settings)
  	elseif listener ~= speaker then listener.log:insert(msg, event)
  	end
  end
end

return ServerNetwork
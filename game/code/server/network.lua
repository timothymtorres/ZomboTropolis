local ServerNetwork = {}

do 
  ServerNetwork.zombie = {}
  for channel=1, 16 do ServerNetwork.zombie[channel] = setmetatable({}, {__mode='k'}) end  -- zombies only have a limited # of channels

  ServerNetwork.human = {}
  for channel=1, 1024 do ServerNetwork.human[channel] = setmetatable({}, {__mode='k'}) end
end

local function getMob(listener)
 	if listener:isInstanceOf('player') then return listener:getMobType()
	else listener:isInstanceOf('building') return 'human' -- transmitters only apply to human channels 
	end
end

function ServerNetwork:insert(listener, channel)
	local mob = getMob(listener)
	ServerNetwork[mob][channel][listener] = true	
end

function ServerNetwork:remove(listener, channel)
	local mob = getMob(listener)
	ServerNetwork[mob][channel][listener] = nil
end

function ServerNetwork:transmit(speaker, channel, message)
  local event, settings = {'network', speaker, channel}, {stage='inside'}
  local mob = getMob(speaker)
  local msg = tostring(speaker)..' ('..channel..'): '..message -- in UD the speaker is omitted from the broadcasted msg

  for listener in pairs(ServerNetwork[mob][channel]) do 
  	-- tostring(listener) == 'building' is probably broken
  	if tostring(listener) == 'building' then listener:broadcastEvent(msg, event, settings)
  	elseif listener ~= speaker then listener.log:insert(msg, event)
  	end
  end
end

return ServerNetwork
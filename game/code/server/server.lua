Server = {} -- This is a global variable for the game

function Server:getMap(name)
  return self[name]
end

function Server:addMap(map)
  if not map then error('No map table to add to server')
  elseif self[map.name] then error('Map already exists in Server')
  end

  self[map.name] = map
end

return Server

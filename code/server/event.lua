local function broadcastEvent(zone, msg, setting) --settings={stage=inside/outside, range=num, mob_type=zombie/human, exclude={player=true, ...}}
  local date = os.time()  

  if zone:isClass('player') then
    local player = zone
    player.log:insert(msg, date)
  elseif zone:isClass('tile') then
    local tile = zone
    local range, stage, mob_type, exclude = setting.range, setting.stage, setting.mob_type, setting.exclude
    
    -- delivers msg to tile
    local players = tile:getPlayers(stage)
    for _, player in pairs(players) do
      if (not mob_type or player:isMobType(mob_type) ) and player:isStanding() and (not exclude or not exclude[player]) then 
        -- plug in map[y][x] coords into msg with string.gsub()
        player.log:insert(msg, date)
      end
    end        

    if range then -- delivers msg to area of tiles (in the shape of a square that is [range] x sized)
      local map = zone:getMap()
      local y_pos, x_pos = tile:getPos()
      for y = y_pos - range, y_pos + range do
        for x = x_pos - range, x_pos + range do
          if map[y] and map[y][x] and not (y_pos == y and x_pos == x) then -- avoid broadcast on map[y_pos][x_pos] since the msg has already been delievered to that tile 
            broadcastEvent(map[y][x], msg, {stage=stage, mob_type=mob_type, exclude=exclude}) 
          end
        end
      end
    end      
  elseif zone:isClass('map') then
    --broadcast msg to all players on that map
  --elseif zone:isType('server') then   broadcast msg to all players on server?
  end
end

return broadcastEvent
local broadcastEvent = {}

function broadcastEvent.player(player, msg, self_msg, event)  --this broadcasts specifically to exclude player and give player their own self_msg
  local date = os.time()
  local tile = player:getTile()
  local stage = player:getStage()

  local players = tile:getPlayers(stage)
  for player_INST in pairs(players) do
    if player_INST:isStanding() and player_INST ~= player then
      -- plug in map[y][x] coords into msg with string.gsub()
      player_INST.log:insert(msg, event, date)
    end
  end

  player.log:insert(self_msg, event, date)
end

--setting={stage=inside/outside, range=num, mob_type=zombie/human, exclude={player=true, tile=true, ...}}
function broadcastEvent.tile(tile, msg, event, setting)
  local date = os.time()
  local range, stage, mob_type, exclude = setting.range, setting.stage, setting.mob_type, setting.exclude

  if not exclude or not exclude[tile] then
    local players = tile:getPlayers(stage)
    for player_INST in pairs(players) do -- deliver msg to tile
      if (not mob_type or player_INST:isMobType(mob_type) ) and player_INST:isStanding() and (not exclude or not exclude[player_INST]) then
        -- plug in map[y][x] coords into msg with string.gsub()
        player_INST.log:insert(msg, event, date)
      end
    end
  end

  if range then -- delivers msg to area of tiles (in the shape of a square that is [range] x sized)
    local map = tile:getMap()
    local x_pos, y_pos, z_pos = tile:getPos()
    local z = z_pos -- later make a z-level range broadcast argument
    for y = y_pos - range, y_pos + range do
      for x = x_pos - range, x_pos + range do
        if map[z][y] and map[z][y][x] and not (y_pos == y and x_pos == x) then -- avoid broadcast on map[y_pos][x_pos] since the msg has already been delievered to that tile
          broadcastEvent(map[z][y][x], msg, event, {stage=stage, mob_type=mob_type, exclude=exclude})
        end
      end
    end
  end
end

-- Add these later when needed
--function broadcastEvent.map(map, msg, event, setting) end
--function broadcastEvent.server(server, msg, event, setting) end

return broadcastEvent

--[[  THIS IS OLD CODE

local broadcast_zone = { --  (terminate, deactivate, cancel, blackkout)
  self = {'move', 'search', 'enter', 'exit', 'discard'},
  pair = {'attack', 'heal'},
  stage = {'revive', 'death', 'destruction', 'speak'}, -- equipment destruction
  tile = {'destruction'},  -- barricade destruction
  area = {'flare', 'blackout'},
}

-- setup our broadcast range for easier access
for zone_type, event in pairs(broadcast_zone) do broadcast_zone[event] = zone_type end

local function event(zone, action, data)  
  broadcastEvent(zone, action, data)
end
--]]

local function event(zone, action, data)
  local z_type, z_tile, z_stage, z_range = zone.type, zone.tile, zone.stage, zone.range  
  local z_player, z_target = zone.player, zone.target
  local date = os.time()
  
  if z_type == 'self' then
    z_player.log:event(date, action, data, 1)
  elseif z_type == 'pair' then
    z_player.log:event(date, action, data, 1)
    z_target.log:event(date, action, data, 2)
  elseif z_type == 'stage' then
    local players = z_tile:getPlayers(z_stage)
    -- if player destroyed equipment or revived, isolate player for 1st person
    for _, player in pairs(players) do 
      if z_player and z_player == player then player.log:event(date, action, data, 1)
      else player.log:event(date, action, data, 3) 
      end
    end
  elseif z_type == 'tile' then  
    local tile_players = z_tile:getPlayers('all')
    for _, player in pairs(tile_players) do  
--print('z_player is '..z_player, 'player is '..player)
      if z_player and z_player == player then player.log:event(date, action, data, 1)
      else player.log:event(date, action, data, 3) 
      end      
    end
  elseif z_type == 'area' then
    local map = z_tile:getMap()
    local y_pos, x_pos = z_tile:getPos()
    for y = y_pos - z_range, y_pos + z_range do
      for x = x_pos - z_range, x_pos + z_range do
        if map[y] and map[y][x] then
          -- setting up a new localized zone thats params will be overwritten
          -- z_type is now 'tile' for the next broadcastEvent() instead of 'area'
          -- this avoids an infinite broadcastEvent() loop
          local zone = zone
          zone.type, zone.tile = 'tile', map[y][x]
          event(zone, action, data)
        end
      end
    end
  end
end

return event
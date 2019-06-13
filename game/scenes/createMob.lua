local function createMob(player, location)
  local username = player:getUsername()
  local animation = player:getMobType() -- swap this out with sprite_name later
  local is_player_standing = player:isStanding()

  local mob_data = {
    gid = location:getAnimationGID(animation),
    height = 32,
    width = 32,
    name = username,
    type = "mob",
    isAnimated = true,
  }

  local mob = location:addObject(mob_data)
  mob:rotate( (is_player_standing and 0) or 90)
  mob.x, mob.y = 0, 0

  local snap_w = 96
  local snap_h = 96
  local layer = location:getLayer(is_player_standing and "Mob" or "Corpse")
  local snap = display.newSnapshot(layer, snap_w, snap_h)

  -- used by berry to extend our snapshot
  snap.name, snap.type = username, 'mob'
  snap.player = player

  snap.group:insert( mob )

  location:extend("mob")
  return snap
end

return createMob
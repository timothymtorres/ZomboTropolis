local class = require('code.libs.middleclass')

local Stats = class('Stats')
Stats.default = 		{hp=50, ep=50, ip= 0, xp=   0, ap=50}
Stats.max =     		{hp=50, ep=50, ip=50, xp=1000, ap=50}
Stats.bonus = {}
Stats.bonus.value = {hp=10, ep=10, ip=10, xp=   0, ap=0}
Stats.bonus.skill = {hp='hp_bonus', ip='ip_bonus', ep='ep_bonus', ap=false, xp=false}

function Stats:initialize(player)
	self.player = player
  self.current =   {hp = default.hp,     xp = default.xp,     ap = default.ap}
  self.potential = {hp = default_max.hp, xp = default_max.xp, ap = default_max.ap} 
  self.vitality = 4
end

local vitality_desc = {'dying', 'wounded', 'injuried', 'full'}

function Stats:getValue(stat, setting)
  if not setting then 								return self.current[stat]
  elseif setting == 'potential' then 	return self.potential[stat]
  elseif setting == 'vitality' then 	return vitality_desc[self.vitality] -- possibly move this to it's own method - getVitality()?
  elseif setting == 'max' then
    local player, skill = self.player, Stats.bonus.skill[stat]
    local has_bonus_skill = (skill and player.skills:check(skill)) or false
    return Stats.max[stat] + (has_bonus_skill and Stats.bonus.value[stat] or 0)
  end
end

function Stats:updateValue(stat, num, setting)
	if not setting then
	  local potential = self.potential[stat]
	  self.current[stat] = math.min(self.current[stat] + num, potential)
	  
	  if stat == 'hp' then
	    if self.hp <= 0 then 
	      self.hp = 0
	      self:killed()
	    else
	      -- we add self.hp+1 so that if health_percent == 100% that it puts it slightly over and math.ceil rounds it to the 'full' state 
	      local health_percent = self.hp+1/self.potential 
	      self.health_state = math.ceil(health_percent/(1/3))
	    end  
	  end
	elseif setting == 'potential' then

	end
end

return Stats
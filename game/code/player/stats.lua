local class = require('code.libs.middleclass')
local lume = require('code.libs.lume')

local Stats = class('Stats')
Stats.bonus = {}

Stats.default = 		{hp=50, ip= 0, xp=   0, ap=50}
Stats.max =     		{hp=50, ip=50, xp=1000, ap=50}
Stats.bonus.value = {hp=10, ip=10, xp=   0, ap=0}
Stats.bonus.skill = {hp='hp_bonus', ip='ip_bonus', ap=false, xp=false}

function Stats:initialize(player)
  self.player = player  

  self.current, self.potential = {}, {} 
  self.current.hp, self.potential.hp = Stats.default.hp, Stats.max.hp
  self.current.ap, self.potential.ap = Stats.default.ap, Stats.max.ap
  self.current.xp, self.potential.xp = Stats.default.xp, Stats.max.xp

  if player.class.name == 'Human' then
  	self.current.ip, self.potential.ip = Stats.default.ip, Stats.max.ip
  end

  self.current.vitality = 4   
end

--local vitality_desc = {'dying', 'wounded', 'injuried', 'full'}  (save this for later?)

function Stats:getBonus(stat)
  local player, skill = self.player, Stats.bonus.skill[stat]
  return (skill and player.skills:check(skill) and Stats.bonus.value[stat]) or 0
end

function Stats:get(stat)
  if stat == 'vitality' then return self.current[stat] end
  return self.current[stat], self.potential[stat], Stats.max[stat] + self:getBonus(stat)
end

local HP_POTENTIAL_LOSS_FROM_LIMB = 20

function Stats:update(stat, num)
	local stat, potential = unpack(lume.split(stat))

	if not potential then
	  self.current[stat] = math.min(self.current[stat] + num, self.potential[stat]) -- can reach negative ap for certain actions...
	  -- what about inventory points?  We want it to go over max potential?
	  
	  if stat == 'hp' then
	    if self.hp == 0 then 
	      self:killed()
	    else
	      -- we add self.hp+1 so that if health_percent == 100% that it puts it slightly over and math.ceil rounds it to the 'full' state 
	      local health_percent = self.current[stat]+1/self.potential[stat]
	      self.vitality = math.ceil(health_percent/(1/3))  -- not sure why this works but it does, lol
	    end  
	  end
	elseif potential and stat == 'hp' then
		local player = self.player
		local maim_number
		if player.status_effect:isActive('maim') then maim_number = player.status_effect.maim:count() end

		local bonus = self:getBonus('hp')
		local ceiling = (Stats.max.hp + bonus) - maim_number*HP_POTENTIAL_LOSS_FROM_LIMB -- being maim'd takes a big chuck outta potential hp
		local change = self.potential[stat] + num
		self.potential.hp = math.max(math.min(change, ceiling), bonus)
	end
end

return Stats
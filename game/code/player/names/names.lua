local names = {}
names.purchased = {}
names.active = {}

-- HUMAN NAMES --
names.first_male = {}
names.first_female = {}
names.last = {}

-- ZOMBIE NAMES --
names.zombie = {}

local zombie_names_file = assert(io.open("code.player.names.zombie"), 'No names/zombie.txt file')
local first_male_names_file = assert(io.open("code.player.names.first_male"), 'No names/first_male.txt file')
local first_female_names_file = assert(io.open("code.player.names.first_female"), 'No names/first_female.txt file')
local last_names_file = assert(io.open("code.player.names.last"), 'No names/last.txt file')

do  -- put our names into Lua tables
	for name in zombie_name_file:lines() do names.zombie[#names.zombie + 1] = name end
	for name in first_male_names_file:lines() do names.first_male[#names.first_male + 1] = name end
	for name in first_female_names_file:lines() do names.first_female[#names.first_female + 1] = name end
	for name in last_names_file:lines() do names.last[#names.last + 1] = name end
end

function names:generateRandom(setting)
	local name
	repeat
		if setting == 'zombie' then name = names.zombie[math.random(1, #names.zombie)]..' ('..math.random(0, 999)..')'
		elseif setting == 'male' then name = names.first_male[math.random(1, #names.first_male)]..' '..names.last[math.random(1, #names.last)]
		elseif setting == 'female' then name = names.first_female[math.random(1, #names.first_female)]..' '..names.last[math.random(1, #names.last)]
		end
	until (not self.purchased[name] and not self.active[name])
	return name
end

function names:isAvailable(name) return (not self.purchased[name] and not self.active[name]) end

function names:purchase(name, account) self.purchased[name] = account end

function names:claim(name, account) self.active[name] = account end

return names 
local human_advanced_actions = require('code.player.human.action.advanced')
local human_basic_actions = require('code.player.human.action.basic')
local human_machine_actions = require('code.player.human.action.machine')
local zombie_advanced_actions = require('code.player.zombie.action.advanced')
local zombie_basic_actions = require('code.player.zombie.action.basic')
local zombie_general_actions = require('code.player.zombie.action.general')
local zombie_brute_actions = require('code.player.zombie.action.brute')
local zombie_hunter_actions = require('code.player.zombie.action.hunter')
local zombie_hive_actions = require('code.player.zombie.action.hive')

local lume = require('code.libs.lume')
local csv_helpers = require('code.libs.csv_helpers')

local actions = {
	zombie = {}, 
	human = {}
}

-- import class data into location class
local actions_path = system.pathForFile("spreadsheet/data/player - actions.csv", system.ResourceDirectory)
local actions_CSV = csv_helpers.convertToLua(actions_path)

for _, action in ipairs(actions_CSV) do
	local mob_type = action.MOB_TYPE

	actions[mob_type][action.ID] = action
	actions[mob_type][action.NAME] = action
end

-- this combines the action activate/critera functions with the CSV data into one table
local addFunctionsToActions = function(mob_type, actions_table)
	for name, functions in pairs(actions_table) do
		local action = lume.merge(actions[mob_type][name], functions) -- merge functions & CSV data

		actions[mob_type][name] = action
		actions[mob_type][action.ID] = action 
	end
end

-- import activate/server_critera/client_critera functions to ALL actions

-- these are default actions 
addFunctionsToActions('human', human_basic_actions)
addFunctionsToActions('human', human_advanced_actions)
addFunctionsToActions('zombie', zombie_basic_actions)
addFunctionsToActions('zombie', zombie_advanced_actions)

-- these require building machineary to activate
addFunctionsToActions('human', human_machine_actions)

-- these require certain skills to activate
addFunctionsToActions('zombie', zombie_general_actions)
addFunctionsToActions('zombie', zombie_brute_actions)
addFunctionsToActions('zombie', zombie_hunter_actions)
addFunctionsToActions('zombie', zombie_hive_actions)

return actions
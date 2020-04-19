local human_advanced_actions = require('code.player.human.action.advanced')
local human_basic_actions = require('code.player.human.action.basic')
local zombie_advanced_actions = require('code.player.zombie.action.advanced')
local zombie_basic_actions = require('code.player.zombie.action.basic')

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
	-- what about abilities/equipment/items
end

-- this combines the action activate/critera functions with the CSV data into one table
local addFunctionsToActions = function(mob_type, ...)
	for _, actions_table in ipairs({...}) do
		for name, functions in pairs(actions_table) do 
			local action = lume.merge(actions[mob_type][name], functions) -- merge functions & CSV data

			actions[mob_type][name] = action
			actions[mob_type][action.ID] = action 
		end
	end
end

-- import activate/server_critera/client_critera functions to actions
addFunctionsToActions('human', human_advanced_actions, human_basic_actions)
addFunctionsToActions('zombie', zombie_advanced_actions, zombie_basic_actions) 

return actions
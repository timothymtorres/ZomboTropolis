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

	-- copy action data to mob_type table
	-- we can use ipairs to get a list of actions 
	actions[mob_type][#actions[mob_type]] = action
	actions[mob_type][action.NAME] = action

	-- copy ALL actions data to table
	-- the action.ID is used for the server/client communication
	actions[action.ID] = action
	actions[action.NAME] = action

	-- what about abilities/equipment/items
	-- we need to import action activate/client & server critera to this
end

-- this combines the action activate/critera functions with the CSV data into one table
local addFunctionsToActions = function(...)
	for _, actions_table in ipairs({...}) do
		for name, functions in pairs(actions_table) do 
			actions[name] = lume.merge(actions[name], functions) 
		end
	end
end

-- import activate/server_critera/client_critera functions to actions
addFunctionsToActions(human_advanced_actions, human_basic_actions) -- for humans
addFunctionsToActions(zombie_advanced_actions, zombie_basic_actions) -- for zombies

return actions
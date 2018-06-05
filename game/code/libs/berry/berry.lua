------------------------------------------------------------------------------------------------
-- The main Berry manager source file. 
-- The API's in this source file can be seen as a set of manager methods for using Berry.	
--
-- @classmod  Berry
-- @release 1.0.0
-- @author Łukasz Durniat
-- @license MIT
-- @copyright Łukasz Durniat, Jan-2018
------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------ --
--                                 REQUIRED MODULES	                                          --						
-- ------------------------------------------------------------------------------------------ --

local class 	  = require 'code.libs.berry.lib.30log-clean'
local Map         = require 'code.libs.berry.Map'
local TileSet     = require 'code.libs.berry.TileSet'
local ObjectLayer = require 'code.libs.berry.ObjectLayer'
local utils       = require 'code.libs.berry.utils'
local json        = require 'json' 

-- ------------------------------------------------------------------------------------------ --
--                                  CLASS                                                     --												
-- ------------------------------------------------------------------------------------------ --

local Berry = class( 'Berry', { berryDebugModeEnabled = true } )

-- ------------------------------------------------------------------------------------------ --
--                                  LOCALISED VARIABLES                                       --	
-- ------------------------------------------------------------------------------------------ --

-- ------------------------------------------------------------------------------------------ --
--                                  PUBLIC METHODS                                            --	
-- ------------------------------------------------------------------------------------------ --

------------------------------------------------------------------------------------------------
-- Enables debug mode so messages are printed to the console when things happen.
------------------------------------------------------------------------------------------------
function Berry:enableDebugMode()

	self.berryDebugModeEnabled = true

end

------------------------------------------------------------------------------------------------
-- Disables debug mode so messages aren't printed to the console. Errors will still be printed.
------------------------------------------------------------------------------------------------
function Berry:disableDebugMode()

		self.berryDebugModeEnabled = false

end	

------------------------------------------------------------------------------------------------
-- Checks if debug mode is currently enabled or disabled.
--
-- @return `true` if enabled, `false` if not.
------------------------------------------------------------------------------------------------
function Berry:isDebugModeEnabled()

	return 	self.berryDebugModeEnabled

end

------------------------------------------------------------------------------------------------
-- Loads a map.
--
-- @param filename The filename of the map.
-- @param tileSetsDirectory Path to load the images. Default is baseDirectory.
-- @return The loaded Map object.
-- @usage
-- local ui = berry.loadMap( "scene/menu/ui/title.json", "scene/menu/ui" )
------------------------------------------------------------------------------------------------
function Berry.loadMap( filename, tileSetsDirectory )

	return Map( filename, tileSetsDirectory )	

end

------------------------------------------------------------------------------------------------
-- Creates the visual representation of a map.
--
-- @param map The map to create.
-- @return The display group for the map world.
------------------------------------------------------------------------------------------------
function Berry.createVisual( map )

	return map:create()

end

------------------------------------------------------------------------------------------------
-- Build a physical representation of a map.
--
-- @param map The map to build. 
------------------------------------------------------------------------------------------------
function Berry.buildPhysical( map )

	map:build()
	
end

return Berry
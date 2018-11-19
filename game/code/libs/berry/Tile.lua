------------------------------------------------------------------------------------------------
-- The Tile class representing single tile image.
--
-- @classmod Tile
-- @author Łukasz Durniat
-- @license MIT
-- @copyright Łukasz Durniat, Jan-2018
------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------ --
--                                 REQUIRED MODULES	                                          --						
-- ------------------------------------------------------------------------------------------ --

local class 	 = require 'code.libs.berry.lib.30log-clean'
local Properties = require 'code.libs.berry.Properties'
local utils      = require 'code.libs.berry.utils'

-- ------------------------------------------------------------------------------------------ --
--                                  CLASS                                                     --												
-- ------------------------------------------------------------------------------------------ --

local Tile = Properties:extend( 'Tile' )

-- ------------------------------------------------------------------------------------------ --
--                                  LOCALISED VARIABLES                                       --	
-- ------------------------------------------------------------------------------------------ --

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight

local abs = math.abs
local floor = math.floor
local ceil = math.ceil

-- ------------------------------------------------------------------------------------------ --
--									PRIVATE METHODS		   									  --
-- ------------------------------------------------------------------------------------------ --

-- ------------------------------------------------------------------------------------------ --
--                                  PUBLIC METHODS                                            --	
-- ------------------------------------------------------------------------------------------ --

------------------------------------------------------------------------------------------------
-- Create a new instance of a Tile object.
--
-- @param data The JSON data.
-- @param map The current Map object.
-- @param tileLayer The TileLayer the the Tile resides on.
-- @return The newly created tile.
------------------------------------------------------------------------------------------------
function Tile:init( data, map, tileLayer )

	-- Make sure we have a properties table
	data.tileproperties = data.tileproperties or {}

	-- Add properties
	self.map = map
	self.data = data
    self.tileLayer = tileLayer
    self.gid = data.gid or 0

    -- If gid is 0 then there is no tile in this spot
    if self.gid and self.gid > 0 then

		self.tileSet = self.map:getTileSetFromGID( self.gid )

		if self.tileSet then 

			-- Add basic properties
			self.tileid = self.gid - self.tileSet.firstgid + 1
			self.tilewidth = self.tileSet.tilewidth
			self.tileheight = self.tileSet.tileheight 

			-- Add tile properties	
			local tileProperties = self.tileSet:getPropertiesForTile( self.tileid )
			for i=1,  #tileProperties do self:addProperty( tileProperties[i] ) end

		end	

	end	

end	

------------------------------------------------------------------------------------------------
-- Sets the rotation of the Tile.
--
-- @param angle The new rotation.
------------------------------------------------------------------------------------------------
function Tile:setRotation( angle )
	
	if self.sprite then

		self.sprite.rotation = angle

	end	
	
end

------------------------------------------------------------------------------------------------
-- Rotates the Tile.
--
-- @param angle The angle to rotate by
------------------------------------------------------------------------------------------------
function Tile:rotate( angle )

	if self.sprite then

		self.sprite.rotation = self.sprite.rotation + angle

	end
	
end

------------------------------------------------------------------------------------------------
-- Gets the Tile visual.
------------------------------------------------------------------------------------------------
function Tile:getVisual()

	return self.sprite

end

------------------------------------------------------------------------------------------------
-- Gets the rotation of the Tile.
--
-- @return The rotation of the tile.
------------------------------------------------------------------------------------------------
function Tile:getRotation()

	if self.sprite then

		return self.sprite.rotation
		
	end
   
end

------------------------------------------------------------------------------------------------
-- Shows the Tile.
------------------------------------------------------------------------------------------------
function Tile:show()
	
	if self.sprite then

		self.sprite.isVisible = true

	end
	
end

------------------------------------------------------------------------------------------------
-- Hides the Tile.
------------------------------------------------------------------------------------------------
function Tile:hide()
	
	if self.sprite then

		self.sprite.isVisible = false
		
	end
	
end

------------------------------------------------------------------------------------------------
-- Moves the Tile.
--
-- @param x The amount to move the Tile along the X axis.
-- @param y The amount to move the Tile along the Y axis.
------------------------------------------------------------------------------------------------
function Tile:move( x, y )

	utils:moveObject( self, x, y )

	if self.sprite then utils:moveObject( self.sprite, x, y ) end

end

------------------------------------------------------------------------------------------------
-- Creates the visual representation of the Tile.
--
-- @param index The Tile number. Not the gid.
------------------------------------------------------------------------------------------------
function Tile:create( index )

	self.index = index

	if self.tileSet then 

		if self.tileSet.imageSheet then 
				
			self.sprite = display.newImageRect( self.tileLayer.group, self.tileSet.imageSheet, self.tileid, self.tilewidth, self.tileheight )	
      		
    	else -- Collections of images  

      		for k, v in pairs( self.tileSet.tiles ) do
        	
        		if tonumber( k ) == self.tileid - 1 then
          	
          			-- Create the actual Corona image object
          			self.sprite = display.newImageRect( self.tileLayer.group, self.tileSet.directory .. v.image, v.imagewidth, v.imageheight )
        	
        		end
      		
      		end

    	end

		-- Calculate and set the row position of this tile in the map
		self.row = floor( ( index + self.tileLayer.width - 1 ) / self.tileLayer.width )	

		-- Calculate and set the column position of this tile in the map
		self.column = index - ( self.row - 1 ) * self.tileLayer.width

		-- this is for my sanity, lol, I keep getting column and rows mixed up 
		local x, y = self.column, self.row 

		-- Get offsets if they exist (note - not every tileLayer has an offset)
		local offsetX, offsetY = self.tileLayer.data.offsetx or 0, self.tileLayer.data.offsety or 0

		-- Apply sprite properties
		self.sprite.anchorX, self.sprite.anchorY = 0, 1

		if self.map.orientation == 'isometric' then
	        self.sprite.x = (-1 * self.row * self.map.tilewidth / 2) + (self.column * self.map.tilewidth  / 2) + offsetX
	        self.sprite.y = (self.column * self.map.tileheight / 2) - (-1 * self.row * self.map.tileheight / 2) + offsetY
	    elseif self.map.orientation == 'staggered' then


	    	local stagger_axis = self.map.data.staggeraxis -- 'y' or 'x'
	    	local stagger_index = self.map.data.staggerindex -- 'odd' or 'even'

	    	local staggered_offset_y, staggered_offset_x = (self.map.tileheight/2), (self.map.tilewidth/2)

print(stagger_axis, stagger_index)

	    	if stagger_axis == 'y' then
	    		if stagger_index == 'odd' then
	    			if y % 2 == 0 then
	    				self.sprite.x = (x * self.map.tilewidth) + staggered_offset_x + offsetX
	    			else
	    				self.sprite.x = (x * self.map.tilewidth) + offsetX
	    			end
	    		else
	    			if y % 2 == 0  then
	    				self.sprite.x = (x * self.map.tilewidth) + offsetX
					else
	    				self.sprite.x = (x * self.map.tilewidth) + staggered_offset_x + offsetX
					end
	    		end
	    		self.sprite.y = (y * (self.map.tileheight - self.map.tileheight/2)) + offsetY
	    	else
	    		if stagger_index == 'odd' then
	    			if x % 2 == 0  then
	    				self.sprite.y = (y * self.map.tileheight) + staggered_offset_y + offsetY
	    			else
	    				self.sprite.y = (y * self.map.tileheight) + offsetY
	    			end
	    		else
	    			if x % 2 == 0  then
	    				self.sprite.y = (y * self.map.tileheight) + offsetY
					else
	    				self.sprite.y = (y * self.map.tileheight) + staggered_offset_y + offsetY
					end
	    		end
	    		self.sprite.x = (x * (self.map.tilewidth - self.map.tilewidth/2)) + offsetX
	    	end


--[[
	    	local staggered_offset_x = self.column % 2 * (self.map.tilewidth/2)
	    	local staggered_offset_y = self.row % 2 * (self.map.tileheight/2)
	        self.sprite.x = self.row*self.map.tilewidth + staggered_offset_x 
	        self.sprite.y = 1*self.column*(self.map.tileheight/2) + staggered_offset_y
--]]
	        --self.sprite.x = (-1 * self.row * self.map.tilewidth)  + staggered_offset + offsetX
	        --self.sprite.y = (1 * self.column * self.map.tileheight / 2) + offsetY



	    elseif self.map.orientation == 'orthogonal' then
			self.sprite.x, self.sprite.y = ( self.column - 1 ) * self.map.tilewidth + offsetX, self.row * self.map.tileheight + offsetY
		end

		--utils:centerAnchor( self.sprite )

		local physicalProperties = {
		'bodyType',
		'isAwake',
		'isSleepingAllowed',
		'isBodyActive',
		'isSensor',
		'isFixedRotation',
		'gravityScale',
		'angularVelocity',
		'angularDamping',
		'linearDamping',
		'isBullet',
		}

		-- Copy over the custom properties to the sprite
    	utils:copyPropertiesToObject( self.tileLayer, self.sprite, physicalProperties )
		utils:copyPropertiesToObject( self, self.sprite, physicalProperties )

		for key, value in pairs( self.properties ) do
					
			self.map:firePropertyListener( self.properties[key], 'tile', self )	
	
		end

	end	

end	

------------------------------------------------------------------------------------------------
-- Builds the physical representation of the Tile.
------------------------------------------------------------------------------------------------
function Tile:build()
	local visual = self:getVisual()
	local body = visual
	
	if visual and visual.hasBody then
		local tileid = self.gid - self.tileSet.firstgid + 1
		local object = self.tileSet:getCollisionShapeForTile( tileid ) 
		local mSin = math.sin
		local mCos = math.cos
		local mRad = math.rad 

		if object then

			local function rotate( vertices, angleInDeg )

				local angleInRad = mRad( angleInDeg ) 

				for _, vertex in ipairs( vertices ) do
					local x = vertex.x
					local y = vertex.y
					local newX = x * mCos( angleInRad ) - y * mSin( angleInRad )
					local newY = x * mSin( angleInRad ) + y * mCos( angleInRad )

					vertex.x = newX
					vertex.y = newY

				end	
					
			end	

			local function translate( vertices, deltaX, deltaY  ) 

				for _, vertex in ipairs( vertices ) do
					local newX = vertex.x + deltaX
					local newY = vertex.y + deltaY 

					vertex.x = newX
					vertex.y = newY
					
				end	

			end	

			-- Use polygon or rectangle as collision shape
			if object.polygon or ( not object.ellipse and not object.polyline ) then
				
				local vertices = utils:deepCopy( object.polygon ) or { 
					{ x=0, y=0 },
					{ x=object.width, y=0 },
					{ x=object.width, y=object.height },
					{ x=0, y=object.height }, 
				}
				local angle = object.rotation
				local deltaX = object.x - visual.width * 0.5 
				local deltaY = object.y - visual.height * 0.5 

				rotate( vertices, angle )
				translate( vertices, deltaX, deltaY )

				local shape = {}

				-- Transform two-dimensional table to one-dimensional table
				for i=1, #vertices do

					shape[2 * i - 1] = vertices[i].x
					shape[2 * i] = vertices[i].y

				end	

				body.shape = shape	

			end	

		end	

		physics.addBody( body, visual ) 

		utils:applyPhysicalParametersToBody( body, self.tileLayer )
		utils:applyPhysicalParametersToBody( body, self )

	end	

end	

------------------------------------------------------------------------------------------------
-- Completely removes all visual and physical objects associated with the Tile if not nil.
------------------------------------------------------------------------------------------------
function Tile:destroy()
	
	-- Destroy the visual object
 	local visual = self:getVisual()

	if visual then

		display.remove( visual )

	end
	
	visual = nil

end

return Tile
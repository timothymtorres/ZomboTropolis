# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased Version

## v0.13.0 - ???
### Added
- New human armors: 
	- Biosuit has special effects when worn *depending on the condition of the armor*.  It grants immunity to infection from bites and hunter zombies are unable to track the player.  It also hides the HP status of the player and conceals their location from being revealed by outside zombies with the scent blood skills.  It offers zero protection, is very fragile, and is light weight.  It can be found in labratory buildings and is classified as a research item.  
	- Kevlar is the jack of all trades armor.  It offers moderate protection, has average durability, and average weight.  Additionally it is *the only armor* in the game to have bullet protection.  It can be found in police departments and is classified as a military item.
	- Riotsuit is the king of melee.  It offers high protection from melee attacks, has high durability, but is the heaviest armor available.  It can be found in police departments (very rare) or in the military base and is classified as a military item.
- Pheromone Spray gadget that masks a players scent from any hunter zombies trying to track.  The condition level of the spray determines how much scent is lost.
- New melee weapons: Wrench, Pipe, Rake, Shovel, Axe, Pickaxe, Pitchfork, and Poolstick.
- New ranged weapon: Bow.

### Fixed
- Antidote not properly removing infection status.

### Changed
- Leather Jacket armor is considered bare bones armor.  It offers minimal protection, is fragile, and is the lightest armor in the game.  It can be commonly found in lots of different buildings and is classified as a military item.
- Firesuit armor only protects from acid attacks.  Although acid does no damage to the player, it does destroy their inventory and this armor is the only way to prevent that from happening.  It offers zero protection, is fragile, and is light weight.  It can be found in fire departments and is classified as a engineering item.
- Almost all items have had their damage, durability, accuracy, and weight values changed.
- All the search rates for items.  They now use a google spreadsheet that is exported to a CSV file and loaded into the code from there.  This makes balancing stuff much easier and less of a burden.
- Zombie bite and claw attacks had their damage, accuracy, and skill modifiers all changed.
- Ammo names now should easily reflect what weapon they belong too.
- Renamed the Rifle to be a SMG.
- All items that are found outside (except barricades) will spawn with a high chance of a ruined state.
- Barricades found outside will spawn with a high chance of a worn state.  However barricades found in carparks and junkyards will spawn with a high chance of a pristine state.

### Removed
- Critical hits from all weapons.


## v0.12.0 - 06/14/2019
### Added
- Sprites for all in game items. (some are placeholders)
- Humans interacting with search areas by `Double Tap` results in a single search | `Tap & Hold` results in repeating searches until released.
	- Hidden zombies being revealed by a search.
	- Different search animations for items, junk, and hidden zombies
- Players sprites moving towards the location of the actions they are performing.
- Physics to location scene.  Mobs wander around a location bouncing off walls and physics boundaries.  These physics boundaries seperate attacker/defenders and it depends on which group is in control of the building.  


### Fixed
- Searching causing players to be deleted from location.
- Hidden zombies being displayed in a location.

### Changed
- Equipment, location, item, and mob icons to be placeholder sprites

### Removed
- Axe, machate, and phone items from search chance since the code classes have not been setup.
- Zooming feature for location or world map.  (will be added at a later date)

## v0.11.0 - 11/26/2018
### Added
- Isometric staggered world map.
- Orthogonal location layout that changes depending on player position in world map.
- Buildings have equipment sprites and animations displayed (if powered) for terminal, generator, and transmitters if present.
- Buildings have barricade and door sprites set based on health.
- Locations display mobs inside or outside with their names overhead.  Mobs wander around aimlessly. 
- Dead humans or killed zombies become corpses.  The mob sprite does a 90 degree horizontal rotation to make it appear they are lying down. The sprite also remains motionless.
- Both city and location images can be panned and zoomed within set boundaries.
- Zooming in far enough from the city map will switch to the current room player is in.
- Zooming out far enough from the room will switch to the city world map.

### Changed
- Map tile types to be set based on `Location Tile ID` layer in the `world.tmx` file.  Previously every map tile was set to be a `hospital` type as default, which was used to temporarily get stuff working.  


## v0.10.0 - 01/27/2018
### Added
- `Gadget` and `Syringe` research human skills grant a higher hp threshold when using a syringe on a zombie.
- Scanner item that is used to scan zombies into a database for tracking.  The `Scanner` research human skill boosts the chance of a successful scan attempt.
- Terminals able to be accessed for data.  By default a human can access a terminal to gain info about the total # of zombies in an area.  If the human has the `Gadget` research skill they get info on the total zombie xp levels in an area.  If the human also has the `Terminal` research skill they get to see the position of scanned zombies on the map.  The condition of the terminal affects the accuracy of the data provided.  The `Gadget` and `Terminal` skills boosts the accuracy of the data.
- Scanned status effect for zombies that is gained from being scanned by a human.  Performing any action will result in this status effect being removed.
- The `Gadget` research human skill grants GPS, Flashlight, Scanner, and Radio items improved durability usage.
- `Repair` and `Repair Adv` engineering human skills decrease the ap cost for repairing building integrity, doors, or machines.
- `Renovate` engineering human skill allows ruins to be repaired.
- `Tech` and `Tech Adv` engineering human skills decrease the ap cost for installing machines into buildings.
- Random name generator for humans and zombies.  
- Humans have traditional names: `Bruce McMullen`, `Sam Warren`, `Rocco Ward`, etc.
- Zombies have hivelike names based on the Greek Alphabet and a number from 0-999:  `Alpha 371`, `Gamma 62`, `Delta 971`, etc.  This is to enforce the role-play that zombies should be without a solid identity.

## v0.9.0 - 01/21/2018
### Added
- CHANGELOG.md
- Zombie skill icons for: Rejuvenation, Smell Blood, Smell Blood Adv, Satiation Bonus, Resurrection, Armor, Armor Adv, Maim, Maim Adv, Power Claw, Hide, Hide Adv
- Human skill icons for: Roof Travel, IP Bonus, Diagnosis, Pyrotech Adv, Gadgets, Scanner, Syringe, Terminal, Renovate, Tech, Tech Adv
- `Maim` brute zombie skill damages a humans potential hp. (when using claws)  There is also a possibility to severe limbs if a human has low health.  This will result in permanent hp loss that is unhealable.
-  `Leap` hunter zombie skill allows them to travel from ruined building to ruined building.  `Leap Adv` skill allows for travel from ruined building to unruined building.
-  `Rejuvenation` general zombie skill replenishes hp from successful bite attacks.
-  `Satiation Bonus` general zombie skill grants a bonus to max satiation a zombie can store.
-  `Smell` general zombie skill displays the presence of zombies on a tile regardless if the player or zombies are inside/outside a building.  It also displays wounded humans nearby.
-  `Smell Adv` hunter zombie skill displays wounded humans regardless of the player's position.  (So you can basically see wounded humans who are inside buildings from the outside, aka x-ray vision) 
-  `Resurrection` general zombie skill grants a hp boost per ap spent to revive.
-  Zombies now gain 15 HP gain when feeding on corpses. The `Rejuvenation` skill increases this amount by 15, resulting in a total of 30 HP gained.
-  `Hivemind` general zombie skill now allows zombies to communicate via telepathy regardless of location.
-  `Armor` brute zombie skill generates organic armor for a zombie by feeding on a corpse.  The armor is selected at random unless `Armor Adv` skill is purchased.  `Armor Adv` also boosts the armor condition when it is generated.
-  Radios for humans can now toggle the power on/off and retune the channel frequency.  The durability code for handheld radios is only checked for radios that are turned on.  (so keeping backup radios that are turned off might be a good idea)

### Changed
- Human and Zombie skill names, descriptions, and icons  
- Combat accuracy has been increased for certain skills
- Reviving as a zombie is no longer a fixed ap cost action.  A player can choose to spend `x` ap to regain lost hp.  The conversion rate is 5 hp per ap.  The `Resurrection` skill boosts the rate to 10 hp per ap.  The minimum hp needed to revive is 20, and the max hp to revive is 50.  (`Hp Bonus` skill automatically gives +10 HP when reviving) 

### Fixed
- Organic armor code to spawn correctly

## v0.8.1 - 01/02/2018
### Added
- A link to the discord server on the README.md
- FAQ.md
- Zombie `power_claw` skill provides a x2 degrade multiplier against human armor. (only when attacking with claws)
- GPS destruction/degrade message
- Armor destruction/degrade message to both attacker and target

### Remove
- Descriptions for door health.

### Changed
- Buildings integrity is now set based on building type.  The max integrity range is between 3-30 depending on the building.  Large buildings and ones with resources will have more integrity.  - A zombie's ruin ability works by decreasing the integrity of a building by -1 per action.  
- Ransacked integrity state is when the building is not at max integrity, this results in lowered search rates and quality of discovered items.
- Ruined integrity state is when the building is at or below 0, this results in *severely* lowered search rates and quality of discovered items.
- Ruin decay sets in once the building is at or below `0`, and keeps decreasing by 1 until the negative of max integrity is reached.  (ie. if max integrity of a building is 5, then the max ruin value is -5)
- The human skill 'renovate' repairs buildings with a toolbox by increasing the integrity by 1 per action.
- Toolbox durability is 1, ap cost is 5 (with modifiers -1 for repair, and -2 for repair_adv)
- Max feedings from a carcass is now 4.
- A zombie can create organic armor from feeding on a corpse with the `armor` skill.  If the zombie has `armor_adv` they may select which armor to spawn, otherwise it is random.
- Organic armor resistance values. 

## v0.8.0 - 12/24/2017
### Added
- Hide ability for Hunter class.  Can only hide in a unpowered building with no humans present.  Hidden players cannot be seen unless the area is successfully searched.  Performing any action while hidden will reveal a player.
- Powering a building with a hidden players inside will reveal their location.
- Hide icons for `hide` and `hide_adv` skills.

## v0.7.0 - 12/17/2017
### Added
- Message for item destruction/degradation
- README.md

### Removed
- Action/Item/Ability scenes
- Building descriptions
- Impale status effect

### Changed
- Burn status effect to deal 1 damage per turn.
- Zombie decay to be called zombie hunger instead.
- Split infection status effect into two effects.  Infection and Immunity. (immunity provides temporary resistance from infection)

### Deprecated
- Item/Organic Armor
- Radio transmission
- Enzyme cost for zombie abilities

## v0.6.0 - 11/02/2017
### Added
- Item destruction/degradation messages for acid ability
- Item condition change visible based on human class
- Broadcast event for player, tile, object, or the entire map
- Broadcast messages for player actions and status effects

### Fixed
- Items now updating condition properly
- Syringe targeting the wrong player
- Humans being able to respawn from their dead bodies

### Changed
- `drag_prey` skill has been moved from general to brute class

### Deprecated
- Attacking barricades

## v0.5.0 - 08/28/2017
### Added
- Humans can reinforce a building to make room for barricades
- Humans can barricade a building provided they have available room
- Humans can be prevented from reinforcing or barricading a building if a zombies are present
- Zombies can ruin/ransack a building to prevent humans from using it
- Toolboxes can repair a ruined/ransacked building
- Buildings can decay when ruined (costing more AP to repair)

### Changed
- Item condition spawn odds based on ruined/ransacked/intact state instead of powered/unpowered state

## v0.4.2 - 08/17/2017
### Fixed
- Selecting proper target for actions
- Attacking with item causing problems due to defunct code

### Changed
- Tracking ability activation to require the zombie to be outside 

## v0.4.1 - 08/12/2017
### Fixed
- Typo that was causing a crash.

### Changed
- Armor items are now single use.

## v0.4.0 - 08/12/2017
### Added
- Acid ability for hive zombies.  This ability melts a humans inventory causing item destruction/degradation.
- Firesuit armor for humans that provides acid immunity. (fragile to melee attacks though)
- Syringe item and skills.  This allows an antidote to be created from a weakened nearby zombie.
- Antidote item that cures infection.
- Antibodies item that gives immunity from infection.

### Removed
- Stinger weapon

### Fixed
- All medical items disabled for zombies (we need to use syringes on them at least)

### Changed
- Items are now categorized into single use, limited use, and multi use durability. 

## [0.3.0] - 07/11/2017
### Added
- Flashlight gives a bonus to searching when not inside a powered building.

### Changed
- Infection status effect to be active on zombie bite.  At first it goes dormant for a period of time and then once active does continous damage.

### Removed
- Poison status effect

## v0.2.0 - 11/14/2016
### Added
- GPS item that gives a chance of free movement when outside.
- Durability values to flashlight and GPS

### Removed
- Sentient zombie class
- Medical human class

## v0.1.0 - 11/07/2016
### Added
- Durability checks for items
- Barricade item that fortifies a building to prevent zombie entry.
- Tracking ability for Hunter class that allows a zombie to locate humans.

### Fixed
- Item/armor degrades properly

## v0.0.0 - 05/24/2016
- This is the starting point where I moved my code from Dropbox to Git.
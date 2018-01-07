# Changelog

-----------------------------------------------------------------------------------------

All notable changes to this project will be documented in this file.  The format is based on [Keep a Changelog]() and this project adheres to [Semantic Versioning]().

-----------------------------------------------------------------------------------------

## [Unreleased]()

### Added
- CHANGELOG.md
- Maim ability for brute zombies that damages a humans max hp, and potentially amputates limbs if they have low health.

-----------------------------------------------------------------------------------------

## [0.8.1] - 01/02/2018

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

-----------------------------------------------------------------------------------------

## [0.8.0] - 12/24/2017

### Added
- Hide ability for Hunter class.  Can only hide in a unpowered building with no humans present.  Hidden players cannot be seen unless the area is successfully searched.  Performing any action while hidden will reveal a player.
- Powering a building with a hidden players inside will reveal their location.
- Hide icons for `hide` and `hide_adv` skills.

-----------------------------------------------------------------------------------------

## [0.7.0] - 12/17/2017

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

-----------------------------------------------------------------------------------------

## [0.6.0] - 11/02/2017

### Added
- Item destruction/degradation messages for acid ability
- Item condition change visible based on human class
- Broadcast event for player, tile, object, or the entire map
- Broadcast messages for player actions and status effects

### Fixed
- Items now updating condition properly
- Syringe targetting the wrong player
- Humans being able to respawn from their dead bodies

### Changed
- `drag_prey` skill has been moved from general to brute class

### Deprecated
- Attacking barricades

-----------------------------------------------------------------------------------------

## [0.5.0] - 08/28/2017

### Added
- Humans can reinforce a building to make room for barricades
- Humans can barricade a building provided they have available room
- Humans can be prevented from reinforcing or barricading a building if a zombies are present
- Zombies can ruin/ransack a building to prevent humans from using it
- Toolboxes can repair a ruined/ransacked building
- Buildings can decay when ruined (costing more AP to repair)

### Changed
- Item condition spawn odds based on ruined/ransacked/intact state instead of powered/unpowered state

-----------------------------------------------------------------------------------------

## [0.4.2] - 08/17/2017

### Fixed
- Selecting proper target for actions
- Attacking with item causing problems due to defunct code

### Changed
- Tracking ability activation to require the zombie to be outside 

-----------------------------------------------------------------------------------------

## [0.4.1] - 08/12/2017

### Fixed
- Typo that was causing a crash.

### Changed
- Armor items are now single use.

-----------------------------------------------------------------------------------------

## [0.4.0] - 08/12/2017

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

-----------------------------------------------------------------------------------------

## [0.3.0] - 07/11/2017

### Added
- Flashlight gives a bonus to searching when not inside a powered building.

### Changed
- Infection status effect to be active on zombie bite.  At first it goes dormant for a period of time and then once active does continous damage.

### Removed
- Poison status effect

-----------------------------------------------------------------------------------------

## [0.2.0] - 11/14/2016

### Added
- GPS item that gives a chance of free movement when outside.
- Durability values to flashlight and GPS

### Removed
- Sentient zombie class
- Medical human class

-----------------------------------------------------------------------------------------

## [0.1.0] - 11/07/2016

### Added
- Durability checks for items
- Barricade item that fortifies a building to prevent zombie entry.
- Tracking ability for Hunter class that allows a zombie to locate humans.

### Fixed
- Item/armor degrades properly

-----------------------------------------------------------------------------------------

## [0.0.0] - 05/24/2016

- This is the starting point where I moved my code from Dropbox to Git.
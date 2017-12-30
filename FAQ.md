### Q: What is the difference between the ZomboTropolis remake and Urbandead/Quarantine2019?

*(Note - I will here forth refer to ZomboTropolis as ZT, Urbandead as UD, and Quarantine2019 as Q)*

Multiple major and distinct differences.  

**Platform:**  ZT is going to be an app for mobile.  Browser based games are dying, any remake needs to address this.  The app market has a huge playerbase that keeps growing, and for games such as this, the complexity of getting a decent user interface for mobile is pretty doable.  Push notifications also present a major advantage over browsers when it comes to in game events.

**Graphics:**  ZT is going to be using sprites for the characters, locations, and skills from free art assets.  (Space Station 13, game-icons.net, etc.)  This is a __MUST HAVE__ for an app on the app store.  Without graphics there would be no playerbase! (although the hardcore vets will still play regardless)

**Gameplay for UD:**  
UD was a simple game, with basic math calculations and combat.  Survivors had items, safehouses, and equipment.  Zombies had abilities that were rather... plain.  The skills for both sides complemented the above rather well, but none of it was groundbreaking.  Neither side in the game could truly win.  When one side started to win, the code in the game would nerf the other side.  What gave this game so much life was the *community*.  They were so active and fun to play with and it gave the game a rich and immersive history.  The map for the game was huge!  There were endless suburbs and buildings, not to mention distinct landmarks such as malls, churches, and mansions that were fun to discover and explore.  One problem with a map this size was population.  If population for the game dipped to low (and it did) then large portions of the map became ghost towns.  Kevan (the developer) did test out new maps with permadeath enabled.  This briefly revitalized the playerbase, although each of these maps are now over with.

**Gameplay for Q:**  
Q was a remake of UD with the intention of adding more complexity, features, and a end goal for both sides.  With Q, you could actually win the game for your side!  By playing through a round based system, zombies could either eliminate all humans, or humans could research the cure to win the game.  Maps for Q were much smaller and tailored to the size of the population.  One notable thing that Q did was to split skills into classes.  Certain zombies were given abilities that others did not have, and vice-versa for humans.  While this was a great idea, I believe it was executed poorly.  Some skills were worthless, others were unbalanced.  Some classes only had one utility they were good for and nothing else. (which made gameplay dull and repetitive for that class)  Other features and systems seemed to be designed without proper planning.  Staircases and multi-level buildings served no purpose, infection was unrealistic and unpractical, and resource points for buildings was just plain weird.  It had it's flaws but I respected what the developers of Q were trying to do.  UD had been neglected with updates, and Q was trying to branch off into a much better version.  And to be fair, Q did come up with some really great stuff!  Power plant buildings that powered entire suburbs, computers could network with ISP buildings, items had durability, etc. etc.  Q only had a fraction of the population that UD had, so their rounds and maps were rather quick and small.  Still lots of fun to play back in the day though!

**Gameplay for ZT:**  
ZT seeks to take both of these games a step further and add roguelike features and complexity to the code.  All skills, abilities, and items in the game use dice rolls and dice modifiers to function.  This has been implemented in a (mostly) balanced fashion.  

Just like UD, there is a persistent world, but with rubber banding enabled that stretches the map based on population size.    Respawns for the game are always enabled, but a player will lose all their items, abilities, and skills upon permadeath.  Permadeath is triggered for humans upon death, and zombies upon starvation.  The goal is to follow a [prey/predator model](http://www.tiem.utk.edu/~gross/bioed/bealsmodules/pred-prey.gph1.gif) of graphing.

Leveling is based on time.  Players are no longer forced to heal, fight, or repair things to gain experience.  The longer a player's character survives in the game, the more experience they earn to unlock skills.  The skill system is setup to exponentially increase the skill cost after prior skills have been purchased.  With enough time, a player can even unlock a special class with it's own special abilities to enhance a certain playstyle.  

Items and equipment in the game possess a condition value that will enhance or degrade its functionality.  Each class can see relevant condition data based on the type of object. (military class can see weapon conditions, engineering class can see equipment and barricade conditions, etc.)  Subsequent uses of an item or equipment eventually decreases the condition, yielding lower dice rolls or performance results.  For instance, a generator that is "pristine" condition will use fuel more efficiently than the "ruined" condition.  Additionally, searching in buildings when they are ruined yields items of lower quality. (including lowered search rates)   

A lot more features have been added to ZT than in Q and UD.  A quick list as follows,

+ Hunter zombie function as scouts.  They can hide in unlit buildings, track players scent, free-run from ruined buildings into unruined buildings, move faster than other zombies (movement cost 1 AP), blood vision (x-ray) to see wounded characters from outside.
+ Brute zombies function as tanks.  They can maim humans (reduce their hp permanently), generate organic armor from corpses, drag prey out into the streets, and destroy barricades/equipment/armor more effectively
+ Hive zombies function as support.  They can ruin buildings, corrode human inventory with acid, deliver infection with bites, and communicate with all zombies via the hivemind. 

+ Engineers are builders.  They can repair ruins, barricade to higher levels, and install equipment faster.
+ Military are fighters.  They can master any weapon, maim zombies, and give a bonus to safehouse defenses.
+ Researchers are healers.  They can heal efficiently, scan zombies, use terminals (gives info about surroundings), and create antidotes.

While humans generally do not have restrictions to their actions, certain actions will greatly benefit from skills from one class.

### Q: Roguelike?!  With permadeath, dice and stuff?

Yes.  If you die (as a human) or starve (as a zombie) then it's game over.  Fortunately, respawning is easy and you won't be completely useless with a new character.  With ZT, your goal is to see how long you can survive, and if I have developed the game correctly, this should be hard for both sides.
  
Regarding dice, I felt like both UD and Q suffered from using what I call 'basic' math.  Weapons and items always did `x` amount of effect.  That wasn't realistic and pretty boring for gameplay.  So by adding dice it would allow ZT to be more dynamic!  Weapons in better condition do more damage or have better accuracy.  Skills either boost accuracy or grant rerolls to weapon attacks that successfully land.  This is a powerful system that works well and allows for interesting possibilities. 

### Q: What about PK'ing?

Player killing is going to be disabled for both sides.  So a human cannot kill other humans, and vice-versa for zombies.  It would be too game breaking to have this feature enabled with permadeath functioning.  

Additionally:

* It is not possible for humans to attack or destroy equipment in buildings.
* Humans can enter buildings regardless of barricade levels (thus no overcade griefing)

To enable these things would be the trivial task of removing a few lines of code.  This may get added as a feature to a new map (such as Monroeville), or in game event (a dark fog), or a map subsection (sewers).  Don't expect it to be a normal occurrence in game though.

### Q: Will this be free?  What is the monetization plan?

Free for freedom!  Yes, it will be free.  The monetization plan I have in mind is to have an occasional ad inserted into the game. (probably after AP is used)  Another source of funding is to have cosmetic items in game that can be unlocked via purchasing tokens or surviving for `x` amount of days.  

Money will not give a person an in game advantage.  This will keep the game true to it's predecessors!  :)

### Q: When will the game be playable/finished?

I'm aiming for development to be finished around Spring 2018.  The app should launch shortly after that time frame.

### Q: How long has this been in development?

I have been developing ZT for a few years off and on in my free time.  This last year I have made tremendous progress, and the game is now close to being finished.  I have worked on other smaller projects, but this game has been my most ambitious yet.  

### Q: What about modding?

I will be looking at modding ZT to other themes since my API and source code is pretty robust.  It shouldn't be that hard to switch it to something like say, Ninjas vs Samurais, heh.

### Q: How can I help?

I need help with the following:

+ Playtesters in a few months  
+ Setting up a ZT game wiki
+ People to bounce ideas off

I am **not** looking for other coders or artists to contribute at this time.  After launch this may change.

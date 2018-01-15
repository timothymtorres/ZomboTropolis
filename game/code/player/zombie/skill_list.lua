local fillSkillList = require('code.player.fillSkillList')

local skill_list = {
  flag = {
    -- Classes
    brute =                2^0,
    hunter =               2^1,
    hive =                 2^2,

    -- General
    hp_bonus =             2^0,  -- hp_bonus MUST remain flag 1 b/c it's used for both zombies & humans on the bitflag 1 slot
    hand_stimulus =        2^1,
    head_stimulus =        2^2,
    grapple =              2^3,
    hivemind =             2^4,
    rejuvenation =         2^5,
    smell_blood =          2^6,
    muscle_stimulus =      2^7,
    hunger_bonus =         2^8,  
    resurrection =         2^9,  

    -- Brute
    claw =                 2^0,
    claw_adv =             2^1,
    power_claw =           2^2,
    grapple_adv =          2^3, -- combine drag_prey with this?
    armor =                2^4,
    armor_adv =            2^5,
    maim =                 2^6,
    maim_adv =             2^7,
    
    -- Hunter
    sprint =               2^0,
    leap =                 2^1,
    leap_adv =             2^2,
    track =                2^3,
    track_adv =            2^4,
    hide =                 2^5,
    hide_adv =             2^6,
    smell_blood_adv =      2^7,
    
    -- Hive  
    bite =                 2^0,
    bite_adv =             2^1,
    acid =                 2^2,
    acid_adv =             2^3,
    ruin =                 2^4,
    ruin_adv =             2^5,
    infection =            2^6,
    infection_adv =        2^7,
  },
  order = {
    category = {'classes', 'general', 'brute', 'hunter', 'hive'},
    classes = {'brute', 'hunter', 'hive'},
    general = {'muscle_stimulus', 'hand_stimulus', 'head_stimulus', 'grapple', 'hivemind', 'hp_bonus', 'hunger_bonus', 'smell_blood', 'rejuvenation', 'resurrection'},    
    brute = {'claw', 'claw_adv', 'power_claw', 'grapple_adv', 'armor', 'armor_adv', 'maim', 'maim_adv'},      
    hunter = {'sprint', 'leap', 'leap_adv', 'track', 'track_adv', 'hide', 'hide_adv', 'smell_blood_adv'},         
    hive = {'bite', 'bite_adv', 'acid', 'acid_adv', 'ruin', 'ruin_adv', 'infection', 'infection_adv'},
  },
  info = {
    classes = {
      brute = {
        name='brute',
        desc='Unlock Brute skills',
        icon='lizardman',
      },
      hunter = {
        name='hunter',
        desc='Unlock Hunter skills',
        icon='tear-tracks',
      },
      hive = {
        name='hive',
        desc='Unlock Hive skills',
        icon='frontal-lobe',
      },
      
    },
    general = {
      muscle_stimulus = {
        name='muscle stimulus',
        desc='Melee attacks +5% to-hit',
        icon='embrassed-energy',
      },
      hand_stimulus = {
        name='hand stimulus',
        desc='Claw attacks +10% to-hit',
        icon='evil-hand',
      },
      head_stimulus = {
        name='head stimulus',
        desc='Bite attacks +10% to-hit',
        icon='totem-head',
      },
      grapple = {
        name='grapple',
        desc='Melee attacks +5% to-hit for selected target after successful claw attack',
        icon='grab',
      },
      smell_blood = {
        name='smell blood',
        desc='Vague health status of visible humans is displayed as well as the number of standing zombies both inside and outside buildings',
        icon='cut-palm',
      },
      hp_bonus = {
        name='hp bonus',
        desc='Bonus +10 max hp',
        icon='heart-organ',
      },
      hunger_bonus = {
        name='hunger bonus',
        desc='Bonus for max satiation',
        icon='fat',
      },
      hivemind = {
        name='hivemind',
        desc='Unlocks ability to communicate with the hive and emit feeding groans when humans are nearby.',
        icon='conversation',
      },
      rejuvenation = {
        name='rejuvenation',
        desc='Bite attacks replenish HP',
        icon='neck-bite',
      },
      resurrection = {
        name='resurrection',
        desc='Lowered AP cost to revive after being killed',
        icon='raise-zombie',
      },
    },
    brute = {
      claw = {
        name='claw',
        desc='Claw attacks +10% to-hit and increased damage',
        icon = 'claw-slashes',
      },    
      claw_adv = {
        name='claw advanced',
        desc='Claw attacks recieve +15% to-hit, an extra damage roll, and a bonus reroll',
        icon='wolverine-claws',
      }, 
      power_claw = {
        name='power claw',
        desc='[Not Implemented] Claw attacks against buildings, barricades, worn armor, and machines deals double damage',
        icon='slashed-shield',
      }, 
      armor = {
        name='armor',
        desc='Manifest an exterior hide of organic armor that is randomly selected after feeding on a corpse',
        icon='layered-armor',
      }, 
      armor_adv = {
        name='armor advanced',
        desc='Manually select which organic armor type to spawn and increase its starting condition',
        icon='shieldcomb',
      },        
      maim = {
        name='maim',
        desc='Claw attacks do a fraction of permanent damage and have a chance to delimb a weakened human',
        icon = 'amputation',
      },
      maim_adv = {
        name='maim advanced',
        desc='Increased permanent damage and chance to delimb for claw attacks',
        icon = 'decapitation',
      },
      grapple_adv = {
        name='grapple advanced',
        desc='Ability to drag severely wounded humans outside of open buildings (and perma grapple)',
        icon = 'swallow',
      },
    },
    hunter = {
      sprint = {
        name='sprint',
        desc='AP cost to travel is reduced by one',
        icon='run',
      },
      leap = {
        name='leap',
        desc='Can now leap from ruined buildings',
        icon='sprint',
      },
      leap_adv = {
        name='leap advanced',
        desc='Can now leap from ruined buildings into unruined buildings',
        icon='fire-dash',
      },
      track = {
        name='track',
        desc='Ability to locate humans',
        icon='eyeball',
      },
      track_adv = {
        name='track advanced',
        desc='Ability to locate humans is improved',
        icon='brass-eye',
      },
      hide = {
        name='hide',
        desc='Ability to hide inside unoccupied and unpowered buildings',
        icon='worried-eyes',
      },
      hide_adv = {
        name='hide advanced',
        desc='Improved chance and reduced ap cost to hide',
        icon='hidden',
      },
      smell_blood_adv = {
        name='smell blood advanced',
        desc='Shows a precise health indication of nearby humans and detect wounded humans inside a building from the outside',
        icon='chewed-heart',
      },   
    },
    hive = {         
      bite = {
        name='bite',
        desc='Bite attacks +10% to-hit and increased damage',
        icon='carnivore-mouth',
      }, 
      bite_adv = {
        name='bite advanced',
        desc='Bite attacks receive a bonus reroll',
        icon='gluttonous-smile',
      },        
      infection =   {
        name = 'infection',
        desc = 'A successful bite attacks while a human is grappled results in infection.  Infection has a small incubation and then deals continous damage until it is cured or stalled with antibodies.',
        icon = 'drop',
        requires={'grapple'},
      },
      infection_adv =   {
        name = 'infection advanced',
        desc = 'All successful bite attacks result in infection.',
        icon = 'vile-fluid',
        requires={'infection'},
      },  
      acid = {
        name='acid',
        desc='Grants ability to attack with chemicals that ruin and destroy inventory items ',
        icon='lizard-tongue'
      }, 
      acid_adv = {
        name='acid advanced',
        desc='Acid ability increased chance of ruined items',
        icon='fire-breath',
      }, 
      ruin = {
        name='ruin',
        desc='[Not Implemented] Ruins a building that is devoid of humans and unpowered',
        icon='groundbreaker',
      }, 
      ruin_adv = {
        name='ruin advanced',
        desc='[Not Implemented] Ransack a building that is ruined',
        icon='cogsplosion',
      },     
    },
  },
}

skill_list = fillSkillList(skill_list)

return skill_list
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
    groan =                2^4,
    gesture =              2^5,
    smell_blood =          2^6,
    muscle_stimulus =      2^7,
    ep_bonus =             2^8,  -- fix this
    drag_prey =            2^9,  -- and this

    -- Brute
    claw =                 2^0,
    claw_adv =             2^1,
    power_claw =           2^2,
    grapple_adv =          2^3,
    armor =                2^4,
    armor_adv =            2^5,
    maim =                2^6,
    maim_adv =            2^7,
    
    -- Hunter
    sprint =               2^0,
    leap =                 2^1,
    leap_adv =             2^2,
    track =                2^3,
    track_adv =            2^4,
    hide =                 2^5,
    hide_adv =             2^6,
    smell_blood_adv =      2^7,
    night_vision =         2^8,
    mark_prey =            2^9,
    
    -- Hive  
    hivemind =             2^0,  
    bite =                 2^1,
    bite_adv =             2^2,
    corrode =              2^3,
    acid =                 2^4,
    acid_adv =             2^5,
    ruin =                 2^6,
    ransack =              2^7,
    infection =            2^8,
    infection_adv =        2^9,
  },
  order = {
    category = {'classes', 'general', 'brute', 'hunter', 'hive'},
    classes = {'brute', 'hunter', 'hive'},
    general = {'muscle_stimulus', 'hand_stimulus', 'head_stimulus', 'grapple', 'groan', 'gesture', 'hp_bonus', 'ep_bonus', 'drag_prey', 'smell_blood'},    
    brute = {'claw', 'claw_adv', 'power_claw', 'grapple_adv', 'armor', 'armor_adv', 'maim', 'maim_adv'},      
    hunter = {'sprint', 'leap', 'leap_adv', 'track', 'track_adv', 'hide', 'hide_adv', 'smell_blood_adv', 'night_vision', 'mark_prey'},         
    hive = {'hivemind', 'bite', 'bite_adv', 'corrode', 'acid', 'acid_adv', 'ruin', 'ransack', 'infection', 'infection_adv'},
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
      groan = {
        name='groan',
        desc='Emit a feeding groan with range dependent upon the number of humans in the vicinity',
        icon='terror',
      },
      gesture = {
        name='gesture',
        desc='[Not Implemented] Ability to make various useful gestures',
        icon='pointing',
      },
      smell_blood = {
        name='smell blood',
        desc='Vague health status of nearby humans is displayed',
        icon='gluttony',
      },
      hp_bonus = {
        name='hp bonus',
        desc='Bonus +10 max hp',
        icon='heart-organ',
      },
      ep_bonus = {
        name='ep bonus',
        desc='Bonus +10 max ep',
        icon='dna1',
      },
      drag_prey = {
        name='drag prey',
        desc='Ability to drag severely wounded humans outside of open buildings',
        icon='swallow',
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
        icon='flaming-claw',
      }, 
      armor = {
        name='armor',
        desc='Manifest an exterior hide of organic armor that is randomly selected after feeding on a corpse',
        icon='shieldcomb',
      }, 
      armor_adv = {
        name='armor advanced',
        desc='Manually select which organic armor type to spawn and increase its starting condition',
        icon='spiked-armor',
      },        
      maim = {
        name='maim',
        desc='Claw attacks do a fraction of permanent damage and have a chance to delimb a weakened human',
        icon = 'stigmata',
      },
      maim_adv = {
        name='maim advanced',
        desc='Increased permanent damage and chance to delimb for claw attacks',
        icon = 'half-body-crawling',
      },
      grapple_adv = {
        name='grapple advanced',
        desc='Claw attacks +10% to-hit and increased damage',
        icon = 'imprisoned',
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
        icon='double-face-mask',
      },
      hide_adv = {
        name='hide advanced',
        desc='Improved chance and reduced ap cost to hide',
        icon='shadow-follower',
      },
      smell_blood_adv = {
        name='smell blood advanced',
        desc='Shows a precise health indication of nearby humans',
        icon='nose-side',
      },
      night_vision = {
        name='night vision',
        desc='Removes attack penalty when in a dark building',
        icon='hidden',
      },
      mark_prey = {
        name='mark prey',
        desc='Tags a human who later can be tracked',
        icon='spill',
      },      
    },
    hive = {
      hivemind = {
        name='hivemind',
        desc='Ability to communicate full speech and revive easier',
        icon='brain-stem',
      },         
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
        icon='vomiting'
      }, 
      corrode = {
        name='corrode',
        desc='Acid attack +5% to-hit, increased chance of ruined items',
        icon='lizard-tongue',
      },         
      acid_adv = {
        name='acid advanced',
        desc='Acid attack +10% to-hit, increased chance of ruined items',
        icon='fire-breath',
      }, 
      ruin = {
        name='ruin',
        desc='[Not Implemented] Ruins a building that is devoid of humans and unpowered',
        icon='groundbreaker',
      }, 
      ransack = {
        name='ransack',
        desc='[Not Implemented] Ransack a building that is ruined',
        icon='grass',
      },     
    },
  },
}

skill_list = fillSkillList(skill_list)

return skill_list
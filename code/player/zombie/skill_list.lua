local fillSkillList = require('code.player.fillSkillList')

--[[
  skill = {
    name = 'string', 
    desc = 'string', 
    icon = 'image-name'  
    requires = {'skill_name1', 'skill_name2', etc.}/nil,
  }
--]]

local skill_list = {
  flag = {
    -- Classes
    brute =                1,
    hunter =               2,
    hive =                 4,

    -- General
    hp_bonus =             1,  -- hp_bonus MUST remain flag 1 b/c it's used for both zombies & humans on the bitflag 1 slot
    hand_stimulus =        2,
    head_stimulus =        4,
    grapple =             16,
    groan =               32,
    gesture =             64,
    smell_blood =        128,
    muscle_stimulus =    256,
    ep_bonus =           512,  -- fix this
    drag_prey =         1024,  -- and this

    -- Brute
    claw =                 1,
    dual_claw =            2,
    claw_adv =             4,
    power_claw =           8,
    impale =              16,
    armor =               32,
    liquid_armor =        64,
    ranged_armor =       128,
    pain_armor =         256,
    dying_grasp =        512,
    
    -- Hunter
    sprint =               1,
    leap =                 2,
    leap_adv =             4,
    track =                8,
    scavenge =            16,
    track_adv =           32,
    dodge =               64,
    smell_blood_adv =    128,
    night_vision =       256,
    mark_prey =          512,
    
    -- Hive  
    hivemind =             1,  
    bite =                 2,
    bite_adv =             4,
    corrode =              8,
    acid =                16,
    acid_adv =            32,
    ruin =                64,
    ransack =            128,
    infection =          256,
    infection_adv =      512,
  },
  order = {
    category = {'classes', 'general', 'brute', 'hunter', 'hive'},
    classes = {'brute', 'hunter', 'hive'},
    general = {'muscle_stimulus', 'hand_stimulus', 'head_stimulus', 'grapple', 'groan', 'gesture', 'hp_bonus', 'ep_bonus', 'drag_prey', 'smell_blood'},    
    brute = {'claw', 'dual_claw', 'claw_adv', 'power_claw', 'impale', 'armor', 'liquid_armor', 'ranged_armor', 'pain_armor', 'dying_grasp',},      
    hunter = {'sprint', 'leap', 'leap_adv', 'track', 'scavenge', 'track_adv', 'dodge', 'smell_blood_adv', 'night_vision', 'mark_prey'},         
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
      dual_claw = {
        name='dual claw',
        desc='Claw attacks receive an extra damage roll',
        icon='wolverine-claws',
      }, 
      claw_adv = {
        name='claw advanced',
        desc='Claw attacks recieve +15% to-hit and a bonus reroll',
        icon='grasping-claws',
      }, 
      power_claw = {
        name='power claw',
        desc='[Not Implemented] Claw attacks against buildings or barricades deal double damage',
        icon='flaming-claw',
      }, 
      impale = {
        name='impale',
        desc='Melee attacks +5% to-hit for selected target after critical claw attack (stacks with grappling)',
        icon='pierced-body'
      }, 
      armor = {
        name='armor',
        desc='Form a thick skin armor that grants [-1] damage protection from all types of weapons',
        icon='shieldcomb',
      }, 
      pain_armor = {
        name='pain armor',
        desc='Form a bone armor that grants [-2] damage protection against pierce weapons',
        icon='spiked-armor',
      }, 
      liquid_armor = {
        name='liquid armor',
        desc='Form a gel armor that grants [-2] damage protection against brute weapons',
        icon='dripping-honey',
      }, 
      ranged_armor = {
        name='ranged armor',
        desc='Form a stretch armor that grants [-2] damage protection against bullet weapons',
        icon='meeple',
      }, 
      dying_grasp = {
        name='dying grasp',
        desc='[Not Implemented] If a melee weapon was used to strike a killing blow against yourself, the melee weapon is destroyed',
        icon='blade-bite',
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
      scavenge = {
        name='scavenge',
        desc='Gives a small chance to find wildlife that may be consumed for food',
        icon='maggot',
      },
      track_adv = {
        name='track advanced',
        desc='Ability to locate humans is improved',
        icon='brass-eye',
      },
      dodge = {
        name='dodge',
        desc='Gives a small chance to dodge melee attaks',
        icon='move',
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
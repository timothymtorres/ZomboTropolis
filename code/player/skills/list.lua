local flag = require('code.player.skills.flags')
local bit = require('plugin.bit')
local band, bor, bxor, bnot = bit.band, bit.bor, bit.bxor, bit.bnot

--[[
  skill = {
    name = 'string', 
    desc = 'string', 
    icon = 'image-name'  
    requires = {'skill_name1', 'skill_name2', etc.}/nil,
  }
--]]

local skill_list = {
  order = {
    zombie = {
      category = {'classes', 'general', 'brute', 'hunter', 'sentient', 'hive'},
      classes = {'brute', 'hunter', 'sentient', 'hive'},
      general = {'muscle_stimulus', 'hand_stimulus', 'head_stimulus', 'grapple', 'groan', 'gesture', 'hp_bonus', 'ep_bonus', 'drag_prey', 'smell_blood'},    
      brute = {'claw', 'dual_claw', 'claw_adv', 'power_claw', 'impale', 'armor', 'liquid_armor', 'ranged_armor', 'pain_armor', 'dying_grasp',},    
      sentient = {'open_door', 'resurrection', 'ankle_bite', 'bite', 'power_bite', 'bite_adv', 'jugular', 'chew', 'speech', 'digestion'},        
      hunter = {'sprint', 'leap', 'leap_adv', 'track', 'scavenge', 'track_adv', 'dodge', 'smell_blood_adv', 'night_vision', 'mark_prey'},         
      hive = {'stinger', 'venom', 'venom_adv', 'corrode', 'acid', 'acid_adv', 'ruin', 'ransack', 'homewrecker'},
    },
    human = {
      category = {'classes', 'general', 'military', 'medical', 'research', 'engineering'},
      classes = {'military', 'medical', 'research', 'engineering'},
      general = {'melee', 'cutting', 'swinging', 'martial_arts', 'martial_arts_adv', 'ranged', 'roof_travel', 'hp_bonus', 'ip_bonus', 'looting', 'diagnosis', 'graffiti'},
      military = {'ranged_adv', 'guns', 'light_guns', 'heavy_guns', 'archery', 'archery_adv', 'melee_adv', 'chopping', 'slicing', 'smashing', 'smacking', 'explosives'},
      medical = {'healing', 'major_healing', 'major_healing_adv', 'minor_healing', 'minor_healing_adv', 'chemistry', 'serium', 'stimulants', 'antibodies', 'recovery', 'recovery_adv', 'diagnosis_adv'},
      research = {'bookworm'},
      engineering = {'repairs', 'repairs_adv', 'barricade', 'barricade_adv', 'reinforce', 'renovate', 'tech', 'power_tech', 'radio_tech', 'computer_tech'}, --'construction', 'reserve'},
    },
  },
  info = {
    zombie = {
      classes = {
        brute = {
          name='brute',
          desc='Unlock Brute skills',
          icon='lizardman',
        },
        sentient = {
          name='sentient',
          desc='Unlock Sentient skills',
          icon='frontal-lobe',
        },
        hunter = {
          name='hunter',
          desc='Unlock Hunter skills',
          icon='one-eyed',
        },
        hive = {
          name='hive',
          desc='Unlock Hive skills',
          icon='tear-tracks',
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
      sentient = {
        open_door = {
          name='open door',
          desc='[Not Implemented] Ability to open doors',
          icon='brain-stem',
        }, 
        resurrection = {
          name='resurrection',
          desc='Reviving from being killed now costs 5 ap',
          icon='haunting',
        }, 
        ankle_bite = {
          name='ankle bite',
          desc='[Not Implemented] If any humans are nearby upon reviving a free auto bite attack is performed',
          icon='barefoot',
        }, 
        bite = {
          name='bite',
          desc='Bite attacks +10% to-hit and increased damage',
          icon='carnivore-mouth',
        }, 
        power_bite = {
          name='power bite',
          desc='Bite attacks +15% to-hit and increased damage',
          icon='gluttonous-smile'
        }, 
        bite_adv = {
          name='bite advanced',
          desc='Bite attacks receive a bonus reroll',
          icon='sharp-smile',
        }, 
        jugular = {
          name='jugular',
          desc='[Not Implemented] Bite attacks do triple damage upon a critical hit',
          icon='ragged-wound',
        }, 
        chew = {
          name='chew',
          desc='[Not Implemented] Successful bite attacks regain lost hp',
          icon='ent-mouth',
        }, 
        speech = {
          name='speech',
          desc='Ability to communicate full speech',
          icon='conversation',
        }, 
        digestion = {
          name='digestion',
          desc='Eating from corpses grants a higher xp bonus',
          icon='carrion',
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
        stinger =   {
          name = 'stinger',
          desc = 'Grants ability to attack with a poisonous stinger that injects venom into the bloodstream for a small duration',
          icon = 'scorpion-tail',
        },
        venom =   {
          name = 'venom',
          desc = 'Increase the stingers to-hit 5%, higher dosage of venom injected and increased duration',
          icon = 'drop',
          requires={'stinger'},
        },
        venom_adv =   {
          name = 'venom advanced',
          desc = 'Stinger attacks +10% to-hit, higher dosage of venom injected and increased duration',
          icon = 'vile-fluid',
          requires={'venom'},
        },  
        acid = {
          name='acid',
          desc='Grants ability to attack with chemicals that ruin and destroy inventory items ',
          icon='vomiting'
        }, 
        corrode = {
          name='corrode',
          desc='Acid attack +5% to-hit, increased chance of ruined items',
          icon='lizard-tounge',
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
        homewrecker = {
          name='homewrecker',
          desc='[Not Implemented] Attacks against building equipment deals double damage',
          icon='cogsplosion',
        },     
      },
    },
    human = {
      classes = {
        engineering = {
          name='engineering',     
          desc='Unlock Engineering skills', 
          icon='tinker',  
        },
        military = {
          name='military',        
          desc='Unlock Military skills', 
          icon='crossed-swords',
        },
        research = {
          name='research',        
          desc='Unlock Research skills', 
          icon='biohazard',
        },
        medical = {
          name='medical',         
          desc='Unlock Medical skills', 
          icon='hospital-cross',
        },      
      },
      general = {      
        melee = {
          name='melee',           
          desc='Melee weapons +5% to-hit', 
          icon='quick-slash',
        },
        cutting = {
          name='blade weapons',         
          desc='Blade weapons +10% to-hit', 
          icon='serrated-slash', 
          requires={'melee'},
        },   
        swinging = {
          name='blunt weapons',        
          desc='Blunt weapons +10% to-hit', 
          icon='large-slash', 
          requires={'melee'},
        },
        martial_arts = {
          name='martial arts',    
          desc='Hand-to-hand combat +10% to-hit', 
          icon='punch', 
          requires={'melee'},
        },
        martial_arts_adv={
          name='martial arts advanced',  
          desc='Hand-to-hand combat +15% to-hit, +1 to damage range, and a bonus reroll', 
          icon='fulguro-punch', 
          requires={'martial_arts'},
        },
        ranged = {
          name='ranged weapons',          
          desc='Ranged weapons +5% to-hit', 
          icon='targeting',
        },
        roof_travel = {
          name='roof travel',     
          desc='Travel through buildings', 
          icon='sprint',
        },
        hp_bonus = {
          name='hp bonus',        
          desc='Bonus +10 max hp', 
          icon='muscle-up',
        },
        ip_bonus = {
          name='ip bonus',        
          desc='Bonus +10 max ip', 
          icon='muscle-fat', 
          requires={'hp_bonus'},
        },  
      --ap_bonus =       {name='ap bonus',},
        looting = {
          name='looting',         
          desc='[Not Implemented] Bonus chance to find items when searching', 
          icon='snatch',
        },
        diagnosis = {
          name='diagnosis',       
          desc='Grants ability to determine damage states of players', 
          icon='pummeled',
        },
        graffiti = {
          name='graffiti',        
          desc='[Not Implemented] Spraycan use costs less and lasts longer', 
          icon='aerosol',
        },        
      },
      military = {
        ranged_adv =     {
          name='ranged advanced',    
          desc='Ranged weapons +10% to-hit', 
          icon='reticule', 
          requires={'ranged'}, 
        },
        guns =           {
          name='gun weapons', 
          desc='Ballistic weapons +10% to-hit', 
          icon='bullets', 
          requires={'ranged_adv'},
        },
        light_guns =     {
          name='light gun weapons', 
          desc='Light ballistic weapons +15% to-hit', 
          icon='pistol-gun', 
          requires={'guns'},
        },
        heavy_guns =     {
          name='heavy gun weapons', 
          desc='Heavy ballistic weapons +15% to-hit', 
          icon='mp5',
          requires={'guns'},
        },
        archery =        {
          name='archery weapons', 
          desc='Archery weapons +10% to-hit', 
          icon='bowman', 
          requires={'ranged_adv'},
        },
        archery_adv =    {
          name='archery weapons advanced', 
          desc='Archery weapons +15% to-hit', 
          icon='archery-target', 
          requires={'archery'},
        },
        melee_adv =      {
          name='melee advanced',  
          desc='Melee weapons +10% to-hit', 
          icon='crossed-slashes', 
          requires={'melee'},
        },
        chopping =       {
          name='heavy blade weapons',        
          desc='Heavy blade weapons +15% to-hit', 
          icon='fire-axe', 
          requires={'cutting', 'melee_adv'},
        },
        slicing =        {
          name='light blade weapons',         
          desc='Light blade weapons +15% to-hit', 
          icon='bowie-knife', 
          requires={'cutting', 'melee_adv'}
        },
        smashing =       {
          name='heavy blunt weapons',        
          desc='Heavy blunt weapons +15% to-hit', 
          icon='gavel', 
          requires={'swinging', 'melee_adv'},
        },
        smacking =       {
          name='light blunt weapons',        
          desc='Light blunt weapons +15% to-hit', 
          icon='spade', 
          requires={'swinging', 'melee_adv'},
        },      
        explosives =     {
          name='explosives',      
          desc='Scorch weapons +10% to-hit', 
          icon='molotov',
        },  
      },
      medical = {
        healing =        {
          name = 'healing',
          desc = 'Healing items receive bonus',
          icon = 'sticking-plaster',
        },
        major_healing =  {
          name = 'major healing',
          desc = 'First aid kits receive minor healing bonus',
          icon = 'medical-pack-alt',
          requires={'healing'},
        },
        major_healing_adv={
          name = 'major healing advanced',
          desc = 'First aid kits receive major healing bonus',
          icon = 'scalpel',
          requires={'major_healing'},
        },
        minor_healing =  {
          name = 'minor healing',
          desc = 'Bandages receive minor healing bonus',
          icon = 'bandage-roll',
          requires={'healing'},
        },
        minor_healing_adv={
          name = 'minor healing advanced',
          desc = 'Bandages receive major healing bonus',
          icon = 'sewing-needle',
          requires={'minor_healing'},
        },
        chemistry =      {
          name = 'chemistry',
          desc = 'Unlocks ability to make chemistry products',
          icon = 'fizzing-flask',
        },
        serium =         {
          name = 'serium',
          desc = 'Making antidote costs less and better quality',
          icon = 'corked-tube',
          requires={'chemistry'},
        },
        stimulants =     {
          name = 'stimulants',
          desc = 'Making amphediente costs less and better quality',
          icon = 'pill',
          requires={'chemistry'},          
        },
        antibodies =     {
          name = 'antibodies',
          desc = 'Making syringes costs less and better quality',
          icon = 'square-bottle',
          requires={'chemistry'},          
        },
        recovery =       {
          name = 'recovery',
          desc = 'Unlocks ability to recover 1d2-1 health',
          icon = 'health-normal',
        },
        recovery_adv =   {
          name = 'recovery advanced',
          desc = 'Recover ability costs less and is now 1d2',
          icon = 'health-increase',
          requires={'recovery'},
        },
        diagnosis_adv =  {
          name='diagnosis advanced',       
          desc='Determine PRECISE health status',
          icon = 'anatomy',
          requires={'diagnosis'},},     
      },
      research = {
        lab_tech =       {name='lab tech',        desc='Gain ability to use science equipment',},
        researcher =     {name='researcher',      desc='Gain ability to tag zombies and track via terminals',},
        bookworm =       {name='bookworm',},
      },
      engineering = {
        repairs =        {
          name='basic repairs',   
          desc='Gain ability to repair equipment',
          icon='spanner',
        },  
        repairs_adv=     {
          name='advanced repairs',
          desc='Repair equipment at cheaper cost',
          icon='auto-repair',
        },
        barricade =      {
          name='barricade',
          desc='Gain ability to barricade past regular and increased barricade strength',
          icon='wooden-door',
        },
        barricade_adv=   {
          name='barricade advanced',
          desc='Gain ability to barricade past very strongly and a bonus reroll for barricade strength',
          icon='closed-doors',
        },
        reinforce =      {
          name='reinforce',
          desc='Gain ability to reinforce barricades for more available space',
          icon='push',
        },
        renovate =       {
          name='renovate',
          desc='Gain ability to repair ruins',
          icon='hammer-nails'
        },      
        tech =           {
          name='tech',
          desc='Gain ability to install equipment',
          icon='processor',
        },  
        power_tech =     {
          name='power tech',
          desc='Installing generators requires less ap',
          icon='light-bulb',
        },
        radio_tech =     {
          name='radio tech',
          desc='Installing radio transmitters requires less ap',
          icon='radar-dish',
        },
        computer_tech =  {
          name='computer tech',
          desc='Installing computer terminals requires less ap',
          icon='keyboard',
        },        
        --[[
        construction =   {name='construction'}, -- ???
        reserve =        {name='reserve',}, -- toolbox durability increased       
        --]]
      },
    },
  },
}

-- 64 skills max  (4 are classes)
-- 60 skills 5 cataegories (12 general skills, 12 in each skill tree)

--[[
print()
print('flag LIST')
print()
for k,v in pairs(flag) do print(k,v) end
--]]

local function lookupFlags(mob_type, skills)
  local array = {}
  for _, category in ipairs(skill_list.order[mob_type].category) do array[category] = {} end
  
  for _, skill in ipairs(skills) do
--print('look flag requirements for skill')
--print(i, skill, flag[skill])
    local array_category = array[skill_list[skill].category]
    array_category[#array_category+1] = flag[skill] 
  end
  return array
end

local function combineFlags(mob_type, requirements)
  local list = lookupFlags(mob_type, requirements)
  for _, category in ipairs(skill_list.order[mob_type].category) do 
    list[category] = (next(list[category]) and bor(unpack(list[category]))) or 0 
  end
  return list --bor(unpack(list)) 
end

local function fillData(list)
  for mob_type in pairs(skill_list.info) do 
    for skill_tree in pairs(skill_list.info[mob_type]) do 
      for skill, data in pairs(skill_list.info[mob_type][skill_tree]) do 
        list[skill] = data
        list[skill].mob_type = mob_type
        list[skill].category = skill_tree        
        list[skill].flag = flag[skill]        
      end
    end
  end
  return list
end

local function fillRequirements(list)
  for mob_type in pairs(skill_list.info) do 
    for skill_tree in pairs(skill_list.info[mob_type]) do 
      for skill, data in pairs(skill_list.info[mob_type][skill_tree]) do                 
        local class_criteria = (not (skill_tree == 'general' or skill_tree == 'classes') and skill_tree) or nil
        local skills_criteria = list[skill].requires and table.copy(list[skill].requires)
        
        list[skill].requires = list[skill].requires or {}
        list[skill].requires[#list[skill].requires+1] = class_criteria        
        
        local requirements = list[skill].requires
        if next(requirements) then
          list[skill].required_flags = combineFlags(mob_type, requirements)
        else
          list[skill].required_flags = {}
          for _, category in ipairs(skill_list.order[mob_type].category) do
            list[skill].required_flags[category] = 0
          end
        end
        list[skill].required_class = class_criteria
        list[skill].required_skills = skills_criteria
      end 
    end
  end
  return list
end

--[[
local function fillFlagSets(list)
  for mob_type in pairs(skill_list.order) do
    if next(skill_list.order[mob_type]) == nil then break end  -- remove this after zombie skills get added
    for _, category in ipairs(skill_list.order[mob_type].category) do
      if #skill_list.order[mob_type][category] == 0 then break end  -- remove this too?
      
      local flag_set = {}
      for _, flag_name in ipairs(skill_list.order[mob_type][category]) do 
        flag_set[#flag_set+1] = flag_name
      end
      list[category] = list[category] or {}  -- some categories were already setup in fillList()
      list[category].flag_set = combineFlags(flag_set)
      
--print()
--print()
-- bit.plugin is 32 bits, but the total skills are 64?  This might be a problem...     
--for i,v in ipairs(flag_set) do print(i,v, flag[v]) end      
--print('category flag set:', category, list[category].flag_set)      
--print()
    end    
  end  
  return list
end
--]]

do  
  -- combine zombie/human skills into one list
  skill_list = fillData(skill_list)
  skill_list = fillRequirements(skill_list)
  
  -- combine flags of each category (ie. military, classes, brute) into a set
  --skill_list = fillFlagSets(skill_list)
end

function skill_list.getRequirement(skill, category) 
  if category == 'skills' then return skill_list[skill].required_skills
    -- {classses = 0, ...}
  elseif category == 'class' then return skill_list[skill].required_class
    -- {classes = flag}
  else return skill_list[skill].requires  -- return all requirements
    -- {classes = 0, military = 0, ...}
  end  
end

function skill_list.getRequiredFlags(skill) return skill_list[skill].required_flags end

function skill_list.getFlag(skill) return skill_list[skill].flag end

--function skill_list.getFlagSet(category) return skill_list[category].flag_set end

function skill_list.getMobType(skill) return skill_list[skill].mob_type end

function skill_list.getCategory(skill) return skill_list[skill].category end

function skill_list.isClass(skill) return skill_list[skill].category == 'classes' end

return skill_list
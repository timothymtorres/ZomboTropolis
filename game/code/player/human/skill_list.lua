local fillSkillList = require('code.player.fillSkillList')

local skill_list = {
  flag = {
    -- Classes 
    military =             2^0,
    research =             2^1,
    engineering =          2^2,  
      
    -- General
    hp_bonus =             2^0,  -- hp_bonus MUST remain flag 1 b/c it's used for both zombies & humans on the bitflag 1 slot
    cutting =              2^1,
    swinging =             2^2,
    martial_arts =         2^3,
    martial_arts_adv =     2^4,
    ranged =               2^5,
    roof_travel =          2^6,
    melee =                2^7,
    ip_bonus =             2^8,
    looting =              2^9,
    diagnosis =            2^10,
    graffiti =             2^11,

    -- Military
    ranged_adv =           2^0,
    guns =                 2^1,
    light_guns =           2^2,
    heavy_guns =           2^3,
    archery =              2^4,
    archery_adv =          2^5,
    melee_adv =            2^6,
    smacking =             2^7,
    chopping =             2^8,
    slicing =              2^9,
    smashing =             2^10,
    explosives =           2^11,

    -- Research
    healing =              2^0,
    major_healing =        2^1,
    minor_healing =        2^2,
    diagnosis_adv =        2^3,
    gadgets =              2^4,
    scanner =              2^5,
    syringe =              2^6,
    syringe_adv =          2^7,
    terminal =             2^8,
    terminal_adv =         2^9,
    
    -- Engineering
    repair =               2^0,
    repair_adv =           2^1,
    barricade =            2^2,
    barricade_adv =        2^3,
    reinforce =            2^4,
    renovate =             2^5,
    tech =                 2^6,
    power_tech =           2^7,
    radio_tech =           2^8,
    computer_tech =        2^9,
  },
  order = {
    category = {'classes', 'general', 'military', 'research', 'engineering'},
    classes = {'military', 'research', 'engineering'},
    general = {'melee', 'cutting', 'swinging', 'martial_arts', 'martial_arts_adv', 'ranged', 'roof_travel', 'hp_bonus', 'ip_bonus', 'looting', 'diagnosis', 'graffiti'},
    military = {'ranged_adv', 'guns', 'light_guns', 'heavy_guns', 'archery', 'archery_adv', 'melee_adv', 'chopping', 'slicing', 'smashing', 'smacking', 'explosives'},
    research = {'healing', 'major_healing', 'minor_healing', 'diagnosis_adv', 'gadgets', 'syringe', 'syringe_adv', 'scanner', 'terminal', 'terminal_adv'},
    engineering = {'repair', 'repair_adv', 'barricade', 'barricade_adv', 'reinforce', 'renovate', 'tech', 'power_tech', 'radio_tech', 'computer_tech'}, --'construction', 'reserve'},
  },
  info = {
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
    research = {
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
      minor_healing =  {
        name = 'minor healing',
        desc = 'Bandages receive minor healing bonus',
        icon = 'bandage-roll',
        requires={'healing'},
      },
      diagnosis_adv =  {
        name='diagnosis advanced',       
        desc='Determine PRECISE health status',
        icon = 'anatomy',
        requires={'diagnosis'},
      },
      gadgets =  {
        name='gadgets',       
        desc='Provides a bonus when using research items',
        icon = 'anatomy',
      },    
      scanner =  {
        name='scanner',       
        desc='Provides a bonus when using research items',
        icon = 'anatomy',
      }, 
      syringe =  {
        name='syringe',       
        desc='Provides a bonus when using research items',
        icon = 'anatomy',
      }, 
      syringe_adv =  {
        name='syringe advanced',       
        desc='Provides a bonus when using research items',
        icon = 'anatomy',
      }, 
      terminal =  {
        name='terminal',       
        desc='Provides a bonus when using research items',
        icon = 'anatomy',
      }, 
      terminal_adv =  {
        name='terminal advanced',       
        desc='Provides a bonus when using research items',
        icon = 'anatomy',
      },         
    },
    engineering = {
      repair =        {
        name='basic repair',   
        desc='Gain ability to repair equipment',
        icon='spanner',
      },  
      repair_adv=     {
        name='advanced repair',
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
}

skill_list = fillSkillList(skill_list)

return skill_list
local fillSkillList = require('code.player.fillSkillList')

local skill_list = {
  flag = {
    -- Classes 
    military =             2^0,
    research =             2^1,
    engineering =          2^2,  
      
    -- General
    hp_bonus =             2^0,  -- hp_bonus MUST remain flag 1 b/c it's used for both zombies & humans on the bitflag 1 slot
    blunt =                2^1,
    blade =                2^2,
    martial_arts =         2^3,
    ranged =               2^4,
    roof_travel =          2^5,
    melee =                2^6,
    ip_bonus =             2^7,
    looting =              2^8,
    diagnosis =            2^9,

    -- Military
    ranged_adv =           2^0,
    sidearm =              2^1,
    primary =              2^2,
    melee_adv =            2^3,
    blade_adv =            2^4,
    blunt_adv =            2^5,
    pyrotech =             2^6,
    pyrotech_adv =         2^7,

    -- Research
    healing =              2^0,
    major_healing =        2^1,
    minor_healing =        2^2,
    diagnosis_adv =        2^3,
    gadgets =              2^4,
    scanner =              2^5,
    syringe =              2^6,
    terminal =             2^7,
    
    -- Engineering
    repair =               2^0,
    repair_adv =           2^1,
    barricade =            2^2,
    barricade_adv =        2^3,
    reinforce =            2^4,
    renovate =             2^5,
    tech =                 2^6,
    tech_adv =             2^7,
  },
  order = {
    category = {'classes', 'general', 'military', 'research', 'engineering'},
    classes = {'military', 'research', 'engineering'},
    general = {'melee', 'blunt', 'blade', 'martial_arts', 'ranged', 'roof_travel', 'hp_bonus', 'ip_bonus', 'looting', 'diagnosis'},
    military = {'ranged_adv', 'sidearm', 'primary', 'melee_adv', 'blade_adv', 'blunt_adv', 'pyrotech', 'pyrotech_adv'},
    research = {'healing', 'major_healing', 'minor_healing', 'diagnosis_adv', 'gadgets', 'syringe', 'scanner', 'terminal'},
    engineering = {'repair', 'repair_adv', 'barricade', 'barricade_adv', 'reinforce', 'renovate', 'tech', 'tech_adv'},
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
      blade = {
        name='blade weapons',         
        desc='Blade weapons +10% to-hit', 
        icon='serrated-slash', 
        requires={'melee'},
      },   
      blunt = {
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
      ranged = {
        name='ranged weapons',          
        desc='Ranged weapons +5% to-hit', 
        icon='targeting',
      },
      roof_travel = {
        name='roof travel',     
        desc='Travel through buildings', 
        icon='jump-across',
      },
      hp_bonus = {
        name='hp bonus',        
        desc='Bonus +10 max hp', 
        icon='muscle-up',
      },
      ip_bonus = {
        name='ip bonus',        
        desc='Bonus +10 max ip', 
        icon='bindle', 
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
        icon='coma',
      },        
    },
    military = {
      ranged_adv =     {
        name='ranged advanced',    
        desc='Ranged weapons +10% to-hit', 
        icon='reticule', 
        requires={'ranged'}, 
      },
      sidearm =     {
        name='sidearm', 
        desc='Light ballistic weapons +15% to-hit', 
        icon='pistol-gun', 
        requires={'ranged_adv'},
      },
      primary =     {
        name='primary', 
        desc='Heavy ballistic weapons +15% to-hit', 
        icon='mp5',
        requires={'ranged_adv'},
      },
      melee_adv =      {
        name='melee advanced',  
        desc='Melee weapons +10% to-hit', 
        icon='crossed-slashes', 
        requires={'melee'},
      },
      blade_adv =       {
        name='blade advanced weapons',        
        desc='Blade weapons +15% to-hit', 
        icon='fire-axe', 
        requires={'melee_adv'},
      },
      blunt_adv =       {
        name='blunt advanced weapons',        
        desc='Blunt weapons +15% to-hit', 
        icon='gavel', 
        requires={'melee_adv'},
      },
      pyrotech =     {
        name='pyrotech',      
        desc='Scorch weapons +10% to-hit', 
        icon='lighter',
      }, 
      pyrotech_adv =     {
        name='pyrotech advanced',      
        desc='Scorch weapons +10% to-hit', 
        icon='molotov',
      },             
      --[[
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
      --]] 
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
        icon = 'batteries',
      },    
      scanner =  {
        name='scanner',       
        desc='Provides a bonus when using research items',
        icon = 'dna1',
      }, 
      syringe =  {
        name='syringe',       
        desc='Provides a bonus when using research items',
        icon = 'syringe',
      }, 
      terminal =  {
        name='terminal',       
        desc='Provides a bonus when using research items',
        icon = 'keyboard',
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
        icon='brick-pile'
      },      
      tech =           {
        name='tech',
        desc='Gain ability to install machines.  Can also improve condition.',
        icon='processor',
      },  
      tech_adv =     {
        name='tech advanced',
        desc='Install machines for less AP',
        icon='power-generator',
      },     
    },
  },
}

skill_list = fillSkillList(skill_list)

return skill_list
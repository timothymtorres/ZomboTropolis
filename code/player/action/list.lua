--[[-- If action not default

  action = {
    name = 'string', 
    image = 'path.to.image.file'
    desc = 'string', 
    cost = num,
    modifier = {skill_1=num, skill_2=num, ...}/nil,
  }
--+-- If action is default
  action = {
    cost = num,
  }
--+-- If action is skill  
  
--]]--

local action_list = {
  info = {
    human = {
      default = {
        move =          {name='move',      cost= 1},      
        enter =         {name='enter',     cost= 1},
        exit =          {name='exit',      cost= 1},
        discard =       {name='discard',   cost= 0},      
      },
      basic = {
        respawn =       {name='respawn',   cost=10},
        search =        {name='search',    cost= 1},
        attack =        {name='attack',    cost= 1},
        speak =         {name='speak',     cost= 1},      
        --close =         {name='close door', cost= 1},
      },
      skill = {
        repair = {
          door =        {cost=5, name='repair door', modifier={repair=-1, repair_adv=-1, construction=-1},},
          generator =   {cost=5, name='repair generator', modifier={repair=-1, repair_adv=-1, power_tech=-1},},
          transmitter = {cost=5, name='repair transmitter', modifier={repair=-1, repair_adv=-1, radio_tech=-1},},
          terminal =    {cost=5, name='repair terminal', modifier={repair=-1, repair_adv=-1, computer_tech=-1},},
          -- ruin repairs?  Dependent on lenght of ruin?
        },
      },
      item = {
        barricade =     {name='barricade',    cost=1},
        generator =     {name='generator',    cost=10, modifier={tech=-2, power_tech=-4},},
        transmitter =   {name='transmitter',  cost=10, modifier={tech=-2, radio_tech=-4},},
        terminal =      {name='terminal',     cost=10, modifier={tech=-2, computer_tech=-4},},
        
  --[[ 
  **RELOADING**
  assualt rifle - ? ap (3 bursts)         [10 ap, 8ap,  5ap]
  magnum        - ? ap (6 shots)          [5 ap,  4ap,  2ap]
  pistol        - ? ap (14 shots)         [5 ap,  4ap,  2ap]
  shotgun       - ? ap (2 shots)          [3 ap,  2ap, .5ap]
  bow           - ? ap (8 shots [quiver]) [8 ap,  6ap,  3ap]  
  --]]      
        shotgun_shell = {name='shotgun shell',  cost=2, modifier={guns = -1, shotguns = -1},},
        pistol_clip =   {name='pistol clip',    cost=3, modifier={guns = -2, handguns = -1},},
        speed_loader =  {name='speed loader',   cost=3, modifier={guns = -2, handguns = -1},},
        rifle_magazine= {name='rifle magazine', cost=4, modifier={guns = -3,   rifles = -1},},
        quiver =        {name='quiver',         cost=4, modifier={archery= -3,     bows = -1},},
        book =          {name='book',           cost=5, modifier={bookworm= -2},},
        FAK =           {name='first aid kit',  cost=1},
        bandage =       {name='bandage',        cost=1},
        antidote =      {name='antidote',       cost=1},
        antibodies=     {name='antibodies',     cost=1},
        syringe =       {name='syringe',        cost=1},      
        leather =       {name='leather',        cost=1},
        firesuit =      {name='firesuit',       cost=1},
        toolbox =       {name='toolbox',        cost=10, modifier={repair = -2, repair_adv = -3},
      },
      equipment = {
        broadcast =   {cost=3, modifier={tech = -1, radio_tech = -1}},
        retune =  {cost=3, modifier={tech = -1, radio_tech = -1}},
        --terminal =      {cost=3, modifier={tech = -1, computer_tech = -1},},
      },
    },
    zombie = {
      default = {
        move =          {name='move',      cost=2, modifier={sprint = -1}},   
        enter =         {name='enter',     cost=1},
        exit =          {name='exit',      cost=1}, 
      },  
      basic = {
        respawn =       {cost= 10, modifier={hivemind = -5}},
        attack =        {cost=  1},
        speak =         {cost=  1},
        feed =          {cost=  1},
        ransack =       {cost=  5, modifier={ransack = -1, ruin = -2},
      },
      skill = {
        -- generic skills
        groan =          {name='groan',         cost=1},
        gesture =        {name='gesture',       cost=1},
        drag_prey =      {name='drag prey',     cost=1},
        -- brute skills
        armor =          {name='armor',         cost=1},
        -- hive skills
        ruin =           {name='ruin',          cost=1},
        acid =           {name='acid',          cost=1},
        -- hunter skills
        mark_prey =      {name='mark prey',     cost=1},
        track =          {name='track',         cost=1},        
      },
    },
  },
}

local function fillList(list)
  for mob_type in pairs(list.info) do
    list[mob_type] = {}
    for category in pairs(list.info[mob_type]) do
      for action, data in pairs(list.info[mob_type][category]) do 
        list[mob_type][action] = data
        -- basic actions are classified as default for their category
        list[mob_type][action].category = (category == 'basic' and 'default') or category
      end
    end  
  end
  return list
end

do
  action_list = fillList(action_list)
end

return action_list
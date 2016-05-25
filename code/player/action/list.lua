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
        --barricade =     {name='barricade', cost= 1},
        attack =        {name='attack',    cost= 1},
        speak =         {name='speak',     cost= 1},      
        --close =         {name='close door', cost= 1},
        --[[ Are these neccessary?
        item =          {cost=1},
        equipment =     {cost=1},
        skill =         {cost=1},
        --]]
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
        generator =     {cost=4, modifier={tech=-1, power_tech=-2},},
        transmitter =   {cost=4, modifier={tech=-1, radio_tech=-2},},
        terminal =      {cost=4, modifier={tech=-1, computer_tech=-2},},
        
  --[[ 
  **RELOADING**
  assualt rifle - ? ap (3 bursts)         [10 ap, 8ap,  5ap]
  magnum        - ? ap (6 shots)          [5 ap,  4ap,  2ap]
  pistol        - ? ap (14 shots)         [5 ap,  4ap,  2ap]
  shotgun       - ? ap (2 shots)          [3 ap,  2ap, .5ap]
  bow           - ? ap (8 shots [quiver]) [8 ap,  6ap,  3ap]  
  --]]      
        shotgun_shell = {cost=2, modifier={guns = -1, shotguns = -1},},
        pistol_clip =   {cost=3, modifier={guns = -2, handguns = -1},},
        speed_loader =  {cost=3, modifier={guns = -2, handguns = -1},},
        rifle_magazine= {cost=4, modifier={guns = -3,   rifles = -1},},
        quiver =        {cost=4, modifier={archery= -3,     bows = -1},},
        book =          {cost=5, modifier={bookworm=-2},},
        FAK =           {cost=1},
        bandage =       {},
        antidote =      {},
        syringe =       {},      
      },
      equipment = {
        broadcast =   {cost=3, modifier={tech = -1, radio_tech = -1},},
        retune =  {cost=3, modifier={tech = -1, radio_tech = -1},},
        --terminal =      {cost=3, modifier={tech = -1, computer_tech = -1},},
      },
    },
    zombie = {
      default = {
        move =          {name='move',       cost=2, modifier={sprint = -1},},   
        enter =         {name='enter',     cost= 1},
        exit =          {name='exit',      cost= 1}, 
      },  
      basic = {
        respawn = {cost=10, modifier={resurrection = -5},},
        attack = {cost=1},
        speak = {cost=1},
        feed =  {cost=1},
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
        -- hunter skills
        mark_prey =      {name='mark prey',     cost=1},
      },
    },
  },
}

local function fillList(list)
  for mob_type in pairs(list.info) do
    list[mob_type] = {}
    for category in pairs(list.info[mob_type]) do
      for action, data in pairs(list.info[mob_type][category]) do list[mob_type][action] = data end
    end  
  end
  return list
end

do
  action_list = fillList(action_list)
end

return action_list
local move, attack, enter, exit =                          unpack(require('code.player.action.default'))
local search, discard, speak, reinforce, item, equipment = unpack(require('code.player.action.human'))
local respawn, ransack, feed, ability =                    unpack(require('code.player.action.zombie'))

local action = {
  -- DEFAULT
  move, attack, enter, exit,
  -- HUMAN
  search, discard, speak, reinforce, item, equipment,
  -- ZOMBIE
  respawn, ransack, feed, ability,
}

for _, action_tbl in ipairs(action) do
  action[action_tbl.name] = action_tbl
end

  --[[ 
  **RELOADING**
  assualt rifle - ? ap (3 bursts)         [10 ap, 8ap,  5ap]
  magnum        - ? ap (6 shots)          [5 ap,  4ap,  2ap]
  pistol        - ? ap (14 shots)         [5 ap,  4ap,  2ap]
  shotgun       - ? ap (2 shots)          [3 ap,  2ap, .5ap]
  bow           - ? ap (8 shots [quiver]) [8 ap,  6ap,  3ap]  
  speed_loader =  {cost=3, modifier={guns = -2, handguns = -1},},  
  --]]  

local action_list = {
  info = {
    human = {
      default = {
        move =          {cost= 1},      
        enter =         {cost= 1},
        exit =          {cost= 1},
        discard =       {cost= 0},      
      },
      basic = {
        search =        {cost= 1},
        attack =        {cost= 1},
        speak =         {cost= 1},
        reinforce =     {cost= 1},
        --close =         {name='close door', cost= 1},
      },
      item = {
        barricade =     {cost= 1},
        generator =     {cost=10, modifier={tech=-2, power_tech=-4},},
        transmitter =   {cost=10, modifier={tech=-2, radio_tech=-4},},
        terminal =      {cost=10, modifier={tech=-2, computer_tech=-4},},            
        shell =         {cost= 2, modifier={guns = -1, shotguns = -1},},
        magazine =      {cost= 3, modifier={guns = -2, handguns = -1},},
        clip =          {cost= 4, modifier={guns = -3,   rifles = -1},},
        quiver =        {cost= 4, modifier={archery= -3,     bows = -1},},
        book =          {cost= 5, modifier={bookworm= -2},},
        FAK =           {cost= 1},
        bandage =       {cost= 1},
        antidote =      {cost= 1},
        antibodies=     {cost= 1},
        syringe =       {cost= 1},      
        leather =       {cost= 1},
        firesuit =      {cost= 1},
        toolbox =       {cost=10, modifier={repair = -2, repair_adv = -3}},
      },
      equipment = {
        broadcast =     {cost= 3, modifier={tech = -1, radio_tech = -1}},
        retune =        {cost= 3, modifier={tech = -1, radio_tech = -1}},
        repair =        {cost= 5, modifier={repair= -1, repair_adv = -1}}
        --terminal =      {cost=3, modifier={tech = -1, computer_tech = -1},},
      },
    },
    zombie = {
      default = {
        move =          {cost= 2, modifier={sprint = -1}},   
        enter =         {cost= 1},
        exit =          {cost= 1}, 
      },  
      basic = {
        respawn =       {cost=10, modifier={hivemind = -5}},
        attack =        {cost= 1},
        speak =         {cost= 1},
        feed =          {cost= 1},
        ransack =       {cost= 5, modifier={ransack = -1, ruin = -2}},
      },
      ability = {
        -- generic skills
        groan =         {cost= 1},
        gesture =       {cost= 1},
        drag =          {cost= 1},
        -- brute skills
        armor =         {cost= 1},
        -- hive skills
        ruin =          {cost= 1},
        acid =          {cost= 1},
        -- hunter skills
        mark =          {cost= 1},
        track =         {cost= 1},        
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

return action
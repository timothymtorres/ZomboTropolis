local ap_list = {
  info = {
    basic = {
      move =          {cost= 1},      
      enter =         {cost= 1},
      exit =          {cost= 1},
      discard =       {cost= 0},      
      speak =         {cost= 0},
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
  },
}

local function fillList(list)
  for category in pairs(list.info) do
    for action, data in pairs(list.info[category]) do list[action] = data end
  end  
  return list
end

do
  ap_list = fillList(ap_list)
end

return action
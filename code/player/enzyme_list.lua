--[[--
  ability = {
    cost = num,
    modifier = {skill_1=num, skill_2=num, ...}/nil,
  }
--]]--

local enzyme_list = {
  -- generic skills
  groan =          {cost=1},
  gesture =        {cost=1},
  drag_prey =      {cost=1},
  -- brute skills
  scale =    {cost=2},
  bone =     {cost=2},
  gel =      {cost=2},
  stretch =  {cost=2},
  blubber =  {cost=2},
  sticky =   {cost=2},
  -- hunter skills
  mark_prey =      {cost=1},
  track =       {cost=3, modifier={track_adv = -1}},
  leap =           {cost=2, modifier={leap_adv = -1},},
  -- sentient skills
  open_door =      {cost=1},
  speech =         {cost=1},
  resurrection =   {cost=5},
  -- hive skills
  stinger =        {cost=3, modifier={venom = -1, venom_adv = -1},},
  acid =           {cost=3, modifier={corrode = -1, acid_adv = -1},},
  ruin =           {cost=3, modifier={ransack = -1},},
}

return enzyme_list
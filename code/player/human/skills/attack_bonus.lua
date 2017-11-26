local skill_attack_bonus = { 
  --group_catagetory = {skill_name1=attack_bonus, skill_name2=attack_bonus, etc.}
  human = {
    melee = {melee=0.05, melee_adv=0.10},
    ranged = {ranged=0.05, ranged_adv=0.10,},
    
  -- MELEE WEAPONS
    brute = {swinging=0.10},
    light_brute = {smacking=0.15},
    heavy_brute = {smashing=0.15},
  
    blade = {cutting=0.10},  
    light_blade = {slicing=0.15},
    heavy_blade = {chopping=0.15},
    
    hand = {martial_arts=0.10, martial_arts_adv=0.15},  --  H2H WEAPON  
    
  -- RANGED WEAPONS
    guns = {shooting=0.10},
    light_guns = {light_guns=0.15},
    heavy_guns = {heavy_guns=0.15},
    
    bows = {archery=0.10, archery_adv=0.15},
    
  },
  zombie = {
    melee = {muscle_stimulus=0.05},
    ranged = {},
    
    arm = {hand_stimulus=0.10, claw=0.10, claw_adv=0.15},
    teeth = {head_stimulus=0.10, bite=0.10, bite_adv=0.15},
    --acid = {acid=0.05, acid_adv=0.05},
    --stinger = {venom=0.05, venom_adv=0.10},
  },
}

return skill_attack_bonus
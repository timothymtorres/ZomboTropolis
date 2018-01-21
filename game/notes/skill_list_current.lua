-- ZOMBIE -- 
    hp_bonus            -- bonus hp when standing
    hunger_bonus
    smell_blood
    digestion/rejuivante -- full hp from feeding + healing from bite attacks
    grapple                 
    muscle_stimulus              
        hand_stimulus 
        head_stimulus
    intelligence        -- groan + gesture combined
        hivemind        -- communicate with hive zombies  [communicate by rank -> zombie username + class + level] (???)

    -- Brute
    claw
        dual_claw
        claw_adv
            power_claw
    strong_grip          -- dying_grasp, tangled_grasp_adv, and cade_interference combined
        drag_prey
    armor
        armor_adv
    maime                -- require claw? claw_adv?
        maime_adv

    -- Hunter
    sprint 
        leap
            leap_adv 
    track 
        track_adv
    hide                  -- can hide in unlit building, (humans have a bonus to discovery using a flashlight) (easier to hide in ruined building)
        hide_adv          -- improved hiding and less chance of discovery (auto hide in ruined buildings)
    smell_blood_adv       -- see hp

    -- not sure what to do with these?  (also replace one with ankle_grap skill?)    
    mark_prey             -- can mark buildings/tiles as well?
    x_ray_vision          -- see wounded inside buildings from outside


    -- Hive  
    hivemind_adv          -- communication with all nearby zombies? recovery? (can see what other zombies see?  Like a terminal for zombies?) (braodcast range limited to # of ALIVE zombies on tile)
    bite
        bite_adv
    corrode
        acid
            acid_adv
    ruin
        ruin_adv 
    infection
        infection_adv

-----------------------------------------------------------------------------

-- HUMAN --
    -- General
    hp_bonus
    roof_travel
    ip_bonus
    looting
    diagnosis
    ranged
    melee
        blade
        blunt
        martial_arts

    -- Military [2 skills?]
    ranged_adv
        sidearm --(shoot hunters window)
        primary --(armor piercing?)
    melee_adv
        blade_adv   --(maime)
        blunt_adv   --(can break grip from brutes)
    pyrotech
        pyrotech_adv
    --guard_watch (protection from hunter leaps, block barricade intereference, lower chance-to-hit barrier defenses)
    --guard_watch_adv 

    -- Research
    diagnosis_adv     -- can see infected (require healing?) (see exact hp of humans)
    healing
        major_healing -- [heal permahp]
        minor_healing -- [heal permahp]
    gadgets
        scanner
    syringe -- boost chance of use %, and increase hp amount it can be used on [4, 7, 10, 13]
        syringe_adv -- [5, 8, 11, 14]
    terminal
        terminal_adv
    
    -- Engineering
    repair
        repair_adv
        renovate         
    barricade
        barricade_adv
        reinforce
    tech
        power_tech    (fix conditions)
        radio_tech    (fix conditions)
        computer_tech (fix conditions)
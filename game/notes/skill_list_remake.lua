-- SKILL LIST REMAKE --

-- ZOMBIE --
    hp_bonus            -- bonus hp when standing
    hunger_bonus
    smell_blood
    digestion/rejuivante -- full hp from feeding + healing from bite attacks
    grapple              -- bonus to attack
    	grapple_adv      -- cannot escape grip
    muscle_stimulus              
        hand_stimulus 
        head_stimulus
    hivemind        -- communicate with hive zombies  [communicate by rank -> zombie username + class + level] (???)

    -- Brute
    claw
        claw_adv (dual_claw)
        power_claw
    drag_prey/grappled_adv
    armor
        armor_adv
    maime                -- require claw? claw_adv?
        maime_adv

    -- Hunter (x_ray _vision?)
    sprint 
    leap
        leap_adv
    track                 -- mark prey included?
        track_adv
    hide                  -- can hide in unlit building, (humans have a bonus to discovery using a flashlight) (easier to hide in ruined building)
        hide_adv          -- improved hiding and less chance of discovery (auto hide in ruined buildings)
    smell_blood_adv       -- see hp, see wounded inside buildings from outside 

    -- Hive  (remove infection_adv or ruin_adv)
    bite
        bite_adv
    acid
        acid_adv 
    ruin                   -- can only ransack
        ruin_adv           -- can ruin
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

    -- Military
    ranged_adv
        sidearm --(shoot hunters window)
        primary --(armor piercing?)
    melee_adv
        blade_adv   --(maime)
        blunt_adv   --(can break grip from brutes)
    pyrotech
        pyrotech_adv 

    -- Research
    diagnosis_adv     -- can see infected (require healing?) (see exact hp of humans)
    healing
        major_healing -- [heal permahp]
        minor_healing -- [heal permahp]
    gadgets -- boost chance of use % for items, and increase hp amount for syringes it can be used on [4, 7, 10, 13]
        scanner
    	syringe -- [5, 8, 11, 14]
    	terminal
    
    -- Engineering
    repair            -- (fix doors)
        repair_adv    -- (fix machines)
        renovate      -- (fix ruins)
    barricade
        barricade_adv
    	reinforce
    tech         --(install equipment)  
    	tech_adv --(install equipment ap cost reduced, fix conditions)
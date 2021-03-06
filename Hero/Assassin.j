library Assassin uses Systems
            
    globals
        Assassin ASSASSIN
        
        Ability ASSASSIN_SHADOW_STRIKE
        Ability ASSASSIN_WIND_WALK
        Ability ASSASSIN_TROLL_REGEN
        Ability ASSASSIN_MIRROR_IMAGE
        Ability ASSASSIN_SHADOWSTEP
    endglobals

    struct Assassin extends UnitType
    
        /*

        UNIMPLEMENTED
        The Assassin struct contains basic behavior for how units of type Assassin behave.

        */
        
        static method onEnterFlagRange takes Unit this, Flag which returns nothing
            /*
            
            UNIMPLEMENTED
            Behavior for when a hero comes within a certain range of the given flag.
            Ideally, this will allow a bot to attempt to pick-up or return the flag.
            
            */
            
            call IssueTargetOrder(this.unit,"smart",which.whichFlag)
        endmethod
    
        static method init takes nothing returns nothing
            /*
            
            Basic initialization
            
            */           
            
            set ASSASSIN = Assassin.create('E002')
            
            set ASSASSIN.isHero = true
            
            set ASSASSIN_SHADOW_STRIKE = Ability.create('A00C',"shadowstrike",TARGET_TYPE_UNIT,60,60,60,60)
            set ASSASSIN_WIND_WALK = Ability.create('A00H',"windwalk",TARGET_TYPE_NONE,40,40,40,40)
            set ASSASSIN_TROLL_REGEN = Ability.create('A000',"",TARGET_TYPE_NONE,0,0,0,0)
            set ASSASSIN_MIRROR_IMAGE = Ability.create('A003',"mirrorimage",TARGET_TYPE_NONE,60,60,0,0)
            set ASSASSIN_SHADOWSTEP = Ability.create('A013',"possession",TARGET_TYPE_UNIT,65,0,0,0)
            set ASSASSIN.range = Unit.DISTANCE_MELEE
            
            set ASSASSIN.desc[0] = DARKGREEN + "Troll Assassin" + END //little power, some control, some survivability
            set ASSASSIN.desc[1] = YELLOW + "Excels in " + END + GREEN + "All Combat" + END + YELLOW + "." + END
            set ASSASSIN.desc[2] = YELLOW + "The Assassin is slippery and deadly in the right hands." + END
            
            set UnitType.Heroes[0] = ASSASSIN
        endmethod
        
    endstruct
    
endlibrary
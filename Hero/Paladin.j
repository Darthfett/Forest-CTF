library Paladin uses Systems

    globals
        UnitType PALADIN
        
        Ability PALADIN_STORM_BOLT
        Ability PALADIN_BASH
        Ability PALADIN_RALLY_OF_JUSTICE
        Ability PALADIN_HOLY_LIGHT
        Ability PALADIN_DIVINE_SHIELD
    endglobals
    
    struct Paladin extends UnitType
        
        static method onEnterFlagRange takes Unit this, Flag which returns nothing
            call IssueTargetOrder(this.unit,"smart",which.whichFlag)
        endmethod
    
        private static method onInit takes nothing returns nothing
            set PALADIN = Paladin.create('E000')
            
            set PALADIN.model = gg_unit_E000_0021
            
            set PALADIN.isHero = true
            
            set PALADIN_STORM_BOLT = Ability.create('A00S',"stormbolt",TARGET_TYPE_UNIT,60,60,60,60)
            set PALADIN_BASH = Ability.create('A001',"",TARGET_TYPE_UNIT,0,0,0,0)
            set PALADIN_RALLY_OF_JUSTICE = Ability.create('A00Z',"bloodlust",TARGET_TYPE_UNIT,45,45,45,45)
            set PALADIN_HOLY_LIGHT = Ability.create('A002',"holybolt",TARGET_TYPE_UNIT,60,60,0,0)
            set PALADIN_DIVINE_SHIELD = Ability.create('A00J',"divineshield",TARGET_TYPE_NONE,75,0,0,0)
            
            set PALADIN.range = Unit.DISTANCE_MELEE
            
            set PALADIN.desc[0] = LIGHTYELLOW + "Makrura Paladin" + END //little Power, little Control, Survivability
            set PALADIN.desc[1] = YELLOW + "Excels in " + END + RED + "Close Combat" + END + YELLOW + "." + END
            set PALADIN.desc[2] = YELLOW + "Survivability is the Paladin's hidden power."
        endmethod
        
    endstruct
    
endlibrary
library Mage uses Systems

    globals
        UnitType MAGE
        
        Ability MAGE_FIREBOLT
        Ability MAGE_CHRONOBURN
        Ability MAGE_FEEDBACK
        Ability MAGE_BLINK
        Ability MAGE_SUMMON_WATER_ELEMENTAL
    endglobals
    
    struct Mage extends UnitType
        
        static method onEnterFlagRange takes Unit this, Flag which returns nothing
            call IssueTargetOrder(this.unit,"smart",which.whichFlag)
        endmethod
    
        private static method onInit takes nothing returns nothing
            set MAGE = Mage.create('E004')
            
            set MAGE.model = Repick_Mage
            
            set MAGE.isHero = true
            
            set MAGE_FIREBOLT = Ability.create('A00Y',"firebolt",TARGET_TYPE_UNIT,65,65,65,65)
            set MAGE_CHRONOBURN = Ability.create('A01Y',"magicleash",TARGET_TYPE_UNIT,60,60,60,60)
            set MAGE_FEEDBACK = Ability.create('A00V',"",TARGET_TYPE_UNIT,0,0,0,0)
            set MAGE_BLINK = Ability.create('A004',"blink",TARGET_TYPE_POINT,60,30,0,0)
            set MAGE_SUMMON_WATER_ELEMENTAL = Ability.create('A010',"waterelemental",TARGET_TYPE_NONE,90,0,0,0)
            
            set MAGE.range    = 750
            
            set MAGE.desc[0] = BLUE + "Murloc Mage" + END //some Power, some control, little survivability
            set MAGE.desc[1] = YELLOW + "Excels in " + END + BLUE + "Ranged Combat" + END + YELLOW + "." + END
            set MAGE.desc[2] = YELLOW + "The secret of the mage is through the powers of its mind." + END
            
            set UnitType.Heroes[2] = MAGE
        endmethod
    
    endstruct
    
endlibrary
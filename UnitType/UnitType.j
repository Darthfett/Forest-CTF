library UnitType uses Ability

    struct UnitType
        
        implement EnvMethods
        
        integer whichType
        boolean isHero
        
        private static hashtable ht

        Ability array abil[5]
        real range
        string array desc[3]
        unit model

        static method getRandomHero takes nothing returns UnitType
            return UnitType(GetRandomInt(integer(WARRIOR),integer(ASSASSIN)))
        endmethod
        
        static method create takes integer whichType returns UnitType
            local UnitType this = UnitType.allocate()
            set this.whichType = whichType
            set this.isHero = false
            call SaveInteger(UnitType.ht,0,whichType,this)
            return this
        endmethod

        static method operator[] takes integer whichType returns UnitType
            /*
            
            UnitTypes are stored in a hashtable with their keys being 0 and their corresponding '0000' number.
            
            */
            
            if not HaveSavedInteger(UnitType.ht,0,whichType) then
                return UnitType.create(whichType)
            endif
            return LoadInteger(UnitType.ht,0,whichType)
        endmethod
        
        private static method onInit takes nothing returns nothing
            set UnitType.ht = InitHashtable()
        endmethod
        
    endstruct

endlibrary
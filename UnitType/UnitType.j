library UnitType uses Ability

    struct UnitType
        /*
        
        Every Unit has some basic information that is independent of its state, such as what Abilities it has, whether
        it is a hero or not, etc.
        
        This data is stored here, or in one of its child structs.
        
        */
        
        implement EnvMethods
        
        integer whichType
        boolean isHero
        
        private static hashtable ht
        static UnitType array Heroes[6]

        Ability array abil[5]
        real range
        string array desc[3]
        unit model

        static method getRandomHero takes nothing returns UnitType
            /*
            
            Returns a UnitType for a random selectable hero (for repicking purposes)
            
            */
            return Heroes[GetRandomInt(0,5)]
        endmethod
        
        static method create takes integer whichType returns UnitType
            /*
            
            Creates a new UnitType and stores it in the hashtable
            
            */
            
            local UnitType this = UnitType.allocate()
            set this.whichType = whichType
            if whichType == 'E001' then
                call BJDebugMsg("Hooray, we are working!")
                call BJDebugMsg(I2S(this))
                call BJDebugMsg(I2S('E001'))
                call BJDebugMsg(I2S(whichType))
                call BJDebugMsg(I2S(this.whichType))
            endif
            set this.isHero = false
            call SaveInteger(UnitType.ht,0,whichType,this)
            return this
        endmethod

        static method operator[] takes integer whichType returns UnitType
            /*
            
            UnitTypes are stored in the hashtable with their keys being 0 and their corresponding '0000' number.
            
            */
            
            if not HaveSavedInteger(UnitType.ht,0,whichType) then
                return UnitType.create(whichType)
            endif
            return LoadInteger(UnitType.ht,0,whichType)
        endmethod
        
        static method initHeroes takes nothing returns nothing
            call Assassin.init()
            call Hunter.init()
            call Mage.init()
            call Paladin.init()
            call Rogue.init()
            call Warrior.init()
        endmethod
        
        private static method onInit takes nothing returns nothing
            /*
            
            Initializes the hashtable
            
            */
            
            set UnitType.ht = InitHashtable()
        endmethod
        
    endstruct

endlibrary

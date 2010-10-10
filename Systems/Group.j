library Group

    /*
    
    Possibly Deprecated
    
    */

    //vJASS version of a group.
    //
    //Automatically recycles groups (but slightly slower CreateGroup)
    //Unit stack
    //Loses speed in add/remove units
    //Same speed IsUnitInGroup
    //Gains speed with enums, Destroy/Clear Group
    //
    //Useful for building on with custom (map-specific) enum functions, and for improving readability

    //How to use:

    /*
    Group tempGroup
    Unit someUnit
    integer i = 0
    loop
        exitwhen i >= tempGroup.unitCount
        //Do stuff with tempGroup[i], as an alternative to FirstOfGroup
        set i = i + 1
    endloop
    */

    globals
        private integer temp = 0
        private Unit tempUnit
        group ENUM_GROUP
    endglobals

    struct Group

        private static hashtable ht

        private group whichGroup
        Unit array whichUnits[32]
        integer unitCount

    //===========================================================

        method operator[] takes integer index returns Unit
            return this.whichUnits[index]
        endmethod

        method containsUnit takes Unit whichUnit returns boolean
            return IsUnitInGroup(whichUnit.unit,this.whichGroup)
        endmethod

        method addUnit takes Unit whichUnit returns nothing
            if IsUnitInGroup(whichUnit.unit,this.whichGroup) == false then
                call GroupAddUnit(this.whichGroup,whichUnit.unit)
                set this.whichUnits[.unitCount] = whichUnit
                call SaveInteger(Group.ht,integer(this),integer(whichUnit),this.unitCount)
                set this.unitCount = this.unitCount + 1
            endif
        endmethod

        method removeUnit takes Unit whichUnit returns nothing
            if IsUnitInGroup(whichUnit.unit,this.whichGroup) then
                call GroupRemoveUnit(this.whichGroup,whichUnit.unit)
                set this.unitCount = this.unitCount - 1
                set temp = LoadInteger(Group.ht,integer(this),integer(whichUnit))
                set this.whichUnits[temp] = this.whichUnits[.unitCount]
            endif
        endmethod

        method removeIndexedUnit takes integer index returns nothing
            if index < this.unitCount then
                call GroupRemoveUnit(this.whichGroup,this.whichUnits[index].unit)
                set this.unitCount = this.unitCount - 1
                set this.whichUnits[index] = this.whichUnits[.unitCount]
            endif
        endmethod

    //===========================================================

        method getAvailableWeakest takes Unit whichUnit, real range returns Unit
            local real p = 10
            local real dist = range + 1
            set temp = 0
            set tempUnit = this.whichUnits[temp]
            loop
                exitwhen temp >= this.unitCount
                if IsUnitInRange(whichUnit.unit,this.whichUnits[temp].unit,range) then
                    if this.whichUnits[temp].life / this.whichUnits[temp].maxLife < p then
                        set tempUnit = this.whichUnits[temp]
                        set dist = range
                        set p = this.whichUnits[temp].life / this.whichUnits[temp].maxLife
                    elseif dist > range then
                        set tempUnit = this.whichUnits[temp]
                        set dist = range
                        set p = this.whichUnits[temp].life / this.whichUnits[temp].maxLife
                    endif
                else
                    if this.whichUnits[temp].life / this.whichUnits[temp].maxLife < p and dist > range then
                        set tempUnit = this.whichUnits[temp]
                        set dist = range
                        set p = this.whichUnits[temp].life / this.whichUnits[temp].maxLife
                    endif
                endif
                set temp = temp + 1
            endloop
            return tempUnit
        endmethod

        method getWeakest takes nothing returns Unit
            local real p = 10
            set tempUnit = 0
            set temp = 0
            loop
                exitwhen temp >= this.unitCount
                if this.whichUnits[temp].life / this.whichUnits[temp].maxLife < p then
                    set tempUnit = this.whichUnits[temp]
                    set p = this.whichUnits[temp].life / this.whichUnits[temp].maxLife
                endif
                set temp = temp + 1
            endloop
            return tempUnit
        endmethod

        method getAverageLife takes nothing returns real
            local real hp = 0
            set temp = 0
            loop
                exitwhen temp >= this.unitCount
                set hp = hp + GetWidgetLife(this.whichUnits[temp].unit)
                set temp = temp + 1
            endloop
            return hp / temp
        endmethod

        method getAverageX takes nothing returns real
            local real x = 0
            set temp = 0
            loop
                exitwhen temp >= this.unitCount
                set x = x + GetUnitX(this.whichUnits[temp].unit)
                set temp = temp + 1
            endloop
            return x / temp
        endmethod

        method getAverageY takes nothing returns real
            local real y = 0
            set temp = 0
            loop
                exitwhen temp >= this.unitCount
                set y = y + GetUnitY(this.whichUnits[temp].unit)
                set temp = temp + 1
            endloop
            return y / temp
        endmethod

        method getAverageAngleFromUnit takes Unit whichUnit returns real
            local real a = 0
            local real x = GetUnitX(whichUnit.unit)
            local real y = GetUnitY(whichUnit.unit)
            set temp = 0
            loop
                exitwhen temp >= this.unitCount
                set a = a + Atan2(GetUnitY(this.whichUnits[temp].unit) - y,GetUnitX(this.whichUnits[temp].unit) - x)
                set temp = temp + 1
            endloop
            return a / temp //in Radians
        endmethod

    //===========================================================
    //===========================================================

        method clear takes nothing returns nothing
            set this.unitCount = 0
        endmethod

        static method create takes nothing returns Group
            local Group this = Group.allocate()
            set this.unitCount = 0
            if this.whichGroup == null then
                set this.whichGroup = CreateGroup()
            else
                call GroupClear(this.whichGroup)
            endif
            return this
        endmethod

        private method onDestroy takes nothing returns nothing
            set this.unitCount = 0
        endmethod

        private static method onInit takes nothing returns nothing
            set Group.ht = InitHashtable()
        endmethod

    endstruct

endlibrary
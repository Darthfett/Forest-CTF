library Detection

    /*

    Units are invisible IFF
        * They have some sort of ability that makes them invisible
    */

    module Detection
        /*

        Some functionality for bot Units related to detecting Units

        */

        static constant real ENTER_RANGE_MIN_DISTANCE = 1500
        //Units cannot be seen beyond the above distance (excluding Flag carriers)
        static constant real ENTER_RANGE_CALLBACK = 0.08

        trigger enterRangeTrig
        timer enterRangeTimer
        group enterRangeUnits

        method onDetect takes Unit target returns nothing
            //Runs the onDetect method responsible for the behavior of the type of this Unit
            call this.whichType.onDetect(this,target)
        endmethod

        method causeNotice takes Unit enterer returns nothing
            /*

            Runs whenever a Unit can suddenly 'see' a friendly/enemy within range

            */

            if enterer.owner.team == this.owner.team then
                call this.friendly.addUnit(enterer)
            else
                call this.threats.addUnit(enterer)
            endif
            if this.whichType.isHero and this.owner.isEnabled then
                call this.onDetect(enterer) //Detected a unit
            endif
        endmethod

        method onAttackOrderActions takes nothing returns nothing
            //Prevents Team-Attacks, changing the order to follow
            if Unit[GetTriggerUnit()].owner.team == Unit[GetOrderTargetUnit()].owner.team and GetIssuedOrderId() == OrderId("attack") then
                call IssueTargetOrder(GetTriggerUnit(),"smart",GetOrderTargetUnit())
            endif
        endmethod

        static method enterRangeGroupCallback takes nothing returns nothing
            /*

            AUTOMATED
            Nearby invisible units' position and visibility status are checked, removed from the list of units to check if
            they are out of range, or 'detected' if they are visible.

            */

            local Unit e = Unit[GetEnumUnit()]
            if IsUnitInRange(Unit.tempUnit.unit,GetEnumUnit(),Unit.ENTER_RANGE_MIN_DISTANCE) then
                if IsUnitVisible(Unit.tempUnit.unit,GetOwningPlayer(GetEnumUnit())) then
                    call Unit.tempUnit.onDetect(e)
                endif
            else
                call GroupRemoveUnit(Unit.tempUnit.enterRangeUnits,e.unit)
            endif
        endmethod

        method enterRangeCallback takes nothing returns nothing
            /*

            AUTOMATED
            Automatically goes through all nearby invisible units, waiting for them to become visible or leave range

            */

            set Unit.tempUnit = this
            call ForGroup(this.enterRangeUnits,function Unit.enterRangeGroupCallback)
            if FirstOfGroup(this.enterRangeUnits) == null then
                call PauseTimer(this.enterRangeTimer)
            endif
        endmethod

        static method enterRangeConditions takes nothing returns boolean
            //Bots only register Units matching these conditions
            return true
            //return GetPlayerId(GetOwningPlayer(GetEnteringUnit())) < 12
        endmethod

        method enterRange takes nothing returns nothing
            /*

            Whenever a unit comes within a certain range of this Unit, the bot suddenly 'notices' them, and may do something.
            Invisible units are polled until they either leave range, or become visible.

            */

            local Unit enter = Unit[GetTriggerUnit()]
            if this == enter then
                return
            endif

            if IsUnitVisible(enter.unit,this.owner.whichPlayer) then
                call this.causeNotice(enter)
            else
                call GroupAddUnit(this.enterRangeUnits,enter.unit)
                call StartTimer(this,this.enterRangeTimer,Unit.ENTER_RANGE_CALLBACK,true,Unit.enterRangeCallback)
            endif
        endmethod

    endmodule

endlibrary
library Detection

module Detection

    static constant real ENTER_RANGE_MIN_DISTANCE = 1500
    static constant real ENTER_RANGE_CALLBACK = 0.08
    
    trigger enterRangeTrig
    timer enterRangeTimer
    group enterRangeUnits
    
    method onDetect takes Unit target returns nothing
        call this.whichType.onDetect(this,target)
    endmethod

    method causeNotice takes Unit e returns nothing
        if e.owner.team == this.owner.team then
            call this.friendly.addUnit(e)
        else
            call this.threats.addUnit(e)
        endif
        if this.whichType.isHero and this.owner.isEnabled then
            call this.onDetect(e)
        endif
    endmethod
    
    method onAttackOrderActions takes nothing returns nothing
        if Unit[GetTriggerUnit()].owner.team == Unit[GetOrderTargetUnit()].owner.team and GetIssuedOrderId() == OrderId("attack") then
            call IssueTargetOrder(GetTriggerUnit(),"smart",GetOrderTargetUnit())
        endif
    endmethod
    
    static method enterRangeGroupCallback takes nothing returns nothing
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
        set Unit.tempUnit = this
        call ForGroup(this.enterRangeUnits,function Unit.enterRangeGroupCallback)
        if FirstOfGroup(this.enterRangeUnits) == null then
            call PauseTimer(this.enterRangeTimer)
        endif
    endmethod
    
    static method enterRangeConditions takes nothing returns boolean
        return true
        //return GetPlayerId(GetOwningPlayer(GetEnteringUnit())) < 12
    endmethod
    
    method enterRange takes nothing returns nothing
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
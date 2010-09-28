library Death

module Death
    
    static constant real REVIVE_BUFF_DURATION = 6.0
    static trigger onDeathTrig
    timer reviveTimer
    timerdialog reviveDialog
    boolean isAlive
    
    method onDeath takes Unit die returns nothing
        call this.whichType.onDeath(this,die)
    endmethod

    private method reviveCallback takes nothing returns nothing
        call SetUnitInvulnerable(this.unit,false)
    endmethod

    method revive takes boolean display returns nothing
        local unit u
        if this.isAlive then
            return
        endif
        call TimerDialogDisplay(this.reviveDialog,false)
        if this.unit != null and this.owner.isEmpty == false then
            call ReviveHero(this.unit,this.owner.team.reviveX,this.owner.team.reviveY,display)
            set this.isAlive = true
            if this.owner.localThis then //Avoid the native function call of GetLocalPlayer
                call PanCameraToTimed(this.owner.team.reviveX,this.owner.team.reviveY,.5)
                call ClearSelection()
                call SelectUnit(this.unit,true)
            endif
            call SetUnitInvulnerable(this.unit,true)
            set u = CreateUnit(this.owner.whichPlayer,'n009',this.owner.team.reviveX,this.owner.team.reviveY,0)
            call UnitApplyTimedLife(u,'BTLF',3)
            call IssueTargetOrder(u,"bloodlust",this.unit)
            set u = null
            if display then
                call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,8,P2CN(this.owner.whichPlayer) + YELLOW + "  been revived." + END)
            endif
            if this.owner.isEnabled then
                call Debug.PlaceHolder(this.name + " has revived.  Run orders PlaceHolder")
            endif
            call StartTimer(this,this.reviveTimer,Unit.REVIVE_BUFF_DURATION,false,Unit.reviveCallback)
        endif
        
    endmethod
    
    method onDeathCallback takes nothing returns nothing
        call this.revive(true)
    endmethod
    
    static method onDeathFilter takes nothing returns boolean
        local Unit this = Unit[GetFilterUnit()]
        call this.onDeath(Unit.tempUnit)
        return false
    endmethod
    
    static method onDeathActions takes nothing returns nothing
        local Unit this = Unit[GetTriggerUnit()]
        set this.isAlive = false
        set Unit.tempUnit = this
        call GroupEnumUnitsInRange(ENUM_GROUP,this.x,this.y,thistype.ENTER_RANGE_MIN_DISTANCE,Filter(function thistype.onDeathFilter))
        if this.whichType.isHero then
            call TimerDialogDisplay(this.reviveDialog,true)
            call StartTimer(this,this.reviveTimer,9 + (I2R(GetUnitLevel(this.unit)) / 2),false, Unit.onDeathCallback)
        endif
    endmethod
    
    private static method onInit takes nothing returns nothing
        set Unit.onDeathTrig = CreateTrigger()
        call TriggerAddAction(Unit.onDeathTrig,function Unit.onDeathActions)
        call TriggerRegisterAnyUnitEventBJ(Unit.onDeathTrig,EVENT_PLAYER_UNIT_DEATH)
    endmethod

endmodule

endlibrary
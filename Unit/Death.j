library Death

    module Death
        /*

        Some functionality for bot Units related to death

        */

        static constant real REVIVE_BUFF_DURATION = 6.0
        static trigger onDeathTrig
        timer reviveTimer
        timerdialog reviveDialog
        boolean isAlive

        method onDeath takes Unit die returns nothing
            //When a Unit dies near this Unit
            call this.whichType.onDeath(this,die)
        endmethod

        private method reviveCallback takes nothing returns nothing
            //For a certain period of time after reviving, Units are made invulnerable (then vulnerable again by this method)
            call SetUnitInvulnerable(this.unit,false)
        endmethod

        method revive takes boolean display returns nothing
            /*
            
            Revives this Unit at its base.
            If display, it will display to everyone that it revived, and show revive effects
            
            */
            
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
                
                //Apply special revive bonuses, to prevent camping:
                call SetUnitInvulnerable(this.unit,true)
                set u = CreateUnit(this.owner.whichPlayer,'n009',this.owner.team.reviveX,this.owner.team.reviveY,0)
                call UnitApplyTimedLife(u,'BTLF',3)
                call IssueTargetOrder(u,"bloodlust",this.unit)
                set u = null
                
                if display then
                    call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,8,P2CN(this.owner.whichPlayer) + YELLOW + "  been revived." + END)
                endif
                if this.owner.isEnabled then
                    /*
                    
                    UNIMPLEMENTED
                    This should order the Unit to do something intelligent.
                    
                    */
                    call BJDebugMsg(this.name + " has revived.  Run orders PlaceHolder")
                endif
                call StartTimer(this,this.reviveTimer,Unit.REVIVE_BUFF_DURATION,false,Unit.reviveCallback)
            endif

        endmethod

        method onDeathCallback takes nothing returns nothing
            //After a certain period of time, the unit is revived with displayed effects
            call this.revive(true)
        endmethod

        static method onDeathFilter takes nothing returns boolean
            //Tells all nearby bots that a Unit died near them.
            local Unit this = Unit[GetFilterUnit()]
            call this.onDeath(Unit.tempUnit)
            return false
        endmethod

        static method onDeathActions takes nothing returns nothing
            /*
            
            Starts the revive timer when a hero Unit dies
            
            */
            
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
            /*
            
            Sets up some basic triggers for Unit Death events
            
            */
            
            set Unit.onDeathTrig = CreateTrigger()
            call TriggerAddAction(Unit.onDeathTrig,function Unit.onDeathActions)
            call TriggerRegisterAnyUnitEventBJ(Unit.onDeathTrig,EVENT_PLAYER_UNIT_DEATH)
        endmethod

    endmodule

endlibrary
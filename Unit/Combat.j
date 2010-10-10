library Combat

    module Combat
        /*
        
        Contains functionality for Units relating to Combat
        
        */

        Unit target
        Group friendly
        Group threats

        static constant real DISTANCE_VERY_FAR = 2000
        static constant real DISTANCE_FAR = 900
        static constant real DISTANCE_CLOSE = 500
        static constant real DISTANCE_MELEE = 150

        static constant real PERCENT_CRITICAL = 0.10
        static constant real PERCENT_DANGER =   0.20
        static constant real PERCENT_LOW =      0.50

        static constant real COMBAT_TIMER_DURATION = 4.0

        trigger castSpellTrig

        timer combatTimer
        boolean inCombat

        method leaveCombat takes nothing returns nothing
            //After a certain period of time, Units that have not taken damage or see any action, "leave combat"
            set this.inCombat = false
            call PauseTimer(GetExpiredTimer())
        endmethod

        method enterCombat takes nothing returns nothing
            //Whenever anything happens to a Unit, this method will put it into combat, and reset the combat timer
            set this.inCombat = true
            call StartTimer(this,this.combatTimer,Unit.COMBAT_TIMER_DURATION,false,Unit.leaveCombat)
        endmethod

        method canCast takes Ability abil returns boolean
            //Returns whether this Unit can cast the given ability
            return GetUnitAbilityLevel(this.unit,abil.whichAbility) > 0 and this.mana >= abil.manaCost[GetUnitAbilityLevel(this.unit,abil.whichAbility)]
        endmethod

        method attack takes Unit target returns nothing
            //Orders a bot to attack a specific Unit, and sets that Unit as its target
            call BJDebugMsg(this.name + " attacking " + target.name)
            set this.target = target
            call IssueTargetOrder(this.unit,"attack",target.unit)
        endmethod

        method onCast takes Unit caster, CastData data returns nothing
            /*

            Runs the onCast method responsible for the behavior of the type of this Unit
            TODO: Lookup and see if this puts a Unit in-combat
            
            */
            
            call this.whichType.onCast(this,caster,data)
        endmethod

        method onCastActions takes nothing returns nothing
            /*
            
            Whenever a Unit casts an ability, it enters combat based on any of the following conditions:
                * The target is an enemy
                * The target is a friend that is in-combat
            
            */
            
            local Unit target = Unit[GetSpellTargetUnit()]
            local Ability whichAbility = Ability[GetSpellAbilityId()]
            if target != 0 then
                if (target.owner.team != this.owner.team or target.inCombat) then
                    call this.enterCombat()
                    call target.enterCombat()
                endif
                call target.onCast(this,CastData.UnitCreate(this,target,GetSpellAbilityId()))
            elseif GetSpellTargetX() != 0 or GetSpellTargetY() != 0 then
                if this.inCombat then
                    call target.onCast(this,CastData.PointCreate(this,GetSpellTargetX(),GetSpellTargetY(),GetSpellAbilityId()))
                endif
            endif
        endmethod

    endmodule

endlibrary
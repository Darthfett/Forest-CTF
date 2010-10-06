library Hunter uses Systems

    globals
        integer HUNTER_MID_RANGE = 350
        UnitType HUNTER
        
        Ability HUNTER_FLURRY_OF_ARROWS
        Ability HUNTER_LAY_TRAP
        Ability HUNTER_SCOUT
        Ability HUNTER_SUMMON_BEAR
        Ability HUNTER_SILENCE
    endglobals
    
    struct Hunter extends UnitType
        
        static method onEnterFlagRange takes Unit this, Flag which returns nothing
            call IssueTargetOrder(this.unit,"smart",which.whichFlag)
        endmethod
    
        static method engage takes Unit this, Unit target returns nothing
            local real dist = DistanceBetweenXY(this.x,this.y,target.x,target.y)
            if dist > HUNTER.range then
                if target.whichType.range == Unit.DISTANCE_MELEE then
                    if target > this then
                        if this.canCast(HUNTER_SUMMON_BEAR) then
                            call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                        elseif this.canCast(HUNTER_LAY_TRAP) then
                            call IssuePointOrder(this.unit,HUNTER_LAY_TRAP.order,this.x,this.y)
                        elseif target.whichType == WARRIOR and target.canCast(WARRIOR_CHARGE) and this.canCast(HUNTER_SILENCE) then
                            call IssuePointOrder(this.unit,HUNTER_SILENCE.order,target.x,target.y)
                        else
                            call this.attack(target)
                        endif
                    else
                        call this.attack(target)
                    endif
                else
                    if target > this then
                        if target.manaPercent > 0.10 and this.canCast(HUNTER_SILENCE) then
                            call IssuePointOrder(this.unit,HUNTER_SILENCE.order,target.x,target.y)
                        elseif this.canCast(HUNTER_SUMMON_BEAR) then
                            call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                        else
                            call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                        endif
                    else
                        call this.attack(target)
                    endif
                endif
            elseif dist > HUNTER_MID_RANGE then
                if target.whichType.range == Unit.DISTANCE_MELEE then
                    if target > this then
                        if this.canCast(HUNTER_SUMMON_BEAR) then
                            call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                        elseif this.canCast(HUNTER_LAY_TRAP) then
                            call IssuePointOrder(this.unit,HUNTER_LAY_TRAP.order,this.x,this.y)
                        elseif target.manaPercent > 0.10 and this.canCast(HUNTER_SILENCE) then
                            call IssuePointOrder(this.unit,HUNTER_SILENCE.order,target.x,target.y)
                        else
                            call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                        endif
                    else
                        if target.lifePercent > 0.25 and this.canCast(HUNTER_SUMMON_BEAR) then
                            call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                        else
                            call this.attack(target)
                        endif
                    endif
                else
                    if target > this then
                        if this.canCast(HUNTER_SUMMON_BEAR) then
                            call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                        elseif target.manaPercent > 0.10 and this.canCast(HUNTER_SILENCE) then
                            call IssuePointOrder(this.unit,HUNTER_SILENCE.order,target.x,target.y)
                        else
                            call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                        endif
                    else
                        call this.attack(target)
                    endif
                endif
            else
                if target > this then
                    if this.canCast(HUNTER_SUMMON_BEAR) then
                        call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                    elseif this.canCast(HUNTER_LAY_TRAP) then
                        call IssuePointOrder(this.unit,HUNTER_LAY_TRAP.order,this.x,this.y)
                    elseif target.manaPercent > 0.10 and this.canCast(HUNTER_SILENCE) then
                        call IssuePointOrder(this.unit,HUNTER_SILENCE.order,target.x,target.y)
                    else
                        call this.attack(target)
                    endif
                else
                    if this.canCast(HUNTER_SUMMON_BEAR) then
                        call IssueImmediateOrder(this.unit,HUNTER_SUMMON_BEAR.order)
                    elseif this.canCast(HUNTER_LAY_TRAP) then
                        call IssuePointOrder(this.unit,HUNTER_LAY_TRAP.order,this.x,this.y)
                    else
                        call this.attack(target)
                    endif
                endif
            endif
        endmethod                        
    
        private static method onInit takes nothing returns nothing
            set HUNTER = Hunter.create('E005')
            
            set HUNTER.model = Repick_Hunter
            
            set HUNTER.isHero = true
            
            set HUNTER_FLURRY_OF_ARROWS = Ability.create('A018',"",TARGET_TYPE_UNIT,0,0,0,0)
            set HUNTER_LAY_TRAP = Ability.create('A016',"ward",TARGET_TYPE_POINT,70,70,70,70)
            set HUNTER_SCOUT = Ability.create('A014',"scout",TARGET_TYPE_NONE,30,30,30,30)
            set HUNTER_SUMMON_BEAR = Ability.create('A01A',"summongrizzly",TARGET_TYPE_NONE,90,90,0,0)
            set HUNTER_SILENCE = Ability.create('A01D',"silence",TARGET_TYPE_POINT,45,0,0,0)
            
            set HUNTER.range  = 900
            
            set HUNTER.desc[0] = ORANGE + "Human Hunter" + END //some Power, some Control, some Survivability
            set HUNTER.desc[1] = YELLOW + "Excels in " + END + GREEN + "All Combat" + END + YELLOW + "." + END
            set HUNTER.desc[2] = YELLOW + "The Hunter thrives in a balance between control, survivability, and power." + END
        endmethod
    
    endstruct
    
endlibrary
library Rogue uses Systems

    globals
        integer ROGUE_MID_RANGE = 350
    
        UnitType ROGUE
        
        Ability ROGUE_SPRINT
        Ability ROGUE_ENSNARE
        Ability ROGUE_CRITICAL_STRIKE
        Ability ROGUE_SHADOW_MELD
        Ability ROGUE_BLADE_FURY
    endglobals

    struct Rogue extends UnitType
        
        static method onEnterFlagRange takes Unit this, Flag which returns nothing
            call IssueTargetOrder(this.unit,"smart",which.whichFlag)
        endmethod
        
        static method engage takes Unit this, Unit target returns nothing
            local real dist = DistanceBetweenXY(this.x,this.y,target.x,target.y)
            if dist > ROGUE.range then
                if target.whichType.range == Unit.DISTANCE_MELEE then
                    if this.canCast(ROGUE_ENSNARE) then
                        call IssueTargetOrder(this.unit,ROGUE_ENSNARE.order,target.unit)
                    else
                        call this.attack(target)
                    endif
                else
                    if this <= target then
                        if this.canCast(ROGUE_BLADE_FURY) then
                            call IssueImmediateOrder(this.unit,ROGUE_BLADE_FURY.order)
                        else
                            call this.attack(target)
                        endif
                    else
                        call this.attack(target)
                    endif
                endif
            elseif dist > ROGUE_MID_RANGE or target.whichType.range != Unit.DISTANCE_MELEE then
                if target.whichType.range == Unit.DISTANCE_MELEE then
                    if this.canCast(ROGUE_ENSNARE) then
                        call IssueTargetOrder(this.unit,ROGUE_ENSNARE.order,target.unit)
                    elseif this <= target then
                        if this.canCast(ROGUE_SPRINT) then
                            call IssueImmediateOrder(this.unit,ROGUE_SPRINT.order)
                        endif
                        call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                    else
                        call this.attack(target)
                    endif
                elseif this.canCast(ROGUE_BLADE_FURY) and target > this then
                    call IssueImmediateOrder(this.unit,ROGUE_BLADE_FURY.order)
                else
                    call this.attack(target)
                endif
            else
                if target.whichType.range == Unit.DISTANCE_MELEE then
                    if this.canCast(ROGUE_ENSNARE) then
                        call IssueTargetOrder(this.unit,ROGUE_ENSNARE.order,target.unit)
                    elseif this.canCast(ROGUE_SPRINT) then
                        call IssueImmediateOrder(this.unit,ROGUE_SPRINT.order)
                        call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                    elseif target > this then
                        call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                    else
                        call this.attack(target)
                    endif
                endif
            endif
        endmethod             
    
        private static method onInit takes nothing returns nothing
            set ROGUE = Rogue.create('E001')
            
            set ROGUE.isHero = true
            
            set ROGUE_SPRINT = Ability.create('A00D',"berserk",TARGET_TYPE_NONE,50,46,43,40)
            set ROGUE_ENSNARE = Ability.create('A006',"ensnare",TARGET_TYPE_UNIT,40,40,40,40)
            set ROGUE_CRITICAL_STRIKE = Ability.create('A00K',"",TARGET_TYPE_NONE,0,0,0,0)   
            set ROGUE_SHADOW_MELD = Ability.create('A00O',"ambush",TARGET_TYPE_NONE,0,0,0,0)
            set ROGUE_BLADE_FURY = Ability.create('S009',"creepthunderclap",TARGET_TYPE_NONE,90,0,0,0)
            
            set ROGUE.range   = 700
            
            set ROGUE.desc[0] = BROWN + "Gnoll Rogue" + END //some Power, control, no survivability
            set ROGUE.desc[1] = YELLOW + "Excels in " + END + BLUE + "Ranged Combat" + END + YELLOW + "." + END
            set ROGUE.desc[2] = YELLOW + "The Rogue's high damage output and maneuverability is offset by his fragility." + END
            
            set UnitType.Heroes[4] = ROGUE
        endmethod
        
    endstruct
    
endlibrary
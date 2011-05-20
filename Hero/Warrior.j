library Warrior uses Systems

    globals
        integer WARRIOR_BATTLE_CRY_MANA_MIN_REQ = 80
        
        UnitType WARRIOR
        
        Ability WARRIOR_RAMPAGE
        Ability WARRIOR_SLASH
        Ability WARRIOR_BATTLE_CRY
        Ability WARRIOR_CHARGE
        Ability WARRIOR_BLOOD_RAGE
    endglobals

    struct Warrior extends UnitType
        
        static method onEnterFlagRange takes Unit this, Flag which returns nothing
            call IssueTargetOrder(this.unit,"smart",which.whichFlag)
        endmethod
        
        static method engage takes Unit this, Unit target returns nothing
            local real dist = DistanceBetweenXY(this.x,this.y,target.x,target.y)
            if dist > 600 then
                if this.canCast(WARRIOR_CHARGE) then
                    call IssueTargetOrder(this.unit,WARRIOR_CHARGE.order,target.unit)
                elseif this > target then
                    if GetUnitAbilityLevel(this.unit,WARRIOR_BATTLE_CRY.whichBuff) == 0 and this.canCast(WARRIOR_BATTLE_CRY) and this.mana > WARRIOR_BATTLE_CRY_MANA_MIN_REQ then
                        call IssueImmediateOrder(this.unit,WARRIOR_BATTLE_CRY.order)
                    elseif this.canCast(WARRIOR_SLASH) then
                        call IssueTargetOrder(this.unit,WARRIOR_SLASH.order,target.unit)
                    else
                        call this.attack(target)
                    endif
                else
                    call Debug.PlaceHolder(this.name + " is attempting to flee from " + target.name)
                endif
            elseif dist > 400 then
                if this.canCast(WARRIOR_BATTLE_CRY) and GetUnitAbilityLevel(this.unit,WARRIOR_BATTLE_CRY.whichBuff) == 0 and this.mana > WARRIOR_BATTLE_CRY_MANA_MIN_REQ then
                    call IssueImmediateOrder(this.unit,WARRIOR_BATTLE_CRY.order)
                elseif this.canCast(WARRIOR_SLASH) then
                    call IssueTargetOrder(this.unit,WARRIOR_SLASH.order,target.unit)
                else
                    call this.attack(target)
                endif
            else
                if this.canCast(WARRIOR_SLASH) then
                    call IssueTargetOrder(this.unit,WARRIOR_SLASH.order,target.unit)
                else
                    call this.attack(target)
                endif
            endif
        endmethod

        private static method onInit takes nothing returns nothing
            set WARRIOR = Warrior.create('E003')
            
            set WARRIOR_RAMPAGE = Ability.create('A01I',"stomp",TARGET_TYPE_NONE,50,50,50,50)
            set WARRIOR_SLASH = Ability.create('A01V',"thunderbolt",TARGET_TYPE_UNIT,55,55,55,55)
            set WARRIOR_BATTLE_CRY = Ability.create('A00P',"roar",TARGET_TYPE_NONE,45,45,45,45)
            set WARRIOR_BATTLE_CRY.whichBuff = 'B00E'
            set WARRIOR_CHARGE = Ability.create('A01F',"banish",TARGET_TYPE_UNIT,40,30,0,0)
            set WARRIOR_BLOOD_RAGE = Ability.create('A01W',"defend",TARGET_TYPE_NONE,0,0,0,0)
            
            set WARRIOR.isHero = true
            
            set WARRIOR.range = Unit.DISTANCE_MELEE
            
            set WARRIOR.desc[0] = RED + "Demon Warrior" + END //Power, no control, some survivability
            set WARRIOR.desc[1] = YELLOW + "Excels in " + END + RED + "Close Combat" + END + YELLOW + "." + END
            set WARRIOR.desc[2] = YELLOW + "What the Warrior lacks in range, he gains in power." + END
            
            set UnitType.Heroes[5] = WARRIOR
        endmethod
        
    endstruct

endlibrary
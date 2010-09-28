library LayTrap uses AIDS,Data

private struct Data

    private static integer UID_TRAP = 'n004'
    private static integer UID_DUMMY = 'n008'
    private static real TIMEOUT = 0.20
    private static integer AID_ENTRAP = 'A015'
    private static string OID_SHACKLE = "magicleash"
    
    private unit attacker
    private unit attackee
    private timer timer
    private unit dummy
    
    private method onDestroy takes nothing returns nothing
        call RemoveUnit(.attacker)
        call DestroyTimer(.timer)
    endmethod
    
    private static method create takes unit att, unit tar returns Data
        local Data this = Data.allocate()
        set this.attacker = att
        set this.attackee = tar
        set this.timer = CreateTimer()
        call StartTimer(this,this.timer,Data.TIMEOUT,false,Data.Callback)
        return this
    endmethod
    
    private method Callback takes nothing returns nothing
        local AI ai = AI[GetOwningPlayer(this.attacker)]
        set this.dummy = CreateUnit(GetOwningPlayer(this.attacker),Data.UID_DUMMY,GetUnitX(this.attacker),GetUnitY(this.attacker),0)
        call SetUnitAbilityLevel(this.dummy,Data.AID_ENTRAP,GetUnitAbilityLevel(this.attacker,ai.hero.whichType.abil[1].whichAbility))
        call IssueTargetOrder(this.dummy,Data.OID_SHACKLE,this.attackee)
        call UnitApplyTimedLife(this.dummy,'BTLF',10)
        call this.destroy()
    endmethod
    
    private static method Conditions takes nothing returns boolean
        return GetUnitTypeId(GetAttacker()) == Data.UID_TRAP
    endmethod
    
    private static method Actions takes nothing returns nothing
        call Data.create(GetAttacker(),GetTriggerUnit())
    endmethod
    
    private static method onInit takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ATTACKED)
        call TriggerAddCondition(t,Condition(function Data.Conditions))
        call TriggerAddAction(t,function Data.Actions)
    endmethod
    
endstruct

endlibrary
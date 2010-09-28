library Rampage initializer Init uses AIDS,Data

globals
    private constant real DURATION = 15.
    private constant integer DUMMY = 'n00A'
    private constant integer ABILITY = 'A01I'
    private constant integer SPEED = 'A009'
    private integer array DAMAGE
    private constant string ORDER = "bloodlust"
endglobals

public struct Data
    //! runtextmacro PUI()
    timer t = CreateTimer()
    unit c
    integer lvl
    
    method onDestroy takes nothing returns nothing
        call UnitRemoveBuffs(this.c,true,false)
        call UnitRemoveAbility(this.c,DAMAGE[this.lvl])
        call PauseTimer(this.t)
        call DestroyTimer(this.t)
        set this.t = null
        set this.c = null
    endmethod
endstruct

private function Callback takes Data this returns nothing
    call this.release()
endfunction

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == ABILITY
endfunction

private function Actions takes nothing returns nothing
    local Data d = Data[GetTriggerUnit()]
    local unit u
    
    if d == 0 then
        set d = Data.create()
        set Data[GetTriggerUnit()] = d
    endif
    
    set d.c = GetTriggerUnit()
    set d.lvl = GetUnitAbilityLevel(d.c,ABILITY)
    call UnitAddAbility(d.c,DAMAGE[d.lvl])
    set u = CreateUnit(GetOwningPlayer(d.c),DUMMY,GetUnitX(d.c) - 1,GetUnitY(d.c),0)
    call SetUnitAbilityLevel(u,SPEED,d.lvl)
    call IssueTargetOrder(u,ORDER,d.c)
    call UnitApplyTimedLife(u,'BTLF',2)
    call StartTimer(d,d.t,DURATION,false,dymet.Callback)
    set u = null
endfunction

private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 0
    local integer j = 1
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition(t, Condition( function Conditions ) )
    call TriggerAddAction(t, function Actions )
    set DAMAGE[1] = 'A01K' //Rawcodes
    set DAMAGE[2] = 'A01O'
    set DAMAGE[3] = 'A01P'
    set DAMAGE[4] = 'A01Q'
    loop
        exitwhen j >= 6
        set i = 0
        loop
            exitwhen i >= 12  //Goes through disabling the spellbook for all the players
            call SetPlayerAbilityAvailable(Player(i),DAMAGE[j],false)
            set i = i + 1
        endloop
        set j = j + 1
    endloop

endfunction

endlibrary
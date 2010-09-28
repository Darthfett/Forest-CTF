library BloodRage initializer Init uses AIDS,Data

//==================================================||
//                                                  ||
//           Spell Created by Darthfett             ||
//                                                  ||
//             Easy to end spell, use:              ||
//                                                  ||
//    call BloodRage_Data[UNIT].release()           ||
//      - to finish the spell abruptly              ||
//                                                  ||
//==================================================||

globals
    private integer AID_BloodRage = 'A01W' //If he has the ability
    private string OID_BloodRage = "defend"
    private string OID_BloodRage_OFF = "undefend"
    private string EFFECT_PATH = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"
    private real TIMEOUT = 1
    private real ATTACK_MANA = 4
    private real TRADE_MANA = 4
    private real TRADE_LIFE = 4
endglobals

public struct Data
    //! runtextmacro PUI()
    timer t
    unit c
    integer lvl
    
    static method create takes nothing returns Data
        local Data d = Data.allocate()
        set d.t = CreateTimer()
        set d.c = GetTriggerUnit()
        set d.lvl = GetUnitAbilityLevel(d.c,AID_BloodRage)
        return d
    endmethod
    
    method onDestroy takes nothing returns nothing
//All the actual cleanup is done in .release/.destroy methods, 
//so that it is possible to stop a spell whenever.
//This makes the spell very flexible
        call PauseTimer(this.t)
        call DestroyTimer(this.t)
        set this.t = null
        set this.c = null
    endmethod
    
endstruct

private function Callback takes Data this returns nothing
    local real x = GetUnitX(this.c)
    local real y = GetUnitY(this.c)
    
    if this == 0 then
        return
    endif
    
    if GetWidgetLife(this.c) < .405 == true then //Ending abnormally
        call this.release()
    endif
    
    if ((GetUnitState(this.c,UNIT_STATE_MANA) >= TRADE_MANA) == true) and ((GetUnitState(this.c,UNIT_STATE_LIFE) < GetUnitState(this.c,UNIT_STATE_MAX_LIFE)) == true) then
        call DestroyEffect(AddSpecialEffect(EFFECT_PATH,x,y))
        call SetUnitState(this.c,UNIT_STATE_MANA,GetUnitState(this.c,UNIT_STATE_MANA) - TRADE_MANA)
        call SetUnitState(this.c,UNIT_STATE_LIFE,GetUnitState(this.c,UNIT_STATE_LIFE) + TRADE_LIFE)
    endif
endfunction

private function ON_Conditions takes nothing returns boolean
    return OrderId2String(GetIssuedOrderId()) == OID_BloodRage
endfunction

private function ON_Actions takes nothing returns nothing
    local Data this = Data[GetTriggerUnit()]
    if this == 0 then
        set this = Data.create()
        set Data[GetTriggerUnit()] = this
    endif
    
    call StartTimer(this,this.t,TIMEOUT,true,dymet.Callback)
endfunction

private function OFF_Conditions takes nothing returns boolean
    return OrderId2String(GetIssuedOrderId()) == OID_BloodRage_OFF
endfunction

private function OFF_Actions takes nothing returns nothing
    local Data this = Data[GetTriggerUnit()]
    if this == 0 then
        return
    else
        call this.release()
    endif
endfunction

private function ATT_Actions takes nothing returns nothing
    local Data this = Data[GetAttacker()]
    if this == 0 then
        return
    endif
    if this.lvl > 0 then
        call SetUnitState(this.c,UNIT_STATE_MANA,GetUnitState(this.c,UNIT_STATE_MANA) + ATTACK_MANA)
    endif    
endfunction

private function Init takes nothing returns nothing
    local trigger att = CreateTrigger()
    local trigger ordon = CreateTrigger()
    local trigger ordoff = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(att,EVENT_PLAYER_UNIT_ATTACKED)
    call TriggerAddAction(att,function ATT_Actions)
    call TriggerRegisterAnyUnitEventBJ(ordon,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(ordon,Condition(function ON_Conditions))
    call TriggerAddAction(ordon,function ON_Actions)
    call TriggerRegisterAnyUnitEventBJ(ordoff,EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(ordoff,Condition(function OFF_Conditions))
    call TriggerAddAction(ordoff,function OFF_Actions)
    
endfunction

endlibrary
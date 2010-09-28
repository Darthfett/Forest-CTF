library BattleFocus uses Data,PUI

public struct Data
    //! runtextmacro PUI()
    static constant integer AID = 'ASDF'
    static constant integer BID = 'JKLZ'
    static constant real DURATION = 15
    
    private static constant real TIMEOUT = 0.03125
    
//==================================================================================

    unit caster
    unit target
    integer level
    real ticks
    
    timer t
    
//==================================================================================
    
    static trigger onCast
    
//==================================================================================

    static method isUnitFocused takes unit c returns boolean
        return Data[c] != 0
    endmethod
    
    static method isUnitFocusedUpon takes unit t returns boolean
        return GetUnitAbilityLevel(t,Data.BID) != 0
    endmethod
    
    method finish takes nothing returns nothing
        call .release()
    endmethod
    
//==================================================================================

    private static method create takes unit c, unit t returns Data
        local Data this = Data[c]
        if this != 0 then
            call .release()
        endif
        set this = Data.allocate()
        set Data[c] = this
        set .caster = c
        set .target = t
        set .level = GetUnitAbilityLevel(c,Data.AID)
        set .ticks = 0.
        set .t = CreateTimer()
        return this
    endmethod
    
    private method onDestroy takes nothing returns nothing
        call UnitRemoveAbility(.target,Data.BID)
        call PauseTimer(.t)
        call DestroyTimer(.t)
    endmethod
    
//==================================================================================

    private method Callback takes nothing returns nothing
        set .ticks = .ticks + 1.
        if IsUnitVisible(.target,GetOwningPlayer(.caster)) == false then
            call .release()
            return
        endif
        if GetWidgetLife(.target) < 0.405 then
            call .release()
            return
        endif
        if GetWidgetLife(.caster) < 0.405 then
            call .release()
            return
        endif
        if .ticks * Data.TIMEOUT > Data.DURATION then
            call .finish()
            return
        endif
    endmethod
    
    private static method Actions takes nothing returns nothing
        local Data this = Data.create(GetSpellAbilityUnit(),GetSpellTargetUnit())
        call UnitAddAbility(.target,Data.BID)
        call SetUnitAbilityLevel(.target,Data.BID,.level)
        call StartTimer(this,this.t,Data.TIMEOUT,true,Data.Callback)
    endmethod
    
    private static method Conditions takes nothing returns boolean
        return GetSpellAbilityId() == Data.AID
    endmethod
    
    private static method onInit takes nothing returns nothing
        set Data.onCast = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(Data.onCast,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(Data.onCast,Condition(function Data.Conditions))
        call TriggerAddAction(Data.onCast,function Data.Actions)
    endmethod

endstruct

endlibrary
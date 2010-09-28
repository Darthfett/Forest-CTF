library SeekerOwl uses Data,AIDS

public struct Data
    //! runtextmacro PUI()

    unit caster
    unit target
    integer level
    unit owl
    
//====================================================================================

    static constant integer AID = 'SEEK'
    static trigger onCast
    
//====================================================================================

    private static method create takes unit caster returns Data
        local Data this = Data[caster]
        if this != 0 then
            call this.release()
        endif
        set this = Data.allocate()
        set Data[caster] = this
        set .caster = caster
        set .level = GetUnitAbilityLevel(caster,Data.AID)
        return this
    endmethod
    
//====================================================================================
    
    private static method Actions takes nothing returns nothing
        local Data d = Data.create(GetTriggerUnit())
        call d.release()
    endmethod
    
    private static method Conditions takes nothing returns boolean
        return GetSpellAbilityId() == Data.AID
    endmethod

    private static method onInit takes nothing returns nothing
        set Data.onCast = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(Data.onCast,EVENT_PLAYER_UNIT_SPELL_CAST)
        call TriggerAddCondition(Data.onCast,Condition(function Data.Conditions))
        call TriggerAddAction(Data.onCast,function Data.Actions)
    endmethod

endstruct

endlibrary
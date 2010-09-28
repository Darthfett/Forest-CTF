library Shackle uses Data,AIDS,Unit

public struct Data
    //! runtextmacro PUI()
    
//==============================================================================
    // Struct Configurables
    
    private static constant integer AID = 'MASH' //
    private static constant real TIMEOUT = 0.03125
    private static constant string SFX_TRAP_MODEL = ""
    
//==============================================================================
    // Struct Members
    
    private timer t
    private Unit caster
    private Unit target
    private integer level
    private real ticks
    
//==============================================================================
    // Create/Cleanup
    
    private static method create takes unit c returns Data
        local Data this = Data[c]
        if this == 0 then
            set this = Data.allocate()
            set Data[c] = this
        else
            call this.release()
        endif
        set this.t = CreateTimer()
        set this.caster = Unit[c]
        set this.target = Unit[tar]
        set this.level = GetUnitAbilityLevel(this.caster.unit,Data.AID)
        set this.ticks = 0.
        call StartTimer(this,this.t,Data.TIMEOUT,true,Data.Callback)
        return this
    endmethod
    
    private method onDestroy takes nothing returns nothing
        call PauseTimer(this.t)
        call DestroyTimer(this.t)
    endmethod
    
//==============================================================================
    // Spell Config
    
    method operator timeout takes nothing returns real
        return 2 + this.level    
    endmethod
    
    method operator damage takes nothing returns real
        return 15 + (10 * this.level)
    endmethod
    
//==============================================================================
    // Spell End
    
    method finish takes nothing returns nothing
        call .release()
    endmethod
    
//==============================================================================
    // Spell Middle
    
    private method Callback takes nothing returns nothing        
        if this.caster.isAlive == false or this.target.isAlive == false then //Spell ends abnormally (bypass normal finish method)
            call this.release()
            return
        endif
        
        set this.ticks = this.ticks + this.TIMEOUT
        if this.ticks >= this.timeout then //Spell ends normally
            call this.finish()
        endif
        
    endmethod
    
//==============================================================================
    // Spell Beginning
    
    private static method Actions takes nothing returns nothing
        local Data this = Data.create(GetTriggerUnit())
        call DestroyEffect(AddSpecialEffectTarget(Data.SFX_TRAP_MODEL,this.target.unit,"origin"))
    endmethod
    
//==============================================================================
    // Spell Init
    
    private static method Conditions takes nothing returns boolean
        return GetSpellAbilityId() == Data.AID
    endmethod

    private static method onInit takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Data.Conditions))
        call TriggerAddAction(t,function Data.Actions)
    endmethod
    
//==============================================================================

endstruct

endlibrary
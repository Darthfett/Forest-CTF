library Chronoburn uses AIDS,Data,Systems

public struct Data
    //! runtextmacro PUI()
    
//==============================================================================
    
    static constant integer AID = 'A01Y'
    static constant integer BUFFID = 'Cbsl'
    static constant real DEFAULTSPEED = 270
    static constant real EFFECTSPEED = 150
    static constant real SPELLLENGTH = 5
    static constant real MAXDISTANCE = 1300
    static constant real MINDISTANCE = 275
    static constant real DAMAGE_AMOUNT_FINISH = 50
    private static constant string LIGHTNINGTYPE = "LEAS"
    private static constant string SFX_FIREBALL_FINISH = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
    private static constant real TIMEOUT = 0.03125
    private static real temp
    
    private method GetFinishDamage takes nothing returns real
        return ((30. + 25. * .level)) //55,80,105,130
    endmethod
    
    private method GetCallbackDamage takes nothing returns real
        return ((20. + 8. * .level) * Data.TIMEOUT) //28,36,44,52 dps
    endmethod
    
//==============================================================================

    private static trigger endcast = CreateTrigger()
    
//==============================================================================

    private timer t
    private unit caster
    private unit target
    private integer level
    private lightning l
    private real ticks
    private sound sound
    
//==============================================================================
    
    private static method create takes unit c, unit t returns Data
        local Data this = Data[c]
        if this == 0 then
            set this = Data.allocate()
            set Data[c] = this
        endif
        set this.t = CreateTimer()
        set this.caster = c
        set this.target = t
        set this.level = GetUnitAbilityLevel(this.caster,Data.AID)
        set this.ticks = 0.
        if this.sound == null then
            set this.sound = CreateSound("Abilities\\Spells\\Human\\AerialShackles\\MagicLariatLoop1.wav",true,true,false,10,10,null)
            call SetSoundVolume(this.sound,127)
        endif
        call StartTimer(this,this.t,Data.TIMEOUT,true,Data.Callback)
        return this
    endmethod
    
    private method onDestroy takes nothing returns nothing
        call StopSound(.sound,false,false)
        call PauseTimer(.t)
        call DestroyTimer(.t)
        call DestroyLightning(.l)
        call UnitRemoveAbility(.target,Data.BUFFID)
        call SetUnitMoveSpeed(.target,Data.DEFAULTSPEED)
        call DisableTrigger(Data.endcast)
        call IssueImmediateOrder(.caster,"stop")
        call EnableTrigger(Data.endcast)
    endmethod
    
    method finish takes nothing returns nothing
        call DestroyEffect(AddSpecialEffect(Data.SFX_FIREBALL_FINISH,GetUnitX(.target),GetUnitY(.target)))
        call UnitDamageTarget(.caster,.target,.GetFinishDamage(),false,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_FIRE,WEAPON_TYPE_WHOKNOWS)
        call .release()
    endmethod
    
//==============================================================================
    
    private method Callback takes nothing returns nothing        
        set Data.temp = DistanceBetweenXY(GetUnitX(this.caster),GetUnitY(this.caster),GetUnitX(this.target),GetUnitY(this.target))
        if GetWidgetLife(this.target) <= 0.405 or GetWidgetLife(this.caster) <= 0.405 or Data.temp > Data.MAXDISTANCE or Data.temp < Data.MINDISTANCE then
            call this.release()
            return
        endif
        call MoveLightning(this.l,true,GetUnitX(this.caster),GetUnitY(this.caster),GetUnitX(this.target),GetUnitY(this.target))
        call UnitDamageTarget(this.caster,this.target,this.GetCallbackDamage(),false,true,ATTACK_TYPE_MAGIC,DAMAGE_TYPE_FIRE,WEAPON_TYPE_WHOKNOWS)
        set this.ticks = this.ticks + Data.TIMEOUT
        
        if this.ticks >= Data.SPELLLENGTH then
            call this.finish()
        endif
    endmethod
    
//==============================================================================
    
    private static method Actions takes nothing returns nothing
        local Data this = Data.create(GetTriggerUnit(),GetSpellTargetUnit())
        set this.l = AddLightning(Data.LIGHTNINGTYPE,true,GetUnitX(this.caster),GetUnitY(this.caster),GetUnitX(this.target),GetUnitY(this.target))
        call SetUnitMoveSpeed(this.target,Data.EFFECTSPEED)
        call AttachSoundToUnit(this.sound,this.caster)
        call StartSound(this.sound)
        call UnitAddAbility(this.target,Data.BUFFID)
        call SetUnitAbilityLevel(this.target,Data.BUFFID,GetUnitAbilityLevel(this.caster,Data.AID))
    endmethod
    
//==============================================================================

    private static method StopChannel takes nothing returns nothing
        local Data this = Data[GetTriggerUnit()]
        if this != 0 then
            call this.release()
        endif
    endmethod
    
    private static method Conditions takes nothing returns boolean
        return GetSpellAbilityId() == Data.AID
    endmethod

    private static method onInit takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
        call TriggerAddCondition(t,Condition(function Data.Conditions))
        call TriggerAddAction(t,function Data.Actions)
        call TriggerRegisterAnyUnitEventBJ(Data.endcast,EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        call TriggerAddCondition(Data.endcast,Condition(function Data.Conditions))
        call TriggerAddAction(Data.endcast,function Data.StopChannel)
    endmethod
endstruct

endlibrary
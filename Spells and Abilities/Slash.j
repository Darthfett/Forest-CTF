library Slash initializer Init uses AIDS,Data

globals
    private constant integer AID_Slash = 'A01V'
    private constant integer DMG_Base = 30
    private constant integer DMG_Inc = 20
    private constant sound SND_Hit = CreateSound("Abilities\\Spells\\Orc\\Purge\\PurgeTarget1.wav",false,true,true,1,1,"")
    private constant string FX = "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl"
    private integer temp
endglobals

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == AID_Slash
endfunction

private function Actions takes nothing returns nothing
    local unit c = GetTriggerUnit()
    local unit t = GetSpellTargetUnit()
    local texttag tt
    local effect fx
    
    call SetUnitAnimationByIndex(c,2)
    //--
    call TriggerSleepAction(.35)
    set temp = DMG_Base + (DMG_Inc * GetUnitAbilityLevel(c,AID_Slash))
    call UnitDamageTarget(c,t,temp,true,false,ATTACK_TYPE_MELEE,DAMAGE_TYPE_UNKNOWN,WEAPON_TYPE_WHOKNOWS)
    set tt = CreateTextTag()

    call SetTextTagTextBJ(tt,I2S(temp),10)
    call SetTextTagPos(tt,GetUnitX(t),GetUnitY(t),0)
    call SetTextTagColor(tt,255,0,0,255)    
    call SetTextTagLifespan(tt,2)    
    call SetTextTagFadepoint(tt,0)   
    call SetTextTagVelocityBJ(tt,64,90)
    call SetTextTagPermanent(tt,false)
    
    set fx = AddSpecialEffect(FX,GetUnitX(t),GetUnitY(t))
    
    call PauseUnit(t,true)
    
    call AttachSoundToUnit(SND_Hit,t)
    call SetSoundVolume(SND_Hit,127)
    call StartSound(SND_Hit)
    call TriggerSleepAction(1.75)
    call DestroyEffect(fx)
    call PauseUnit(t,false)
    set tt = null
    set c = null
    set t = null
    set fx = null
endfunction

//===========================================================================
private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition(t, Condition( function Conditions ) )
    call TriggerAddAction(t, function Actions )
endfunction

endlibrary
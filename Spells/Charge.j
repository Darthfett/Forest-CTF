library Charge initializer Init uses AIDS,Data

globals
    private constant real period = 0.035
    private constant integer AID_Charge = 'A01F'
    private constant integer DMG_Base = 0
    private constant integer DMG_Inc = 40
    private constant string FX = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
    private constant sound SND_Start = CreateSound("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.wav",false,true,true,1,1,"")
endglobals

public struct Data
    //! runtextmacro PUI()
    timer t
    unit c
    unit tar
    
    method onDestroy takes nothing returns nothing
        call PauseUnit(this.c,false)
        call SetUnitPathing(this.c,true)
        call SetUnitTimeScale(this.c,1)
        call SetUnitScale(this.c,.8,.8,.8)
        call PauseTimer(this.t)
        call DestroyTimer(this.t)
        set this.tar = null
        set this.c = null
        set this.t = null
    endmethod
endstruct

private function Finish takes unit c, unit tar returns nothing
    local integer lvl = GetUnitAbilityLevel(c,AID_Charge)
    local texttag tt = CreateTextTag()
    local location tar_loc = GetUnitLoc(tar)
    call UnitDamageTarget(c,tar,(DMG_Base+(DMG_Inc*lvl)),true,false,ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
    //---
    call DestroyEffect(AddSpecialEffectLoc(FX,tar_loc))
    //---
    call SetTextTagTextBJ(tt,I2S(DMG_Base+(DMG_Inc*lvl)),10)
    call SetTextTagPos(tt,GetLocationX(tar_loc),GetLocationY(tar_loc),0)
    call SetTextTagColor(tt,255,0,0,255)    
    call SetTextTagLifespan(tt,2)    
    call SetTextTagFadepoint(tt,0)   
    call SetTextTagVelocityBJ(tt,64,90)
    call SetTextTagPermanent(tt,false)
    //---
    call RemoveLocation(tar_loc)
    set tt = null
    set tar_loc = null
endfunction

private function IsUnitStunned takes unit u returns boolean
    return GetUnitAbilityLevel(u,'BSTN') > 0 or GetUnitAbilityLevel(u,'BPSE') > 0 or GetUnitAbilityLevel(u,'Beng') > 0 or GetUnitAbilityLevel(u,'Bmlt') > 0 or GetUnitAbilityLevel(u,'B006') > 0
endfunction

private function Callback takes Data this returns nothing
    local real cur_x = GetUnitX(this.c)
    local real cur_y = GetUnitY(this.c)
    local real tar_x = GetUnitX(this.tar)
    local real tar_y = GetUnitY(this.tar)
    local real new_x
    local real new_y
    local real dist = SquareRoot(((cur_x - tar_x) * (cur_x - tar_x)) + ((cur_y - tar_y) * (cur_y - tar_y)))
    local real speedModifiers = 1
    local real ang = bj_RADTODEG * Atan2(tar_y - cur_y,tar_x - cur_x)
    if dist <= 129 then //End the spell
        if IsUnitStunned(this.c) or (GetUnitState(this.c, UNIT_STATE_LIFE) <= 0) == true or (GetUnitState(this.tar, UNIT_STATE_LIFE) <= 0) == true then
            call this.release()
            return 
        endif
        call Finish(this.c,this.tar)
        call this.release()
        return
    endif
    
    if dist >= 250 and dist < 268 then
    //trial and error timed to find how much time it takes the animation to finish.
    //It won't be exactly right if the targetted unit is moving away, though :/
        call SetUnitAnimationByIndex(this.c,2)
    endif
    if GetUnitAbilityLevel(this.c,Chronoburn_Data.BUFFID) > 0 then
        set speedModifiers = speedModifiers * (Chronoburn_Data.EFFECTSPEED / Chronoburn_Data.DEFAULTSPEED)
    endif
    set new_x = cur_x + (18 * speedModifiers) * Cos(ang * bj_DEGTORAD) //18 / 0.035 is the pixels per second the unit moves
    set new_y = cur_y + (18 * speedModifiers) * Sin(ang * bj_DEGTORAD)
    call SetUnitX(this.c,new_x)
    call SetUnitY(this.c,new_y)
    //Done!
endfunction

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == AID_Charge
endfunction

private function Actions takes nothing returns nothing
    local Data this = Data[GetTriggerUnit()]
    
    if this == 0 then
        set this = Data.create() // if not create it
        set Data[GetTriggerUnit()] = this // and attach it
    endif
    
    set this.c = GetTriggerUnit()
    set this.tar = GetSpellTargetUnit()
    set this.t = CreateTimer()
    
    call PauseUnit(this.c,true)
    call SetUnitTimeScale(this.c,2)
    call SetUnitScale(this.c,.95,.95,.95)
    call SetUnitPathing(this.c,false)
    call SetUnitAnimationByIndex(this.c,0)
    call AttachSoundToUnit(SND_Start,this.c)
    call SetSoundVolume(SND_Start,127)
    call StartSound(SND_Start)
    //--
    call StartTimer(this,this.t,period,true,dymet.Callback)
endfunction

//===========================================================================
private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition(t, Condition( function Conditions ) )
    call TriggerAddAction(t, function Actions )
endfunction

endlibrary
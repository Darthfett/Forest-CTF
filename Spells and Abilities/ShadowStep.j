library Shadowstep initializer Init uses AIDS,Data

globals
    private integer AID_SHADOWSTEP = 'A013'
    private real DMG_BASE = 60
    private real DMG_INC = 20
endglobals

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == AID_SHADOWSTEP
endfunction

private function Actions takes nothing returns nothing
    local Unit c = Unit[GetTriggerUnit()]
    local Unit t = Unit[GetSpellTargetUnit()]
    local integer lvl = GetUnitAbilityLevel(c.unit,AID_SHADOWSTEP)
    local real t_x = t.x
    local real t_y = t.y
    local real n_x = t_x - 100 * Cos(bj_DEGTORAD * t.facing)
    local real n_y = t_y - 100 * Sin(bj_DEGTORAD * t.facing)
    local texttag tt = CreateTextTag()
    set c.x = n_x
    set c.y = n_y
    set c.facing = t.facing
    call UnitDamageTarget(c.unit,t.unit,(DMG_BASE + (DMG_INC * lvl)),true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
    call SetTextTagText(tt,R2S(DMG_BASE + (DMG_INC * lvl) ),0.023)
    call SetTextTagPos(tt,t_x,t_y,0)
    call SetTextTagColor(tt,255,0,0,255)    
    call SetTextTagLifespan(tt,2)    
    call SetTextTagFadepoint(tt,0)   
    call SetTextTagVelocity(tt,0,0.5 * 0.071)
    call SetTextTagPermanent(tt,false)
    set tt = null
endfunction

private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction

endlibrary
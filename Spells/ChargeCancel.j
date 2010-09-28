library ChargeCancel initializer Init uses SimError,Systems

globals
    private integer AID = 'A01F'
endglobals

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == AID
endfunction

private function Actions takes nothing returns nothing
    local AI ai = AI[GetOwningPlayer(GetSpellAbilityUnit())]
    if DistanceBetweenXY(GetUnitX(ai.hero.unit),GetUnitY(ai.hero.unit),GetUnitX(GetSpellTargetUnit()),GetUnitY(GetSpellTargetUnit())) <= 450. then
        call IssueImmediateOrder(ai.hero.unit,"stop")
        call SimError(ai.whichPlayer,"Target is too close.")
    endif
endfunction

//===========================================================================
private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_CAST)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction

endlibrary
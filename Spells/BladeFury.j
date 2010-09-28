library BladeFury initializer Init uses AIDS,Data

//==================================================||
//                                                  ||
//           Spell Created by Darthfett             ||
//                                                  ||
//             Easy to end spell, use:              ||
//                                                  ||
//    call BladeFury_Data[UNIT].release()           ||
//      - to finish a spell abruptly                ||
//                                                  ||
//==================================================||

globals
    private integer AID_BLADEFURY = 'S009'
    private integer array ABIL_BOOK
    private integer BONUS_COUNT = 4
    private string SFX = "Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl"
endglobals

public struct Data
    //! runtextmacro PUI()
    timer t
    unit c
    integer cur = 1   
    
    static method create takes nothing returns Data
        local Data d = Data.allocate()
        set d.t = CreateTimer()
        set d.cur = 1
        return d
    endmethod
        
    
    method onDestroy takes nothing returns nothing
        local integer i = 1
//All the actual cleanup is done in .release/.destroy methods, 
//so that it is possible to stop a spell whenever.
//This makes the spell very flexible
        loop
            exitwhen i > BONUS_COUNT
            call UnitRemoveAbility(this.c,ABIL_BOOK[i])
            set i = i + 1
        endloop
        call PauseTimer(this.t)
        call DestroyTimer(this.t)
        set this.t = null
        set this.c = null
    endmethod
endstruct

private function Conditions takes nothing returns boolean
    return GetSpellAbilityId() == AID_BLADEFURY
endfunction

private function Callback takes Data this returns nothing
    if GetWidgetLife(this.c) < .405 == true then //Ending abnormally
        call this.release()
        return
    endif
    if this.cur == BONUS_COUNT then //Ending normally
        call this.release()
        return
    endif
    call UnitRemoveAbility(this.c,ABIL_BOOK[this.cur])
    set this.cur = this.cur + 1
    call UnitAddAbility(this.c,ABIL_BOOK[this.cur])
    call DestroyEffect(AddSpecialEffect(SFX,GetUnitX(this.c),GetUnitY(this.c)))
    call StartTimer(this,this.t,BONUS_COUNT - this.cur + 1,false,dymet.Callback)
endfunction

private function Actions takes nothing returns nothing
    local Data this = Data[GetTriggerUnit()]
    if this != 0 then
        call this.release()
    endif
    set this = Data.create()
    set Data[GetTriggerUnit()] = this
    
    set this.c = GetTriggerUnit()   
    call UnitAddAbility(this.c,ABIL_BOOK[1])
    call DestroyEffect(AddSpecialEffect(SFX,GetUnitX(this.c),GetUnitY(this.c)))
    //Set data
    call StartTimer(this,this.t,BONUS_COUNT,false,dymet.Callback)
endfunction

private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 0
    local integer j = 1
    call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_EFFECT)
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
    set ABIL_BOOK[1] = 'S008'
    set ABIL_BOOK[2] = 'S007'
    set ABIL_BOOK[3] = 'S006'
    set ABIL_BOOK[4] = 'S005'
    loop
        exitwhen j > BONUS_COUNT
        set i = 0
        loop
            exitwhen i >= 12  //Goes through disabling the spellbook for all the players
            call SetPlayerAbilityAvailable(Player(i),ABIL_BOOK[j],false)
            set i = i + 1
        endloop
        set j = j + 1
    endloop

endfunction

endlibrary
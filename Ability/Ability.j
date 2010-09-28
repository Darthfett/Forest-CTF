library Ability

globals
    private integer tempInt
endglobals

struct Ability    
    private static hashtable ht
    
    integer whichAbility
    integer whichBuff
    string order
    real array manaCost[4]
    integer targetType //use TARGET keys
    
    method canCast takes Unit whichUnit returns boolean
        set tempInt = GetUnitAbilityLevel(whichUnit.unit,this.whichAbility)
        return tempInt > 0 and whichUnit.mana >= this.manaCost[tempInt]
    endmethod
    
    static method operator [] takes integer whichAbility returns Ability
        local Ability this = LoadInteger(Ability.ht,0,whichAbility)
        if this == 0 then
            set this = Ability.allocate()
            set this.whichAbility = whichAbility
        endif
        return this
    endmethod
    
    static method create takes integer whichAbil, string ord, integer targetType, real cost1, real cost2, real cost3, real cost4 returns Ability
        local Ability this = Ability.allocate()
        call SaveInteger(Ability.ht,0,whichAbil,this)
        set this.whichAbility = whichAbil
        set this.order = ord
        set this.manaCost[0] = cost1
        set this.manaCost[1] = cost2
        set this.manaCost[2] = cost3
        set this.manaCost[3] = cost4
        return this
    endmethod
    
    method toString takes nothing returns string
        return AbilityId2String(this.whichAbility)
    endmethod
    
    static method onInit takes nothing returns nothing
        set Ability.ht = InitHashtable()
    endmethod        
endstruct
    
endlibrary
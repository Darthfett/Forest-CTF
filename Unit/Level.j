library Level

module Level
    /*
    
    Has some functionality for Units when they gain a level
    
    */

    trigger gainLevelTrig //A trigger that is run when a Unit gains a level
    integer level //The Unit's current level
    
    method gainLevelActions takes nothing returns nothing
        /*
        
        When a Unit gains a level, it is automatically ordered to select a new ability

        */
        
        local integer rand = GetRandomInt(0,2)
        set this.level = this.level + 1
        if this.owner.isEnabled then
            if this.level == 8 then
                call SelectHeroSkill(this.unit,this.whichType.abil[4])
            elseif this.level == 2 or this.level == 6 then
                call SelectHeroSkill(this.unit,this.whichType.abil[3])
            else
                call SelectHeroSkill(this.unit,this.whichType.abil[rand])
                set rand = rand + 1
                if rand > 2 then
                    set rand = 0
                endif
                call SelectHeroSkill(this.unit,this.whichType.abil[rand])
                set rand = rand + 1
                if rand > 2 then
                    set rand = 0
                endif
                call SelectHeroSkill(this.unit,this.whichType.abil[rand])
            endif
        endif
    endmethod

endmodule

endlibrary
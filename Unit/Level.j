library Level

module Level

    trigger gainLevelTrig
    integer level
    
    method gainLevelActions takes nothing returns nothing
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
library Damage

module Damage
    
    trigger takeDamageTrig

    method onDamage takes Unit damager returns nothing
        call this.whichType.onDamage(this,damager)
    endmethod   
    
    method takeDamageActions takes nothing returns nothing
        local Unit damager = Unit[GetEventDamageSource()]
        if GetEventDamage() != 0 and this != damager then
            call this.enterCombat()
            call damager.enterCombat()
            call this.onDamage(damager)
        endif
    endmethod
    
endmodule

endlibrary
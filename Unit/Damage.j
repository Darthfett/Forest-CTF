library Damage

    module Damage
        /*
        
        Some functionality for bots relating to taking damage
        
        */

        trigger takeDamageTrig

        method onDamage takes Unit damager returns nothing
            //Runs the onDamage method responsible for the behavior of the type of this Unit
            call this.whichType.onDamage(this,damager)
        endmethod

        method takeDamageActions takes nothing returns nothing
            //Puts units that take damage in-combat, and tells bots when they take damage.
            local Unit damager = Unit[GetEventDamageSource()]
            if GetEventDamage() != 0 and this != damager then
                call this.enterCombat()
                call damager.enterCombat()
                call this.onDamage(damager)
            endif
        endmethod

    endmodule

endlibrary